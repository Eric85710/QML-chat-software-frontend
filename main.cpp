#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Server_Page_status/eventbus.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

     qmlRegisterSingletonInstance("App", 1, 0, "EventBus", EventBus::instance());


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("qrc_test", "Main");

    return app.exec();
}
