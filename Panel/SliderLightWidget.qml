import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15 as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend


Item {
    property alias mHeader: txtHeader.text
    property alias mSubHeader: txtSubHeader.text
    property alias mWidth : root.width
    property alias mHeight : root.height
    property int mValue : 0
    property string mLink: ""
    property bool isDimable: true
    property int size : root.height - 32
    signal mPercentChanged(int percent);
    signal mReleased(int percent);
    id: root

    property int mBoxMargin : 16
    property int mBoxWidth : 96
    property int mBoxHeight: 96
    property int mIconWidth : 96
    property int mIconHeight: 96
    property int mIconMaxSize: 96

    onMWidthChanged: {
        root.mBoxWidth = (root.mWidth * 2 / 3) ;
        root.mBoxHeight = root.mBoxWidth / 3;
        root.mIconWidth = Math.min( root.mBoxWidth / 3 , Backend.getScreenWidth() / 16)
        root.mIconHeight =  Math.min( root.mBoxWidth / 3 , Backend.getScreenWidth() / 16)
    }

    Component.onCompleted: {

        txtPercent.text =  root.mValue.toFixed(0) + "%";
        let result = (baseShapePath.sweepAngle * root.mValue) / 100;
        let startAngle = 360 - baseShapePath.startAngle;
        let value = result ;
        console.log("result : " + result);
        value = value >= 0 ? value : value + 360;
        let totalAngle = Math.abs(baseShapePath.sweepAngle);
        console.log("result : " + result);
        if(value < 180){
            percentShapeArc1.useLargeArc = false;
            percentShapeArc2.useLargeArc = false;
        }
        else {
            percentShapeArc1.useLargeArc = true;
            percentShapeArc2.useLargeArc = true;
        }
        let precent = (value * 100) / totalAngle;
        precent = precent < 0 ? 0 : precent;
        precent = precent > 100 ? 100 : precent;
        txtPercent.text =  precent.toFixed(0) + "%";
        precentShape.sweepAngle = result;
    }

    onMValueChanged: {
        if(!root.isDimable && root.mValue >0) root.mValue =100;
        let result = (baseShapePath.sweepAngle * root.mValue) / 100;
        let startAngle = 360 - baseShapePath.startAngle;
        let value = Math.abs(result);;

        console.log("result : " + result);
        value = value >= 0 ? value : value + 360;
        let totalAngle = Math.abs(baseShapePath.sweepAngle);
        if(value < 180){
            percentShapeArc1.useLargeArc = false;
            percentShapeArc2.useLargeArc = false;
        }
        else {
            percentShapeArc1.useLargeArc = true;
            percentShapeArc2.useLargeArc = true;
        }
        let precent = (value * 100) / totalAngle;
        precent = precent < 0 ? 0 : precent;
        precent = precent > 100 ? 100 : precent;
        console.log("precent : " + precent);
        txtPercent.text =  precent.toFixed(0) + "%";
        precentShape.sweepAngle = result;
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(!root.isDimable){
                let totalAngle = Math.abs(baseShapePath.sweepAngle);
                let percent = Math.abs(precentShape.sweepAngle) > (.99 * totalAngle) ? 0 : 100;
                let value = totalAngle * percent / 100;
                if(value < 180){
                    percentShapeArc1.useLargeArc = false;
                    percentShapeArc2.useLargeArc = false;
                }
                else {
                    percentShapeArc1.useLargeArc = true;
                    percentShapeArc2.useLargeArc = true;
                }
                txtPercent.text =  percent.toFixed(0) + "%";
                let result =  (baseShapePath.sweepAngle * percent) / 100;
                precentShape.sweepAngle = result;
                root.mValue = percent;
                root.mReleased(percent);
                root.mPercentChanged(percent);
                return;
            }
        }
    }

    Rectangle {
        id: rectBackground
        anchors.fill: parent
        radius: 8
        color : "#01000000"
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
        x: 48
        y: 16
        width: root.size
        height: root.size
        antialiasing: true
        layer.enabled: true
        id: baseShape
        Sh.ShapePath {
            property int startAngle: 300
            property int sweepAngle: -180
            id: baseShapePath
            fillColor: Colors.gray6
            strokeColor: "transparent"
            strokeWidth: 0
            capStyle: Sh.ShapePath.RoundCap
            startX: root.getBaseArcEndX(baseShapePath.startAngle,
                                        0,
                                        root.size / 2 - root.size / 16, // size minus strok
                                        root.size / 2)
            startY: root.getBaseArcEndY(baseShapePath.startAngle,
                                        0,
                                        root.size / 2 - root.size / 16,
                                        root.size / 2)
            PathArc{
                x:root.getBaseArcEndX(baseShapePath.startAngle,
                                      baseShapePath.sweepAngle,
                                      root.size / 2 - root.size / 16, // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(baseShapePath.startAngle,
                                      baseShapePath.sweepAngle,
                                      root.size / 2 - root.size / 16, // size minus strok
                                      root.size / 2)
                radiusX: root.size / 2 - root.size / 16
                radiusY: root.size / 2 - root.size / 16
                direction: PathArc.Counterclockwise
                useLargeArc: true
            }
            PathArc{
                x:root.getBaseArcEndX(baseShapePath.startAngle,
                                      baseShapePath.sweepAngle,
                                      root.size / 2, // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(baseShapePath.startAngle,
                                      baseShapePath.sweepAngle,
                                      root.size / 2, // size minus strok
                                      root.size / 2)
                radiusX: root.size / 16 / 2
                radiusY: root.size / 16 / 2
                direction: PathArc.Clockwise
                useLargeArc: false
            }
            PathArc{
                x:root.getBaseArcEndX(baseShapePath.startAngle,
                                      0,
                                      root.size / 2 , // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(baseShapePath.startAngle,
                                      0,
                                      root.size / 2 , // size minus strok
                                      root.size / 2)
                radiusX: root.size / 2
                radiusY: root.size / 2
                direction: PathArc.Clockwise
                useLargeArc: true
            }
            PathArc{
                x:root.getBaseArcEndX(baseShapePath.startAngle,
                                      0,
                                      root.size / 2 - root.size / 16, // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(baseShapePath.startAngle,
                                      0,
                                      root.size / 2 - root.size / 16,
                                      root.size / 2)
                radiusX: root.size / 16 / 2
                radiusY: root.size / 16 / 2
                direction: PathArc.Clockwise
                useLargeArc: false
            }

        }

    }

    Sh.Shape {
        x: 48
        y: 16
        width: root.size
        height: root.size
        antialiasing: true
        layer.enabled: true
        id: percentShape
        Sh.ShapePath {
            property int startAngle: 300
            property int sweepAngle: -180
            id: precentShape
            fillColor: "#ffffff"
            fillGradient:  Sh.ConicalGradient {
                angle: (360 - precentShape.startAngle) - ((360 + precentShape.sweepAngle) / 2)
                centerX: root.size / 2; centerY: root.size /2
                GradientStop { position: 0.0; color: Backend.colorTransparency(Colors.orange , 1) }
                GradientStop { position: 1.0; color: Backend.colorTransparency(Colors.red , 1) }

            }
            strokeColor: "transparent"
            strokeWidth: 0
            capStyle: Sh.ShapePath.RoundCap
            startX: root.getBaseArcEndX(precentShape.startAngle,
                                        0,
                                        root.size / 2 - root.size / 16, // size minus strok
                                        root.size / 2)
            startY: root.getBaseArcEndY(precentShape.startAngle,
                                        0,
                                        root.size / 2 - root.size / 16,
                                        root.size / 2)
            PathArc{
                id: percentShapeArc1
                x:root.getBaseArcEndX(precentShape.startAngle,
                                      precentShape.sweepAngle,
                                      root.size / 2 - root.size / 16, // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(precentShape.startAngle,
                                      precentShape.sweepAngle,
                                      root.size / 2 - root.size / 16, // size minus strok
                                      root.size / 2)
                radiusX: root.size / 2 - root.size / 16
                radiusY: root.size / 2 - root.size / 16
                direction: PathArc.Counterclockwise
                useLargeArc: true
            }
            PathArc{
                x:root.getBaseArcEndX(precentShape.startAngle,
                                      precentShape.sweepAngle,
                                      root.size / 2, // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(precentShape.startAngle,
                                      precentShape.sweepAngle,
                                      root.size / 2, // size minus strok
                                      root.size / 2)
                radiusX: root.size / 16 / 2
                radiusY: root.size / 16 / 2
                direction: PathArc.Clockwise
                useLargeArc: false
            }
            PathArc{
                id: percentShapeArc2
                x:root.getBaseArcEndX(precentShape.startAngle,
                                      0,
                                      root.size / 2 , // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(precentShape.startAngle,
                                      0,
                                      root.size / 2 , // size minus strok
                                      root.size / 2)
                radiusX: root.size / 2
                radiusY: root.size / 2
                direction: PathArc.Clockwise
                useLargeArc: true
            }
            PathArc{
                x:root.getBaseArcEndX(precentShape.startAngle,
                                      0,
                                      root.size / 2 - root.size / 16, // size minus strok
                                      root.size / 2)
                y:root.getBaseArcEndY(precentShape.startAngle,
                                      0,
                                      root.size / 2 - root.size / 16,
                                      root.size / 2)
                radiusX: root.size / 16 / 2
                radiusY: root.size / 16 / 2
                direction: PathArc.Clockwise
                useLargeArc: false
            }
        }

        MouseArea{
            id: percentMouseArea
            anchors.fill: parent
            property bool pressActive: false;
            onPressed: {
                if(!root.isDimable) return;
                percentMouseArea.pressActive = true;
            }
            onReleased: {
                if(!root.isDimable) return;
                percentMouseArea.pressActive = false;
                let result = (precentShape.sweepAngle * 100.0) / baseShapePath.sweepAngle;
                let precent = result.toFixed(0);
                precent = precent < 0 ? 0 : precent;
                precent = precent > 100 ? 100 : precent;
                root.mReleased(precent);
            }
            onPositionChanged: {
                if(!root.isDimable) return;
                if(!percentMouseArea.pressActive) return;
                let x = mouse.x - root.size / 2;
                let y = -(mouse.y - root.size / 2);
                console.log("X is :"+x);
                console.log("Y is :"+y);
                let teta =root.radians_to_degrees(Math.atan2(y,x));
                console.log("Teta is :"+teta);
                let startAngle = 360 - baseShapePath.startAngle;
                let value = teta - startAngle;
                console.log("Value is :"+value);
                value = value >= 0 ? value : value + 360;
                let totalAngle = Math.abs(baseShapePath.sweepAngle);
                if(value < 180){
                    percentShapeArc1.useLargeArc = false;
                    percentShapeArc2.useLargeArc = false;
                }
                else {
                    percentShapeArc1.useLargeArc = true;
                    percentShapeArc2.useLargeArc = true;
                }

                let precent = (value * 100) / totalAngle;
                precent = precent < 0 ? 0 : precent;
                precent = precent > 100 ? 100 : precent;
                console.log( "Percent => " +precent + "%");
                txtPercent.text =  precent.toFixed(0) + "%";
                let result = (baseShapePath.sweepAngle * precent) / 100;
                precentShape.sweepAngle = result;
                root.mValue = precent;
                root.mPercentChanged(precent);
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
                x1:root.mWidth / 2- 48
                y1:0
                x2:root.mWidth / 2 - root.mBoxWidth / 3- 48
                y2:root.mHeight
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.1; color: "transparent" }
                GradientStop { position: 0.5; color: Colors.white }
                GradientStop { position: 0.9; color: "transparent" }
                GradientStop { position: 1.0; color: "transparent" }

            }
            strokeColor: "transparent"
            strokeWidth: 2
            capStyle: Sh.ShapePath.RoundCap
            startX: root.mWidth / 2 - 1 - 48
            startY: 0
            PathLine{
                x: root.mWidth / 2 + 1- 48
                y: 0
            }
            PathLine{
                x: root.mWidth / 2 + 1 - root.mBoxWidth / 3- 48
                y: root.mHeight
            }
            PathLine{
                x: root.mWidth / 2 - 1 - root.mBoxWidth / 3- 48
                y: root.mHeight
            }
//            startX: 48 * 2 + root.size - 1
//            startY: 0 + 16
//            PathLine{
//                x: 48 * 2 + root.size  + 1
//                y: 0 + 16
//            }
//            PathLine{
//                x: 48 + (root.size / 4)  + 1
//                y: root.height - 16
//            }
//            PathLine{
//                x: 48  + (root.size / 4)  - 1
//                y: root.height - 16
//            }
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
        anchors.left: txtHeader.left
        anchors.leftMargin: 0
        anchors.top: txtHeader.bottom
        anchors.topMargin: 16
        wrapMode:Text.NoWrap
        height: 32
        clip: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
    }

    Text {
        id: txtHeader
        text: ""
        color: Colors.white1
        x: 48 * 2 + root.size + 16
        anchors.top: parent.top
        anchors.topMargin: 16 + 16
        height: 64
        width: root.mWidth - (48 * 2 + root.size + 16)
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 36
        font.styleName: "Light"
        font.weight: Font.DemiBold
    }
    Text {
        id: txtPercent
        text: ""
        color: Colors.white1
        x: 48 - 16
        y: 16 - 16
        width: root.size
        height: root.size
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "Far.Nazanin"
        font.pixelSize: 32
        font.styleName: "Light"
        font.weight: Font.DemiBold
    }

//    MouseArea {
//        anchors.fill: parent
//        onClicked: {
//            root.mClicked();
//        }
//    }

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
    function getBaseArcEndX(startAngle, sweepAngle,radius ,center ){
        let angle =degrees_to_radians(   360 - startAngle - sweepAngle);
        let x = (center ) + (Math.cos(angle) * radius);// This is available in all editors.
        return x;
    }

    function getBaseArcEndY(startAngle, sweepAngle,radius ,center){
        let angle =degrees_to_radians(  360 - startAngle - sweepAngle);
        let y = (center ) - ( Math.sin(angle) * radius);
        return y;
    }

    function degrees_to_radians(degrees)
    {
        var pi = Math.PI;
        return degrees * (pi/180);
    }

    function radians_to_degrees(radians)
    {
        var pi = Math.PI;
        return (radians * 180) / pi;
    }

    function getPercent(){
        console.log(Number.toString((precentArc.sweepAngle * 100 / baseArc.sweepAngle )) + "%");
        return Number.toString((precentArc.sweepAngle * 100 / baseArc.sweepAngle )) + "%"
    }
}
