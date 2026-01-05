#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SmartCarDashboard", "Main");
    engine.addImportPath("qrc:/qml");

    // engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
