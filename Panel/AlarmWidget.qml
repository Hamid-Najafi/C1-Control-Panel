import QtQuick 2.0
import 'Backend.js' as Backend
import QtGraphicalEffects 1.15

Item {
    id:root

    property string mIconOn: ""
    property string mIconOff: ""
    property alias mIcon: imgIcon.source
    property alias mText: txtHeader.text
    property alias mWidth: root.width
    property alias mHeight: root.height
    property bool mIsActive: false


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
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        height: root.height/ 2
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
        color: root.mIsActive ? Colors.red : Colors.gray5
    }

    Text {
        id: txtHeader
        text:""
        fontSizeMode: Text.Fit
        font.pointSize: 34
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        font.family: "Exo"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: imgIcon.bottom
        anchors.margins: 16
        height: root.height/ 4
        color: root.mIsActive ? Colors.red : Colors.gray5
    }


    states: [
        State {
            name: "deactivate"

        },
        State {
            name: "active"

        },
        State {
            name: "hovered"

        }
    ]

}

