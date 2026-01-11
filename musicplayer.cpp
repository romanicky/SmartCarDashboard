#include "musicplayer.h"

MusicPlayer::MusicPlayer(QObject *parent)
    : QObject{parent}
{
    mediaPlayer = new QMediaPlayer(this);
    audioOutput = new QAudioOutput(this);
    mediaPlayer->setAudioOutput(audioOutput);
    audioOutput->setVolume(1);

    connect(this, &MusicPlayer::scanMusicDone,
            this, &MusicPlayer::loadMusicIntoPlayer);
    connect(mediaPlayer,&QMediaPlayer::mediaStatusChanged, this, &MusicPlayer::updateReadyPlayStatus);
    connect(mediaPlayer, &QMediaPlayer::mediaStatusChanged, this, &MusicPlayer::updateMetaData);
    connect(mediaPlayer, &QMediaPlayer::positionChanged, this, &MusicPlayer::positionChanged);
    connect(mediaPlayer, &QMediaPlayer::durationChanged, this, &MusicPlayer::durationChanged);

    scanMusicDirectory();
}

MusicPlayer::~MusicPlayer()
{
    delete mediaPlayer;
    delete audioOutput;
}

void MusicPlayer::playMusic()
{
    qDebug() << "Clicked~~~~";
    switch (mediaPlayer -> playbackState()) {
    case QMediaPlayer::StoppedState:
    case QMediaPlayer::PausedState:
        mediaPlayer -> play();
        m_isPlaying = true;
        emit isPlayingChanged();
        qDebug() << "Playing music.";
        break;
    case QMediaPlayer::PlayingState:
        mediaPlayer->pause();
        m_isPlaying = false;
        emit isPlayingChanged();
        qDebug() << "Music paused.";
        break;
    }
}

void MusicPlayer::previous()
{
    if (musicList.isEmpty()) return;

    currentIndex = (currentIndex - 1 + musicList.size()) % musicList.size();
    loadTrack(currentIndex);
    qDebug() << "Previous track:" << currentIndex;

}

void MusicPlayer::next()
{
    if (musicList.isEmpty()) return;

    currentIndex = (currentIndex + 1) % musicList.size();
    loadTrack(currentIndex);
    qDebug() << "Next track:" << currentIndex;
}

void MusicPlayer::seek(qint64 position)
{
    mediaPlayer->setPosition(position);
}

void MusicPlayer::toggleFavorite()
{
    m_isFavorite = !m_isFavorite;
    emit isFavoriteChanged();
    qDebug() << "Favorite toggled:" << m_isFavorite;
}

void MusicPlayer::scanMusicDirectory()
{
    QDir dir(musicDirectory);
    QStringList nameFilters = {"*.mp3", "*.wav","*.ogg","*.flac","*.m4a"};
    QFileInfoList fileInfoList = dir.entryInfoList(nameFilters, QDir::Files);
    qDebug() << "Found music files:" << fileInfoList;

    musicList.clear();
    for (const QFileInfo &fileInfo : fileInfoList) {
        musicList.append(fileInfo.absoluteFilePath());
    }

    emit scanMusicDone();
}

void MusicPlayer::loadTrack(int index)
{
    if (index < 0 || index >= musicList.size()) return;

    bool wasPlaying = m_isPlaying;
    QString trackPath = musicList[index];
    mediaPlayer->setSource(QUrl::fromLocalFile(trackPath));

    if(wasPlaying) {
        mediaPlayer->play();
    }
}

void MusicPlayer::loadMusicIntoPlayer()
{
    if (musicList.isEmpty()) {
        qWarning() << "No music files found in directory:" << musicDirectory;
        return;
    }

    // For demonstration, play the first track in the list
    QString firstTrack = musicList.first();

    mediaPlayer->setSource(QUrl::fromLocalFile(firstTrack));
}



void MusicPlayer::updateReadyPlayStatus()
{
    switch (mediaPlayer->mediaStatus()) {
    case QMediaPlayer::LoadedMedia:
        m_readyPlay = true;
        emit readyPlayChanged();
        break;
    }
}



void MusicPlayer::updateMetaData()
{
    if (mediaPlayer->mediaStatus() == QMediaPlayer::LoadedMedia) {
        auto metaData = mediaPlayer->metaData();

        QString title = metaData.stringValue(QMediaMetaData::Title);
        QString artist = metaData.stringValue(QMediaMetaData::ContributingArtist);

        if (!title.isEmpty()) {
            setMusicTitle(title);
        } else {
            //Use filename if no title metaData
            QFileInfo fileInfo(musicList[currentIndex]);
            setMusicTitle(fileInfo.baseName());
        }

        if (!artist.isEmpty()) {
            setSingerName(artist);
        } else {
            setSingerName("Unknown Artist");
        }

        QVariant artVariant = metaData.value(QMediaMetaData::ThumbnailImage);
        if (artVariant.isValid()) {
            setAlbumArt(artVariant.value<QImage>());
        }
        //QDebug() << "Metadata updated - Title:" << m_musicTitle << "Artist:" << m_singerName;
    }
}

//Getters

bool MusicPlayer::readyPlay() const
{
    return m_readyPlay;
}

bool MusicPlayer::isPlaying() const
{
    return m_isPlaying;
}

QString MusicPlayer::musicTitle() const
{
    return m_musicTitle;
}

QString MusicPlayer::singerName() const
{
    return m_singerName;
}

QImage MusicPlayer::albumArt() const
{
    return m_albumArt;
}

qint64 MusicPlayer::postion() const
{
    return mediaPlayer->position();
}

qint64 MusicPlayer::duration() const
{
    return mediaPlayer->duration();
}

bool MusicPlayer::isFavorite() const
{
    return m_isFavorite;
}

//Setters

void MusicPlayer::setAlbumArt(const QImage &newAlbumArt)
{
    if (m_albumArt == newAlbumArt)
        return;
    m_albumArt = newAlbumArt;
    emit albumArtChanged();
}

void MusicPlayer::setSingerName(const QString &newSingerName)
{
    if (m_singerName == newSingerName)
        return;
    m_singerName = newSingerName;
    emit singerNameChanged();
}

void MusicPlayer::setMusicTitle(const QString &newMusicTitle)
{
    if (m_musicTitle == newMusicTitle)
        return;
    m_musicTitle = newMusicTitle;
    emit musicTitleChanged();
}

void MusicPlayer::setIsPlaying(bool newIsPlaying)
{
    if (m_isPlaying == newIsPlaying)
        return;
    m_isPlaying = newIsPlaying;
    emit isPlayingChanged();
}

void MusicPlayer::setIsFavorite(bool newIsFavorite)
{
    if (m_isFavorite == newIsFavorite)
        return;
    m_isFavorite = newIsFavorite;
    emit isFavoriteChanged();
}















