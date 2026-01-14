#include "CarDataReceiver.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

CarDataReceiver::CarDataReceiver(CarInfoModel *model, QObject *parent)
    : QObject(parent), m_socket(new QTcpSocket(this)), m_carModel(model)
{
    connect(m_socket, &QTcpSocket::connected, this, &CarDataReceiver::onConnected);
    connect(m_socket, &QTcpSocket::disconnected, this, &CarDataReceiver::onDisconnected);
    connect(m_socket, &QTcpSocket::readyRead, this, &CarDataReceiver::onReadyRead);
    connect(m_socket, &QTcpSocket::errorOccurred, this, &CarDataReceiver::onError);
}

void CarDataReceiver::connectToSimulator(const QString &host, quint16 port)
{
    qDebug() << "Connecting to simulator at" << host << ":" << port;
    m_socket->connectToHost(host, port);
}

void CarDataReceiver::onConnected()
{
    qDebug() << "Connected to car simulator!";
}

void CarDataReceiver::onDisconnected()
{
    qDebug() << "Disconnected from car simulator";
}

void CarDataReceiver::onReadyRead()
{
    m_buffer.append(m_socket->readAll());

    // Process complete lines (JSON messages end with \n)
    while (m_buffer.contains('\n'))
    {
        int newlineIndex = m_buffer.indexOf('\n');
        QByteArray line = m_buffer.left(newlineIndex);
        m_buffer.remove(0, newlineIndex + 1);

        // Parse JSON
        QJsonDocument doc = QJsonDocument::fromJson(line);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();

            // Update model with received data
            if (obj.contains("speed"))
            {
                m_carModel->setSpeed(obj["speed"].toInt());
                qDebug() << "Speed:" << obj["speed"].toInt();
            }
            if (obj.contains("leftSignal"))
            {
                m_carModel->setLeftSignal(obj["leftSignal"].toBool());
                qDebug() << "Left signal:" << obj["leftSignal"].toBool();
            }
            if (obj.contains("rightSignal"))
            {
                m_carModel->setRightSignal(obj["rightSignal"].toBool());
                qDebug() << "Right signal:" << obj["rightSignal"].toBool();
            }
            if (obj.contains("gear"))
            {
                m_carModel->setGear(obj["gear"].toString());
                qDebug() << "Gear:" << obj["gear"].toString();
            }
            if (obj.contains("headlightsOn"))
            {
                m_carModel->setHeadlightsOn(obj["headlightsOn"].toBool());
                qDebug() << "Headlights On:" << obj["headlightsOn"].toBool();
            }
            if (obj.contains("capacity"))
            {
                m_carModel->setCapacity(obj["capacity"].toDouble());
                qDebug() << "Capacity:" << obj["capacity"].toDouble();
            }
        }
    }
}

void CarDataReceiver::onError(QAbstractSocket::SocketError error)
{
    qDebug() << "Socket error:" << m_socket->errorString();
}
