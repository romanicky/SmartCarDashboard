#ifndef CARINFOMODEL_H
#define CARINFOMODEL_H

#include <QObject>

class CarInfoModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString vehicleName READ vehicleName WRITE setVehicleName NOTIFY vehicleNameChanged)
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(int range READ range WRITE setRange NOTIFY rangeChanged)
    Q_PROPERTY(double average READ average WRITE setAverage NOTIFY averageChanged)
    Q_PROPERTY(double capacity READ capacity WRITE setCapacity NOTIFY capacityChanged)
    Q_PROPERTY(QString imageSource READ imageSource WRITE setImageSource NOTIFY imageSourceChanged)
    Q_PROPERTY(QString gear READ gear WRITE setGear NOTIFY gearChanged)
    Q_PROPERTY(bool headlightsOn READ headlightsOn WRITE setHeadlightsOn NOTIFY headlightsOnChanged)
    Q_PROPERTY(bool leftSignal READ leftSignal WRITE setLeftSignal NOTIFY leftSignalChanged)
    Q_PROPERTY(bool rightSignal READ rightSignal WRITE setRightSignal NOTIFY rightSignalChanged)

public:
    explicit CarInfoModel(QObject *parent = nullptr);

    QString vehicleName() const;
    void setVehicleName(const QString &name);

    int speed() const;
    void setSpeed(int s);

    int range() const;
    void setRange(int r);

    double average() const;
    void setAverage(double a);

    double capacity() const;
    void setCapacity(double c);

    QString imageSource() const;
    void setImageSource(const QString &src);

    QString gear() const;
    void setGear(const QString &g);

    bool headlightsOn() const;
    void setHeadlightsOn(bool on);

    bool leftSignal() const;
    void setLeftSignal(bool on);

    bool rightSignal() const;
    void setRightSignal(bool on);

signals:
    void vehicleNameChanged();
    void speedChanged();
    void rangeChanged();
    void averageChanged();
    void capacityChanged();
    void imageSourceChanged();
    void gearChanged();
    void headlightsOnChanged();
    void leftSignalChanged();
    void rightSignalChanged();

private:
    QString m_vehicleName;
    int m_speed = 0;
    int m_range = 0;
    double m_average = 0.0;
    double m_capacity = 0.0;
    QString m_imageSource;
    QString m_gear;
    bool m_headlightsOn = false;
    bool m_leftSignal = false;
    bool m_rightSignal = false;
};

#endif
