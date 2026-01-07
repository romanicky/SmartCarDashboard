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
            }
            if (obj.contains("leftSignal"))
            {
                // Store signal states if needed
                qDebug() << "Left signal:" << obj["leftSignal"].toBool();
            }
            if (obj.contains("rightSignal"))
            {
                qDebug() << "Right signal:" << obj["rightSignal"].toBool();
            }
        }
    }
}

void CarDataReceiver::onError(QAbstractSocket::SocketError error)
{
    qDebug() << "Socket error:" << m_socket->errorString();
}
