#include "rnaccount.h"
#include <QString>
#include <QDebug>
#include "rnpjsip.h"

RNAccount::RNAccount(RNPjsip *parent)
{
    this->parent = parent;
}

RNAccount::~RNAccount()
{
}

void RNAccount::onRegState(OnRegStateParam &prm) {
    AccountInfo ai = getInfo();
    qDebug() << (ai.regIsActive? "*** Register:" : "*** Unregister:")
             << " code=" << prm.code;

    parent->emitRegStateStarted(ai.regIsActive);
}

void RNAccount::onRegStarted(OnRegStartedParam &prm)
{
     AccountInfo ai = getInfo();
     qDebug() << (ai.regIsActive? "*** Register:" : "*** Unregister:")
              << " code=" << prm.renew;

     parent->emitRegStateChanged(ai.regIsActive);
}

void RNAccount::onIncomingCall(OnIncomingCallParam &iprm)
{
    qDebug() << "MetaVoIP: Incoming call with callId" << iprm.callId;

    parent->ring(iprm.callId);
}
