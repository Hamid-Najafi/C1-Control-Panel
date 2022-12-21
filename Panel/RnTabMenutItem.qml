import QtQuick 2.15
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend

Item {
    id:root

    property string mIconOn: ""
    property string mIconOff: ""
    property alias mIcon: imgIcon.source
    property alias mText: txtHeader.text
    property bool mIsActive: false
    signal mClicked();

    Component.onCompleted: {
        if(root.mIsActive){
            root.mIcon = root.mIconOn;
            root.state = "active"
        }else{
            root.mIcon = root.mIconOff;
            root.state = "deactivate"
        }
    }

    onMIsActiveChanged: {
        if(root.mIsActive){
            root.mIcon = root.mIconOn;
            root.state = "active"
        }else{
            root.mIcon = root.mIconOff;
            root.state = "deactivate"
        }
    }

    Image {
        id: imgIcon
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: (parent.height / 4)
        anchors.bottomMargin: (parent.height / 4)
        anchors.left: parent.left
        width: parent.width / 2 - 32
        horizontalAlignment: Image.AlignRight
        verticalAlignment: Image.AlignVCenter
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size( root.height/ 2, root.height/ 2 )
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
        color: root.mIsActive ? Colors.orange : Colors.white
    }

    Glow{
        id: glImgIcon
        anchors.fill: coImgIcon
        radius: 16
        //samples: 17
        color: Backend.colorTransparency(Colors.orange , .3)
        opacity: 1
        visible: root.mIsActive
        source: coImgIcon
    }


    Text {
        id: txtHeader
        text:""
        anchors.bottomMargin: 8
        fontSizeMode: Text.Fit
        font.pointSize: 28
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: "Exo"
        font.weight: root.mIsActive ? Font.Bold : Font.Thin
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: imgIcon.right
        anchors.leftMargin: 32
        anchors.top: parent.top
        color: root.mIsActive ? Colors.orange : Colors.white
    }
    Rectangle{
        id: rectUnderline
        color:root.mIsActive ? Colors.orange : "transparent"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 8
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {

            root.mClicked();
        }
        onEntered: {
            if(!root.mIsActive){
                root.state = "hovered"
            }
        }
        onExited: {
            if(root.mIsActive){
                root.state = "active"
            }else{
                root.state = "deactivate"
            }
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

