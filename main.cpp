#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/CarInfoModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    auto *carInfo = new CarInfoModel(&app);
    carInfo->setVehicleName("Vinfast");
    carInfo->setSpeed(84);
    carInfo->setRange(204);
    carInfo->setAverage(128.0);
    carInfo->setCapacity(35.5);
    carInfo->setImageSource("qrc:/qt/qml/SmartCarDashboard/asset/images/car_left.png");
    engine.rootContext()->setContextProperty("CarInfo", carInfo);
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
