#include "radiusimage.h"

RadiusImage::RadiusImage(QQuickPaintedItem *parent)
    : QQuickPaintedItem{parent}
{
    connect(this, &RadiusImage::imageChanged, this, &RadiusImage::update);
}

void RadiusImage::paint(QPainter *painter)
{
    if (m_image.isNull())
        return;
    QPainterPath path;
    path.addRoundedRect(boundingRect(),m_radius,m_radius);
    painter->setClipPath(path);
    painter->drawImage(boundingRect(),m_image);
}

QImage RadiusImage::image() const
{
    return m_image;
}


void RadiusImage::setImage(const QImage &newImage)
{
    if(m_image == newImage)
        return;
    m_image = newImage;
    emit imageChanged(rect);
}


int RadiusImage::radius() const
{
    return m_radius;
}

void RadiusImage::setRadius(int newRadius)
{
    if(m_radius == newRadius)
        return ;
    m_radius = newRadius;
    emit radiusChanged();
}

