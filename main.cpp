#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Server_Page_status/eventbus.h"
#include "systemscrollhandler.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    auto systemScrollHandler = createSystemScrollHandler(&app);

    QQmlApplicationEngine engine;
    qmlRegisterSingletonInstance("App", 1, 0, "EventBus", EventBus::instance());
    qmlRegisterSingletonInstance("App", 1, 0, "SystemScroll", systemScrollHandler.get());


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("qrc_test", "Main");

    return app.exec();
}
