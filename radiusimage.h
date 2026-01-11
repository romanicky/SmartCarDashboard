#ifndef RADIUSIMAGE_H
#define RADIUSIMAGE_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>
#include <QPainterPath>
#include <QDebug>

class RadiusImage : public QQuickPaintedItem
{
    Q_OBJECT
public:
    explicit RadiusImage(QQuickPaintedItem *parent = nullptr);
    void paint(QPainter *painter) override;
    Q_PROPERTY(QImage image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(int radius READ radius WRITE setRadius NOTIFY radiusChanged )

    QImage image() const;
    void setImage(const QImage &newImage);

    int radius() const;
    void setRadius(int newRadius);

signals:
    void imageChanged(const QRect &rect = QRect());
    void radiusChanged();

private:
    QRect rect = QRect (0,0,200,200);
    QImage m_image;
    int m_radius;
};
#endif // RADIUSIMAGE_H
