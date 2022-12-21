#include "musicController.h"
#include <QBuffer>
#include <QUrl>
#include <QMediaContent>
#include <QMediaService>
#include <QAudioOutputSelectorControl>
#include <QStandardPaths>

MusicController::MusicController(QObject *parent) : QObject(parent)
{

    m_watcher = new QDeviceWatcher;
    m_watcher->appendEventReceiver(this);
    connect(m_watcher,
            SIGNAL(deviceAdded(QString)),
            this,
            SLOT(slotDeviceAdded(QString)),
            Qt::DirectConnection);
    connect(m_watcher,
            SIGNAL(deviceChanged(QString)),
            this,
            SLOT(slotDeviceChanged(QString)),
            Qt::DirectConnection);
    connect(m_watcher,
            SIGNAL(deviceRemoved(QString)),
            this,
            SLOT(slotDeviceRemoved(QString)),
            Qt::DirectConnection);
    m_watcher->start();

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(timer_handle()));
    timer->start(1000);

    m_watcherTimer = new QTimer(this);
    connect(m_watcherTimer, SIGNAL(timeout()), this, SLOT(watcherTimerHandle()));
    m_watcherTimer->start(1000);

    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/";
    QString filename=path + "lastDevices.txt";
    QFile file( filename );
    if ( file.open(QIODevice::ReadOnly) )
    {
        QTextStream in(&file);
        QString str = in.readAll();
        auto temp = str.split("\n");
        m_wathcerList.clear();
        for(int i = 0;i< temp.length();i++)
            m_wathcerList << temp[i];
        qDebug() << m_wathcerList;
        file.close();
    }
    watcherCounter = 20;
    //! [create-objs]
    m_player = new QMediaPlayer(this);

    //    QMediaService *svc = m_player->service();
    //    if (svc != nullptr)
    //    {
    //        QAudioOutputSelectorControl *out = qobject_cast<QAudioOutputSelectorControl *>
    //                                           (svc->requestControl(QAudioOutputSelectorControl_iid));
    //        if (out != nullptr)
    //        {
    //            out->setActiveOutput(this->ui->comboBox->currentText());
    //            svc->releaseControl(out);
    //        }
    //    }

    // owned by PlaylistModel
    m_playlist = new QMediaPlaylist();
    m_player->setPlaylist(m_playlist);

    //! [create-objs]
    //!
    //!
    connect(m_player, &QMediaPlayer::durationChanged, this, &MusicController::mDurationChanged);
    connect(m_player, &QMediaPlayer::positionChanged, this, &MusicController::mPositionChanged);
    connect(m_player, QOverload<>::of(&QMediaPlayer::metaDataChanged), this, &MusicController::metaDataChanged);
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, &MusicController::mMediaStatusChanged);
    connect(m_playlist, &QMediaPlaylist::currentIndexChanged, this, &MusicController::playlistPositionChanged);
    //connect(m_player, &QMediaPlayer::mediaStatusChanged, this, &MusicController::statusChanged);
    connect(m_player, &QMediaPlayer::bufferStatusChanged, this, &MusicController::bufferingProgress);
    //connect(m_player, QOverload<QMediaPlayer::Error>::of(&QMediaPlayer::error), this, &MusicController::displayErrorMessage);
    connect(m_player, &QMediaPlayer::stateChanged, this, &MusicController::mediaStateChanged);

    //m_playlist = new QMediaPlaylist();
    m_playlist->setPlaybackMode(QMediaPlaylist::Loop);
    //m_player->setPlaylist(m_playlist);
    //! [2]


    setVolume(50);
    setIsMuted(false);
    metaDataChanged();
    qInfo() << "Supported audio roles:";
    mountPath = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Music";
    m_usbList << mountPath;
    if(mountPath != "")
    {
        isMounted = true;
        currentDir = new QDir(mountPath);
        currentPath.append( mountPath);
        getFilesInCurrentDir();
    }

}


const QMediaPlaylist &MusicController::playlist() const
{
    return *m_playlist;
}

void MusicController::play()
{
    m_player->play();
}

void MusicController::pause()
{
    m_player->pause();
}

void MusicController::stop()
{
    m_player->stop();
}

void MusicController::next()
{
    m_playlist->next();
    play();
}

void MusicController::mute()
{
    m_player->setMuted(true);
}

void MusicController::previous()
{
    // Go to previous track if we are within the first 5 seconds of playback
    // Otherwise, seek to the beginning.
    if (m_player->position() <= 5000) {
        m_playlist->previous();
        play();
    } else {
        m_player->setPosition(0);
    }
}

void MusicController::metaDataChanged()
{
    auto metaData = ""; // m_player->metaData();
    setMetadata(metaData);
}

void MusicController::playlistPositionChanged(int value)
{
    setPlaylistCurrentIndex(value);
}

void MusicController::mediaErrorOccured(QMediaPlayer::Error err, const QString &str)
{
    qWarning() <<str;
}

void MusicController::seek(int seconds)
{

}

void MusicController::jump(const QModelIndex &index)
{

}

void MusicController::statusChanged(QMediaPlayer::MediaStatus status)
{

}

void MusicController::mediaStateChanged(QMediaPlayer::State state)
{
    setState(state);
}

void MusicController::bufferingProgress(int progress)
{

}

void MusicController::slotDeviceAdded(const QString &dev)
{
    qDebug() << dev;
    watcherCounter += 2;
    m_wathcerList << dev;
    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/";
    QString filename= path + "lastDevices.txt";
    qDebug() << "^^^^^^$$$$$$$ " << filename;
    QFile file( filename );
    if ( file.open(QIODevice::WriteOnly) ){
        QTextStream stream( &file );
        for(int i = 0;i<m_wathcerList.count();i++){
            stream << m_wathcerList[i] << "\n";
        }
        file.flush();
        file.close();
    }
    //qDebug() << getMountPoint(dev);
}

void MusicController::slotDeviceRemoved(const QString &dev)
{
    qDebug() << dev;
    watcherCounter += 2;
    m_wathcerList.removeOne(dev);
    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/";
    QString filename= path + "lastDevices.txt";
    QFile file( filename );
    if ( file.open(QIODevice::WriteOnly) ){
        QTextStream stream( &file );
        for(int i = 0;i<m_wathcerList.count();i++){
            stream << m_wathcerList[i] << "\n";
        }
        file.flush();
        file.close();
    }
    //qDebug() << getMountPoint(dev);
}

void MusicController::slotDeviceChanged(const QString &dev)
{
    qDebug() << dev;
}



int MusicController::volume() const
{
    return m_volume;
}

void MusicController::setVolume(int newVolume)
{
    if (m_volume == newVolume)
        return;
    m_volume = newVolume;
    qInfo() << "newVolume " << newVolume;
    m_player->setVolume(newVolume);
    emit volumeChanged();
}

bool MusicController::isMuted() const
{
    return m_isMuted;
}

void MusicController::setIsMuted(bool newIsMuted)
{
    if (m_isMuted == newIsMuted)
        return;
    m_isMuted = newIsMuted;
    m_player->setMuted(newIsMuted);
    emit isMutedChanged();
}

const QMediaPlayer::State &MusicController::state() const
{
    qDebug() << "m_state" << (int)m_state;
    return m_state;
}

void MusicController::setState(const QMediaPlayer::State &newState)
{
    if (m_state == newState)
        return;
    m_state = newState;
    emit stateChanged();
}

qint64 MusicController::duration() const
{
    return m_duration;
}

void MusicController::setDuration(qint64 newDuration)
{
    if (m_duration == newDuration)
        return;
    m_duration = newDuration;
    emit durationChanged();
}

qint64 MusicController::position() const
{
    m_player->position();
    return m_position;
}

void MusicController::setPosition(qint64 newPosition)
{
    if (m_position == newPosition)
        return;
    m_position = newPosition;
    //m_player->setPosition(newPosition);
    //qDebug() << "newPosition " <<newPosition;
    emit positionChanged();
}

const QString &MusicController::metadata() const
{
    return m_metadata;
}

void MusicController::setMetadata(const QString &newMetadata)
{
    if (m_metadata == newMetadata)
        return;
    m_metadata = newMetadata;
    emit metadataChanged();
}

const QMediaPlayer::MediaStatus &MusicController::mediaStatus() const
{
    return m_mediaStatus;
}

void MusicController::setMediaStatus(const QMediaPlayer::MediaStatus &newMediaStatus)
{
    if (m_mediaStatus == newMediaStatus)
        return;
    m_mediaStatus = newMediaStatus;
    switch (m_mediaStatus) {
    case QMediaPlayer::NoMedia:
    case QMediaPlayer::LoadedMedia:
        break;
    case QMediaPlayer::LoadingMedia:
        break;
    case QMediaPlayer::BufferingMedia:
    case QMediaPlayer::BufferedMedia:
        break;
    case QMediaPlayer::StalledMedia:
        break;
    case QMediaPlayer::EndOfMedia:
        qDebug() << "end of media";
        m_playlist->next();
        m_player->play();
        break;
    case QMediaPlayer::UnknownMediaStatus:
    case QMediaPlayer::InvalidMedia:
        m_playlist->next();
        m_player->play();
        break;
    }
    emit mediaStatusChanged();
}


void MusicController::getFilesInCurrentDir()
{
    currentDir->refresh();
    auto info = currentDir->entryInfoList();
    int j = 0;
    m_filesList.clear();
    if(currentPath.length()>1){
        auto back = new FileListModelData(this);
        back->setIsBackItem(true);
        back->setName("Parent Directory");
        back->setItemType(0);
        m_filesList.append(back);
        j++;
    }
    for (int i =0; i<info.length() ; i++ ) {
        if(info[i].isDir() && !info[i].isHidden())
        {
            auto back = new FileListModelData(this);
            back->setIsBackItem(false);
            back->setName(info[i].fileName());
            back->setItemType(1);
            m_filesList.append(back);
            j++;
        }
        else if(isMusicFile(info[i])  && !info[i].isHidden()){
            auto back = new FileListModelData(this);
            back->setIsBackItem(false);
            back->setName(info[i].fileName());
            back->setItemType(2);
            m_filesList.append(back);
            j++;
        }
    }
    emit filesListChanged();
}

void MusicController::listItemDoubleClicked(QString name)
{
    qInfo() << "listItemDoubleClicked";
    auto path = createPath() + "/" + name;
    QFileInfo file(path);
    QDir dir ;
    if(!file.exists() && !currentPath.isEmpty()){
        currentPath.pop_back();
        currentDir = new QDir(createPath());
        getFilesInCurrentDir();
    }
    if(file.exists() && file.isDir())
    {
        currentPath.append(name);
        currentDir = new QDir(createPath());
        getFilesInCurrentDir();
    }
    else if(file.exists()) {
        m_player->stop();
        m_playlist->clear();
        int index = 0;
        auto info = currentDir->entryInfoList();
        for (int i =0; i<info.length() ; i++ ) {
            if(!info[i].isDir() && isMusicFile(info[i])  && !info[i].isHidden()){
                QUrl url = QUrl::fromLocalFile(info[i].canonicalFilePath());
                m_playlist->addMedia(url);
                if(url.path().endsWith(name))
                {

                }
            }
        }
        for(int i=0;i< m_playlist->mediaCount();i++){
            if(m_playlist->media(i).canonicalUrl().path().endsWith(name))
            {
                index = i;break;
            }
        }

        qInfo() << m_playlist;
        qInfo() << "m_playlist";
        qInfo() << index;
        qInfo() << "index";
        m_playlist->setCurrentIndex(index);
        qInfo() << "playPauseClicked";
        playPauseClicked();
    }
}

const QList<FileListModelData *> &MusicController::filesList() const
{
    return m_filesList;
}

void MusicController::setFilesList(const QList<FileListModelData *> &newFilesList)
{
    if (m_filesList == newFilesList)
        return;
    m_filesList = newFilesList;
    emit filesListChanged();
}

bool MusicController::isMusicFile(const QFileInfo &info)
{
    auto ext = info.suffix().toLower();
    return ( ext == "mp3" ||
             ext == "ogg" ||
             ext == "wav" ||
             ext == "wma" ||
             ext == "webm");
}

void MusicController::setPlaylist(const QMediaPlaylist &newPlaylist)
{

}

QString MusicController::createPath()
{
    QString str = "";
    for (int i = 0; i< currentPath.length() ; i++ ) {
        if(i>0) str += "/";
        str += currentPath.at(i);
    }
    return str;
}

void MusicController::playPauseClicked()
{
    qInfo() << "m_playlist->isEmpty() " << m_playlist->isEmpty();
    qInfo() << "m_state " << m_state;
    if(m_playlist->isEmpty()) return;
    if(m_state == QMediaPlayer::StoppedState){
        //m_player->play();
        play();
        qInfo() << "play" << m_playlist->currentIndex();
    }
    else if(m_state == QMediaPlayer::PausedState )
    {
        //m_player->play();
        play();
        qInfo() << "play" << m_playlist->currentIndex();
    }
    else if(m_state == QMediaPlayer::PlayingState)
    {
        pause();
        //m_player->pause();
    }
    else{
        qDebug() << "play";
        play();
        //m_player->play();
    }
}

void MusicController::setPositionWithoutNotify(qint64 value)
{
    m_player->setPosition(value);
}

void MusicController::setVolumeWithoutNotify(int value)
{
    setVolume(value);
}

QUrl MusicController::imageToUrl(const QImage &image)
{
    QByteArray byteArray;
    QBuffer buffer(&byteArray);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "png");
    QString base64 = QString::fromUtf8(byteArray.toBase64());
    return QString("data:image/png;base64,") + base64;
}



void MusicController::timer_handle()
{
    //qDebug() << "is Playing => "<<m_player->hasAudio();
    //setPosition(m_player->position());

}

void MusicController::watcherTimerHandle()
{
    if(watcherCounter <= 0) return;
    watcherCounter--;

    m_usbList.clear();
    mountPath = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Music";
    m_usbList << mountPath;
    for(int i = 0;i< m_wathcerList.length();i++){
        auto path = getMountPoint(m_wathcerList.at(i));
        if(path != ""){
            qDebug() << "path " << path;
            m_usbList << path;
        }
    }
    bool pathStillExist = false;
    for(int i = 1;i< m_usbList.length();i++){
        if(m_usbList.at(i).contains( currentPath.at(0)))
        {
            pathStillExist = true;
        }
    }
    if(!pathStillExist){
        isMounted = true;
        stop();
        m_playlist->clear();
        if(m_usbList.length() > 0){
            mountPath = m_usbList.last();
            currentDir = new QDir(mountPath);
            currentPath.clear();
            currentPath.append( mountPath);
            getFilesInCurrentDir();
        }
        else{
            mountPath = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Music";
            if(mountPath != currentPath[0])
            {
                currentDir = new QDir(mountPath);
                currentPath.clear();
                currentPath.append( mountPath);
                getFilesInCurrentDir();
            }

        }
        //qDebug() << "mountPath " << mountPath;
    }

}

void MusicController::mPositionChanged()
{
    //qDebug() << "position => "<<m_player->position();
    setPosition(m_player->position());
}

void MusicController::mDurationChanged()
{
    setDuration(m_player->duration());
}

void MusicController::mMediaStatusChanged()
{
    setMediaStatus(m_player->mediaStatus());
}



int MusicController::playlistCurrentIndex() const
{
    return m_playlistCurrentIndex;
}

void MusicController::setPlaylistCurrentIndex(int newPlaylistCurrentIndex)
{
    if (m_playlistCurrentIndex == newPlaylistCurrentIndex)
        return;
    m_playlistCurrentIndex = newPlaylistCurrentIndex;
    emit playlistCurrentIndexChanged();
}

QString MusicController::getMountPoint(QString path)
{
    std::ifstream fs;
    QString str = QString(SYSFS_MTAB_DIR);
    fs.open(str.toStdString());

    if(!fs.is_open())
    {
        return "";
    }
    QString ch;
    std::string line;
    while (std::getline(fs, line)) {
        ch = QString(line.c_str());
        auto list = ch.split(" ");
        if(list[0] == path)
        {

            fs.close();
            return list[1];
        }
    }

    fs.close();
    return "";
}

bool MusicController::fillPlayList()
{
    if(!m_playlist->isEmpty())
        return true;
    getFilesInCurrentDir();
    bool hasMusicFile = false;
    for(int i=0;i<m_filesList.length();i++){
        auto path = createPath() + "/" + m_filesList[i]->name();
        QFileInfo file(path);
        if(file.exists()) {
            m_player->stop();
            m_playlist->clear();
            int index = 0;
            auto info = currentDir->entryInfoList();
            for (int i =0; i<info.length() ; i++ ) {
                if(!info[i].isDir() && isMusicFile(info[i])  && !info[i].isHidden()){
                    QUrl url = QUrl::fromLocalFile(info[i].canonicalFilePath());
                    m_playlist->addMedia(url);
                    hasMusicFile=  true;
                }
            }
        }
    }
    if(hasMusicFile){
        m_playlist->setCurrentIndex(0);
        return true;
    }else{
        for(int i=0;i<m_filesList.length();i++){
            auto path = createPath() + "/" + m_filesList[i]->name();
            QFileInfo file(path);
            if(file.exists() && file.isDir())
            {
                currentPath.append(m_filesList[i]->name());
                currentDir = new QDir(createPath());
                getFilesInCurrentDir();
                auto result = fillPlayList();
                if(result) return true;
            }
            currentPath.pop_back();
            currentDir = new QDir(createPath());
            getFilesInCurrentDir();
        }
    }
    return false;

}

