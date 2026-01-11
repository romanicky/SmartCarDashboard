#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H
#include <QObject>
#include <QDebug>
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
    Q_INVOKABLE void previous();
    Q_INVOKABLE void next();
    Q_INVOKABLE void seek(qint64 position);
    Q_INVOKABLE void toggleFavorite();

    Q_PROPERTY(bool readyPlay READ readyPlay NOTIFY readyPlayChaned)
    Q_PROPERTY(bool isPlaying READ isPlaying WRITE setIsPlaying NOTIFY isPlayingChanged )
    Q_PROPERTY(QString musicTitle READ musicTitle WRITE setMusicTitle NOTIFY musicTitleChanged )
    Q_PROPERTY(QString singerName READ singerName WRITE setSingerName NOTIFY singerNameChanged )
    Q_PROPERTY(QImage albumArt READ albumArt WRITE setAlbumArt NOTIFY albumArtChanged )
    Q_PROPERTY(qint64 position READ postion NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(bool isFavorite READ isFavorite WRITE setIsFavorite NOTIFY isFavoriteChanged)

    bool readyPlay() const;
    bool isPlaying() const;

    QString singerName() const;
    QString musicTitle() const;
    QImage albumArt() const;
    qint64 position() const;
    qint64 duration() const;
    bool isFavorite() const;


    void setAlbumArt(const QImage &newAlbumArt);
    void setSingerName(const QString &newSingerName);
    void setMusicTitle(const QString &newMusicTitle);
    void setIsPlaying(bool newIsPlaying);
    void setIsFavorite(bool newIsFavorite);

    qint64 postion() const;

private:
    QString musicDirectory = "../../Music";
    QMediaPlayer *mediaPlayer;
    QAudioOutput *audioOutput;
    QStringList musicList;
    int currentIndex = 0;

    // Scan the music directory method
    void scanMusicDirectory();
    void loadTrack(int index);

    bool m_readyPlay = false;
    bool m_isPlaying = false;
    bool m_isFavorite = false;

    QString m_singerName;
    QString m_musicTitle;
    QImage m_albumArt;

    qint64 m_position;

    qint64 m_duration;

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
    void readyPlayChaned();
    void positionChanged();
    void durationChanged();
    void isFavoriteChanged();
};

#endif // MUSICPLAYER_H
