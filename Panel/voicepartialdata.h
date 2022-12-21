#ifndef VOICEPARTIALDATA_H
#define VOICEPARTIALDATA_H
#include <QString>

class VoicePartialData
{
public:
    VoicePartialData();

    float conf;
    float start;
    float end;
    QString word;

};

#endif // VOICEPARTIALDATA_H
