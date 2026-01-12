#include "musicplayer.h"

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
