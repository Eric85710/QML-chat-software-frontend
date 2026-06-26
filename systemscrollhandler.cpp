#include "systemscrollhandler.h"

#include <QtGlobal>

#include <algorithm>
#include <cmath>

namespace {

qreal navigationAxisDelta(qreal x, qreal y)
{
    return std::abs(x) > std::abs(y) ? -x : -y;
}

qreal clampNavigationDistance(qreal distance, qreal maxDistance)
{
    if (qFuzzyIsNull(maxDistance) || maxDistance < 0.0) {
        return distance;
    }

    return std::clamp(distance, -maxDistance, maxDistance);
}

class MacOsScrollHandler final : public SystemScrollHandler
{
public:
    using SystemScrollHandler::SystemScrollHandler;

protected:
    QString platformName() const override
    {
        return QStringLiteral("macOS");
    }

    int computeNavigationStep(qreal angleDeltaX,
                              qreal angleDeltaY,
                              qreal pixelDeltaX,
                              qreal pixelDeltaY) override
    {
        const bool hasPixelDelta = !qFuzzyIsNull(pixelDeltaX) || !qFuzzyIsNull(pixelDeltaY);
        if (hasPixelDelta) {
            const bool useHorizontal = std::abs(pixelDeltaX) > std::abs(pixelDeltaY);
            const qreal delta = useHorizontal ? pixelDeltaX : pixelDeltaY;
            const bool positiveMeansNext = useHorizontal;
            return consumeScrollDelta(delta, 85.0, positiveMeansNext, 180);
        }

        const bool useHorizontal = std::abs(angleDeltaX) > std::abs(angleDeltaY);
        const qreal delta = useHorizontal ? angleDeltaX : angleDeltaY;
        const bool positiveMeansNext = useHorizontal;
        return consumeScrollDelta(delta, 120.0, positiveMeansNext, 260);
    }
};

class BasicScrollHandler final : public SystemScrollHandler
{
public:
    using SystemScrollHandler::SystemScrollHandler;

protected:
    QString platformName() const override
    {
        return QStringLiteral("basic");
    }

    int computeNavigationStep(qreal angleDeltaX,
                              qreal angleDeltaY,
                              qreal pixelDeltaX,
                              qreal pixelDeltaY) override
    {
        const bool hasPixelDelta = !qFuzzyIsNull(pixelDeltaX) || !qFuzzyIsNull(pixelDeltaY);
        if (hasPixelDelta) {
            const bool useHorizontal = std::abs(pixelDeltaX) > std::abs(pixelDeltaY);
            const qreal delta = useHorizontal ? pixelDeltaX : pixelDeltaY;
            const bool positiveMeansNext = useHorizontal;
            return consumeScrollDelta(delta, 90.0, positiveMeansNext, 180);
        }

        const bool useHorizontal = std::abs(angleDeltaX) > std::abs(angleDeltaY);
        const qreal delta = useHorizontal ? angleDeltaX : angleDeltaY;
        const bool positiveMeansNext = useHorizontal;
        return consumeScrollDelta(delta, 120.0, positiveMeansNext, 220);
    }
};

class WindowsScrollHandler final : public SystemScrollHandler
{
public:
    using SystemScrollHandler::SystemScrollHandler;

protected:
    QString platformName() const override
    {
        return QStringLiteral("Windows");
    }

    int computeNavigationStep(qreal angleDeltaX,
                              qreal angleDeltaY,
                              qreal pixelDeltaX,
                              qreal pixelDeltaY) override
    {
        Q_UNUSED(pixelDeltaX)
        Q_UNUSED(pixelDeltaY)

        const bool useHorizontal = std::abs(angleDeltaX) > std::abs(angleDeltaY);
        const qreal delta = useHorizontal ? angleDeltaX : angleDeltaY;
        const bool positiveMeansNext = useHorizontal;
        return consumeScrollSteps(delta, 120.0, positiveMeansNext);
    }
};

} // namespace

SystemScrollHandler::SystemScrollHandler(QObject *parent)
    : QObject(parent)
{
}

QString SystemScrollHandler::platform() const
{
    return platformName();
}

int SystemScrollHandler::navigationStep(qreal angleDeltaX,
                                        qreal angleDeltaY,
                                        qreal pixelDeltaX,
                                        qreal pixelDeltaY)
{
    return computeNavigationStep(angleDeltaX, angleDeltaY, pixelDeltaX, pixelDeltaY);
}

qreal SystemScrollHandler::normalizedNavigationDistance(qreal angleDeltaX,
                                                        qreal angleDeltaY,
                                                        qreal pixelDeltaX,
                                                        qreal pixelDeltaY,
                                                        qreal itemWidth,
                                                        qreal pixelGain,
                                                        bool mouseWheel)
{
    if (itemWidth <= 0.0) {
        return 0.0;
    }

    const qreal angle = navigationAxisDelta(angleDeltaX, angleDeltaY);
    if (!qFuzzyIsNull(angle)) {
        const qreal divisor = mouseWheel ? 120.0 : 240.0;
        const qreal maxDistance = mouseWheel ? itemWidth : itemWidth * 0.5;
        return clampNavigationDistance(angle / divisor * itemWidth, maxDistance);
    }

    const qreal pixel = navigationAxisDelta(pixelDeltaX, pixelDeltaY);
    if (qFuzzyIsNull(pixel)) {
        return 0.0;
    }

    return clampNavigationDistance(pixel * pixelGain, itemWidth * 0.35);
}

int SystemScrollHandler::nextNavigationIndex(int currentIndex,
                                             int itemCount,
                                             qreal angleDeltaX,
                                             qreal angleDeltaY,
                                             qreal pixelDeltaX,
                                             qreal pixelDeltaY)
{
    if (itemCount <= 0) {
        return currentIndex;
    }

    const int step = navigationStep(angleDeltaX, angleDeltaY, pixelDeltaX, pixelDeltaY);
    if (step == 0) {
        return currentIndex;
    }

    return std::clamp(currentIndex + step, 0, itemCount - 1);
}

int SystemScrollHandler::consumeScrollDelta(qreal delta,
                                            qreal threshold,
                                            bool positiveMeansNext,
                                            int throttleMs)
{
    if (qFuzzyIsNull(delta) || threshold <= 0.0) {
        return 0;
    }

    if (m_stepTimer.isValid() && m_stepTimer.elapsed() < throttleMs) {
        m_scrollRemainder = 0.0;
        return 0;
    }

    m_scrollRemainder += delta;
    if (std::abs(m_scrollRemainder) < threshold) {
        return 0;
    }

    const bool isPositive = m_scrollRemainder > 0.0;
    m_scrollRemainder = 0.0;
    m_stepTimer.restart();
    return isPositive == positiveMeansNext ? 1 : -1;
}

int SystemScrollHandler::consumeScrollSteps(qreal delta,
                                            qreal threshold,
                                            bool positiveMeansNext)
{
    if (qFuzzyIsNull(delta) || threshold <= 0.0) {
        return 0;
    }

    if (!qFuzzyIsNull(m_scrollRemainder)
            && ((m_scrollRemainder > 0.0) != (delta > 0.0))) {
        m_scrollRemainder = 0.0;
    }

    m_scrollRemainder += delta;

    const int steps = static_cast<int>(std::abs(m_scrollRemainder) / threshold);
    if (steps <= 0) {
        return 0;
    }

    const bool isPositive = m_scrollRemainder > 0.0;
    const qreal consumed = steps * threshold * (isPositive ? 1.0 : -1.0);
    m_scrollRemainder -= consumed;

    return (isPositive == positiveMeansNext ? 1 : -1) * steps;
}

std::unique_ptr<SystemScrollHandler> createSystemScrollHandler(QObject *parent)
{
#if defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    return std::make_unique<MacOsScrollHandler>(parent);
#elif defined(Q_OS_WIN)
    return std::make_unique<WindowsScrollHandler>(parent);
#else
    return std::make_unique<BasicScrollHandler>(parent);
#endif
}
