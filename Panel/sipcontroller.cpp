#include "sipcontroller.h"
#include <QDebug>
#include <QStandardPaths>
#include <QUrl>
SipController::SipController(QObject *parent)
    : QObject{parent}
{
    m_protocol = "UDP";
    m_port = 5060;
    //! [create-objs]
    m_player = new QMediaPlayer(this);
    // owned by PlaylistModel
    m_playlist = new QMediaPlaylist();
    m_player->setPlaylist(m_playlist);

    //! [create-objs]
    auto mountPath = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Intercom/";
    m_playlist->addMedia(QUrl::fromLocalFile(mountPath+"ring.wav"));
    m_playlist->addMedia(QUrl::fromLocalFile(mountPath+"ringback.wav"));
    m_playlist->addMedia(QUrl::fromLocalFile(mountPath+"busy.wav"));
    m_playlist->playbackModeChanged(QMediaPlaylist::CurrentItemInLoop);
    //sip = new RNPjsip(m_protocol,m_port,this);

}

void SipController::registerAccount()
{
    //    if(sip == nullptr || !sip->isLoaded())
    //    {
    //        sip = new RNPjsip(m_protocol,m_port,this);
    //        if(!sip->isLoaded())
    //        {
    //            qDebug() << "cant create sip.";
    //            return;
    //        }
    //    }
    qDebug() << QString("sip:%1@%2").arg(m_username).arg(m_serverAddress);
    qDebug() << QString("sip:%2").arg(m_serverAddress);
    qDebug() << m_username;
    qDebug() << m_password;

    sip->createAccount(QString("sip:%1@%2").arg(m_username).arg(m_serverAddress),
                       QString("sip:%2").arg(m_serverAddress),
                       m_username,
                       m_password);

    sip->registerAccount();

}

void SipController::connectToServer()
{
    //    if(sip != nullptr){
    //        delete sip;
    //    }
    sip = new RNPjsip(m_protocol,m_port,this);

    connect(sip,&RNPjsip::callStateChanged,this,&SipController::onCallStateChanged);
    qDebug() << "created sip.";
}

void SipController::call(QString number)
{
    if(number == m_username) return;
    QString id = QString("sip:%1@%2").arg(number).arg(m_serverAddress);
    if(this->m_state == 0)
        sip->makeCall(id);
}

void SipController::acceptCall()
{
    if(m_last_call_id != -1)
    {sip->acceptCall(m_last_call_id);
    m_player->stop();
    setState(3);}
}

void SipController::rejectCall()
{
    if(m_last_call_id != -1)
    {m_player->stop();
    sip->hangupCall(m_last_call_id);}
}

const QString &SipController::protocol() const
{
    return m_protocol;
}

void SipController::setProtocol(const QString &newProtocol)
{
    if (m_protocol == newProtocol)
        return;
    m_protocol = newProtocol;
    emit protocolChanged();
}

int SipController::port() const
{
    return m_port;
}

void SipController::setPort(int newPort)
{
    if (m_port == newPort)
        return;
    m_port = newPort;
    emit portChanged();
}

const QString &SipController::username() const
{
    return m_username;
}

void SipController::setUsername(const QString &newUsername)
{
    if (m_username == newUsername)
        return;
    m_username = newUsername;
    emit usernameChanged();
}

const QString &SipController::password() const
{
    return m_password;
}

void SipController::setPassword(const QString &newPassword)
{
    if (m_password == newPassword)
        return;
    m_password = newPassword;
    emit passwordChanged();
}

const QString &SipController::serverAddress() const
{
    return m_serverAddress;
}

void SipController::setServerAddress(const QString &newServerAddress)
{
    if (m_serverAddress == newServerAddress)
        return;
    m_serverAddress = newServerAddress;
    emit serverAddressChanged();
}

int SipController::state() const
{
    return m_state;
}

void SipController::setState(int newState)
{
    if (m_state == newState)
        return;
    m_state = newState;
    emit stateChanged();
}

void SipController::onCallStateChanged(int role, int callId, int state, int status, QString remoteUri)
{
    if(remoteUri.indexOf("@")!= -1)
    {
        auto number = remoteUri.split("@");
        remoteUri = number[0];
    }
    if(remoteUri.indexOf(":")!= -1)
    {
        auto number = remoteUri.split(":");
        remoteUri = number[1];
    }

    qDebug() << " =========> STATE : " << state;
    switch (state) {
    case 1:
        m_last_call_id = callId;
        setCallerId(remoteUri);
        m_lastUri = remoteUri;
        m_playlist->setCurrentIndex(1);
        m_player->play();
        setState(1);
        qDebug() << " =========> OUT CALL";
        break;
    case 2:
        m_last_call_id = callId;
        setCallerId(remoteUri);
        m_lastUri = remoteUri;
        m_playlist->setCurrentIndex(0);
        m_player->play();
        qDebug() << " =========> IN CALL";
        setState(2);
        break;
    case 5:
        m_playlist->setCurrentIndex(0);
        m_player->stop();
        qDebug() << " =========> Call Accepted";
        setState(5);
        break;
    case 6:
        m_last_call_id = -1;
        m_lastUri = "";
        m_playlist->setCurrentIndex(0);
        m_player->stop();
        qDebug() << " =========> FINISH CALL";
        setState(0);
        break;
    default:
        break;
    }
}

const QString &SipController::callerId() const
{
    return m_callerId;
}

void SipController::setCallerId(const QString &newCallerId)
{
    if (m_callerId == newCallerId)
        return;
    m_callerId = newCallerId;
    emit callerIdChanged();
}
