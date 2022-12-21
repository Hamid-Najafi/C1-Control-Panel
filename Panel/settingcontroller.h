#ifndef SETTINGCONTROLLER_H
#define SETTINGCONTROLLER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QQmlEngine>
#include <QJSEngine>

class SettingController : public QObject
{
    Q_OBJECT
    static SettingController *m_pThis;
    QString selected_output_device = "";
    QString selected_input_device = "";

public:
    /// Static getter
    static SettingController *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);


    Q_INVOKABLE QStringList getOutputAudioDevices();
    Q_INVOKABLE QStringList getInputAudioDevices();
    Q_INVOKABLE QString getOutputDefaultDevice();
    Q_INVOKABLE QString getInputDefaultDevice();

signals:

private:
    explicit SettingController(QObject *parent = nullptr);

};

#endif // SETTINGCONTROLLER_H
