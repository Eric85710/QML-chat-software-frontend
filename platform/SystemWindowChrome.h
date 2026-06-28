#pragma once

#include <QAbstractNativeEventFilter>
#include <QColor>
#include <QObject>
#include <QPointer>
#include <QQuickItem>
#include <QQuickWindow>

class SystemWindowChrome : public QObject, public QAbstractNativeEventFilter
{
    Q_OBJECT
    Q_PROPERTY(QQuickWindow* window READ window WRITE setWindow NOTIFY windowChanged)
    Q_PROPERTY(QQuickItem* dragArea READ dragArea WRITE setDragArea NOTIFY dragAreaChanged)
    Q_PROPERTY(QQuickItem* maximizeButton READ maximizeButton WRITE setMaximizeButton NOTIFY maximizeButtonChanged)
    Q_PROPERTY(int topInset READ topInset NOTIFY metricsChanged)
    Q_PROPERTY(int leadingInset READ leadingInset NOTIFY metricsChanged)
    Q_PROPERTY(bool usesSystemTitleButtons READ usesSystemTitleButtons CONSTANT)
    Q_PROPERTY(bool maximized READ isMaximized NOTIFY windowStateChanged)

public:
    explicit SystemWindowChrome(QObject* parent = nullptr);
    ~SystemWindowChrome() override;

    QQuickWindow* window() const;
    void setWindow(QQuickWindow* window);

    QQuickItem* dragArea() const;
    void setDragArea(QQuickItem* dragArea);

    QQuickItem* maximizeButton() const;
    void setMaximizeButton(QQuickItem* maximizeButton);

    int topInset() const;
    int leadingInset() const;
    bool usesSystemTitleButtons() const;
    bool isMaximized() const;

    Q_INVOKABLE void showMinimized();
    Q_INVOKABLE void toggleMaximized();
    Q_INVOKABLE void close();
    Q_INVOKABLE bool startSystemMove();
    Q_INVOKABLE bool startSystemResize(Qt::Edges edges);

signals:
    void windowChanged();
    void dragAreaChanged();
    void maximizeButtonChanged();
    void metricsChanged();
    void windowStateChanged();

protected:
    bool nativeEventFilter(const QByteArray& eventType, void* message, qintptr* result) override;

private:
    void ensurePlatformChrome();
    void updatePlatformMetrics(int topInset, int leadingInset);

#ifdef Q_OS_WIN
    int hitTestResize(const QPoint& globalPos) const;
    bool isDragAreaHit(const QPoint& globalPos) const;
    bool isMaximizeButtonHit(const QPoint& globalPos) const;
    void setMaximizeButtonState(bool hovered, bool pressed);
    void refreshWindowsFrame();
#endif

    QPointF itemLocalPositionFromGlobal(QQuickItem* item, const QPoint& globalPos) const;
    QRectF itemRect(QQuickItem* item) const;

    QPointer<QQuickWindow> m_window;
    QPointer<QQuickItem> m_dragArea;
    QPointer<QQuickItem> m_maximizeButton;
    int m_topInset = 0;
    int m_leadingInset = 0;
    bool m_platformChromeReady = false;

#ifdef Q_OS_WIN
    bool m_nativeEventFilterInstalled = false;
    bool m_maximizeButtonHovered = false;
    bool m_maximizeButtonPressed = false;
#endif
};
