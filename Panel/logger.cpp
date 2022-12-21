#include "logger.h"
#include <QStandardPaths>
#include <QTextStream>
#include <QCalendar>

Logger::Logger(QObject *parent)
    : QObject{parent}
{

}

void Logger::info(const QString &str)
{
    writeString("INFO", str);
}

void Logger::writeString(const QString &type, const QString &str)
{
    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Logs/";
    auto date = QDateTime::currentDateTime().toLocalTime();
    QCalendar calender(QCalendar::System::Jalali);
    QString filename=path + getCurrentMonthFileName();
    auto oldDate = date.addMonths(-6);
    QString OldFile = path + getFileName(oldDate.date().month(),oldDate.date().year());
    if(QFile::exists(OldFile))
        QFile::remove(OldFile);
    QFile file( filename );
    if ( file.open(QIODevice::Append) )
    {
        QTextStream stream( &file );
        stream << strToStrWithPrefix(date.date().toString("ddd",calender)
                                     +" "
                                     + date.date().toString("MMMM",calender)
                                     +" "
                                     + date.date().toString("dd",calender)
                                     +", "
                                     + date.date().toString("yyyy",calender)
                                     ,20)
               << strToStrWithPrefix(date.time().toString("hh:mm:ss"),10)
               << strToStrWithPrefix("#",2)
               << strToStrWithPrefix(type,10)
               << strToStrWithPrefix("==>   ",8)
               << str
               << "\n";
        file.flush();
        file.close();
    }
}

void Logger::log(const QString &str)
{
    writeString("LOG", str);
}

void Logger::warning(const QString &str)
{
    writeString("WARNING", str);
}

void Logger::error(const QString &str)
{
    writeString("*ERROR*", str);
}

QString Logger::readLog()
{
    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Logs/";
    QString filename=path + getCurrentMonthFileName();
    QFile file( filename );
    if ( file.open(QIODevice::ReadOnly) )
    {
        QTextStream in(&file);
        QString str = in.readAll();
        file.close();
        return str;
    }
    return "";
}

QString Logger::readLog(int month, int year)
{
    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/Logs/";
    QString filename=path + getFileName(month,year);
    QFile file( filename );
    if ( file.open(QIODevice::ReadOnly) )
    {
        QTextStream in(&file);
        QString str = in.readAll();
        file.close();
        return str;
    }
    return "";
}

QString Logger::getCurrentMonthFileName()
{
    auto date = QDateTime::currentDateTime();
    return intToStrWithPrefix(date.toUTC().date().year(),4)+
            "_" +
            intToStrWithPrefix(date.toUTC().date().month(),2)+
            ".txt";
}

QString Logger::getFileName(int month, int year)
{
    return intToStrWithPrefix(year,4)+
            "_" +
            intToStrWithPrefix(month,2)+
            ".txt";
}

QString Logger::intToStrWithPrefix(int data, int length)
{
    QString str = QString::number(data);
    while (str.length()< length)
        str = "0" + str;
    return str;
}

QString Logger::strToStrWithPrefix(const QString &data, int length, char prefix)
{
    QString str = QString(data);
    while (str.length()< length)
        str = prefix + str;
    return str;
}

