#pragma once

#include <QObject>
#include <QElapsedTimer>
#include <QString>
#include <QtGlobal>

#include <memory>

class SystemScrollHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString platform READ platform CONSTANT)

public:
    explicit SystemScrollHandler(QObject *parent = nullptr);

    QString platform() const;

    Q_INVOKABLE int navigationStep(qreal angleDeltaX,
                                   qreal angleDeltaY,
                                   qreal pixelDeltaX,
                                   qreal pixelDeltaY);
    Q_INVOKABLE qreal normalizedNavigationDistance(qreal angleDeltaX,
                                                   qreal angleDeltaY,
                                                   qreal pixelDeltaX,
                                                   qreal pixelDeltaY,
                                                   qreal itemWidth,
                                                   qreal pixelGain,
                                                   bool mouseWheel);
    Q_INVOKABLE int nextNavigationIndex(int currentIndex,
                                        int itemCount,
                                        qreal angleDeltaX,
                                        qreal angleDeltaY,
                                        qreal pixelDeltaX,
                                        qreal pixelDeltaY);

protected:
    virtual QString platformName() const = 0;
    virtual int computeNavigationStep(qreal angleDeltaX,
                                      qreal angleDeltaY,
                                      qreal pixelDeltaX,
                                      qreal pixelDeltaY) = 0;

    int consumeScrollDelta(qreal delta,
                           qreal threshold,
                           bool positiveMeansNext,
                           int throttleMs);
    int consumeScrollSteps(qreal delta,
                           qreal threshold,
                           bool positiveMeansNext);

private:
    qreal m_scrollRemainder = 0.0;
    QElapsedTimer m_stepTimer;
};

std::unique_ptr<SystemScrollHandler> createSystemScrollHandler(QObject *parent = nullptr);
