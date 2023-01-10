import QtQuick 2.15
import 'Backend.js' as Backend
import com.nourbakhsh.Logger 1.0
Item {
    id:root

    property int _singleWidthMargin: 16
    property int _singleHeightMargin: 16
    signal toggleLightChanged(int id , bool val);
    signal occupationChanged(int val);
    signal sliderLightChanged(int id, int val);
    property bool disableClick: false


    Logger{
        id:logger
    }

    ToggleLightWidget{
        id: toggleLight1
        x: Backend.getGridItemX(root.width,root.height,3,6,1,2,2,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,1,2,2,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,1,2) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,1,2) - root._singleHeightMargin * 2
        mHeader: "Light"
        mSubHeader: "Operating 1"
        mIsActive: false
        mIconOff: Icons.lighting_off
        mIconOn: Icons.lighting_on
        onMClicked: {
            if(root.disableClick) return;
            mIsActive = !mIsActive;
            logger.log(mHeader+"[" + mSubHeader +"]" + " turned " + (mIsActive?"ON.":"OFF."))
            root.toggleLightChanged(1,mIsActive);
        }
    }

    ToggleLightWidget{
        id: toggleLight2
        x: Backend.getGridItemX(root.width,root.height,3,6,1,2,2,3) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,1,2,2,3) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,1,2) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,1,2) - root._singleHeightMargin * 2
        mHeader: "Light"
        mSubHeader: "Operating 2"
        mIsActive: false
        mIconOff: Icons.lighting_off
        mIconOn: Icons.lighting_on
        onMClicked: {
            if(root.disableClick) return;
            mIsActive = !mIsActive;
            logger.log(mHeader+"[" + mSubHeader +"]" + " turned " + (mIsActive?"ON.":"OFF."))
            root.toggleLightChanged(2,mIsActive);
        }
    }

    ToggleLightWidget{
        id: toggleLight3
        x: Backend.getGridItemX(root.width,root.height,3,6,1,2,3,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,1,2,3,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,1,2) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,1,2) - root._singleHeightMargin * 2
        mHeader: "Light"
        mSubHeader: "Negatoscope"
        mIsActive: false
        mIconOff: Icons.negatoscope_off
        mIconOn: Icons.negatoscope_on
        onMClicked: {
            if(root.disableClick) return;
            mIsActive = !mIsActive;
            logger.log(mHeader+"[" + mSubHeader +"]" + " turned " + (mIsActive?"ON.":"OFF."))
            root.toggleLightChanged(3,mIsActive);
        }
    }

    ToggleLightWidget{
        id: toggleLight4
        x: Backend.getGridItemX(root.width,root.height,3,6,1,2,3,3) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,1,2,3,3) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,1,2) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,1,2) - root._singleHeightMargin * 2
        mHeader: "UV"
        mSubHeader: "Lamp"
        mIsActive: false
        mIconOff: Icons.uv_off
        mIconOn: Icons.uv_on
        onMClicked: {
            if(root.disableClick) return;
            mIsActive = !mIsActive;
            logger.log(mHeader+"[" + mSubHeader +"]" + " turned " + (mIsActive?"ON.":"OFF."))
            //root.toggleLightChanged(4,mIsActive);
        }
    }

    OccupationLightWidget{
        id: occupy1
        x: Backend.getGridItemX(root.width,root.height,3,6,2,2,2,5) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,2,2,2,5) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,2,2) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,2,2) - root._singleHeightMargin * 2
        mHeader: "Occupation"
        mSubHeader: "Ready"
        mState: 1
        mIcon: {
            if(mState == 1)
                return Icons.occupation_ready;
            else if(mState == 2)
                return Icons.occupation_clean;
            else if(mState == 3)
                return Icons.occupation_busy;
        }
        onMClicked: {
            if(root.disableClick) return;
            mState = (mState % 3 ) + 1
            if(mState == 1)
                mSubHeader = "Ready";
            else if(mState == 2)
                mSubHeader = "Cleaning";
            else
                mSubHeader = "Occupy";
            root.occupationChanged(mState);
            logger.log(mHeader + " changed to " + mSubHeader)
        }
    }

    SliderLightWidget{
        id: sldLight1
        x: Backend.getGridItemX(root.width,root.height,3,6,1,3,1,1) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,1,3,1,1) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,1,3) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,1,3) - root._singleHeightMargin * 2
        mHeader: "Prismatic"
        mSubHeader: "Rect Light 1"
        isDimable: false
        onMPercentChanged: {
            //mIsActive = !mIsActive;
        }
        onMReleased: {
            if(root.disableClick) return;
            logger.log(mHeader+"[" + mSubHeader +"]" + " changed to " + mValue + "% .");
            root.sliderLightChanged(1,mValue);
        }
    }

    SliderLightWidget{
        id: sldLight2
        x: Backend.getGridItemX(root.width,root.height,3,6,1,3,1,4) + root._singleWidthMargin
        y: Backend.getGridItemY(root.width,root.height,3,6,1,3,1,4) + root._singleHeightMargin
        mWidth: Backend.getGridItemWidth(root.width,root.height,3,6,1,3) - root._singleWidthMargin * 2
        mHeight: Backend.getGridItemHeight(root.width,root.height,3,6,1,3) - root._singleHeightMargin * 2
        mHeader: "Prismatic"
        mSubHeader: "Rect Light 2"
        isDimable: false
        onMPercentChanged: {
            //mIsActive = !mIsActive;
        }
        onMReleased: {
            if(root.disableClick) return;
            logger.log(mHeader+"[" + mSubHeader +"]" + " changed to " + mValue + "% .");
            root.sliderLightChanged(2,mValue);
        }
    }

    function setToggleLights(id : int, val : bool){

        if(id == 0){
            toggleLight1.mIsActive = val;
        }
        if(id == 1){
            toggleLight2.mIsActive = val;
        }
        if(id == 2){
            toggleLight3.mIsActive = val;
        }
        if(id == 3){
           // toggleLight4.mIsActive = val;
        }

    }

    function setOccupy(val:int)
    {
        occupy1.mState = val;
    }

    function setSliderLight(id: int, val: int){
         console.log("setSliderLight");
         console.log(id);
         console.log(val);
        if(id == 1){
            sldLight1.mValue = val;
        }else if(id == 2){
            sldLight2.mValue = val;
        }
    }
}
