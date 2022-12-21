#ifndef LOGGER_H
#define LOGGER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDateTime>

class Logger : public QObject
{
    Q_OBJECT
public:
    explicit Logger(QObject *parent = nullptr);

    Q_INVOKABLE void info(const QString &str);
    Q_INVOKABLE void log(const QString &str);
    Q_INVOKABLE void warning(const QString &str);
    Q_INVOKABLE void error(const QString &str);
    Q_INVOKABLE QString readLog();
    Q_INVOKABLE QString readLog(int month,int year);

signals:

private:
    void writeString(const QString &type,const QString &str);
    QString getCurrentMonthFileName();
    QString getFileName(int month,int year);
    QString intToStrWithPrefix(int data, int length);
    QString strToStrWithPrefix(const QString &data, int length, char prefix = ' ');

};

#endif // LOGGER_H
