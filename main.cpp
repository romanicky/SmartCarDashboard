#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/CarInfoModel.h"
#include "src/CarDataReceiver.h"
#include "musicplayer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<MusicPlayer>("Musicplayer", 1, 0, "MusicPlayer");

    auto *carInfo = new CarInfoModel(&app);
    carInfo->setVehicleName("Vinfast");
    carInfo->setSpeed(0);
    carInfo->setRange(204);
    carInfo->setAverage(128.0);
    carInfo->setCapacity(35.5);
    carInfo->setImageSource("qrc:/qt/qml/SmartCarDashboard/asset/images/car_left.png");
    engine.rootContext()->setContextProperty("CarInfo", carInfo);

    // Connect to car simulator
    auto *dataReceiver = new CarDataReceiver(carInfo, &app);
    dataReceiver->connectToSimulator();
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SmartCarDashboard", "Main");
    engine.addImportPath("qrc:/qml");

    return app.exec();
}
