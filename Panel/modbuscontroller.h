#ifndef MODBUSCONTROLLER_H
#define MODBUSCONTROLLER_H

#include <QObject>
#include <QModbusServer>
#include <QString>
#include <QModbusTcpServer>
#include <QList>

#include <QModbusDataUnit>
#include <QModbusRtuSerialMaster>
#include <QStandardItemModel>
#include <QUrl>
#include <QSerialPort>
#include <QTimer>

class ModbusController : public QObject
{
    Q_OBJECT


    QModbusServer *modbusDevice = nullptr;
    const quint16 registerCount = 10;
    bool clientIsConnected = false;
    bool rtu_isConnected = false;
    QString ipAddress = "";

    QList<bool> coil;
    QList<bool> discreteInput;
    QList<quint16> inputRegister;
    QList<quint16> holdingRegister;

    QTimer *timer = nullptr;
    QTimer *stringUpdater = nullptr;

    QString rtu_port = "/dev/ttyUSB0";
    int parity = QSerialPort::EvenParity;
    int baud = QSerialPort::Baud19200;
    int dataBits = QSerialPort::Data8;
    int stopBits = QSerialPort::OneStop;

public:
    explicit ModbusController(QObject *parent = nullptr);

    Q_PROPERTY(QString connectionMessage READ connectionMessage WRITE setConnectionMessage NOTIFY connectionMessageChanged)
    Q_PROPERTY(bool isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged)

    Q_INVOKABLE void setCoilWithId(int id, bool val);
    Q_INVOKABLE void setDiscreteInputWithId(int id, bool val);
    Q_INVOKABLE void setInputRegisterWithId(int id,quint16 value);
    Q_INVOKABLE void setHoldingRegisterWithId(int id,quint16 value);


    const QString &connectionMessage() const;
    void setConnectionMessage(const QString &newConnectionMessage);

    bool isConnected() const;
    void setIsConnected(bool newIsConnected);

private Q_SLOTS:
    void timerHandle();
    void stringUpdaterHandle();

    void onConnectButtonClicked();
    void onStateChanged(int state);

    void coilChanged(int id, bool val);
    void discreteInputChanged(int id, bool val);
    void bitChanged(int id, QModbusDataUnit::RegisterType table, bool value);

    void setInputRegister(int id,const QString &value);
    void setHoldingRegister(int id,const QString &value);
    void updateWidgets(QModbusDataUnit::RegisterType table, int address, int size);

    void onCurrentConnectTypeChanged(int);

    void handleDeviceError(QModbusDevice::Error newError);

    // RTU

    void rtu_onConnectButtonClicked();
    void rtu_onModbusStateChanged(int state);

    void rtu_onReadReady();

    void rtu_onConnectTypeChanged(int);

    void rtu_handleDeviceError(QModbusDevice::Error newError);

signals:
    void coilUpdated(int id ,bool val);
    void discreteInputUpdated(int id,bool val);
    void inputRegisterUpdated(int id,quint16 value);
    void holdingRegisterUpdated(int id,quint16 value);

    void connectionMessageChanged();

    void isConnectedChanged();

private:
    void setupDeviceData();

    void rtu_setCoilWithId(int id, bool val);
    void rtu_setHoldingRegisterWithId(int id,quint16 value);

    QModbusReply *rtu_lastRequest = nullptr;
    QModbusClient *rtu_modbusDevice = nullptr;

    QModbusDataUnit rtu_readRequest(QModbusDataUnit::RegisterType type) const;
    QModbusDataUnit rtu_writeRequest(int id, QModbusDataUnit::RegisterType type) const;

    QList<bool> m_coil;
    QList<bool> m_discreteInput;
    QList<quint16> m_inputRegister;
    QList<quint16> m_holdingRegister;
    QString m_connectionMessage;
    bool m_isConnected=  false;
    qint32 modbusRetryTime = 3;
    qint32 modbusRetryRemainingtime = 3;
};

#endif // MODBUSCONTROLLER_H
