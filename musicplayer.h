#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QDir>
#include <QUrl>
#include <QStringList>
#include <QMediaMetaData>
#include <QDebug>
#include <QImage>

class MusicPlayer : public QObject
{
    Q_OBJECT
public:
    explicit MusicPlayer(QObject *parent = nullptr);
    ~MusicPlayer() override;
    Q_INVOKABLE void playMusic();
    Q_INVOKABLE void nextTrack();
    Q_INVOKABLE void previousTrack();

    Q_PROPERTY(bool readyPlay READ readyPlay NOTIFY readyPlayChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QString musicTitle READ musicTitle NOTIFY musicTitleChanged)
    Q_PROPERTY(QString singerName READ singerName NOTIFY singerNameChanged)
    Q_PROPERTY(QString albumTitle READ albumTitle NOTIFY albumTitleChanged)
    Q_PROPERTY(int currentTrackIndex READ currentTrackIndex NOTIFY currentTrackIndexChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(float progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QImage albumArt READ albumArt WRITE setAlbumArt NOTIFY albumArtChanged FINAL)
    Q_PROPERTY(QString thumbailSource READ thumbailSource NOTIFY albumArtChanged)

    bool readyPlay() const
    {
        return mediaPlayer->mediaStatus() == QMediaPlayer::LoadedMedia;
    }

    bool isPlaying() const;

    QString musicTitle() const;

    QString singerName() const;

    QString albumTitle() const;

    int currentTrackIndex() const;

    qint64 position() const;
    void setPosition(qint64 pos);

    qint64 duration() const;

    Q_INVOKABLE void seek(qint64 position);

    float progress() const;

    QImage albumArt() const;
    void setAlbumArt(const QImage &newAlbumArt);

    QString thumbailSource() const;

private:
    QString musicDirectory = QDir::homePath() + "/Downloads/resource/Music";
    QMediaPlayer *mediaPlayer;
    QAudioOutput *audioOutput;
    QStringList playlist;
    int m_currentTrackIndex = -1;

    // Scan the music directory and populate the playlist
    void scanMusicDirectory();
    void playTrackAtIndex(int index);

    bool m_isPlaying = false;
    bool m_readyPlay = false;

    QString m_musicTitle;

    QString m_singerName;

    QString m_albumTitle; // album metadata title

    float m_progress;

    qint64 m_position = 0;
    qint64 m_duration = 0;

    QImage m_albumArt;

private slots:
    void loadMusicIntoPlayer();
    void updateReadyPlayStatus();
    void updateMetaData();

signals:
    void scanMusicDone();
    void readyPlayChanged();
    void isPlayingChanged();
    void musicTitleChanged();
    void singerNameChanged();
    void albumTitleChanged();
    void currentTrackIndexChanged();
    void positionChanged();
    void durationChanged();
    void progressChanged();
    void albumArtChanged();
};

#endif // MUSICPLAYER_H
