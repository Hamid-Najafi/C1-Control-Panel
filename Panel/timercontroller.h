#ifndef TIMERCONTROLLER_H
#define TIMERCONTROLLER_H

#include <QObject>
#include <QString>
#include <QTimer>
#include <QElapsedTimer>

class TimerController : public QObject
{
    Q_OBJECT
    QString m_timer;
    QElapsedTimer timeElapsed;
    bool timerStarted;
    qint64 timerSec = 0;
    int timerSecond = 0;
    int timerMinutes = 0;
    int timerHour = 0;

    QTimer *update_timer;

public:
    explicit TimerController(QObject *parent = nullptr);
    Q_PROPERTY(QString timer READ timer WRITE setTimer NOTIFY timerChanged)

    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();

    const QString &timer() const;
    void setTimer(const QString &newTimer);

signals:

    void timerChanged();

public slots:
    void updateTime();
};

#endif // TIMERCONTROLLER_H
