#include "voicecontroller.h"


enum Commands{
    lightsOff,
    light1Off,
    light2Off,
    lightsOn,
    light1On,
    light2On,
    prismaticLightsOff,
    prismaticLight1Off,
    prismaticLight2Off,
    prismaticLights10,
    prismaticLights20,
    prismaticLights30,
    prismaticLights40,
    prismaticLights50,
    prismaticLights60,
    prismaticLights70,
    prismaticLights80,
    prismaticLights90,
    prismaticLights100,
    prismaticLight110,
    prismaticLight120,
    prismaticLight130,
    prismaticLight140,
    prismaticLight150,
    prismaticLight160,
    prismaticLight170,
    prismaticLight180,
    prismaticLight190,
    prismaticLight1100,
    prismaticLight210,
    prismaticLight220,
    prismaticLight230,
    prismaticLight240,
    prismaticLight250,
    prismaticLight260,
    prismaticLight270,
    prismaticLight280,
    prismaticLight290,
    prismaticLight2100,
    uvLightOff,
    uvLightOn,
    negatoscopeOff,
    negatoscopeOn,
    occupationReady,
    occupationCleaning,
    occupationOccupied,
    musicPlay,
    musicStop,
    musicNext,
    musicPrevious,
    musicMute,
    timer1Start,
    timer1Stop,
    timer1Reset,
    timer2Start,
    timer2Stop,
    timer2Reset,
    timer3Start,
    timer3Stop,
    timer3Reset,
    lightingPage,
    timersPage,
    musicPage,
    intercomPage,
    logsPage,
    aboutPage
};

VoiceController::VoiceController(QObject *parent)
    : QObject{parent}
{
    server = new QTcpServer(this);
    logger = new Logger(this);
    // whenever a user connects, it will emit signal
    connect(server, SIGNAL(newConnection()),
            this, SLOT(newConnection()));


    if(!server->listen(QHostAddress::LocalHost,65502))
    {
        qDebug() << "Server could not start";
        logger->error("Voice Command Server could not start.");
    }
    auto mountPath = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/microphone.py";
    QStringList ar;
    ar.append(mountPath);
    voiceProcess = new QProcess(this);
    voiceProcess->startDetached("python3",ar);


    //! [create-objs]
    m_player = new QMediaPlayer(this);
    // owned by PlaylistModel
    m_playlist = new QMediaPlaylist();
    m_player->setPlaylist(m_playlist);

    //! [create-objs]
    auto soundPath = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Intercom/";
    m_playlist->addMedia(QUrl::fromLocalFile(soundPath+"speechWakeUp.mp3"));
    m_playlist->playbackModeChanged(QMediaPlaylist::CurrentItemOnce);
    m_playlist->setCurrentIndex(0);

    setIsWakeUp(false);
}

void VoiceController::setOnCall(bool val)
{
    isOnCall = val;
}

void VoiceController::setActive(bool val)
{
    isActive = val;
}
void VoiceController::setLevel(int val)
{
    QProcess p;
    p.start(QString("amixer sset 'Capture' %1").arg(val)+ "%");
    p.waitForFinished();
}

bool VoiceController::connected() const
{
    return m_connected;
}

void VoiceController::setConnected(bool newConnected)
{
    if (m_connected == newConnected)
        return;
    m_connected = newConnected;
    emit connectedChanged();
}

void VoiceController::parseCommand(const VoiceData *data)
{
    if(!isActive) return;
    if(isOnCall) {m_player->stop();setIsWakeUp(false);return;}
    if(data->text.contains("سیمان"))
    {
        if(data->result.length() == 1
                && data->result[0].word == "سیمان"
                && data->result[0].conf > .9){
            // Wake up Word
            m_player->play();
            setIsWakeUp(true);
            return;
        }
    }else{
    m_player->stop();
    setIsWakeUp(false);
    }
    if(data->text.contains("چراغ"))
    {
        if(data->text.contains("سقف"))
        {
            // Prismatic Ligth
            if(resultContainsWordWithConf(data,"یک",.9)
                    && resultContainsWordWithConf(data,"دو",.9))
            {
                // Prismatic Lights 1 & 2
                if(resultContainsWordWithConf(data,"ده",.9))
                {
                    // 10%
                    emit newCommand(Commands::prismaticLights10);
                }
                else if(resultContainsWordWithConf(data,"بیست",.9)){
                    // 20%
                    emit newCommand(Commands::prismaticLights20);
                }
                else if(resultContainsWordWithConf(data,"سی",.9)){
                    // 30%
                    emit newCommand(Commands::prismaticLights30);
                }
                else if(resultContainsWordWithConf(data,"چهل",.9)){
                    // 40%
                    emit newCommand(Commands::prismaticLights40);
                }
                else if(resultContainsWordWithConf(data,"پنجاه",.9)){
                    // 50%
                    emit newCommand(Commands::prismaticLights50);
                }
                else if(resultContainsWordWithConf(data,"شصت",.9)){
                    // 60%
                    emit newCommand(Commands::prismaticLights60);
                }
                else if(resultContainsWordWithConf(data,"هفتاد",.9)){
                    // 70%
                    emit newCommand(Commands::prismaticLights70);
                }
                else if(resultContainsWordWithConf(data,"هشتاد",.9)){
                    // 80%
                    emit newCommand(Commands::prismaticLights80);
                }
                else if(resultContainsWordWithConf(data,"نود",.9)){
                    // 90%
                    emit newCommand(Commands::prismaticLights90);
                }
                else if(resultContainsWordWithConf(data,"صد",.9)){
                    // 100%
                    emit newCommand(Commands::prismaticLights100);
                }
                else if(resultContainsWordWithConf(data,"خاموش",.9))
                {
                    //OFF
                    emit newCommand(Commands::prismaticLightsOff);
                }
            }
            else if(resultContainsWordWithConf(data,"یک",.9))
            {
                // Light 1 ON
                if(resultContainsWordWithConf(data,"ده",.9))
                {
                    // 10%
                    emit newCommand(Commands::prismaticLight110);
                }
                else if(resultContainsWordWithConf(data,"بیست",.9)){
                    // 20%
                    emit newCommand(Commands::prismaticLight120);
                }
                else if(resultContainsWordWithConf(data,"سی",.9)){
                    // 30%
                    emit newCommand(Commands::prismaticLight130);
                }
                else if(resultContainsWordWithConf(data,"چهل",.9)){
                    // 40%
                    emit newCommand(Commands::prismaticLight140);
                }
                else if(resultContainsWordWithConf(data,"پنجاه",.9)){
                    // 50%
                    emit newCommand(Commands::prismaticLight150);
                }
                else if(resultContainsWordWithConf(data,"شصت",.9)){
                    // 60%
                    emit newCommand(Commands::prismaticLight160);
                }
                else if(resultContainsWordWithConf(data,"هفتاد",.9)){
                    // 70%
                    emit newCommand(Commands::prismaticLight170);
                }
                else if(resultContainsWordWithConf(data,"هشتاد",.9)){
                    // 80%
                    emit newCommand(Commands::prismaticLight180);
                }
                else if(resultContainsWordWithConf(data,"نود",.9)){
                    // 90%
                    emit newCommand(Commands::prismaticLight190);
                }
                else if(resultContainsWordWithConf(data,"صد",.9)){
                    // 100%
                    emit newCommand(Commands::prismaticLight1100);
                }
                else if(resultContainsWordWithConf(data,"خاموش",.9))
                {
                    //OFF
                    emit newCommand(Commands::prismaticLight1Off);
                }
            }
            else if(resultContainsWordWithConf(data,"دو",.9))
            {
                // Light 2 ON
                if(resultContainsWordWithConf(data,"ده",.9))
                {
                    // 10%
                    emit newCommand(Commands::prismaticLight210);
                }
                else if(resultContainsWordWithConf(data,"بیست",.9)){
                    // 20%
                    emit newCommand(Commands::prismaticLight220);
                }
                else if(resultContainsWordWithConf(data,"سی",.9)){
                    // 30%
                    emit newCommand(Commands::prismaticLight230);
                }
                else if(resultContainsWordWithConf(data,"چهل",.9)){
                    // 40%
                    emit newCommand(Commands::prismaticLight240);
                }
                else if(resultContainsWordWithConf(data,"پنجاه",.9)){
                    // 50%
                    emit newCommand(Commands::prismaticLight250);
                }
                else if(resultContainsWordWithConf(data,"شصت",.9)){
                    // 60%
                    emit newCommand(Commands::prismaticLight260);
                }
                else if(resultContainsWordWithConf(data,"هفتاد",.9)){
                    // 70%
                    emit newCommand(Commands::prismaticLight270);
                }
                else if(resultContainsWordWithConf(data,"هشتاد",.9)){
                    // 80%
                    emit newCommand(Commands::prismaticLight280);
                }
                else if(resultContainsWordWithConf(data,"نود",.9)){
                    // 90%
                    emit newCommand(Commands::prismaticLight290);
                }
                else if(resultContainsWordWithConf(data,"صد",.9)){
                    // 100%
                    emit newCommand(Commands::prismaticLight2100);
                }
                else if(resultContainsWordWithConf(data,"خاموش",.9))
                {
                    //OFF
                    emit newCommand(Commands::prismaticLight2Off);
                }
            }
            else
            {
                // Both Lights
                if(resultContainsWordWithConf(data,"ده",.9))
                {
                    // 10%
                    emit newCommand(Commands::prismaticLights10);
                }
                else if(resultContainsWordWithConf(data,"بیست",.9)){
                    // 20%
                    emit newCommand(Commands::prismaticLights20);
                }
                else if(resultContainsWordWithConf(data,"سی",.9)){
                    // 30%
                    emit newCommand(Commands::prismaticLights30);
                }
                else if(resultContainsWordWithConf(data,"چهل",.9)){
                    // 40%
                    emit newCommand(Commands::prismaticLights40);
                }
                else if(resultContainsWordWithConf(data,"پنجاه",.9)){
                    // 50%
                    emit newCommand(Commands::prismaticLights50);
                }
                else if(resultContainsWordWithConf(data,"شصت",.9)){
                    // 60%
                    emit newCommand(Commands::prismaticLights60);
                }
                else if(resultContainsWordWithConf(data,"هفتاد",.9)){
                    // 70%
                    emit newCommand(Commands::prismaticLights70);
                }
                else if(resultContainsWordWithConf(data,"هشتاد",.9)){
                    // 80%
                    emit newCommand(Commands::prismaticLights80);
                }
                else if(resultContainsWordWithConf(data,"نود",.9)){
                    // 90%
                    emit newCommand(Commands::prismaticLights90);
                }
                else if(resultContainsWordWithConf(data,"صد",.9)){
                    // 100%
                    emit newCommand(Commands::prismaticLights100);
                }
                else if(resultContainsWordWithConf(data,"خاموش",.9))
                {
                    //OFF
                    emit newCommand(Commands::prismaticLightsOff);
                }
            }
        }
        else
        {
            qDebug() << "Operating Light";
            // Operating Light
            if(resultContainsWordWithConf(data,"چراغ",.9)
                    && resultContainsWordWithConf(data,"روشن",.9))
            {
                qDebug() << "ON";
                // ON
                if(resultContainsWordWithConf(data,"یک",.9)
                        && resultContainsWordWithConf(data,"دو",.9)){
                    // LIGHT 1 && 2
                    emit newCommand(Commands::lightsOn);
                    qDebug() << "LIGHT 1 && 2";
                }
                else if(resultContainsWordWithConf(data,"یک",.9)){
                    // LIGHT 1
                    emit newCommand(Commands::light1On);
                      qDebug() << "LIGHT 1";
                }
                else if(resultContainsWordWithConf(data,"دو",.9)){
                    // LIGHT 2
                    emit newCommand(Commands::light2On);
                      qDebug() << "LIGHT 2";
                }
                else {
                    // both lights
                    emit newCommand(Commands::lightsOn);
                      qDebug() << "both lights";
                }
            }
            if(resultContainsWordWithConf(data,"چراغ",.9)
                    && resultContainsWordWithConf(data,"خاموش",.9))
            {
                // OFF
                  qDebug() << "OFF";
                if(resultContainsWordWithConf(data,"یک",.9)
                        && resultContainsWordWithConf(data,"دو",.9)){
                    // LIGHT 1 && 2
                    emit newCommand(Commands::lightsOff);
                      qDebug() << "LIGHT 1 && 2";
                }
                else if(resultContainsWordWithConf(data,"یک",.9)){
                    // LIGHT 1
                    emit newCommand(Commands::light1Off);
                      qDebug() << "LIGHT 1";
                }
                else if(resultContainsWordWithConf(data,"دو",.9)){
                    // LIGHT 2
                    emit newCommand(Commands::light2Off);
                      qDebug() << "LIGHT 2";
                }
                else {
                    // both lights
                    emit newCommand(Commands::lightsOff);
                      qDebug() << "both lights";
                }
            }
        }
    }
    else if(resultContainsWordWithConf(data,"اتاق",.9))
    {
        // Occupation
        if(resultContainsWordWithConf(data,"آماده",.9)){
            // Ready
            emit newCommand(Commands::occupationReady);
        }
        else if(resultContainsWordWithConf(data,"مشغول",.9))
        {
            // Occupied
            emit newCommand(Commands::occupationOccupied);
        }
        else if(resultContainsWordWithConf(data,"درحال",.9)
                &&resultContainsWordWithConf(data,"تمیزکاری",.9))
        {
            // Cleaning
            emit newCommand(Commands::occupationCleaning);
        }

    }
    else if(resultContainsWordWithConf(data,"یووی",.9))
    {
        // UV Light
        if(resultContainsWordWithConf(data,"روشن",.9))
        {
            //ON
            emit newCommand(Commands::uvLightOn);
        }
        else if(resultContainsWordWithConf(data,"خاموش",.9))
        {
            //OFF
            emit newCommand(Commands::uvLightOff);
        }
    }
    else if(resultContainsWordWithConf(data,"نگار",.9)
            &&resultContainsWordWithConf(data,"توسط",.9))
    {
        // Negatoscope
        if(resultContainsWordWithConf(data,"روشن",.9))
        {
            //ON
            emit newCommand(Commands::negatoscopeOn);
        }
        else if(resultContainsWordWithConf(data,"خاموش",.9))
        {
            //OFF
            emit newCommand(Commands::negatoscopeOff);
        }
    }
    else if(!resultContainsWordWithConf(data,"صفحه",.9)
            &&resultContainsWordWithConf(data,"موزیک",.9))
    {
        // Music
        if(resultContainsWordWithConf(data,"بخش",.9)){
            // Play
            emit newCommand(Commands::musicPlay);
        }
        else if(resultContainsWordWithConf(data,"قطع",.9))
        {
            // Stop
            emit newCommand(Commands::musicStop);
        }
        else if(resultContainsWordWithConf(data,"بعدی",.9))
        {
            // Next
            emit newCommand(Commands::musicNext);
        }
        else if(resultContainsWordWithConf(data,"قبلی",.9))
        {
            // Previous
            emit newCommand(Commands::musicPrevious);
        }
        else if(resultContainsWordWithConf(data,"بی",.9)
                &&resultContainsWordWithConf(data,"صدا",.9))
        {
            // Mute
            emit newCommand(Commands::musicMute);
        }
    }
    else if(!resultContainsWordWithConf(data,"صفحه",.9)
            &&resultContainsWordWithConf(data,"تایمر",.9))
    {
        // Timer
        if(resultContainsWordWithConf(data,"یک",.9))
        {
            // Timer 1
            if(resultContainsWordWithConf(data,"اجرا",.9))
            {
                // Start Timer 1
                emit newCommand(Commands::timer1Start);
            }
            else if(resultContainsWordWithConf(data,"متوقف",.9))
            {
                // Stop Timer 1
                emit newCommand(Commands::timer1Stop);
            }
            else if(resultContainsWordWithConf(data,"ریست",.9))
            {
                // Reset Timer 1
                emit newCommand(Commands::timer1Reset);
            }
        }
        else if(resultContainsWordWithConf(data,"دو",.9))
        {
            // Timer 2
            if(resultContainsWordWithConf(data,"اجرا",.9))
            {
                // Start Timer 2
                emit newCommand(Commands::timer2Start);
            }
            else if(resultContainsWordWithConf(data,"متوقف",.9))
            {
                // Stop Timer 2
                emit newCommand(Commands::timer2Stop);
            }
            else if(resultContainsWordWithConf(data,"ریست",.9))
            {
                // Reset Timer 2
                emit newCommand(Commands::timer2Reset);
            }
        }
        else if(resultContainsWordWithConf(data,"سه",.9))
        {
            // Timer 3
            if(resultContainsWordWithConf(data,"اجرا",.9))
            {
                // Start Timer 3
                emit newCommand(Commands::timer3Start);
            }
            else if(resultContainsWordWithConf(data,"متوقف",.9))
            {
                // Stop Timer 3
                emit newCommand(Commands::timer3Stop);
            }
            else if(resultContainsWordWithConf(data,"ریست",.9))
            {
                // Reset Timer 3
                emit newCommand(Commands::timer3Reset);
            }
        }

    }
    else if(resultContainsWordWithConf(data,"صفحه",.9))
    {
        // Changing Pages
        if(resultContainsWordWithConf(data,"روشنایی",.9)){
            // Lighting page
            emit newCommand(Commands::lightingPage);
        }
        else if(resultContainsWordWithConf(data,"تایمر",.9))
        {
            // Timers page
            emit newCommand(Commands::timersPage);
        }
        else if(resultContainsWordWithConf(data,"موزیک",.9))
        {
            // Music page
            emit newCommand(Commands::musicPage);
        }
        else if(resultContainsWordWithConf(data,"اینترنت",.9))
        {
            // Intercom page
            emit newCommand(Commands::intercomPage);
        }
        else if(resultContainsWordWithConf(data,"لاگ",.9))
        {
            // Logs page
            emit newCommand(Commands::logsPage);
        }
        else if(resultContainsWordWithConf(data,"اطلاعات",.9))
        {
            // About page
            emit newCommand(Commands::aboutPage);
        }
    }
}

void VoiceController::newConnection()
{
    // need to grab the socket
    socket = server->nextPendingConnection();
    connect(socket, &QTcpSocket::disconnected,
            this, &VoiceController::socketDisconnected);
    //    connect(socket, &QTcpSocket::bytesWritten,
    //            this, &VoiceController::onSocketBytesWritten);
    connect(socket, &QTcpSocket::readyRead,
            this, &VoiceController::onSocketBytesWritten);
    qDebug() << "coonected";
    logger->info("Voice Command Server started.");


}

void VoiceController::socketDisconnected()
{
    logger->info("Voice Command Server stoped.");
    socket->close();
}

void VoiceController::onSocketBytesWritten()
{
    auto data = socket->readAll();
    auto str = QString(data);
    VoiceData voice;
    QJsonDocument d = QJsonDocument::fromJson(data);
    QJsonObject result = d.object();
    QJsonValue text = result.value(QString("text"));
    voice.text = text.toString();
    QJsonValue resultValue = result.value(QString("result"));
    if(!resultValue.isUndefined() &&
            !resultValue.isNull() &&
            resultValue.isArray() ){
        QJsonArray resultArray = resultValue.toArray();
        for(int i=0;i<resultArray.count();i++){
            VoicePartialData pd;
            auto tmp = resultArray[i].toObject();

            pd.conf = (float)tmp.value(QString("conf")).toDouble();
            pd.start =(float)tmp.value(QString("start")).toDouble();
            pd.end = (float)tmp.value(QString("end")).toDouble();
            pd.word = tmp.value(QString("word")).toString();
            voice.result.append(pd);
        }
    }
    parseCommand(&voice);
    //    qDebug() << voice.text;
    //    for(int i =0 ;i<voice.result.length();i++)
    //    {
    //        qDebug() << "{ ";
    //        qDebug() << "/t conf: " << voice.result[i].conf;
    //        qDebug() << "/t start: " << voice.result[i].start;
    //        qDebug() << "/t end: " << voice.result[i].end;
    //        qDebug() << "/t word: " << voice.result[i].word;
    //        qDebug() << "} ";
    //    }

}

bool VoiceController::resultContainsWordWithConf(const VoiceData *data, QString word, float conf)
{
    if(data == nullptr) return false;
    for (int i = 0;i<data->result.length();i++)
    {
        if(data->result[i].word.contains(word) && data->result[i].conf >= conf)
            return true;
    }
    return false;
}

bool VoiceController::isWakeUp() const
{
    return m_isWakeUp;
}

void VoiceController::setIsWakeUp(bool newIsWakeUp)
{
    if (m_isWakeUp == newIsWakeUp)
        return;
    m_isWakeUp = newIsWakeUp;
    emit isWakeUpChanged();
}
