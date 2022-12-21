#include "rncall.h"

#include "rnpjsip.h"

#include <QDebug>


// Notification when call's state has changed.
void RNCall::onCallState(OnCallStateParam &prm)
{
    Q_UNUSED(prm);
    CallInfo ci = getInfo();

    parent->emitCallStateChanged(ci.role, ci.id, ci.state, ci.lastStatusCode, QString::fromStdString(ci.remoteUri));

    if(ci.state == PJSIP_INV_STATE_DISCONNECTED)
    {
        parent->setConnectDuration(ci.connectDuration.sec);

        qDebug() << "MetaVoIP: deleting call with callId" << ci.id;

        //to be determined if it's a bug...
        /*if(hasMedia())
        {
            qDebug() << "had media";
            //first stop the mic stream, then the playback stream
            captureMedia->stopTransmit(*audioMedia);
            AudDevManager& mgr = Endpoint::instance().audDevManager();
            audioMedia->stopTransmit(mgr.getPlaybackDevMedia());
        }*/

        delete this;
    }
}

// Notification when call's media state has changed.
void RNCall::onCallMediaState(OnCallMediaStateParam &prm)
{
    Q_UNUSED(prm);
    CallInfo ci = getInfo();

    qDebug() << "MetaVoIP: Has media" << hasMedia();

    // Iterate all the call medias
    for (unsigned i = 0; i < ci.media.size(); i++) {
        if (ci.media[i].type == PJMEDIA_TYPE_AUDIO && getMedia(i)) {
            audioMedia = (AudioMedia *)getMedia(i);

            // Connect the call audio media to sound device
            AudDevManager& mgr = Endpoint::instance().audDevManager();
            audioMedia->startTransmit(mgr.getPlaybackDevMedia());

            audioMedia->adjustRxLevel(1.0f);
            audioMedia->adjustTxLevel(1.0f);

            captureMedia = &(mgr.getCaptureDevMedia());
            captureMedia->adjustRxLevel(1.0f);
            captureMedia->adjustTxLevel(1.0f);

            captureMedia->startTransmit(*audioMedia);
        }
    }
}

void RNCall::onCallTransferRequest(OnCallTransferRequestParam &prm)
{
    qDebug() << "MetaVoIP: onCallTransferRequest destUri" << prm.dstUri.c_str() << prm.statusCode;

    CallInfo ci = getInfo();

    parent->emitCallStateChanged(ci.role, ci.id, ci.state, ci.lastStatusCode, QString::fromStdString(ci.remoteUri));
}

void RNCall::onCallTransferStatus(OnCallTransferStatusParam &prm)
{
    qDebug() << "MetaVoIP: onCallTransferStatus";

    CallInfo ci = getInfo();

    parent->emitCallStateChanged(ci.role, ci.id, ci.state, ci.lastStatusCode, QString::fromStdString(ci.remoteUri));

    if(prm.statusCode == PJSIP_SC_OK)
    {
        qDebug() << "MetaVoIP: deleting call with callId" << ci.id;

        delete this;
    }
}

void RNCall::onCallReplaceRequest(OnCallReplaceRequestParam &prm)
{
    qDebug() << "MetaVoIP: onCallReplaceRequest statusCode" << prm.statusCode;
}
