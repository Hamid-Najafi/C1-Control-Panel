import QtQuick 2.15
import com.nourbakhsh.MusicController 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15 as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend
import com.nourbakhsh.Logger 1.0

Item {
    id: root

    Logger{
        id: logger
    }

    Rectangle{
        id: rectFilesListBackground

        property int headerHeigth: 100
        anchors.fill: parent
        //opacity: .7
        color: Backend.colorTransparency(Colors.menuBackgroundColor , .6);//  "transparent"

        Sh.Shape {
            anchors.fill: parent
            antialiasing: true
            layer.enabled: true
            id: lineShape
            Sh.ShapePath {
                id: lineShapePath
                fillColor: Colors.gray6
                fillGradient:  Sh.LinearGradient {
                    x1:0
                    y1:rectFilesListBackground.headerHeigth
                    x2:rectFilesListBackground.width
                    y2:rectFilesListBackground.headerHeigth
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Colors.white }
                    GradientStop { position: 1.0; color: "transparent" }

                }
                strokeColor: "transparent"
                strokeWidth: 2
                capStyle: Sh.ShapePath.RoundCap
                startX: 16
                startY: 16 + rectFilesListBackground.headerHeigth - 1
                PathLine{
                    x: 16
                    y: 16 + rectFilesListBackground.headerHeigth + 1
                }
                PathLine{
                    x: rectFilesListBackground.width - 16
                    y: 16 + rectFilesListBackground.headerHeigth + 1
                }
                PathLine{
                    x: rectFilesListBackground.width - 16
                    y: 16 + rectFilesListBackground.headerHeigth - 1
                }
            }

        }
        Text {
            id: txtHeader
            text: "Logs"
            color: Colors.white1
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: parent.top
            anchors.topMargin: 8
            height: rectFilesListBackground.headerHeigth
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: "Exo"
            font.pixelSize: 36
            font.styleName: "Light"
            font.weight: Font.DemiBold
            fontSizeMode: Text.Fit
        }
        Flickable{
            anchors.top: txtHeader.bottom
            anchors.topMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            clip: true

        }

        Rectangle {
            anchors.top: txtHeader.bottom
            anchors.topMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            color: "transparent"
            ScrollView {
                id: view
                anchors.fill: parent
                clip: true

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                Text {
                    id: txtlog
                    color: Colors.white1
                    text: logger.readLog()

                    anchors.fill: parent
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    font.family: "Exo"
                    font.pixelSize: 14
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                }
            }
        }


    }

    function updateLog(){
        txtlog.text = logger.readLog();
    }

}
