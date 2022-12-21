#ifndef SERIALCONTROLLER_H
#define SERIALCONTROLLER_H

#include <QObject>
#include <QFile>
#include <QSerialPort>
#include <QStringList>
#include <QTextStream>
#include <QThread>
#include <QDebug>
#include <QTimer>

#include "serialportwriter.h"
#include "serialportreader.h"

class SerialController : public QObject
{
    Q_OBJECT

    const qint32 max_inputs = 8;

    QSerialPort serialPort;
    QString serialPortName = "/dev/ttyUSB0";
    QString serialPortBuad = "57600";

    SerialPortWriter serialPortWriter;
    SerialPortReader serialPortReader;

    QTimer* updater;
    QTimer* unlocker;
    QTimer* stringUpdater;
    bool isLock = false;
    int m_turn = 0;
    int m_val = 1;


    bool m_dIn01;
    bool m_dIn02;
    bool m_dIn03;
    bool m_dIn04;
    bool m_dIn05;
    bool m_dIn06;
    bool m_dIn07;
    bool m_dIn08;

    quint16 m_aIn01;
    quint16 m_aIn02;
    quint16 m_aIn03;
    quint16 m_aIn04;

    bool m_dOut01;
    bool m_dOut02;
    bool m_dOut03;
    bool m_dOut04;
    bool m_dOut05;
    bool m_dOut06;
    bool m_dOut07;
    bool m_dOut08;

public:
    explicit SerialController(QObject *parent = nullptr);

    Q_PROPERTY(bool dIn01 READ dIn01 WRITE setDIn01 NOTIFY dIn01Changed)
    Q_PROPERTY(bool dIn02 READ dIn02 WRITE setDIn02 NOTIFY dIn02Changed)
    Q_PROPERTY(bool dIn03 READ dIn03 WRITE setDIn03 NOTIFY dIn03Changed)
    Q_PROPERTY(bool dIn04 READ dIn04 WRITE setDIn04 NOTIFY dIn04Changed)
    Q_PROPERTY(bool dIn05 READ dIn05 WRITE setDIn05 NOTIFY dIn05Changed)
    Q_PROPERTY(bool dIn06 READ dIn06 WRITE setDIn06 NOTIFY dIn06Changed)
    Q_PROPERTY(bool dIn07 READ dIn07 WRITE setDIn07 NOTIFY dIn07Changed)
    Q_PROPERTY(bool dIn08 READ dIn08 WRITE setDIn08 NOTIFY dIn08Changed)

    Q_PROPERTY(quint16 aIn01 READ aIn01 WRITE setAIn01 NOTIFY aIn01Changed)
    Q_PROPERTY(quint16 aIn02 READ aIn02 WRITE setAIn02 NOTIFY aIn02Changed)
    Q_PROPERTY(quint16 aIn03 READ aIn03 WRITE setAIn03 NOTIFY aIn03Changed)
    Q_PROPERTY(quint16 aIn04 READ aIn04 WRITE setAIn04 NOTIFY aIn04Changed)

    Q_PROPERTY(bool dOut01 READ dOut01 WRITE setDOut01 NOTIFY dOut01Changed)
    Q_PROPERTY(bool dOut02 READ dOut02 WRITE setDOut02 NOTIFY dOut02Changed)
    Q_PROPERTY(bool dOut03 READ dOut03 WRITE setDOut03 NOTIFY dOut03Changed)
    Q_PROPERTY(bool dOut04 READ dOut04 WRITE setDOut04 NOTIFY dOut04Changed)
    Q_PROPERTY(bool dOut05 READ dOut05 WRITE setDOut05 NOTIFY dOut05Changed)
    Q_PROPERTY(bool dOut06 READ dOut06 WRITE setDOut06 NOTIFY dOut06Changed)
    Q_PROPERTY(bool dOut07 READ dOut07 WRITE setDOut07 NOTIFY dOut07Changed)
    Q_PROPERTY(bool dOut08 READ dOut08 WRITE setDOut08 NOTIFY dOut08Changed)

    Q_PROPERTY(QString connectionMessage READ connectionMessage WRITE setConnectionMessage NOTIFY connectionMessageChanged)

    void writeSingleCoil(char address, char coil, bool state);
    void writeMultiCoil(char address , char state);

    bool readSingleCoil(char address , char function, char number,char io, char coil);
    char readMultiCoil(char address , char function, char number,char io);

    void writeSingleRegister(char address , char function, char number,char io, char coil, char val1,char val2);

    quint16 readSingleRegister(char address , char function, char number,char io, char coil);

    void updateInputValues(char address);
    void updateInputRegisterValues(char address);

    bool dIn01() const;
    void setDIn01(bool newDIn01);

    bool dIn02() const;
    void setDIn02(bool newDIn02);

    bool dIn03() const;
    void setDIn03(bool newDIn03);

    bool dIn04() const;
    void setDIn04(bool newDIn04);

    bool dIn05() const;
    void setDIn05(bool newDIn05);

    bool dIn06() const;
    void setDIn06(bool newDIn06);

    bool dIn07() const;
    void setDIn07(bool newDIn07);

    bool dIn08() const;
    void setDIn08(bool newDIn08);

    quint16 aIn01() const;
    void setAIn01(quint16 newAIn01);

    quint16 aIn02() const;
    void setAIn02(quint16 newAIn02);

    quint16 aIn03() const;
    void setAIn03(quint16 newAIn03);

    quint16 aIn04() const;
    void setAIn04(quint16 newAIn04);

    bool dOut01() const;
    void setDOut01(bool newDOut01);

    bool dOut02() const;
    void setDOut02(bool newDOut02);

    bool dOut03() const;
    void setDOut03(bool newDOut03);

    bool dOut04() const;
    void setDOut04(bool newDOut04);

    bool dOut05() const;
    void setDOut05(bool newDOut05);

    bool dOut06() const;
    void setDOut06(bool newDOut06);

    bool dOut07() const;
    void setDOut07(bool newDOut07);

    bool dOut08() const;
    void setDOut08(bool newDOut08);

    const QString &connectionMessage() const;
    void setConnectionMessage(const QString &newConnectionMessage);

public slots:
    void onDataReceived(const QByteArray* data);
    void onUpdaterTriger();
    void onUnlockerTriger();
    void onStringUpdater();

signals:

    void dIn01Changed();
    void dIn02Changed();
    void dIn03Changed();
    void dIn04Changed();
    void dIn05Changed();
    void dIn06Changed();
    void dIn07Changed();
    void dIn08Changed();
    void aIn01Changed();
    void aIn02Changed();
    void aIn03Changed();
    void aIn04Changed();
    void dOut01Changed();
    void dOut02Changed();
    void dOut03Changed();
    void dOut04Changed();
    void dOut05Changed();
    void dOut06Changed();
    void dOut07Changed();
    void dOut08Changed();
    void connectionMessageChanged();
private:
    QString m_connectionMessage;
};

#endif // SERIALCONTROLLER_H
