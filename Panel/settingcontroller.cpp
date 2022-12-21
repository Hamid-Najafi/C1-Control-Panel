#include "settingcontroller.h"
#include <QAudioDeviceInfo>
#include <QDebug>
#include <QAudio>
#include <QAudioDeviceInfo>
#include <QAudioDeviceInfo>
#include <QAudioDeviceInfo>


SettingController* SettingController::m_pThis = nullptr;
SettingController::SettingController(QObject *parent)
    : QObject{parent}
{

}
SettingController *SettingController::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
        m_pThis = new SettingController();
    return m_pThis;
}

QObject *SettingController::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return SettingController::instance();
}

QStringList SettingController::getOutputAudioDevices()
{
    QStringList outputs;
    QList<QAudioDeviceInfo> devices = QAudioDeviceInfo::availableDevices(QAudio::AudioOutput);
    foreach (QAudioDeviceInfo i, devices)
    {
        outputs << i.deviceName();
    }
    return outputs;
}

QStringList SettingController::getInputAudioDevices()
{
    QStringList outputs;
    QList<QAudioDeviceInfo> devices = QAudioDeviceInfo::availableDevices(QAudio::AudioInput);
    foreach (QAudioDeviceInfo i, devices)
    {
        outputs << i.deviceName();
    }
    return outputs;
}

QString SettingController::getOutputDefaultDevice()
{
    return QAudioDeviceInfo::defaultOutputDevice().deviceName();
}

QString SettingController::getInputDefaultDevice()
{
    return QAudioDeviceInfo::defaultInputDevice().deviceName();
}
