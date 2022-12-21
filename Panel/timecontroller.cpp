#include "timecontroller.h"
#include <QProcess>
TimeController::TimeController(QObject *parent)
    : QObject{parent}
{
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout,this,&TimeController::updateHandler);
    timer->setInterval(500);
    timer->start();
    updateHandler();
}

void TimeController::resetDevice()
{
    system("reboot");
}

const QString &TimeController::currentDate() const
{
    return m_currentDate;
}

void TimeController::setCurrentDate(const QString &newCurrentDate)
{
    if (m_currentDate == newCurrentDate)
        return;
    m_currentDate = newCurrentDate;
    emit currentDateChanged();
}

const QString &TimeController::currentTime() const
{
    return m_currentTime;
}

void TimeController::setCurrentTime(const QString &newCurrentTime)
{
    if (m_currentTime == newCurrentTime)
        return;
    m_currentTime = newCurrentTime;
    emit currentTimeChanged();
}

void TimeController::updateHandler()
{
    auto date = QDateTime::currentDateTime().toLocalTime();
    QCalendar calender(QCalendar::System::Jalali);
    auto strDate = date.date().toString("ddd",calender)
            +" "
            + date.date().toString("MMMM",calender)
            +" "
            + date.date().toString("dd",calender)
            +", "
            + date.date().toString("yyyy",calender);
    auto strTime = date.time().toString("hh:mm:ss");
    setCurrentDate(strDate);
    setCurrentTime(strTime);
}
