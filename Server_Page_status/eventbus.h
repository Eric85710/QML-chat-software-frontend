// EventBus.h
#ifndef EVENTBUS_H
#define EVENTBUS_H

#include <QObject>
#include <QString>

class EventBus : public QObject {
    Q_OBJECT
public:
    explicit EventBus(QObject *parent = nullptr) : QObject(parent) {}

    // 單例存取
    static EventBus* instance() {
        static EventBus bus;
        return &bus;
    }

signals:
    void sendMessage(const QString &msg);  // 廣播訊息

public slots:
    void postMessage(const QString &msg) { // 發送事件
        emit sendMessage(msg);
    }
};

#endif // EVENTBUS_H
