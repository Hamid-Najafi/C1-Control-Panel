#ifndef RNACCOUNT_H
#define RNACCOUNT_H
#include <pjsua2.hpp>


#include <QString>
#include <QObject>


using namespace pj;

class RNPjsip;

class RNAccount : public Account
{
public:

    RNAccount(RNPjsip *parent);
    ~RNAccount();

    virtual void onRegState(OnRegStateParam &prm);

    virtual void onRegStarted(OnRegStartedParam &prm);

    virtual void onIncomingCall(OnIncomingCallParam &iprm);

private:
    RNPjsip *parent;
};

#endif // RNACCOUNT_H
