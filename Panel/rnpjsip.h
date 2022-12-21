#ifndef RNPJSIP_H
#define RNPJSIP_H



#include "rnaccount.h"
#include "rncall.h"

#include <pjsua2.hpp>

#include <QString>
#include <QDebug>
#include <QObject>


#include <pjlib.h>
#include <pjlib-util.h>
#include <pjmedia.h>
#include <pjmedia-codec.h>
#include <pjsip.h>
#include <pjsip_simple.h>
#include <pjsip_ua.h>
#include <pjsua-lib/pjsua.h>


class RNAccount;
class RNCall;

class RNPjsip : public QObject
{
    Q_OBJECT

public:
    RNPjsip(QString protocol, int port, QObject *parent = 0);
    ~RNPjsip();

    void createAccount(QString idUri, QString registrarUri, QString user, QString password);
    void registerAccount();
    void unregisterAccount();
    void makeCall(QString number);
    bool hangupCall(int callId);
    void acceptCall(int callId);
    bool holdCall(int callId);
    bool transferCall(QString destination);
    void ring(int callId);
    void sendDtmf(QString num);
    inline bool isLoaded()
    {
        return loaded;
    }

    inline long getConnectDuration()
    {
        return connectDuration;
    }

    inline void setConnectDuration(long connectDuration)
    {
        this->connectDuration = connectDuration;
    }

    void emitRegStateStarted(bool status);
    void emitRegStateChanged(bool status);
    void emitCallStateChanged(int role, int callId, int state, int status, QString remoteUri);

signals:
    void regStateStarted(bool status);
    void regStateChanged(bool status);
    void callStateChanged(int role, int callId, int state, int status, QString remoteUri);

private:
    EpConfig epCfg;
    Endpoint ep;
    TransportConfig tCfg;
    AccountConfig aCfg;
    RNAccount *account;
    RNCall *call;
    bool loaded;
    int connectDuration;

};

#endif // RNPJSIP_H
