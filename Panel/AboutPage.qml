import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15 as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend

Item {
    id: root
    property alias mWidth: root.width
    property alias mHeight: root.height
    property int itemSize: 256
    width: 1920
    height: 780
    signal resetClicked();

    Rectangle{
        id: glowRect
        anchors.centerIn: parent
        width: root.width * 3 / 4 - 4
        height: root.height * 3 / 4 - 4
        radius: 8
        border.color: Colors.white
        border.width: 2
        color: Colors.menuBackgroundColor
    }


    LinearGradient{
        anchors.fill: glowRect
        start: Qt.point(glowRect.width,glowRect.height)
        end: Qt.point(0,0)
        source: glowRect
        gradient: Gradient {
            GradientStop { position: 0.0; color: Backend.colorTransparency(Colors.menuBackgroundColor , .3) }
            GradientStop { position: 1.0; color: Backend.colorTransparency(Colors.menuBackgroundColor , .6)}
        }
    }
    Rectangle{
        id:rectBody
        anchors.centerIn: parent
        width: root.width * 3 / 4 - 4
        height: root.height * 3 / 4 - 4
        radius: 8
        border.color: Colors.white
        border.width: 2
        color: "transparent"
        Rectangle{
            id: rectPicture
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.top: parent.top
            anchors.topMargin: 32
            radius: root.height / 4 / 2
            width: 200
            height: 200
            border.color: Colors.white
            border.width: 2
            clip: true


            Image {
                id: imgPicture
                source: "qrc:/Images/c1tech-official-logo.png"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( 100, 100 )
                Image {
                    id: imgtxtStop
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
        }
        Rectangle{
            id: rectReset
            anchors.top: rectPicture.bottom
            anchors.topMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 32
            width: 200
            height: 48
            Text {
                id: txtVoiceError
                anchors.fill: parent
                text: "Reset"
                color : Colors.red
                font.family: "Cooper Hewitt"
                verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
                font.styleName: Font.Light
                fontSizeMode: Text.Fit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.resetClicked();
                }
            }
        }

        Rectangle{
            id:rectItems
            anchors.left: rectPicture.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 32
            color: "transparent"
            Text {
                id: txtHeader
                text: "ORCO-8 Operating Room Control Panel is a contemporary and reliable device designed for maintaining the most suitable working conditions required in the operation room and creating the most comfortable environment for the operation team.
All electrical controls can be performed manually, music broadcast, air conditioner assembly can be controlled through ORCO-8. Also, communication with high-quality audio provided by the digital audio processor is possible via the hands-free phone system.
Copyright 2018-2023 C1 tech group. All rights reserved.
designed by Reza Nourbakhsh
"
                color: Colors.white1
                anchors.fill: parent
                wrapMode: Text.Wrap
                lineHeight: 1.5
                horizontalAlignment: Text.AlignJustify
                verticalAlignment:Text.AlignTop
                font.family: "Exo"
                font.pixelSize: 26
                font.styleName: "Light"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
            }
        }
    }

}
