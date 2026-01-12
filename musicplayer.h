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

    Q_PROPERTY(bool readyPlay READ readyPlay NOTIFY readyPlayChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QString musicTitle READ musicTitle NOTIFY musicTitleChanged)
    Q_PROPERTY(QString singerName READ singerName NOTIFY singerNameChanged)
    // progress
    Q_PROPERTY(float progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QImage albumArt READ albumArt WRITE setAlbumArt NOTIFY albumArtChanged FINAL)

    bool readyPlay() const {
        return mediaPlayer->mediaStatus() == QMediaPlayer::LoadedMedia;
    }

    bool isPlaying() const;

    QString musicTitle() const;

    QString singerName() const;

    float progress() const;

    QImage albumArt() const;
    void setAlbumArt(const QImage &newAlbumArt);

private:
    QString musicDirectory = QDir::homePath() + "/Downloads/resource/Music";
    QMediaPlayer* mediaPlayer;
    QAudioOutput* audioOutput;
    QStringList playlist;

    // Scan the music directory and populate the playlist
    void scanMusicDirectory();

    bool m_isPlaying = false;
    bool m_readyPlay = false;

    QString m_musicTitle;

    QString m_singerName;

    float m_progress;

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
    void progressChanged();
    void albumArtChanged();
};

#endif // MUSICPLAYER_H
