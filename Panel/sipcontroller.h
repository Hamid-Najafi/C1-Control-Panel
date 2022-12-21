#ifndef SIPCONTROLLER_H
#define SIPCONTROLLER_H

#include <QObject>
#include <QString>
#include "rnaccount.h"
#include "rncall.h"
#include "rnpjsip.h"
#include <QMediaPlayer>
#include <QMediaPlaylist>

class SipController : public QObject
{
    Q_OBJECT

     RNPjsip* sip = nullptr   ;
     QMediaPlaylist *m_playlist = nullptr;
     QMediaPlayer *m_player = nullptr;
     int m_last_call_id = -1;
     QString m_lastUri = "";

public:
    explicit SipController(QObject *parent = nullptr);
    Q_PROPERTY(QString protocol READ protocol WRITE setProtocol NOTIFY protocolChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
     Q_PROPERTY(QString serverAddress READ serverAddress WRITE setServerAddress NOTIFY serverAddressChanged)
     Q_PROPERTY(int state READ state WRITE setState NOTIFY stateChanged)
     Q_PROPERTY(QString callerId READ callerId WRITE setCallerId NOTIFY callerIdChanged)

    Q_INVOKABLE void registerAccount();
     Q_INVOKABLE void connectToServer();
     Q_INVOKABLE void call(QString number);
    Q_INVOKABLE void acceptCall();
    Q_INVOKABLE void rejectCall();
    const QString &protocol() const;
    void setProtocol(const QString &newProtocol);

    int port() const;
    void setPort(int newPort);

    const QString &username() const;
    void setUsername(const QString &newUsername);

    const QString &password() const;
    void setPassword(const QString &newPassword);

    const QString &serverAddress() const;
    void setServerAddress(const QString &newServerAddress);

    int state() const;
    void setState(int newState);

    const QString &callerId() const;
    void setCallerId(const QString &newCallerId);

signals:

    void protocolChanged();
    void portChanged();

    void usernameChanged();

    void passwordChanged();

    void serverAddressChanged();

    void stateChanged();

    void callerIdChanged();

public slots:
    void onCallStateChanged(int role, int callId, int state, int status, QString remoteUri);

private:
    QString m_protocol;
    int m_port;
    QString m_username;
    QString m_password;
    QString m_serverAddress;
    int m_state;
    QString m_callerId;
};

#endif // SIPCONTROLLER_H
