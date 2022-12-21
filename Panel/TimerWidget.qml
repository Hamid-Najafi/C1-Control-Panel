import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15  as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend

Item {
    property alias mHeader: txtHeader.text
    property alias mTime: txtSubHeader.text
    property alias mWidth : root.width
    property alias mHeight : root.height
    signal mStartClicked();
    signal mStopClicked();
    id: root

    state: "stop"

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



    //    DropShadow {
    //        id: rectShadow
    //        anchors.fill: rectBackground
    //        horizontalOffset: 16
    //        verticalOffset: 16
    //        radius: 8.0
    //        color: Colors.elementColor
    //    }


    //    Image {
    //        id: imgIcon
    //        source: "file:///" + mIcon
    //        anchors.right: parent.right
    //        anchors.top: parent.top
    //        anchors.bottom: parent.bottom
    //        anchors.rightMargin: 8
    //        anchors.topMargin: 8
    //        anchors.bottomMargin: 8
    //        verticalAlignment: Image.AlignBottom
    //        horizontalAlignment: Image.AlignRight
    //        width: root.mSize
    //        height: root.mSize
    //        fillMode: Image.PreserveAspectFit

    //    }



    Text {
        id: txtHeader
        text: ""
        color: Colors.white1
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 8
        height: root.height
        width: root.height - 32
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 36
        font.styleName: "Light"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        rotation: -45
    }

    Sh.Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true

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
                //root.mIsActive? Backend.colorTransparency(Colors.circleProgressGradiantBottom,.2) :

            }
            strokeColor: "transparent"
            strokeWidth: 2
            capStyle: Sh.ShapePath.RoundCap
            startX:  root.height + root.height / 2
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

        Sh.ShapePath {
            id: lineShapePath
            fillColor: Colors.gray6
            fillGradient:  Sh.LinearGradient {
                x1:root.height + root.height / 2
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
            startX:  root.height + root.height / 2 - 1 - 16
            startY: 0 + 16
            PathLine{
                x: root.height + root.height / 2 + 1 - 16
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

    Rectangle{
        color: Colors.gray1
        anchors.right: rectControles.left
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        height: parent.height
        x: root.height * 2
    }


    Text {
        id: txtSubHeader
        color: Colors.gray1
        anchors.right: rectControles.left
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        wrapMode:Text.NoWrap
        height: parent.height
        width: root.width - (2* root.height)
        clip: true
        text: "00 : 00 : 00"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 150
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
    }

    Rectangle{
        id:rectControles
        property int _singleWidthMargin: 16
        property int _singleHeightMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        width: 120
        color: "transparent"
        Rectangle{
            id: rectPlay
            x: Backend.getGridItemX(parent.width,parent.height,2,1,1,1,1,1) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height,2,1,1,1,1,1) + parent._singleHeightMargin
            width: Backend.getGridItemWidth(parent.width,parent.height,2,1,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height,2,1,1,1) - parent._singleHeightMargin * 2
            color: "transparent"


            Image {
                id: txtPlay
                anchors.fill: parent
                source: root.state == "play"  ? Icons.musicPause_on : Icons.musicPlay_on
                anchors.margins: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( root.mIconWidth, root.mIconHeight )
                Image {
                    id: img
                    source: parent.source
                    width: 0
                    height: 0
                }
            }



            ColorOverlay{
                id: cotxtPlay
                anchors.fill: txtPlay
                source: txtPlay
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent

                onClicked: {
                    if(root.state == "play")
                        root.state= "pause";
                    else
                        root.state = "play"
                    root.mStartClicked();
                }
            }
        }
        Rectangle{
            id: rectStop
            x: Backend.getGridItemX(parent.width,parent.height,2,1,1,1,2,1) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height,2,1,1,1,2,1) + parent._singleHeightMargin
            width: Backend.getGridItemWidth(parent.width,parent.height,2,1,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height,2,1,1,1) - parent._singleHeightMargin * 2
            color: "transparent"

            Image {
                id: txtStop
                source: Icons.musicStop_on
                anchors.fill: parent
                anchors.margins: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( root.mIconWidth, root.mIconHeight )
                Image {
                    id: imgtxtStop
                    source: parent.source
                    width: 0
                    height: 0
                }
            }



            ColorOverlay{
                id: cotxtStop
                anchors.fill: txtStop
                source: txtStop
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent

                onClicked: {
                    root.state = "stop"
                    root.mStopClicked();
                }
            }
        }
    }

    states: [
        State {
            name: "start"
        },
        State {
            name: "stop"
        },
        State {
            name: "pause"
        }
    ]
}
