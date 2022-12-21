import QtQuick 2.15
import QtQuick.Layouts 1.15
import 'Backend.js' as Backend

Item {
    id:root
    property int mValue: 0

    onMValueChanged: {
        setIndicator();
    }

    onWidthChanged: {
        setIndicator();
    }
    onHeightChanged: {
        setIndicator();
    }


    Rectangle{
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,2) - 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,2) - 2
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,6) + 4
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,6) + 4
        color: Colors.black
    }

    Rectangle{
        id: rectLine1
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,2)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,2)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }



    Text {
        id: txt1
        text: qsTr("0")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,1) + 2 + (Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,1)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rect1
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,2) + 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,2)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.airPollution1
    }
    Rectangle{
        id: rectLine2
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,3)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,3)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }
    Text {
        id: txt2
        text: qsTr("50")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,2) + 2 + (Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,2)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rect2
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,3) + 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,3)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.airPollution2
    }
    Rectangle{
        id: rectLine3
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,4)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,4)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }
    Text {
        id: txt3
        text: qsTr("100")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,3) + 2 + (Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,3)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rect3
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,4) + 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,4)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.airPollution3
    }
    Rectangle{
        id: rectLine4
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,5)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,5)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }
    Text {
        id: txt4
        text: qsTr("150")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,4) + 2 + (Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,4)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rect4
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,5) + 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,5)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.airPollution4
    }
    Rectangle{
        id: rectLine5
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,6)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,6)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }
    Text {
        id: txt5
        text: qsTr("200")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,5) + 2 + (Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,5)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rect5
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,6) + 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,6)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.airPollution5
    }
    Rectangle{
        id: rectLine6
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,7)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,7)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }
    Text {
        id: txt6
        text: qsTr("300")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,6) + 2 +(Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,6)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rect6
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,7) + 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,7)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.airPollution6
    }

    Rectangle{
        id: rectLine7
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,8)
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,8)
        width: 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        color: Colors.black
    }

    Text {
        id: txt7
        text: qsTr("500")
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,2,7) + 2 + (Backend.getGridItemWidth(width,height,2,8,1,1) - 2) / 2
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,2,7)
        width: Backend.getGridItemWidth(root.width,root.height,2,8,1,1) - 2
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1)
        font.family: "Far.Nazanin"
        font.pixelSize: 22
        font.styleName: "Semibold"
        font.weight: Font.DemiBold
        fontSizeMode: Text.Fit
        color: Colors.white
        horizontalAlignment: Text.AlignRight
    }
    Rectangle{
        id: rectIndicator
        x: Backend.getGridItemX(root.width,root.height,2,8,1,1,1,2) + 20
        y: Backend.getGridItemY(root.width,root.height,2,8,1,1,1,2)-4
        width: 4
        height: Backend.getGridItemHeight(root.width,root.height,2,8,1,1) +4
        color: Colors.white
    }


    function setIndicator(){
        let oneCol = Backend.getGridItemWidth(root.width,root.height,2,8,1,1);
        let total = oneCol * 6;
        let startX = oneCol;
        let x = Math.floor((total * root.mValue) / 500) + startX;
        rectIndicator.x = x;
    }


}
