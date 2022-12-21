#ifndef MUSICCONTROLLER_H
#define MUSICCONTROLLER_H

#include <QObject>

#include <QString>
#include <QStringList>
#include <QDebug>
#include <QDir>
#include <QList>
#include <QTimer>
#include <QTime>
#include <QFileInfo>
#include <QImage>
#include <QFileInfoList>
#include <QMediaMetaData>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include "qmediaplaylist.h"
#include <QUrl>
#include <QAudioOutput>
#include <QAudioFormat>
#include <filelistmodeldata.h>
#include <QStandardPaths>
#include <iostream>
#include <fstream>

#include <deviceWatcher/qdevicewatcher.h>

#define SYSFS_MTAB_DIR "/etc/mtab"

class MusicController : public QObject
{
    Q_OBJECT
    QMediaPlaylist *m_playlist = nullptr;
    QMediaPlayer *m_player = nullptr;
    QDeviceWatcher *m_watcher = nullptr;
    QTimer *m_watcherTimer =  nullptr;
    QStringList m_wathcerList;
    QStringList m_usbList;
    int watcherCounter = 0;

    float m_Volume;

    int m_volume;

    bool m_isMuted;

    QMediaPlayer::State m_state;

    qint64 m_duration;

    qint64 m_position;

    QString m_metadata;

    QMediaPlayer::MediaStatus m_mediaStatus;

    QStringList currentPath;
    QFileInfoList pathItems;

    QDir* currentDir;

    bool isMounted = false;
    QString mountPath = "/home/reza/C1/Music";
    QString devPath = "";



    QList<FileListModelData *> m_filesList;

    int m_playlistCurrentIndex;

public:
    explicit MusicController(QObject *parent = nullptr);
    // Music
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool isMuted READ isMuted WRITE setIsMuted NOTIFY isMutedChanged)
    Q_PROPERTY(QMediaPlayer::State state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(qint64 duration READ duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(QString metadata READ metadata WRITE setMetadata NOTIFY metadataChanged)
    Q_PROPERTY(QMediaPlayer::MediaStatus mediaStatus READ mediaStatus WRITE setMediaStatus NOTIFY mediaStatusChanged)
    Q_PROPERTY(QList<FileListModelData*> filesList READ filesList WRITE setFilesList NOTIFY filesListChanged)
    Q_PROPERTY(int playlistCurrentIndex READ playlistCurrentIndex WRITE setPlaylistCurrentIndex NOTIFY playlistCurrentIndexChanged)


    const QMediaPlaylist &playlist() const;


    int volume() const;
    void setVolume(int newVolume);

    bool isMuted() const;
    void setIsMuted(bool newIsMuted);

    const QMediaPlayer::State &state() const;
    void setState(const QMediaPlayer::State &newState);

    qint64 duration() const;
    void setDuration(qint64 newDuration);

    qint64 position() const;
    void setPosition(qint64 newPosition);

    const QString &metadata() const;
    void setMetadata(const QString &newMetadata);

    const QMediaPlayer::MediaStatus &mediaStatus() const;
    void setMediaStatus(const QMediaPlayer::MediaStatus &newMediaStatus);


    const QList<FileListModelData *> &filesList() const;
    void setFilesList(const QList<FileListModelData *> &newFilesList);


    bool isMusicFile(const QFileInfo &info);

    void setPlaylist(const QMediaPlaylist &newPlaylist);

    QString createPath();

    int playlistCurrentIndex() const;
    void setPlaylistCurrentIndex(int newPlaylistCurrentIndex);


    QTimer *timer;
    QString getMountPoint(QString path);


public slots:
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void next();
    Q_INVOKABLE void mute();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void getFilesInCurrentDir();
    Q_INVOKABLE void listItemDoubleClicked(QString name);
    Q_INVOKABLE void playPauseClicked();
    Q_INVOKABLE void setPositionWithoutNotify(qint64 value);
    Q_INVOKABLE void setVolumeWithoutNotify(int value);
    Q_INVOKABLE QUrl imageToUrl(const QImage& image);
    Q_INVOKABLE bool fillPlayList();

    void timer_handle();
    void watcherTimerHandle();

    void mPositionChanged();
    void mDurationChanged();
    void mMediaStatusChanged();

    void metaDataChanged();
    void playlistPositionChanged(int);
    void mediaErrorOccured(QMediaPlayer::Error err,const QString &str);
    void seek(int seconds);
    void jump(const QModelIndex &index);

    void statusChanged(QMediaPlayer::MediaStatus status);
    void mediaStateChanged(QMediaPlayer::State state);
    void bufferingProgress(int progress);

    void slotDeviceAdded(const QString &dev);
    void slotDeviceRemoved(const QString &dev);
    void slotDeviceChanged(const QString &dev);


signals:
    void playlistChanged();
    void volumeChanged();
    void isMutedChanged();
    void stateChanged();
    void durationChanged();
    void positionChanged();
    void metadataChanged();
    void mediaStatusChanged();
    void filesListChanged();
    void playlistCurrentIndexChanged();
};



#endif // MUSICCONTROLLER_H
