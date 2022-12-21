import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15  as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend

Item {
    property alias mHeader: txtHeader.text
    property alias mSubHeader: txtSubHeader.text
    property alias mWidth : root.width
    property alias mHeight : root.height
    signal mClicked();
    id: root

    Component.onCompleted: {
    }


    Rectangle {
        id: rectBackground
        anchors.fill: parent
        radius: 8
        color : "#000000"
        opacity: 0

    }


    LinearGradient{
        id: grdrectBackground
        anchors.fill: rectBackground
        start: Qt.point(rectBackground.width,rectBackground.height)
        end: Qt.point(0,0)
        gradient: Gradient {
            GradientStop { position: 1.0; color:  "transparent" }
            GradientStop { position: 0.5; color:  Colors.menuBackgroundColor }
            GradientStop { position: 0.0; color:  Colors.menuBackgroundColor }
        }
    }

    Sh.Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 8

        Sh.ShapePath {
            id: baseShapePath
            fillColor: Colors.gray6
            fillGradient:  Sh.LinearGradient {
                x1:root.width / 2
                y1:root.height / 2
                x2:root.width
                y2:root.height
                GradientStop { position: 0.0; color: Colors.menuBackgroundColor }
                GradientStop { position: 0.4; color: Colors.menuBackgroundColor }
                GradientStop { position: 1.0; color: "transparent" }

            }
            strokeColor: "transparent"
            strokeWidth: 2
            capStyle: Sh.ShapePath.RoundCap
            startX: root.width - root.height / 2
            startY: 0
            PathLine{
                x: root.width
                y: 0
            }
            PathLine{
                x: root.width
                y: root.height
            }
            PathLine{
                x: root.height - root.height / 2
                y: root.height
            }
        }

    }

    Sh.Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 8

        Sh.ShapePath {
            id: lineShapePath
            fillColor: Colors.gray6
            fillGradient:  Sh.LinearGradient {
                x1:root.width - root.height / 2
                y1:0
                x2:root.height - root.height / 2
                y2:root.height
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: Colors.white }
                GradientStop { position: 1.0; color: "transparent" }

            }
            strokeColor: "transparent"
            strokeWidth: 2
            capStyle: Sh.ShapePath.RoundCap
            startX: root.width - root.height / 2 - 16 - 1
            startY: 0 + 16
            PathLine{
                x: root.width - root.height / 2 - 16 + 1
                y: 0 + 16
            }
            PathLine{
                x: root.height - root.height / 2 + 16 + 1
                y: root.height - 16
            }
            PathLine{
                x: root.height - root.height / 2 + 16 - 1
                y: root.height - 16
            }
        }

    }

    Text {
        id: txtSubHeader
        color: Colors.gray1
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        wrapMode:Text.NoWrap
        height: 32
        width: parent.width / 2
        clip: true
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignBottom
        font.family: "Exo"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
    }

    Text {
        id: txtHeader
        text: ""
        color: Colors.white1
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 8
        height: root.height
        width: parent.width / 2
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        font.family: "Exo"
        font.pixelSize: 36
        font.styleName: "Light"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.mClicked();
        }
    }

    states: [
        State {
            name: "deactivate"
//            PropertyChanges {
//                target: rectGlow
//                visible: false
//            }
//            PropertyChanges{
//                target: grdRectGlow
//                visible: false
//            }
//            PropertyChanges {
//                target: rectHighlightCircle
//                opacity: 0
//            }
        },
        State {
            name: "active"
//            PropertyChanges {
//                target: rectGlow
//                visible: true
//            }
//            PropertyChanges{
//                target: grdRectGlow
//                visible: true
//            }
//            PropertyChanges {
//                target: rectHighlightCircle
//                opacity: .2
//            }
        },
        State {
            name: "hovered"
//            PropertyChanges {
//                target: rectGlow
//                visible: true
//            }
//            PropertyChanges{
//                target: grdRectGlow
//                visible: true
//            }
//            PropertyChanges {
//                target: rectHighlightCircle
//                opacity: .2
//            }
        }
    ]
}
