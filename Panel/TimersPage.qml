import QtQuick 2.0
import com.nourbakhsh.TimerController 1.0
import 'Backend.js' as Backend

Item {
    id: root
    property int _singleWidthMargin: 16
    property int _singleHeightMargin: 16

    TimerController{
        id: anesthesiaTimer
    }

    TimerController{
        id: surgeryTimer
    }

    TimerController{
        id: surgeryTimer1
    }

    TimerWidget{
        x: Backend.getGridItemX(root.width,root.height,3,1,1,1,1,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,1,1,1,1,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,1,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,1,1,1) - root._singleHeightMargin * 2
        mHeader: "Anesthesia"
        mTime: anesthesiaTimer.timer
        onMStartClicked:{
            anesthesiaTimer.start()
        }
        onMStopClicked: {
            anesthesiaTimer.stop()
        }
    }
    TimerWidget{
        x: Backend.getGridItemX(root.width,root.height,3,1,1,1,2,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,1,1,1,2,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,1,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,1,1,1) - root._singleHeightMargin * 2
        mHeader: "Surgery"
        mTime: surgeryTimer.timer
        onMStartClicked:{
            surgeryTimer.start()
        }
        onMStopClicked: {
            surgeryTimer.stop()
        }
    }
    TimerWidget{
        x: Backend.getGridItemX(root.width,root.height,3,1,1,1,3,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,1,1,1,3,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,1,1,1) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,1,1,1) - root._singleHeightMargin * 2
        mHeader: "Surgery"
        mTime: surgeryTimer1.timer
        onMStartClicked:{
            surgeryTimer1.start()
        }
        onMStopClicked: {
            surgeryTimer1.stop()
        }
    }

    function setAnesthesiaTimer(state)
    {
        switch(state)
        {
            case 0:
                anesthesiaTimer.start();
                break;
            case 1:
                break;
            case 2:
                anesthesiaTimer.stop();
                break;
        }
    }

    function setSurgeryTimer(state)
    {

    }

    function setSurgeryTimer1(state)
    {

    }
}
