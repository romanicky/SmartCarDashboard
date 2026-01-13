#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QDir>
#include <QUrl>
#include <QStringList>
#include <QFileInfoList>
#include <QMediaMetaData>
#include <QImage>

class MusicPlayer : public QObject
{
    Q_OBJECT
public:
    explicit MusicPlayer(QObject *parent = nullptr);
    //destructor
    ~MusicPlayer() override;
    Q_INVOKABLE void playMusic();

    Q_PROPERTY(bool readyPlay READ readyPlay NOTIFY readyPlayChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QString musicTitle READ musicTitle NOTIFY musicTitleChanged)
    Q_PROPERTY(QString singerName READ singerName NOTIFY singerNameChanged)
    Q_PROPERTY(QImage albumArt READ albumArt NOTIFY albumArtChanged)


    bool readyPlay() const;
    bool isPlaying() const;

    QString singerName() const;

    QString musicTitle() const;

    QImage albumArt() const;

private:
    QString musicDirectory = "../../Music";
    QMediaPlayer *mediaPlayer;
    QAudioOutput *audioOutput;
    QStringList musicList;

    // Scan the music directory method
    void scanMusicDirectory();
    bool m_readyPlay=false;
    bool m_isPlaying=false;

    QString m_singerName;

    QString m_musicTitle;

    QImage m_albumArt;

private slots:
    void loadMusicIntoPlayer();
    void updateReadyPlayStatus();
    void updateMetaData();

signals:
    void scanMusicDone();
    void readyPlayChanged();
    void isPlayingChanged();
    void singerNameChanged();
    void musicTitleChanged();
    void albumArtChanged();
};

#endif // MUSICPLAYER_H
