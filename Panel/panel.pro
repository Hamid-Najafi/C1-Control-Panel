QT += quick qml core virtualkeyboard  multimedia multimediawidgets virtualkeyboard serialport serialbus

SOURCES += \
    filelistmodeldata.cpp \
    logger.cpp \
    main.cpp \
    modbuscontroller.cpp \
        musicController.cpp \
#        qmediaplaylist.cpp \
#        qplaylistfileparser.cpp \
        rnaccount.cpp \
        rncall.cpp \
        rnpjsip.cpp \
        serialcontroller.cpp \
        serialportreader.cpp \
        serialportwriter.cpp \
    settingcontroller.cpp \
        sipcontroller.cpp \
    timecontroller.cpp \
        timercontroller.cpp \
    voicecontroller.cpp \
    voicedata.cpp \
    voicepartialdata.cpp \
    writeregistermodel.cpp

#resources.files = main.qml \
#                  Dashboard.qml \
#                  Colors.qml \
#                  Backend.js
#resources.prefix = /

#RESOURCES += resources

TRANSLATIONS += \
    panel_en_US.ts

CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /home/ubuntu
!isEmpty(target.path): INSTALLS += target


RESOURCES += \
    mImages.qrc \
    qml.qrc

HEADERS += \
    filelistmodeldata.h \
    logger.h \
    modbuscontroller.h \
    modbuscrc.h \
    musicController.h \
#    qmediaplaylist.h \
#    qmediaplaylist_p.h \
#    qplaylistfileparser.h \
    rnaccount.h \
    rncall.h \
    rnpjsip.h \
    serialcontroller.h \
    serialportreader.h \
    serialportwriter.h \
    settingcontroller.h \
    sipcontroller.h \
    timecontroller.h \
    timercontroller.h \
    voicecontroller.h \
    voicedata.h \
    voicepartialdata.h \
    writeregistermodel.h



unix{
    macx{
        SOURCES += deviceWatcher/qdevicewatcher_mac.cpp
        LIBS += -framework DiskArbitration -framework Foundation
    }else{
        SOURCES += deviceWatcher/qdevicewatcher_linux.cpp
    }
}

win32{
    wince*: SOURCES += deviceWatcher/qdevicewatcher_wince.cpp
    else: SOURCES += deviceWatcher/qdevicewatcher_win32.cpp
    LIBS *= -luser32
}

win32:msvc{
    CONFIG += c++11
}else{
    QMAKE_CXXFLAGS += -std=c++11
}

SOURCES += \
    deviceWatcher/qdevicewatcher.cpp

HEADERS += \
    deviceWatcher/qdevicewatcher_p.h \
    deviceWatcher/qdevicewatcher.h





LIBS += -L/opt/pjsip/lib \
    -lpthread -lm \
    -lpjsua2 \
    -lpjsua \
    -lpjsip-ua \
    -lpjsip-simple \
    -lpjsip \
    -lwebrtc \
    -lpjmedia \
    -lpjmedia-audiodev \
    -lpjmedia \
    -lpjmedia-codec \
    -lpj \
    -lpjnath \
    -lilbccodec \
    -lgsmcodec \
    -lspeex \
    -lresample \
    -lsrtp \
    -lpjlib-util \
    -lg7221codec
INCLUDEPATH += /usr/local/include
INCLUDEPATH += /opt/pjsip/include
