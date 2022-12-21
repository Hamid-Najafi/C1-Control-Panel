#include "timercontroller.h"

TimerController::TimerController(QObject *parent) : QObject(parent)
{
    stop();
    update_timer = new QTimer(this);
    connect(update_timer, SIGNAL(timeout()), this, SLOT(updateTime()));
    update_timer->start(50);
}

void TimerController::start()
{
    if (this->timerStarted) {
        this->timerStarted = false;
        this->timerSec += (this->timeElapsed.elapsed() / 1000);
    }
    else {
        this->timerStarted = true;
        this->timeElapsed.restart();
    }
}

void TimerController::pause()
{
    if (this->timerStarted) {
        this->timerStarted = false;
        this->timerSec += (this->timeElapsed.elapsed() / 1000);
    }
}

void TimerController::stop()
{
    this->timerStarted = false;
    this->timerSec = 0;
    this->timerSecond = 0;
    this->timerMinutes = 0;
    this->timerHour = 0;
    setTimer("00 : 00 : 00");
}

const QString &TimerController::timer() const
{
    return m_timer;
}

void TimerController::setTimer(const QString &newTimer)
{
    if (m_timer == newTimer)
        return;
    m_timer = newTimer;
    emit timerChanged();
}

void TimerController::updateTime()
{
    if (!this->timerStarted) return;
    auto sec = this->timerSec + (this->timeElapsed.elapsed() / 1000);
    this->timerHour = sec / 3600;
    sec -= this->timerHour * 3600;
    this->timerMinutes = sec / 60;
    sec -= this->timerMinutes * 60;
    this->timerSecond = sec;

    QString time = "";
    if (this->timerHour < 10)
    {
        time = time + "0" + QString::number(this->timerHour);
    }
    else
    {
        time = time + QString::number(this->timerHour);
    }
    time = time + " : ";
    if (this->timerMinutes < 10)
    {
        time = time + "0" + QString::number(this->timerMinutes);
    }
    else
    {
        time = time + QString::number(this->timerMinutes);
    }
    time = time + " : ";
    if (this->timerSecond < 10)
    {
        time = time + "0" + QString::number(this->timerSecond);
    }
    else
    {
        time = time + QString::number(this->timerSecond);
    }
    setTimer(time);
}
