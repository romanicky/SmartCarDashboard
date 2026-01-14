#include "CarInfoModel.h"

CarInfoModel::CarInfoModel(QObject *parent)
    : QObject(parent)
{
}

QString CarInfoModel::vehicleName() const { return m_vehicleName; }
void CarInfoModel::setVehicleName(const QString &name)
{
    if (m_vehicleName == name)
        return;
    m_vehicleName = name;
    emit vehicleNameChanged();
}

int CarInfoModel::speed() const { return m_speed; }
void CarInfoModel::setSpeed(int s)
{
    if (m_speed == s)
        return;
    m_speed = s;
    emit speedChanged();
}

int CarInfoModel::range() const { return m_range; }
void CarInfoModel::setRange(int r)
{
    if (m_range == r)
        return;
    m_range = r;
    emit rangeChanged();
}

double CarInfoModel::average() const { return m_average; }
void CarInfoModel::setAverage(double a)
{
    if (qFuzzyCompare(m_average + 1.0, a + 1.0))
        return;
    m_average = a;
    emit averageChanged();
}

double CarInfoModel::capacity() const { return m_capacity; }
void CarInfoModel::setCapacity(double c)
{
    if (qFuzzyCompare(m_capacity + 1.0, c + 1.0))
        return;
    m_capacity = c;
    emit capacityChanged();
}

QString CarInfoModel::imageSource() const { return m_imageSource; }
void CarInfoModel::setImageSource(const QString &src)
{
    if (m_imageSource == src)
        return;
    m_imageSource = src;
    emit imageSourceChanged();
}

QString CarInfoModel::gear() const { return m_gear; }
void CarInfoModel::setGear(const QString &g)
{
    if (m_gear == g)
        return;
    m_gear = g;
    emit gearChanged();
}

bool CarInfoModel::headlightsOn() const { return m_headlightsOn; }
void CarInfoModel::setHeadlightsOn(bool on)
{
    if (m_headlightsOn == on)
        return;
    m_headlightsOn = on;
    emit headlightsOnChanged();
}

bool CarInfoModel::leftSignal() const { return m_leftSignal; }
void CarInfoModel::setLeftSignal(bool on)
{
    if (m_leftSignal == on)
        return;
    m_leftSignal = on;
    emit leftSignalChanged();
}

bool CarInfoModel::rightSignal() const { return m_rightSignal; }
void CarInfoModel::setRightSignal(bool on)
{
    if (m_rightSignal == on)
        return;
    m_rightSignal = on;
    emit rightSignalChanged();
}
