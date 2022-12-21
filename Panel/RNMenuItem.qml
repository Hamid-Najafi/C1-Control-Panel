import QtQuick 2.15
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend

Item {
    id:root

    property string mIconOn: ""
    property string mIconOff: ""
    property alias mIcon: imgIcon.source
    property alias mText: txtHeader.text
    property alias mWidth: root.width
    property alias mHeigth: root.height
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

    }

    Image {
        id: imgIcon
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.height/ 4
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        height: root.height/ 4
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size( root.height/ 4, root.height/ 4 )
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
        fontSizeMode: Text.Fit
        font.pointSize: 34
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        font.family: "Exo"
        font.weight: root.mIsActive ? Font.Bold : Font.Thin
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: imgIcon.bottom
        anchors.margins: 16
        height: imgIcon.height/ 2
        color: root.mIsActive ? Colors.orange : Colors.white
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

