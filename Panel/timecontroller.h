#ifndef TIMECONTROLLER_H
#define TIMECONTROLLER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDateTime>
#include <QTimer>
#include <QCalendar>

class TimeController : public QObject
{
    Q_OBJECT
    QTimer *timer = nullptr;

public:
    explicit TimeController(QObject *parent = nullptr);

    Q_PROPERTY(QString currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)
    Q_PROPERTY(QString currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged)

    Q_INVOKABLE void resetDevice();

    const QString &currentDate() const;
    void setCurrentDate(const QString &newCurrentDate);

    const QString &currentTime() const;
    void setCurrentTime(const QString &newCurrentTime);
public slots:

    void updateHandler();

signals:

    void currentDateChanged();
    void currentTimeChanged();

private:
    QString m_currentDate;
    QString m_currentTime;
};

#endif // TIMECONTROLLER_H
