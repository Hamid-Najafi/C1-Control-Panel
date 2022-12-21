#ifndef VOICEDATA_H
#define VOICEDATA_H
#include <QString>
#include <QList>
#include <voicepartialdata.h>
class VoiceData
{
public:
    VoiceData();

    QString text;
    QList<VoicePartialData> result;
};

#endif // VOICEDATA_H
