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
    connect(mediaPlayer, &QMediaPlayer::mediaStatusChanged,
            this, &MusicPlayer::updateReadyPlayStatus);
    connect(mediaPlayer, &QMediaPlayer::mediaStatusChanged,
            this, &MusicPlayer::updateMetaData);
    scanMusicDirectory();

}

MusicPlayer::~MusicPlayer()
{
    delete mediaPlayer;
    delete audioOutput;
}

void MusicPlayer::playMusic()
{
    qDebug() << "Clicked~~~~~";
    switch (mediaPlayer->playbackState()) {
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

void MusicPlayer::scanMusicDirectory()
{
    QDir dir(musicDirectory);
    QStringList nameFilters = {"*.mp3", "*.wav", "*.ogg", "*.flac", "*.m4a"};
    QFileInfoList fileInfoList = dir.entryInfoList(nameFilters, QDir::Files);
    qDebug() << "Found music files:" << fileInfoList;

    musicList.clear();
    for (const QFileInfo &fileInfo : fileInfoList) {
        musicList.append(fileInfo.absoluteFilePath());
    }

    emit scanMusicDone();
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

        m_musicTitle = metaData.stringValue(QMediaMetaData::Title);
        m_singerName = metaData.stringValue(QMediaMetaData::ContributingArtist);
        m_albumArt = metaData.value(QMediaMetaData::ThumbnailImage).value<QImage>();

        emit albumArtChanged();
        emit musicTitleChanged();
        emit singerNameChanged();
    }
}


bool MusicPlayer::readyPlay() const
{
    return m_readyPlay;
}

bool MusicPlayer::isPlaying() const
{
    return m_isPlaying;
}

QString MusicPlayer::singerName() const
{
    return m_singerName;
}

QString MusicPlayer::musicTitle() const
{
    return m_musicTitle;
}

QImage MusicPlayer::albumArt() const
{
    return m_albumArt;
}
