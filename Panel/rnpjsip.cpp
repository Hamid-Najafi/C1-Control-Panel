#include "rnpjsip.h"

#include <QDebug>
#include <QThread>

using namespace pj;

RNPjsip::RNPjsip(QString protocol, int port, QObject *parent) : QObject(parent)
{
    try
    {
        pj_log_set_level(1);
        loaded = false;
        connectDuration = 0;
        epCfg.logConfig.level = 1;
        ep.libCreate();
        ep.libInit(epCfg);
        tCfg.port = port;
        call = Q_NULLPTR;

        if(protocol=="TCP")
            ep.transportCreate(PJSIP_TRANSPORT_TCP, tCfg);
        else
            ep.transportCreate(PJSIP_TRANSPORT_UDP, tCfg);

        // Start the library (worker threads etc)
        ep.libStart();

        loaded = true;

        qDebug()<< "*** PJSUA2 STARTED ***";

    }
    catch (Error &err)
    {
        loaded = false;
        qDebug() << "RNPjsip: Lib starting failed" << err.info().c_str();
    }
}

RNPjsip::~RNPjsip()
{
    try
    {
        // Delete the account. This will unregister from server
        delete account;
    }
    catch (Error &err)
    {
        qDebug() << "RNPjsip: Lib deleting failed" << err.info().c_str();
    }
}

void RNPjsip::createAccount(QString idUri, QString registrarUri, QString user, QString password)
{
    try
    {
        // Configure an AccountConfig
        aCfg.idUri = idUri.toStdString();
        aCfg.regConfig.registrarUri = registrarUri.toStdString();
        AuthCredInfo cred("digest", "*", user.toStdString(), 0, password.toStdString());
        aCfg.sipConfig.authCreds.push_back(cred);
        aCfg.callConfig.timerMinSESec = 90;
        aCfg.callConfig.timerSessExpiresSec = 1800;

        account = new RNAccount(this);
        account->create(aCfg);

        qDebug() << "RNPjsip: Account creation successful";

    }
    catch(Error& err)
    {
        qDebug() << "RNPjsip: Account creation failed" << err.info().c_str();
    }
}

void RNPjsip::registerAccount()
{
    if(account)
    {
        try
        {
            account->setRegistration(true);

            qDebug() << "RNPjsip: Register account successfull";

        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Register failed" << err.info().c_str();
        }
    }
}

void RNPjsip::unregisterAccount()
{
    if(account)
    {
        try
        {
            account->setRegistration(false);
            qDebug() << "RNPjsip: Unregister account successfull";

        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Unregister error: " << err.info().c_str() << "\n";
        }
    }
}

void RNPjsip::makeCall(QString number)
{
    if(account)
    {
        qDebug() << "RNPjsip: Attempting to create call";

        call = new RNCall(this, *account);
        CallOpParam prm(true); // Use default call settings

        try
        {
            qDebug() << "RNPjsip: Calling API with account" << account->getId() << account->getInfo().regIsActive << account->isValid();

            call->makeCall(number.toStdString(), prm);

            qDebug() << "RNPjsip: makeCall was called with" << number;

        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Call could not be made" << err.info().c_str();
        }
    }
}

void RNPjsip::ring(int callId)
{
    if(account != Q_NULLPTR)
    {
        try
        {
            qDebug() << "RNPjsip: Set state to ringing for callId" << callId;

            call = new RNCall(this, *account, callId);
            CallOpParam prm;
            prm.statusCode = PJSIP_SC_RINGING;
            call->answer(prm);
        }
        catch(Error& err)
        {
            qDebug() << "Ringing failed" << err.info().c_str();
        }
    }
}

void RNPjsip::acceptCall(int callId)
{
    if(account && call != Q_NULLPTR)
    {
        qDebug() << "RNPjsip: Accepting call with callId" << callId;

        try
        {
            call = new RNCall(this, *account, callId);
            CallOpParam prm;
            prm.statusCode = PJSIP_SC_OK;
            call->answer(prm);
        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Accepting failed" << err.info().c_str();
        }
    }
}

bool RNPjsip::hangupCall(int callId)
{
    if(account && call != Q_NULLPTR)
    {
        qDebug() << "RNPjsip: Hang up on callId" << callId;

        try
        {
            CallInfo ci = call->getInfo();

            CallOpParam prm;

            if(ci.lastStatusCode == PJSIP_SC_RINGING)
            {
                prm.statusCode = PJSIP_SC_BUSY_HERE;
            }
            else
            {
                prm.statusCode = PJSIP_SC_OK;
            }

            if(callId>=0 && callId<(int)epCfg.uaConfig.maxCalls)
                call->hangup(prm);
            else
                qDebug() << "RNPjsip: Max calls bug";

            call = Q_NULLPTR;

            return 1;
        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: HangupCall failed" << err.info().c_str();
        }
    }

    return 0;
}

bool RNPjsip::holdCall(int callId)
{
    if(account && call != Q_NULLPTR)
    {
        try
        {
            qDebug() << "RNPjsip: Hold call with callId" << callId;

            CallOpParam prm(true);

            if(!call->isOnHold())
            {
                qDebug() << "RNPjsip: Call will be hold";

                call->setHoldTo(true);

                prm.statusCode = PJSIP_SC_QUEUED;
                call->setHold(prm);
            }
            else
            {
                qDebug() << "RNPjsip: Call will be re-invited";

                call->setHoldTo(false);

                prm.opt.flag = PJSUA_CALL_UNHOLD;
                call->reinvite(prm);
            }

            return 1;
        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Accepting failed" << err.info().c_str();
        }
    }

    return 0;
}

bool RNPjsip::transferCall(QString destination)
{
    if(account && call != Q_NULLPTR)
    {
        try
        {
            qDebug() << "RNPjsip: Transfer call to" << destination;

            CallOpParam prm;
            prm.statusCode = PJSIP_SC_CALL_BEING_FORWARDED;
            call->xfer(destination.toStdString(), prm);

            return 1;
        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Accepting failed" << err.info().c_str();
        }
    }

    return 0;
}

void RNPjsip::emitRegStateStarted(bool status)
{
    qDebug() << "RNPjsip: Regstate started: " << status;
    emit regStateStarted(status);
}

void RNPjsip::emitRegStateChanged(bool status)
{
    qDebug() << "RNPjsip: Regstate changed: " << status;
    emit regStateChanged(status);
}

void RNPjsip::emitCallStateChanged(int role, int callId, int state, int status, QString id)
{

    qDebug() << "RNPjsip: Emitting data to slot " << callId;
    emit callStateChanged(role, callId, state, status, id);
}

void RNPjsip::sendDtmf(QString num)
{
    if(call != Q_NULLPTR)
    {
        try
        {
            call->dialDtmf(num.toStdString());
            qDebug() << "RNPjsip: Dtmf" << num << " sent";
        }
        catch(Error& err)
        {
            qDebug() << "RNPjsip: Dtmf failed" << err.info().c_str();
        }
    }
}
