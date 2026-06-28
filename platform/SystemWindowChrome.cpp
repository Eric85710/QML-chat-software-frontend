#include "SystemWindowChrome.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QTimer>

#if defined(Q_OS_MACOS) || defined(Q_OS_MAC)
#include "platform/macos/MacSystemWindowChrome_p.h"
#endif

#ifdef Q_OS_WIN
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>
#include <WinUser.h>
#include <dwmapi.h>
#include <windowsx.h>

#ifndef _MSC_VER
#ifndef DWMWA_WINDOW_CORNER_PREFERENCE
enum DWM_WINDOW_CORNER_PREFERENCE {
    DWMWCP_DEFAULT = 0,
    DWMWCP_DONOTROUND = 1,
    DWMWCP_ROUND = 2,
    DWMWCP_ROUNDSMALL = 3
};
constexpr DWORD DWMWA_WINDOW_CORNER_PREFERENCE = 33;
#endif
#endif

namespace {
constexpr int kResizeBorder = 8;

HWND hwndForWindow(QQuickWindow* window)
{
    return window ? reinterpret_cast<HWND>(window->winId()) : nullptr;
}
} // namespace
#endif

SystemWindowChrome::SystemWindowChrome(QObject* parent)
    : QObject(parent)
{
#ifdef Q_OS_WIN
    if (QCoreApplication* app = QCoreApplication::instance()) {
        app->installNativeEventFilter(this);
        m_nativeEventFilterInstalled = true;
    }
#endif
}

SystemWindowChrome::~SystemWindowChrome()
{
#ifdef Q_OS_WIN
    if (m_nativeEventFilterInstalled) {
        if (QCoreApplication* app = QCoreApplication::instance()) {
            app->removeNativeEventFilter(this);
        }
    }
#endif
}

QQuickWindow* SystemWindowChrome::window() const
{
    return m_window;
}

void SystemWindowChrome::setWindow(QQuickWindow* window)
{
    if (m_window == window) {
        return;
    }

    if (m_window) {
        disconnect(m_window, nullptr, this, nullptr);
    }

    m_window = window;
    m_platformChromeReady = false;

    if (m_window) {
        connect(m_window, &QWindow::visibleChanged, this, [this]() {
            QTimer::singleShot(0, this, &SystemWindowChrome::ensurePlatformChrome);
        });
        connect(m_window, &QWindow::windowStateChanged, this, [this]() {
            emit windowStateChanged();
        });
        QTimer::singleShot(0, this, &SystemWindowChrome::ensurePlatformChrome);
    }

    emit windowChanged();
    emit windowStateChanged();
}

QQuickItem* SystemWindowChrome::dragArea() const
{
    return m_dragArea;
}

void SystemWindowChrome::setDragArea(QQuickItem* dragArea)
{
    if (m_dragArea == dragArea) {
        return;
    }

    m_dragArea = dragArea;
    emit dragAreaChanged();
}

QQuickItem* SystemWindowChrome::maximizeButton() const
{
    return m_maximizeButton;
}

void SystemWindowChrome::setMaximizeButton(QQuickItem* maximizeButton)
{
    if (m_maximizeButton == maximizeButton) {
        return;
    }

    m_maximizeButton = maximizeButton;
    emit maximizeButtonChanged();
}

int SystemWindowChrome::topInset() const
{
    return m_topInset;
}

int SystemWindowChrome::leadingInset() const
{
    return m_leadingInset;
}

bool SystemWindowChrome::usesSystemTitleButtons() const
{
#if defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    return true;
#else
    return false;
#endif
}

bool SystemWindowChrome::isMaximized() const
{
    return m_window && (m_window->windowState() & Qt::WindowMaximized);
}

void SystemWindowChrome::showMinimized()
{
    if (m_window) {
        m_window->showMinimized();
    }
}

void SystemWindowChrome::toggleMaximized()
{
    if (!m_window) {
        return;
    }

#if defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    if (MacSystemWindowChrome::performWindowZoom(m_window)) {
        emit windowStateChanged();
        return;
    }
#endif

#ifdef Q_OS_WIN
    if (HWND hwnd = hwndForWindow(m_window)) {
        ::SendMessageW(hwnd, WM_SYSCOMMAND, isMaximized() ? SC_RESTORE : SC_MAXIMIZE, 0);
        return;
    }
#endif

    isMaximized() ? m_window->showNormal() : m_window->showMaximized();
}

void SystemWindowChrome::close()
{
    if (m_window) {
        m_window->close();
    }
}

bool SystemWindowChrome::startSystemMove()
{
    if (!m_window) {
        return false;
    }

#if defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    if (MacSystemWindowChrome::startWindowDrag(m_window)) {
        return true;
    }
#endif

    return m_window->startSystemMove();
}

bool SystemWindowChrome::startSystemResize(Qt::Edges edges)
{
    if (!m_window || edges == Qt::Edges()) {
        return false;
    }

    return m_window->startSystemResize(edges);
}

bool SystemWindowChrome::nativeEventFilter(const QByteArray& eventType, void* message, qintptr* result)
{
    Q_UNUSED(eventType)
    Q_UNUSED(message)
    Q_UNUSED(result)

#ifdef Q_OS_WIN
    if (!m_window) {
        return false;
    }

    MSG* msg = reinterpret_cast<MSG*>(message);
    HWND hwnd = hwndForWindow(m_window);
    if (!hwnd || msg->hwnd != hwnd) {
        return false;
    }

    switch (msg->message) {
    case WM_GETMINMAXINFO: {
        auto* minMaxInfo = reinterpret_cast<MINMAXINFO*>(msg->lParam);
        HMONITOR monitor = ::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
        MONITORINFO monitorInfo = {};
        monitorInfo.cbSize = sizeof(monitorInfo);
        if (::GetMonitorInfoW(monitor, &monitorInfo)) {
            const RECT workArea = monitorInfo.rcWork;
            const RECT monitorArea = monitorInfo.rcMonitor;
            minMaxInfo->ptMaxPosition.x = workArea.left - monitorArea.left;
            minMaxInfo->ptMaxPosition.y = workArea.top - monitorArea.top;
            minMaxInfo->ptMaxSize.x = workArea.right - workArea.left;
            minMaxInfo->ptMaxSize.y = workArea.bottom - workArea.top;
        }
        *result = 0;
        return true;
    }

    case WM_NCCALCSIZE:
        *result = 0;
        return true;

    case WM_NCHITTEST: {
        const QPoint globalPos(GET_X_LPARAM(msg->lParam), GET_Y_LPARAM(msg->lParam));

        if (isMaximizeButtonHit(globalPos)) {
            *result = HTMAXBUTTON;
            return true;
        }

        const int resizeHit = hitTestResize(globalPos);
        if (resizeHit) {
            *result = resizeHit;
            return true;
        }

        if (isDragAreaHit(globalPos)) {
            *result = HTCAPTION;
            return true;
        }

        return false;
    }

    case WM_NCMOUSEMOVE:
        if (msg->wParam == HTMAXBUTTON) {
            setMaximizeButtonState(true, m_maximizeButtonPressed);
            TRACKMOUSEEVENT trackEvent = {};
            trackEvent.cbSize = sizeof(trackEvent);
            trackEvent.dwFlags = TME_LEAVE | TME_NONCLIENT;
            trackEvent.hwndTrack = hwnd;
            ::TrackMouseEvent(&trackEvent);
            return false;
        }
        setMaximizeButtonState(false, false);
        return false;

    case WM_NCMOUSELEAVE:
        setMaximizeButtonState(false, false);
        return false;

    case WM_NCLBUTTONDOWN:
        if (msg->wParam == HTMAXBUTTON) {
            setMaximizeButtonState(true, true);
            *result = 0;
            return true;
        }
        return false;

    case WM_NCLBUTTONUP:
        if (m_maximizeButtonPressed) {
            const QPoint globalPos(GET_X_LPARAM(msg->lParam), GET_Y_LPARAM(msg->lParam));
            const bool stillOnButton = isMaximizeButtonHit(globalPos);
            setMaximizeButtonState(stillOnButton, false);
            if (stillOnButton) {
                toggleMaximized();
            }
            *result = 0;
            return true;
        }
        return false;

    default:
        return false;
    }
#else
    return false;
#endif
}

void SystemWindowChrome::ensurePlatformChrome()
{
    if (!m_window || m_platformChromeReady) {
        return;
    }

    m_window->winId();

#ifdef Q_OS_WIN
    refreshWindowsFrame();
    updatePlatformMetrics(0, 0);
#elif defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    const auto metrics = MacSystemWindowChrome::configureWindow(m_window);
    updatePlatformMetrics(metrics.topInset, metrics.leadingInset);
#else
    updatePlatformMetrics(0, 0);
#endif

    m_platformChromeReady = true;
}

void SystemWindowChrome::updatePlatformMetrics(int topInset, int leadingInset)
{
    if (m_topInset == topInset && m_leadingInset == leadingInset) {
        return;
    }

    m_topInset = topInset;
    m_leadingInset = leadingInset;
    emit metricsChanged();
}

#ifdef Q_OS_WIN
int SystemWindowChrome::hitTestResize(const QPoint& globalPos) const
{
    if (!m_window || isMaximized()) {
        return 0;
    }

    HWND hwnd = hwndForWindow(m_window);
    if (!hwnd) {
        return 0;
    }

    RECT windowRect;
    if (!::GetWindowRect(hwnd, &windowRect)) {
        return 0;
    }

    int result = 0;
    const bool resizeWidth = m_window->minimumWidth() != m_window->maximumWidth();
    const bool resizeHeight = m_window->minimumHeight() != m_window->maximumHeight();

    if (resizeWidth) {
        if (globalPos.x() > windowRect.left && globalPos.x() < windowRect.left + kResizeBorder) {
            result = HTLEFT;
        }
        if (globalPos.x() < windowRect.right && globalPos.x() >= windowRect.right - kResizeBorder) {
            result = HTRIGHT;
        }
    }

    if (resizeHeight) {
        if (globalPos.y() >= windowRect.top && globalPos.y() < windowRect.top + kResizeBorder) {
            result = HTTOP;
        }
        if (globalPos.y() <= windowRect.bottom && globalPos.y() > windowRect.bottom - kResizeBorder) {
            result = HTBOTTOM;
        }
    }

    if (resizeWidth && resizeHeight) {
        if (globalPos.x() >= windowRect.left && globalPos.x() < windowRect.left + kResizeBorder
            && globalPos.y() >= windowRect.top && globalPos.y() < windowRect.top + kResizeBorder) {
            result = HTTOPLEFT;
        }
        if (globalPos.x() <= windowRect.right && globalPos.x() > windowRect.right - kResizeBorder
            && globalPos.y() >= windowRect.top && globalPos.y() < windowRect.top + kResizeBorder) {
            result = HTTOPRIGHT;
        }
        if (globalPos.x() >= windowRect.left && globalPos.x() < windowRect.left + kResizeBorder
            && globalPos.y() <= windowRect.bottom && globalPos.y() > windowRect.bottom - kResizeBorder) {
            result = HTBOTTOMLEFT;
        }
        if (globalPos.x() <= windowRect.right && globalPos.x() > windowRect.right - kResizeBorder
            && globalPos.y() <= windowRect.bottom && globalPos.y() > windowRect.bottom - kResizeBorder) {
            result = HTBOTTOMRIGHT;
        }
    }

    return result;
}

bool SystemWindowChrome::isDragAreaHit(const QPoint& globalPos) const
{
    if (!m_dragArea || !m_dragArea->isVisible()) {
        return false;
    }

    const QPointF localPos = itemLocalPositionFromGlobal(m_dragArea, globalPos);
    return itemRect(m_dragArea).contains(localPos);
}

bool SystemWindowChrome::isMaximizeButtonHit(const QPoint& globalPos) const
{
    if (!m_maximizeButton || !m_maximizeButton->isVisible() || !m_maximizeButton->isEnabled()) {
        return false;
    }

    if (m_window && m_window->minimumWidth() == m_window->maximumWidth()
        && m_window->minimumHeight() == m_window->maximumHeight()) {
        return false;
    }

    const QPointF localPos = itemLocalPositionFromGlobal(m_maximizeButton, globalPos);
    return itemRect(m_maximizeButton).contains(localPos);
}

void SystemWindowChrome::setMaximizeButtonState(bool hovered, bool pressed)
{
    if (!m_maximizeButton) {
        m_maximizeButtonHovered = false;
        m_maximizeButtonPressed = false;
        return;
    }

    if (m_maximizeButtonHovered != hovered) {
        m_maximizeButtonHovered = hovered;
        m_maximizeButton->setProperty("nativeHover", hovered);
    }

    if (m_maximizeButtonPressed != pressed) {
        m_maximizeButtonPressed = pressed;
        m_maximizeButton->setProperty("nativePressed", pressed);
    }
}

void SystemWindowChrome::refreshWindowsFrame()
{
    HWND hwnd = hwndForWindow(m_window);
    if (!hwnd) {
        return;
    }

    LONG_PTR style = ::GetWindowLongPtrW(hwnd, GWL_STYLE);
    style |= WS_THICKFRAME | WS_CAPTION | WS_MAXIMIZEBOX | WS_MINIMIZEBOX | WS_SYSMENU;
    ::SetWindowLongPtrW(hwnd, GWL_STYLE, style);
    ::SetWindowPos(hwnd,
                   nullptr,
                   0,
                   0,
                   0,
                   0,
                   SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_FRAMECHANGED);

    UINT cornerPreference = DWMWCP_ROUND;
    DwmSetWindowAttribute(hwnd,
                          DWMWA_WINDOW_CORNER_PREFERENCE,
                          &cornerPreference,
                          sizeof(cornerPreference));
}
#endif

QPointF SystemWindowChrome::itemLocalPositionFromGlobal(QQuickItem* item, const QPoint& globalPos) const
{
    if (!m_window || !item) {
        return {};
    }

    const qreal dpr = m_window->devicePixelRatio();
    const QPoint logicalGlobal(qRound(globalPos.x() / dpr), qRound(globalPos.y() / dpr));
    const QPoint windowPos = m_window->mapFromGlobal(logicalGlobal);
    return item->mapFromScene(QPointF(windowPos));
}

QRectF SystemWindowChrome::itemRect(QQuickItem* item) const
{
    if (!item) {
        return {};
    }

    return QRectF(0.0, 0.0, item->width(), item->height());
}
