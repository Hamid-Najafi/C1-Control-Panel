#include "modbuscontroller.h"
#include <QDebug>
#include <QUrl>
#include <QHostAddress>
#include <QNetworkInterface>
#include <QStandardPaths>
#include <QProcess>
#include <QStringList>
#include <QDir>

ModbusController::ModbusController(QObject *parent)
    : QObject{parent}
{

    // Read RTU params
    auto path = QStandardPaths::writableLocation( QStandardPaths::HomeLocation) + "/C1/";
    QString filename=path + "modbus.txt";
    QFile file( filename );
    if ( file.open(QIODevice::ReadOnly) )
    {
        QTextStream in(&file);
        bool ok = false;
        QString str = in.readLine();
        rtu_port = str;
        str = in.readLine();
        baud = str.toInt(&ok);
        if(!ok)
            baud = QSerialPort::Baud9600;
        str = in.readLine();
        stopBits = str.toInt(&ok);
        if(!ok)
            stopBits = QSerialPort::OneStop;
        str = in.readLine();
        dataBits = str.toInt(&ok);
        if(!ok)
            dataBits = QSerialPort::Data8;
        str = in.readLine();
        parity = str.toInt(&ok);
        if(!ok)
            parity = QSerialPort::NoParity;
        file.close();
    }else{
        rtu_port = "/dev/ttyUSB0";
        baud = QSerialPort::Baud9600;
        stopBits = QSerialPort::OneStop;
        dataBits = QSerialPort::Data8;
        parity = QSerialPort::NoParity;
    }
    setIsConnected(false);


    onCurrentConnectTypeChanged(1);
    onConnectButtonClicked();

    rtu_onConnectTypeChanged(0);
    rtu_onConnectButtonClicked();

    timer = new QTimer(this);
    connect(timer, &QTimer::timeout,this,&ModbusController::timerHandle);
    timer->setInterval(1000);
    timer->start();

    stringUpdater = new QTimer(this);
    connect(stringUpdater, &QTimer::timeout,this,&ModbusController::stringUpdaterHandle);
    stringUpdater->setInterval(1000);
    stringUpdater->start();
}

void ModbusController::timerHandle()
{
    if (!rtu_modbusDevice)
        return;
    if(!isConnected()){
        rtu_onConnectButtonClicked();
    }
    if (!isConnected())
    {

        modbusRetryTime += 6;
        if(modbusRetryTime > 60)
            modbusRetryTime = 60;
        modbusRetryRemainingtime = modbusRetryTime;
        timer->setInterval(modbusRetryTime * 1000);
        return;
    }


//    if (auto *reply = rtu_modbusDevice->sendReadRequest(rtu_readRequest(QModbusDataUnit::Coils), 1)) {
//        if (!reply->isFinished())
//            connect(reply, &QModbusReply::finished, this, &ModbusController::rtu_onReadReady);
//        else
//            delete reply; // broadcast replies return immediately
//    } else {
//        //logger->error(tr("Read error: ") + modbusDevice->errorString());
//    }

    if (auto *reply = rtu_modbusDevice->sendReadRequest(rtu_readRequest(QModbusDataUnit::DiscreteInputs), 1)) {
        if (!reply->isFinished())
            connect(reply, &QModbusReply::finished, this, &ModbusController::rtu_onReadReady);
        else
            delete reply; // broadcast replies return immediately
    } else {
        //logger->error(tr("Read error: ") + rtu_modbusDevice->errorString());
    }

    if (auto *reply = rtu_modbusDevice->sendReadRequest(rtu_readRequest(QModbusDataUnit::InputRegisters), 1)) {
        if (!reply->isFinished())
            connect(reply, &QModbusReply::finished, this, &ModbusController::rtu_onReadReady);
        else
            delete reply; // broadcast replies return immediately
    } else {
        //logger->error(tr("Read error: ") + rtu_modbusDevice->errorString());
    }

//    if (auto *reply = rtu_modbusDevice->sendReadRequest(rtu_readRequest(QModbusDataUnit::HoldingRegisters), 1)) {
//        if (!reply->isFinished())
//            connect(reply, &QModbusReply::finished, this, &ModbusController::rtu_onReadReady);
//        else
//            delete reply; // broadcast replies return immediately
//    } else {
//        //logger->error(tr("Read error: ") + modbusDevice->errorString());
    //    }
}

void ModbusController::stringUpdaterHandle()
{
    if(m_isConnected)
    {
        if(connectionMessage() != ""){
        setConnectionMessage("");
    timer->setInterval(1000);
    timer->start();
        }
    }
    else
        setConnectionMessage(QString("Can not connect to modbus controller ( Retry in ") + QString::number(modbusRetryRemainingtime--) + QString("second(s) )"));
}

void ModbusController::setCoilWithId(int id, bool val)
{
    coil[id] = val;
    rtu_setCoilWithId(id,val);
    bitChanged(id, QModbusDataUnit::Coils, coil[id]);
}

void ModbusController::setDiscreteInputWithId(int id, bool val)
{
    discreteInput[id] = val;
    bitChanged(id, QModbusDataUnit::DiscreteInputs, discreteInput[id]);
}

void ModbusController::setInputRegisterWithId(int id, quint16 value)
{
    if (!modbusDevice)
        return;

    bool ok = true;
    ok = modbusDevice->setData(QModbusDataUnit::InputRegisters, id, value);
    if (!ok)
    {
        //logger->error("Modbus: " + tr("Could not set register: ") + modbusDevice->errorString());
    }
}

void ModbusController::setHoldingRegisterWithId(int id, quint16 value)
{
    if (!modbusDevice)
        return;

    bool ok = true;
    ok = modbusDevice->setData(QModbusDataUnit::HoldingRegisters, id, value);
    rtu_setHoldingRegisterWithId(id,value);
    if (!ok)
    {
//        //logger->error("Modbus: " + tr("Could not set register: ") + modbusDevice->errorString());
    }
}

void ModbusController::onConnectButtonClicked()
{
    bool intendToConnect = true;

    const QHostAddress &localhost = QHostAddress(QHostAddress::LocalHost);
    for (const QHostAddress &address: QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost)
        {
            this->ipAddress = address.toString();
            qDebug() << address.toString();
        }
    }

    if (intendToConnect) {
        QString ipPort = "localhost:65500";
        const QUrl url = QUrl::fromUserInput(ipPort);
        modbusDevice->setConnectionParameter(QModbusDevice::NetworkPortParameter, url.port());
        modbusDevice->setConnectionParameter(QModbusDevice::NetworkAddressParameter, url.host());
        modbusDevice->setConnectionParameter(QModbusDevice::TimeoutError,3000);

        modbusDevice->setServerAddress(1);
        if (!modbusDevice->connectDevice()) {
            //logger->error(tr("Connect failed: ") + modbusDevice->errorString());
        } else {
            //logger->info("Modbus Server connected.");
        }
    }
}

void ModbusController::onStateChanged(int state)
{
    clientIsConnected = (state != QModbusDevice::UnconnectedState);

    if (state == QModbusDevice::UnconnectedState)
    {
        //logger->info("Modbus Server disconnecteds.");
    }
    else if (state == QModbusDevice::ConnectedState)
    {
        //logger->info("Modbus Server connected.");
    }
}

void ModbusController::coilChanged(int id, bool val)
{
    coil[id] = val;
    bitChanged(id, QModbusDataUnit::Coils, coil[id]);
    coilUpdated(id ,val);
}

void ModbusController::discreteInputChanged(int id, bool val)
{
    discreteInput[id] = val;
    bitChanged(id, QModbusDataUnit::DiscreteInputs, discreteInput[id]);
    discreteInputUpdated(id,val);
}

void ModbusController::bitChanged(int id, QModbusDataUnit::RegisterType table, bool value)
{
    if (!modbusDevice)
        return;

    if (!modbusDevice->setData(table, quint16(id), value))
    {
//        //logger->error("Modbus: " + tr("Could not set data: ") + modbusDevice->errorString());
}}

void ModbusController::setInputRegister(int id, const QString &value)
{
    if (!modbusDevice)
        return;

    bool ok = true;
    ok = modbusDevice->setData(QModbusDataUnit::InputRegisters, id, value.toUShort(&ok, 16));
    if (!ok)
    {
//        //logger->error("Modbus: " + tr("Could not set register: ") + modbusDevice->errorString());
    }else{
        inputRegisterUpdated(id,value.toUShort(&ok, 16));
    }

}

void ModbusController::setHoldingRegister(int id, const QString &value)
{
    if (!modbusDevice)
        return;

    bool ok = true;
    ok = modbusDevice->setData(QModbusDataUnit::HoldingRegisters, id, value.toUShort(&ok, 16));
    if (!ok)
    {
        //logger->error("Modbus: " + tr("Could not set register: ") + modbusDevice->errorString());
    }else{
        holdingRegisterUpdated(id,value.toUShort(&ok, 16));
    }
}

void ModbusController::updateWidgets(QModbusDataUnit::RegisterType table, int address, int size)
{
    for (int i = 0; i < size; ++i) {
        quint16 value;
        QString text;
        switch (table) {
        case QModbusDataUnit::Coils:
            modbusDevice->data(QModbusDataUnit::Coils, quint16(address + i), &value);
            coil[address + i ] = (value != 0);
            coilUpdated(address + i,coil[address + i ] );
            break;
        case QModbusDataUnit::HoldingRegisters:
            modbusDevice->data(QModbusDataUnit::HoldingRegisters, quint16(address + i), &value);
            holdingRegister[address + i] = value;
            holdingRegisterUpdated(address + i,value);
            break;
        default:
            break;
        }
    }
}

void ModbusController::onCurrentConnectTypeChanged(int)
{
    if (modbusDevice) {
        modbusDevice->disconnect();
        delete modbusDevice;
        modbusDevice = nullptr;
    }


    modbusDevice = new QModbusTcpServer(this);

    if (!modbusDevice) {
        qDebug() << (tr("Could not create Modbus server."));
        //logger->error("Could not create Modbus server.");
    } else {
        QModbusDataUnitMap reg;
        reg.insert(QModbusDataUnit::Coils, { QModbusDataUnit::Coils, 0, registerCount });
        reg.insert(QModbusDataUnit::DiscreteInputs, { QModbusDataUnit::DiscreteInputs, 0, registerCount });
        reg.insert(QModbusDataUnit::InputRegisters, { QModbusDataUnit::InputRegisters, 0, registerCount });
        reg.insert(QModbusDataUnit::HoldingRegisters, { QModbusDataUnit::HoldingRegisters, 0, registerCount });

        modbusDevice->setMap(reg);

        connect(modbusDevice, &QModbusServer::dataWritten,
                this, &ModbusController::updateWidgets);
        connect(modbusDevice, &QModbusServer::stateChanged,
                this, &ModbusController::onStateChanged);
        connect(modbusDevice, &QModbusServer::errorOccurred,
                this, &ModbusController::handleDeviceError);

        setupDeviceData();
    }
}

void ModbusController::handleDeviceError(QModbusDevice::Error newError)
{
    if (newError == QModbusDevice::NoError || !modbusDevice)
        return;
    //logger->error("Modbus : "+modbusDevice->errorString());
    qDebug() << "Modbus : "+modbusDevice->errorString();
}

void ModbusController::rtu_onConnectButtonClicked()
{
    if (!rtu_modbusDevice)
        return;
    QDir lsDev("/dev/");
    lsDev.setNameFilters(QStringList() << "ttyUSB*");
    QStringList args = lsDev.entryList(QDir::System);
    if(args.length()==1)
    {
        rtu_port = "/dev/" + args.at(0);
    }
    qDebug() << rtu_port;
    rtu_modbusDevice->setConnectionParameter(QModbusDevice::SerialPortNameParameter,
                                             rtu_port);
    rtu_modbusDevice->setConnectionParameter(QModbusDevice::SerialParityParameter,
                                             parity);
    rtu_modbusDevice->setConnectionParameter(QModbusDevice::SerialBaudRateParameter,
                                             baud);
    rtu_modbusDevice->setConnectionParameter(QModbusDevice::SerialDataBitsParameter,
                                             dataBits);
    rtu_modbusDevice->setConnectionParameter(QModbusDevice::SerialStopBitsParameter,
                                             stopBits);
    rtu_modbusDevice->setConnectionParameter(QModbusDevice::TimeoutError,3000);
    rtu_modbusDevice->setTimeout(3000);
    rtu_modbusDevice->setNumberOfRetries(3);
    if (!rtu_modbusDevice->connectDevice()) {
        //logger->error(tr("RTU Connect failed: ") + rtu_modbusDevice->errorString());
        qDebug() << tr("RTU Connect failed: ") + rtu_modbusDevice->errorString();
        setIsConnected(false);
    } else {
        //logger->info("Modbus Master connected.");
        qDebug() << "Modbus Master connected.";
        setIsConnected(true);
        for(int i = 0; i< 8;i++)
        {
            setCoilWithId(i,false);
        }
        for(int i = 1; i< 4;i++)
        {
            setHoldingRegisterWithId(i,0);
        }
    }

}

void ModbusController::rtu_onModbusStateChanged(int state)
{
    rtu_isConnected = (state != QModbusDevice::UnconnectedState);
    setIsConnected(rtu_isConnected);

    if (state == QModbusDevice::UnconnectedState)
    {
        //logger->info("Modbus Master disconnecteds.");
        qDebug() << "Modbus Master disconnecteds.";
    }
    else if (state == QModbusDevice::ConnectedState)
    {
        //logger->info("Modbus Master connected.");
        qDebug() << "Modbus Master connected.";
    }
}

void ModbusController::rtu_onReadReady()
{
    auto reply = qobject_cast<QModbusReply *>(sender());


    if (!reply)
        return;

    if (reply->error() == QModbusDevice::NoError) {
        const QModbusDataUnit unit = reply->result();
        qDebug() << unit.registerType();
        if(unit.registerType() == QModbusDataUnit::InputRegisters)
        {
            for (int i = 0, total = int(unit.valueCount()); i < total; ++i) {
                inputRegister[unit.startAddress() + i] = unit.value(i);
                inputRegisterUpdated(unit.startAddress() + i,unit.value(i));
            }

        }
        if(unit.registerType() == QModbusDataUnit::DiscreteInputs)
        {
            for (int i = 0, total = int(unit.valueCount()); i < total; ++i) {
                discreteInput[unit.startAddress() + i] = unit.value(i);
                discreteInputUpdated(unit.startAddress() + i,unit.value(i));
            }

        }
    } else if (reply->error() == QModbusDevice::ProtocolError) {
        //logger->error(tr("Read response error: %1 (Mobus exception: 0x%2)").
//                      arg(reply->errorString()).
//                      arg(reply->rawResult().exceptionCode(), -1, 16));

    } else {
        //logger->error(tr("Read response error: %1 (code: 0x%2)").
//                      arg(reply->errorString()).
//                      arg(reply->error(), -1, 16));
    }

    reply->deleteLater();
}

void ModbusController::rtu_onConnectTypeChanged(int)
{
    if (rtu_modbusDevice) {
        rtu_modbusDevice->disconnectDevice();
        delete rtu_modbusDevice;
        rtu_modbusDevice = nullptr;
    }

    rtu_modbusDevice = new QModbusRtuSerialMaster(this);


    connect(rtu_modbusDevice, &QModbusClient::errorOccurred,
            this,&ModbusController::rtu_handleDeviceError);
    if (!rtu_modbusDevice) {
        qDebug() << (tr("Could not create Modbus Master."));
        //logger->error("Could not create Modbus Master.");
    } else {
        connect(rtu_modbusDevice, &QModbusClient::stateChanged,
                this, &ModbusController::rtu_onModbusStateChanged);
    }

}

void ModbusController::rtu_handleDeviceError(QModbusDevice::Error newError)
{
    if (newError == QModbusDevice::NoError || !rtu_modbusDevice)
        return;
    //logger->error("Modbus Master : "+rtu_modbusDevice->errorString());
    //qDebug() << "Modbus Master : "+rtu_modbusDevice->errorString();
    if( newError == QModbusDevice::ConnectionError)
        setIsConnected(false);
}

void ModbusController::setupDeviceData()
{
    if (!modbusDevice)
        return;

    for (quint16 i = 0; i < registerCount; ++i) {
        coil.append(false);
        discreteInput.append(false);
        inputRegister.append(0);
        holdingRegister.append(0);
        modbusDevice->setData(QModbusDataUnit::Coils, i, false);
        modbusDevice->setData(QModbusDataUnit::DiscreteInputs, i,false);
        modbusDevice->setData(QModbusDataUnit::InputRegisters, i,0);
        modbusDevice->setData(QModbusDataUnit::HoldingRegisters, i,i==0? 1 : 0);
    }
}

void ModbusController::rtu_setCoilWithId(int id, bool val)
{
    if (!rtu_modbusDevice)
        return;
    if (!isConnected())
        return;

    qDebug() << "#################################";
    qDebug() << "rtu_setCoilWithId " << id <<"  " << val;

    QModbusDataUnit writeUnit = rtu_writeRequest(id, QModbusDataUnit::Coils);
    writeUnit.setValue(0,val);

    if (auto *reply = rtu_modbusDevice->sendWriteRequest(writeUnit, 1)) {
        if (!reply->isFinished()) {
            connect(reply, &QModbusReply::finished, this, [this, reply]() {
                if (reply->error() == QModbusDevice::ProtocolError) {
                    //logger->error(tr("Write response error: %1 (Mobus exception: 0x%2)")
//                                  .arg(reply->errorString()).arg(reply->rawResult().exceptionCode(), -1, 16));
                } else if (reply->error() != QModbusDevice::NoError) {
                    //logger->error(tr("Write response error: %1 (code: 0x%2)").
//                        arg(reply->errorString()).arg(reply->error(), -1, 16));
                }
                reply->deleteLater();
            });
        } else {
            // broadcast replies return immediately
            reply->deleteLater();
        }
    } else {
        //logger->error(tr("Write error: ") + rtu_modbusDevice->errorString());
    }
}

void ModbusController::rtu_setHoldingRegisterWithId(int id, quint16 value)
{
    if (!rtu_modbusDevice)
        return;

    if (!isConnected())
        return;

    QModbusDataUnit writeUnit = rtu_writeRequest(id, QModbusDataUnit::HoldingRegisters);
    writeUnit.setValue(0,(value - 1) / 4);
    qDebug() << "##############################";
    qDebug() << "id " << id << "value " << value;
    if (auto *reply = rtu_modbusDevice->sendWriteRequest(writeUnit, 1)) {
        if (!reply->isFinished()) {
            connect(reply, &QModbusReply::finished, this, [this, reply]() {
                if (reply->error() == QModbusDevice::ProtocolError) {
                    //logger->error(tr("Write response error: %1 (Mobus exception: 0x%2)")
//                                  .arg(reply->errorString()).arg(reply->rawResult().exceptionCode(), -1, 16));
                } else if (reply->error() != QModbusDevice::NoError) {
                    //logger->error(tr("Write response error: %1 (code: 0x%2)").
//                        arg(reply->errorString()).arg(reply->error(), -1, 16));
                }
                reply->deleteLater();
            });
        } else {
            // broadcast replies return immediately
            reply->deleteLater();
        }
    } else {
        //logger->error(tr("Write error: ") + rtu_modbusDevice->errorString());
    }
}

QModbusDataUnit ModbusController::rtu_readRequest(QModbusDataUnit::RegisterType type) const
{
    int regType = 0;
    int count = 8;
    if(type  == QModbusDataUnit::Coils)
    {regType = 2; count = 8; }
    else if(type  == QModbusDataUnit::DiscreteInputs)
    {regType = 1; count = 8;}
    else if(type  == QModbusDataUnit::InputRegisters)
    {regType = 3; count = 4;}
    else
    {regType = 4; count = 4;}
    const auto table =
        static_cast<QModbusDataUnit::RegisterType>(regType);

    int startAddress = 0;
    quint16 numberOfEntries = count;
    return QModbusDataUnit(table, startAddress, numberOfEntries);
}

QModbusDataUnit ModbusController::rtu_writeRequest(int id, QModbusDataUnit::RegisterType type) const
{

    int startAddress = id;

    // do not go beyond 10 entries
    quint16 numberOfEntries = 1;
    return QModbusDataUnit(type, startAddress, numberOfEntries);
}


const QString &ModbusController::connectionMessage() const
{
    return m_connectionMessage;
}

void ModbusController::setConnectionMessage(const QString &newConnectionMessage)
{
    if (m_connectionMessage == newConnectionMessage)
        return;
    m_connectionMessage = newConnectionMessage;
    emit connectionMessageChanged();
}

bool ModbusController::isConnected() const
{
    return m_isConnected;
}

void ModbusController::setIsConnected(bool newIsConnected)
{
    if (m_isConnected == newIsConnected)
        return;
    m_isConnected = newIsConnected;
    emit isConnectedChanged();
}
