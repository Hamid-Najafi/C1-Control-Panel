import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root
    property alias mWidth: root.width
    property alias mHeight: root.height
    property alias mColor: root.rectColor
    property bool seekEnabled: true
    property int mMin: 0
    property int mMax: 100
    property int mValue: 0
    property color rectColor: Qt.hsva(0,1,1,1)

    signal newValue(int value);

//    Rectangle{
//        anchors.fill: parent
//        color: "red"
//    }

    Rectangle{
        id: baseBox
        x: 52 /2
        y: (root.mHeight - height) / 2
        height: 8
        width: root.mWidth - 52;
        radius: 4
        color: Colors.gray5
    }

    Rectangle{
        id: rgbBox
        x: 52 /2
        y: (root.mHeight - height) / 2
        height: 8
        width: colorBox.x - x + 12
        radius: 4
    }

    LinearGradient{
        anchors.fill: rgbBox
        source: rgbBox
        start: Qt.point(0,rgbBox.height / 2)
        end: Qt.point(rgbBox.width,rgbBox.height / 2)
        gradient:  Gradient {
            GradientStop { id: color1; position: 0.0; color: Colors.orange }
            GradientStop { id: color7; position: 1.0; color: Colors.red }
        }
    }



    Rectangle{
        id:rectMouse
        anchors.fill: parent
        color:  "#01000000"
        MouseArea{
            id: rgbMouseArea
            anchors.fill: parent
            property bool isActive: false
            onMouseXChanged: function(mouse) {
                if(!root.seekEnabled) return;
                if(!rgbMouseArea.isActive) return;
                let x = mouse.x;
                let precent = x  / root.width;
                if(precent > 1) precent = 1;
                if(precent < 0) precent = 0;
                root.mValue = (precent * (root.mMax - root.mMin)) + root.mMin;

            }

            onPressed: function(mouse){
                if(!root.seekEnabled) return;
                rgbMouseArea.isActive = true;
                let x = mouse.x;
                let precent = x  / root.width;
                if(precent > 1) precent = 1;
                if(precent < 0) precent = 0;
                root.mValue = (precent * (root.mMax - root.mMin)) + root.mMin;
                colorBox.height = 48;
                colorBox.width = 48;
//                let min = 26 - (colorBox.width / 2);
//                let max = root.mWidth - 52;
//                let percent = (root.mValue - root.mMin) / (root.mMax - root.mMin);
//                let val = percent * (max - min) + min;
//                colorBox.x = 26 - (colorBox.width / 2) + val;
//                root.newValue(root.mValue);


            }
            onReleased: {
                if(!root.seekEnabled) return;
                rgbMouseArea.isActive = false;
                colorBox.height = 24;
                colorBox.width = 24;
            }
        }
    }

    Rectangle
    {
        id: colorBox
        x: 26 - (colorBox.width / 2)
        y: ((root.mHeight - rgbBox.height) / 2 - (colorBox.height / 2)) + (rgbBox.height /2)
        height: 24
        width: 24
        color: root.rectColor
        radius:  colorBox.height / 2
        border.color: Colors.white
        border.width: 2
        visible: root.seekEnabled
    }

   onMValueChanged: {
        let min = 26 - (colorBox.width / 2);
        let max = root.mWidth - 52;
        let percent = (root.mValue - root.mMin) / (root.mMax - root.mMin);
        let val = percent * (max - min) + min;
        colorBox.x = 26 - (colorBox.width / 2) + val;
       root.newValue(root.mValue);
    }

   onMWidthChanged: {
       let min = 26 - (colorBox.width / 2);
       let max = root.mWidth - 52;
       let percent = (root.mValue - root.mMin) / (root.mMax - root.mMin);
       let val = percent * (max - min) + min;
       colorBox.x = 26 - (colorBox.width / 2) + val;
       root.newValue(root.mValue);
   }

}
