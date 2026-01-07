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
