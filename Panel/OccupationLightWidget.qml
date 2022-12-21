import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15 as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend

Item {
    property alias mHeader: txtHeader.text
    property alias mSubHeader: txtSubHeader.text
    property alias mIcon : imgIcon.source
    property alias mWidth : root.width
    property alias mHeight : root.height
    property int mState: 1
    property string mLink
    property int mSize : 96
    signal mClicked();
    id: root


    property int mIconWidth : 96
    property int mIconHeight: 96

    onMWidthChanged: {

        root.mIconWidth = Math.min( root.mWidth / 3 , Backend.getScreenWidth() / 16)
        root.mIconHeight =  Math.min( root.mWidth / 3 , Backend.getScreenWidth() / 16)
    }

    Component.onCompleted: {
//        if(root.mIsActive){
//            root.mIcon = root.mIconOn;
//            root.state = "active"
//        }else{
//            root.mIcon = root.mIconOff;
//            root.state = "deactivate"
//        }
    }

    onMStateChanged: {
//        if(root.mIsActive){
//            root.mIcon = root.mIconOn;
//            root.state = "active"
//        }else{
//            root.mIcon = root.mIconOff;
//            root.state = "deactivate"
//        }
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
        end: Qt.point(rectBackground.width,0)
        gradient: Gradient {
            GradientStop { position: 1.0; color: "transparent" /*(root.mState == 1 ? Colors.green : ((root.mState == 2 ? Colors.orange :  Colors.red)))*/ }
            GradientStop { position: 0.66; color:  Colors.menuBackgroundColor }
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

    Image {
        id: imgIcon
        x: (root.width - root.mIconWidth) / 2
        y: (root.height / 3  - root.mIconHeight) / 2
        width: root.mIconWidth
        height: root.mIconHeight
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
        id: coImgIcon
        anchors.fill: imgIcon
        source: imgIcon
        color: (root.mState == 1 ? Colors.green : ((root.mState == 2 ? Colors.orange :  Colors.red)))
    }

    Glow{
        id: glImgIcon
        anchors.fill: imgIcon
        radius: 48
        samples: 64
        color: (root.mState == 1 ? Colors.green : ((root.mState == 2 ? Colors.orange :  Colors.red)))
        opacity: 1
        source: imgIcon
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
            startX: 0
            startY: root.mHeight / 3
            PathLine{
                x: root.mWidth
                y: root.mHeight / 3
            }
            PathLine{
                x: root.mWidth
                y: root.mHeight
            }
            PathLine{
                x: 0
                y: root.mHeight
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
                x1:0
                y1:0
                x2:root.width
                y2:0
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: Colors.white }
                GradientStop { position: 1.0; color: "transparent" }

            }
            strokeColor: "transparent"
            strokeWidth: 2
            capStyle: Sh.ShapePath.RoundCap
            startX: 0 + 16
            startY: root.mHeight / 3 - 1
            PathLine{
                x: root.mWidth  - 16
                y: root.mHeight / 3 - 1
            }
            PathLine{
                x: root.mWidth  - 16
                y: root.mHeight / 3 + 1
            }
            PathLine{
                x: 0 + 16
                y: root.mHeight / 3 + 1
            }
        }

    }

    //    Sh.Shape {
    //        anchors.fill: parent
    //        antialiasing: true
    //        layer.enabled: true
    //        layer.samples: 8

    //        Sh.ShapePath {
    //            id: baseShapePath
    //            fillColor: Colors.gray6
    //            fillGradient:  Sh.LinearGradient {
    //                x1:root.height
    //                y1:root.height
    //                x2:0
    //                y2:0
    //                GradientStop { position: 0.0; color: Backend.colorTransparency( Colors.gray8 , .8) }
    //                GradientStop { position: 1.0; color: "transparent" }

    //            }
    //            strokeColor: "transparent"
    //            strokeWidth: 2
    //            capStyle: Sh.ShapePath.RoundCap
    //            startX: 0
    //            startY: 0
    //            PathLine{
    //                x: root.width - root.height / 2
    //                y: 0
    //            }
    //            PathLine{
    //                x: root.height - root.height / 2
    //                y: root.height
    //            }
    //            PathLine{
    //                x: 0
    //                y: root.height
    //            }
    //        }

    //    }


    Text {
        id: txtSubHeader
        color: Colors.gray1
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        wrapMode:Text.NoWrap
        height: 64
        clip: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 32
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
    }

    Text {
        id: txtHeader
        text: ""
        color: Colors.white1
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.bottom: txtSubHeader.top
        anchors.bottomMargin: 8
        height: 100
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 48
        font.styleName: "Light"
        font.weight: Font.DemiBold
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
