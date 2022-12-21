#include "serialcontroller.h"
#include "modbuscrc.h"
#include <QDebug>
#include <QtMath>

SerialController::SerialController(QObject *parent) : QObject(parent)
{

    serialPort.setPortName(serialPortName);

    const int serialPortBaudRate = serialPortBuad.toInt() ;
    serialPort.setBaudRate(serialPortBaudRate);

    serialPort.open(QIODevice::ReadWrite);
    qDebug() << "Is Open: "<< serialPort.isOpen();

    stringUpdater = new QTimer(this);
    connect(updater,&QTimer::timeout,this,&SerialController::onStringUpdater);
    stringUpdater->start(1000);

    if(serialPort.isOpen()){
    serialPortWriter.setSerialPort(&serialPort);
    serialPortReader.setSerialPort(&serialPort);
    connect(&serialPortReader,&SerialPortReader::dataReady,this,&SerialController::onDataReceived);

    updater = new QTimer(this);
    connect(updater,&QTimer::timeout,this,&SerialController::onUpdaterTriger);
    updater->start(10);

    unlocker = new QTimer(this);
    connect(unlocker,&QTimer::timeout,this,&SerialController::onUnlockerTriger);
    }
}

void SerialController::writeSingleCoil(char address, char coil, bool state)
{
    QByteArray header;
    header = header.append(address);
    header = header.append((char)0x01);
    header = header.append((char)0x08);
    header = header.append((char)0x00);
    header = header.append(coil);
    if( state)
        header = header.append((char)0xff);
    else
        header = header.append((char)0x00);
    uint8_t *data = (uint8_t *) header.data();
    header = header.append((char)0x00);
    header = header.append((char)0x00);
    serialPortWriter.write(header);
    serialPort.flush();
}

void SerialController::writeMultiCoil(char address, char state)
{
    QByteArray header;
    header = header.append(address);
    header = header.append((char)0x01);
    header = header.append((char)0x08);
    header = header.append((char)0x00);
    header = header.append((char)0xff);
    header = header.append(state);
    header = header.append((char)0x00);
    header = header.append((char)0x00);
    serialPortWriter.write(header);
    serialPort.flush();
}

void SerialController::updateInputValues(char address)
{
    QByteArray header;
    header = header.append(address);
    header = header.append((char)0x02);
    header = header.append((char)0x07);
    header = header.append((char)0xff);
    header = header.append((char)0xff);
    header = header.append((char)0x00);
    header = header.append((char)0x00);
    serialPortWriter.write(header);
    serialPort.flush();
}

void SerialController::updateInputRegisterValues(char address)
{
    QByteArray header;
    header = header.append(address);
    header = header.append((char)0x04);
    header = header.append((char)0x07);
    header = header.append((char)0xff);
    header = header.append((char)0xff);
    header = header.append((char)0x00);
    header = header.append((char)0x00);
    serialPortWriter.write(header);
    serialPort.flush();
}

void SerialController::onDataReceived(const QByteArray *data)
{


    auto len = data->length();
   QString str = "onDataReceived : ";
    for(int i =0;i<len;i++){
       str += QString::number((uchar)data->at(i)) + "_";
    }
    qDebug() << str;
    if(data->at(1) == 1 ){
        // write coil state
        //&& data->at(2) == 7
        auto coilNumber = data->at(3);
        auto value = data->at(4) == 1 ? true: false;
        switch (coilNumber) {
        case 1:
            setDIn01(value);
            break;
        }

    }
    if(data->at(1) == 2 ){
        // read coil
        auto values = new QList<bool>();
        for(int j = 0;j< max_inputs;j++){
            values->append(((data->at(4) & ((int)qPow(2,j))) > 0) ? true: false);
        }
        setDIn01(values->at(0));
        setDIn02(values->at(1));
        setDIn03(values->at(2));
        setDIn04(values->at(3));
        setDIn05(values->at(4));
        setDIn06(values->at(5));
        setDIn07(values->at(6));
        setDIn08(values->at(7));
    }
    if(data->at(1) == 4){
        quint16 a01 = ((data->at(3)) & 0xffff) | ((data->at(4) << 8) & 0xffff);
        quint16 a02 = ((data->at(5)) & 0xffff) | ((data->at(6) << 8) & 0xffff);
        quint16 a03 = ((data->at(7)) & 0xffff) | ((data->at(8) << 8) & 0xffff);
        quint16 a04 = ((data->at(9)) & 0xffff) | ((data->at(10) << 8) & 0xffff);
        qDebug() << "ANALOG 1 : " << a01;
        qDebug() << "ANALOG 2 : " << a02;
        qDebug() << "ANALOG 3 : " << a03;
        qDebug() << "ANALOG 4 : " << a04;
    }
    isLock = false;
    unlocker->stop();
}

void SerialController::onUpdaterTriger()
{
    if(isLock) return;
    if(m_turn == 0){
        updateInputValues(2);
    }else if(m_turn == 1){
        writeMultiCoil(2,m_val++);
        m_val = m_val %256;
    }else if(m_turn == 2){
        updateInputRegisterValues(2);
    }
    isLock = true;
    qDebug() <<m_turn;
    unlocker->start(2000);
    m_turn = ++m_turn % 3;
}

void SerialController::onUnlockerTriger()
{
    qDebug() <<"onUnlockerTriger";
    isLock = false;
    unlocker->stop();
}

void SerialController::onStringUpdater()
{

}


bool SerialController::dIn01() const
{
    return m_dIn01;
}

void SerialController::setDIn01(bool newDIn01)
{
    if (m_dIn01 == newDIn01)
        return;
    m_dIn01 = newDIn01;
    emit dIn01Changed();
}

bool SerialController::dIn02() const
{
    return m_dIn02;
}

void SerialController::setDIn02(bool newDIn02)
{
    if (m_dIn02 == newDIn02)
        return;
    m_dIn02 = newDIn02;
    emit dIn02Changed();
}

bool SerialController::dIn03() const
{
    return m_dIn03;
}

void SerialController::setDIn03(bool newDIn03)
{
    if (m_dIn03 == newDIn03)
        return;
    m_dIn03 = newDIn03;
    emit dIn03Changed();
}

bool SerialController::dIn04() const
{
    return m_dIn04;
}

void SerialController::setDIn04(bool newDIn04)
{
    if (m_dIn04 == newDIn04)
        return;
    m_dIn04 = newDIn04;
    emit dIn04Changed();
}

bool SerialController::dIn05() const
{
    return m_dIn05;
}

void SerialController::setDIn05(bool newDIn05)
{
    if (m_dIn05 == newDIn05)
        return;
    m_dIn05 = newDIn05;
    emit dIn05Changed();
}

bool SerialController::dIn06() const
{
    return m_dIn06;
}

void SerialController::setDIn06(bool newDIn06)
{
    if (m_dIn06 == newDIn06)
        return;
    m_dIn06 = newDIn06;
    emit dIn06Changed();
}

bool SerialController::dIn07() const
{
    return m_dIn07;
}

void SerialController::setDIn07(bool newDIn07)
{
    if (m_dIn07 == newDIn07)
        return;
    m_dIn07 = newDIn07;
    emit dIn07Changed();
}

bool SerialController::dIn08() const
{
    return m_dIn08;
}

void SerialController::setDIn08(bool newDIn08)
{
    if (m_dIn08 == newDIn08)
        return;
    m_dIn08 = newDIn08;
    emit dIn08Changed();
}

quint16 SerialController::aIn01() const
{
    return m_aIn01;
}

void SerialController::setAIn01(quint16 newAIn01)
{
    if (m_aIn01 == newAIn01)
        return;
    m_aIn01 = newAIn01;
    emit aIn01Changed();
}

quint16 SerialController::aIn02() const
{
    return m_aIn02;
}

void SerialController::setAIn02(quint16 newAIn02)
{
    if (m_aIn02 == newAIn02)
        return;
    m_aIn02 = newAIn02;
    emit aIn02Changed();
}

quint16 SerialController::aIn03() const
{
    return m_aIn03;
}

void SerialController::setAIn03(quint16 newAIn03)
{
    if (m_aIn03 == newAIn03)
        return;
    m_aIn03 = newAIn03;
    emit aIn03Changed();
}

quint16 SerialController::aIn04() const
{
    return m_aIn04;
}

void SerialController::setAIn04(quint16 newAIn04)
{
    if (m_aIn04 == newAIn04)
        return;
    m_aIn04 = newAIn04;
    emit aIn04Changed();
}

bool SerialController::dOut01() const
{
    return m_dOut01;
}

void SerialController::setDOut01(bool newDOut01)
{
    if (m_dOut01 == newDOut01)
        return;
    m_dOut01 = newDOut01;
    emit dOut01Changed();
}

bool SerialController::dOut02() const
{
    return m_dOut02;
}

void SerialController::setDOut02(bool newDOut02)
{
    if (m_dOut02 == newDOut02)
        return;
    m_dOut02 = newDOut02;
    emit dOut02Changed();
}

bool SerialController::dOut03() const
{
    return m_dOut03;
}

void SerialController::setDOut03(bool newDOut03)
{
    if (m_dOut03 == newDOut03)
        return;
    m_dOut03 = newDOut03;
    emit dOut03Changed();
}

bool SerialController::dOut04() const
{
    return m_dOut04;
}

void SerialController::setDOut04(bool newDOut04)
{
    if (m_dOut04 == newDOut04)
        return;
    m_dOut04 = newDOut04;
    emit dOut04Changed();
}

bool SerialController::dOut05() const
{
    return m_dOut05;
}

void SerialController::setDOut05(bool newDOut05)
{
    if (m_dOut05 == newDOut05)
        return;
    m_dOut05 = newDOut05;
    emit dOut05Changed();
}

bool SerialController::dOut06() const
{
    return m_dOut06;
}

void SerialController::setDOut06(bool newDOut06)
{
    if (m_dOut06 == newDOut06)
        return;
    m_dOut06 = newDOut06;
    emit dOut06Changed();
}

bool SerialController::dOut07() const
{
    return m_dOut07;
}

void SerialController::setDOut07(bool newDOut07)
{
    if (m_dOut07 == newDOut07)
        return;
    m_dOut07 = newDOut07;
    emit dOut07Changed();
}

bool SerialController::dOut08() const
{
    return m_dOut08;
}

void SerialController::setDOut08(bool newDOut08)
{
    if (m_dOut08 == newDOut08)
        return;
    m_dOut08 = newDOut08;
    emit dOut08Changed();
}

const QString &SerialController::connectionMessage() const
{
    return m_connectionMessage;
}

void SerialController::setConnectionMessage(const QString &newConnectionMessage)
{
    if (m_connectionMessage == newConnectionMessage)
        return;
    m_connectionMessage = newConnectionMessage;
    emit connectionMessageChanged();
}
