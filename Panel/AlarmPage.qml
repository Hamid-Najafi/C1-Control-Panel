import QtQuick 2.0
import 'Backend.js' as Backend

Item {

    id: root
    property int _singleWidthMargin: 8
    property int _singleHeightMargin: 8


    AlarmWidget{
        id: aw0
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,1,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,1,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "VAC"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }
    AlarmWidget{
        id: aw1
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,1,2) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,1,2) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "AIR"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }
    AlarmWidget{
        id: aw2
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,1,3) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,1,3) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "O2"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }
    AlarmWidget{
        id: aw3
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,2,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,2,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "CO2"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }
    AlarmWidget{
        id: aw4
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,2,2) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,2,2) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "N2O"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }
    AlarmWidget{
        id: aw5
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,2,3) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,2,3) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "LIM"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }

    AlarmWidget{
        id: aw6
        x: Backend.getGridItemX(root.width,root.height,3,3,1,1,3,2) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,3,1,1,3,2) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,3,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,3,1,1) - root._singleHeightMargin * 2
        mText: "LAF"
        mIsActive: false
        mIconOff: Icons.alarm_off
        mIconOn: Icons.alarm_on
    }

    function setActiveMode(id, val){
        switch(id){
        case 0:
            aw0.mIsActive = val;
            break;
        case 1:
            aw1.mIsActive = val;
            break;
        case 2:
            aw2.mIsActive = val;
            break;
        case 3:
            aw3.mIsActive = val;
            break;
        case 4:
            aw4.mIsActive = val;
            break;
        case 5:
            aw6.mIsActive = val;
            break;
        case 6:
            aw5.mIsActive = val;
            break;
        }
    }

}
