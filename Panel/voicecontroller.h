#ifndef VOICECONTROLLER_H
#define VOICECONTROLLER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <logger.h>
#include <voicedata.h>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonValue>
#include <QJsonObject>
#include <QProcess>
#include <QStandardPaths>
#include <QStringList>
#include <QMediaPlayer>
#include <QMediaPlaylist>



class VoiceController : public QObject
{
    Q_OBJECT

    QTcpServer *server;
    QTcpSocket *socket;
    Logger *logger;
    QProcess *voiceProcess;
    QMediaPlaylist *m_playlist = nullptr;
    QMediaPlayer *m_player = nullptr;
    bool isActive = true;
    int voiceLevel = 50;

    bool isOnCall = false;
public:
    explicit VoiceController(QObject *parent = nullptr);
    Q_PROPERTY(bool connected READ connected WRITE setConnected NOTIFY connectedChanged)
    Q_PROPERTY(bool isWakeUp READ isWakeUp WRITE setIsWakeUp NOTIFY isWakeUpChanged)

    Q_INVOKABLE void setOnCall(bool val);
    Q_INVOKABLE void setActive(bool val);
    Q_INVOKABLE void setLevel(int val);

    bool connected() const;
    void setConnected(bool newConnected);

    void parseCommand(const VoiceData *data);

    bool isWakeUp() const;
    void setIsWakeUp(bool newIsWakeUp);

signals:

    void connectedChanged();
    void newCommand(int command);

    void isWakeUpChanged();

public slots:
    void newConnection();
    void socketDisconnected();
    void onSocketBytesWritten();

private:
    bool m_connected;

    bool resultContainsWordWithConf(const VoiceData *data,QString word,float conf);
    bool m_isWakeUp;
};

#endif // VOICECONTROLLER_H
