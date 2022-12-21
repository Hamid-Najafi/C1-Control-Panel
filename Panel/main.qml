import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: window
    visibility: "FullScreen"
    visible: true
    title: qsTr("Hello World")

    Rectangle{
        anchors.fill: parent
        color: Colors.backgroundColor
    }

    Dashboard{
        anchors.fill: parent
    }
}
