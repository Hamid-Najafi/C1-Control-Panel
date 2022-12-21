#ifndef RNCALL_H
#define RNCALL_H
#include <QObject>
#include <pjsua2.hpp>

using namespace pj;

class RNPjsip;

class RNCall: public Call
{
public:
    RNCall(RNPjsip *parent, Account &acc, int call_id = PJSUA_INVALID_ID)
    : Call(acc, call_id)
    {
        this->parent = parent;
        this->hold = false;
#ifdef Q_OS_ANDROID
        this->audioMedia = Q_NULLPTR;
        this->captureMedia = Q_NULLPTR;
#else
        this->audioMedia = 0;
        this->captureMedia = 0;
#endif
    }

    ~RNCall()
    {
        this->audioMedia = Q_NULLPTR;
        this->captureMedia = Q_NULLPTR;
        parent = Q_NULLPTR;
    }

    // Notification when call's state has changed.
    virtual void onCallState(OnCallStateParam &prm);

    virtual void onCallMediaState(OnCallMediaStateParam &prm);

    virtual void onCallTransferRequest(OnCallTransferRequestParam &prm);

    virtual void onCallTransferStatus(OnCallTransferStatusParam &prm);

    virtual void onCallReplaceRequest(OnCallReplaceRequestParam &prm);

    // virtual void onCallRxOffer(OnCallRxOfferParam &prm);

    inline bool isOnHold()
    {
        return hold;
    }

    inline void setHoldTo(bool hold)
    {
        this->hold = hold;
    }

private:
    RNPjsip *parent;
    AudioMedia *audioMedia;
    AudioMedia *captureMedia;
    bool hold;
};

#endif // RNCALL_H
