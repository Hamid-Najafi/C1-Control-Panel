#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QFontDatabase>
#include <QLocale>
#include <QTranslator>
#include <musicController.h>
#include <timercontroller.h>
#include <serialcontroller.h>
#include <sipcontroller.h>
#include <logger.h>
#include <modbuscontroller.h>
#include <timecontroller.h>
#include <voicecontroller.h>
#include <settingcontroller.h>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    app.setOrganizationName("C1 Tech");
    app.setOrganizationDomain("c1tech.co");
    app.setApplicationName("ORCO-8");


    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "panel_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }
    qmlRegisterSingletonType(QUrl("qrc:/Colors.qml"), "AppColors", 1, 0, "Colors");
    qmlRegisterSingletonType(QUrl("qrc:/Icons.qml"), "AppIcons", 1, 0, "Icons");

    qmlRegisterType<MusicController>("com.nourbakhsh.MusicController",1,0,"MusicController");
    qmlRegisterType<TimerController>("com.nourbakhsh.TimerController",1,0,"TimerController");
    qmlRegisterType<SerialController>("com.nourbakhsh.SerialController",1,0,"SerialController");
    qmlRegisterType<SipController>("com.nourbakhsh.SipController",1,0,"SipController");
    qmlRegisterType<Logger>("com.nourbakhsh.Logger",1,0,"Logger");
    qmlRegisterType<ModbusController>("com.nourbakhsh.ModbusController",1,0,"ModbusController");
    qmlRegisterType<TimeController>("com.nourbakhsh.TimeController",1,0,"TimeController");
    qmlRegisterType<VoiceController>("com.nourbakhsh.VoiceController",1,0,"VoiceController");
    qmlRegisterSingletonType<SettingController>("com.nourbakhsh.SettingController",1,0,"SettingController" , &SettingController::qmlInstance);


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);



    return app.exec();
}
