#include "musicplayer.h"
#include <QBuffer>

MusicPlayer::MusicPlayer(QObject *parent)
    : QObject{parent}
{
    mediaPlayer = new QMediaPlayer(this);
    audioOutput = new QAudioOutput(this);
    mediaPlayer->setAudioOutput(audioOutput);
    connect(this, &MusicPlayer::scanMusicDone,
            this, &MusicPlayer::loadMusicIntoPlayer);
    connect(mediaPlayer, &QMediaPlayer::mediaStatusChanged,
            this, &MusicPlayer::updateReadyPlayStatus);
    connect(mediaPlayer, &QMediaPlayer::mediaStatusChanged,
            this, &MusicPlayer::updateMetaData);
    scanMusicDirectory();
}

MusicPlayer::~MusicPlayer() {
    delete mediaPlayer;
    delete audioOutput;
}

void MusicPlayer::playMusic()
{
    switch (mediaPlayer->playbackState()) {
    case QMediaPlayer::StoppedState:
    case QMediaPlayer::PausedState:
        mediaPlayer->play();
        m_isPlaying = true;
        emit isPlayingChanged();
        qDebug() << "Playing music";
        break;
    case QMediaPlayer::PlayingState:
        mediaPlayer->pause();
        m_isPlaying = false;
        emit isPlayingChanged();
        qDebug() << "Music paused";
        break;
    default:
        break;
    }
}

void MusicPlayer::nextTrack()
{
    if (playlist.isEmpty())
        return;
    m_currentTrackIndex = (m_currentTrackIndex + 1) % playlist.count();
    playTrackAtIndex(m_currentTrackIndex);
}

void MusicPlayer::previousTrack()
{
    if (playlist.isEmpty())
        return;
    m_currentTrackIndex = (m_currentTrackIndex - 1 + playlist.count()) % playlist.count();
    playTrackAtIndex(m_currentTrackIndex);
}

void MusicPlayer::playTrackAtIndex(int index)
{
    if (index < 0 || index >= playlist.count())
        return;
    m_currentTrackIndex = index;
    mediaPlayer->setSource(QUrl::fromLocalFile(playlist.at(index)));
    mediaPlayer->play();
    m_isPlaying = true;
    emit currentTrackIndexChanged();
    emit isPlayingChanged();
    qDebug() << "Playing track at index" << index << ":" << playlist.at(index);
}

void MusicPlayer::scanMusicDirectory()
{
    QDir dir(musicDirectory);
    QStringList nameFilters = {"*.mp3", "*.wav", "*.flac", "*.aac"};
    QFileInfoList fileList = dir.entryInfoList(nameFilters, QDir::Files);

    playlist.clear();
    for (const QFileInfo &fileInfo : fileList) {
        playlist.append(fileInfo.absoluteFilePath());
    }

    emit scanMusicDone();
}

void MusicPlayer::loadMusicIntoPlayer()
{
    if (playlist.isEmpty()) {
        qWarning() << "No music files found in directory:" << musicDirectory;
        return;
    }

    // For simplicity, play the first track in the playlist
    m_currentTrackIndex = 0;
    QString firstTrack = playlist.first();
    mediaPlayer->setSource(QUrl::fromLocalFile(firstTrack));
}

void MusicPlayer::updateReadyPlayStatus()
{
    switch (mediaPlayer->mediaStatus()) {
    case QMediaPlayer::LoadedMedia:
        m_isPlaying = true;
        emit readyPlayChanged();
        break;
    default:
        break;
    }
}

void MusicPlayer::updateMetaData()
{
    qDebug() << "Updating metadata" << mediaPlayer->mediaStatus();
    if (mediaPlayer->mediaStatus() == QMediaPlayer::LoadedMedia) {
        auto metaData = mediaPlayer->metaData();
        qDebug() << "Metadata:" << metaData;
        m_musicTitle = metaData.stringValue(QMediaMetaData::Title);
        m_singerName = metaData.stringValue(QMediaMetaData::ContributingArtist);
        m_albumArt = metaData.value(QMediaMetaData::ThumbnailImage).value<QImage>();


        emit albumArtChanged();
        emit musicTitleChanged();
        emit singerNameChanged();
    }
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

int MusicPlayer::currentTrackIndex() const
{
    return m_currentTrackIndex;
}

float MusicPlayer::progress() const
{
    return m_progress;
}

QImage MusicPlayer::albumArt() const
{
    return m_albumArt;
}

void MusicPlayer::setAlbumArt(const QImage &newAlbumArt)
{
    if (m_albumArt == newAlbumArt)
        return;
    m_albumArt = newAlbumArt;
    emit albumArtChanged();
}

QString MusicPlayer::thumbailSource() const
{
    if (m_albumArt.isNull())
        return "";
    
    // Convert QImage to base64 data URL
    QByteArray byteArray;
    QBuffer buffer(&byteArray);
    buffer.open(QIODevice::WriteOnly);
    m_albumArt.save(&buffer, "PNG");
    QString base64 = QString::fromLatin1(byteArray.toBase64());
    return "data:image/png;base64," + base64;
}
