#ifndef CARDATARECEIVER_H
#define CARDATARECEIVER_H

#include <QObject>
#include <QTcpSocket>
#include "CarInfoModel.h"

class CarDataReceiver : public QObject
{
    Q_OBJECT

public:
    explicit CarDataReceiver(CarInfoModel *model, QObject *parent = nullptr);
    void connectToSimulator(const QString &host = "127.0.0.1", quint16 port = 12345);

private slots:
    void onConnected();
    void onDisconnected();
    void onReadyRead();
    void onError(QAbstractSocket::SocketError error);

private:
    QTcpSocket *m_socket;
    CarInfoModel *m_carModel;
    QByteArray m_buffer;
};

#endif // CARDATARECEIVER_H
