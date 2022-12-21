import QtQuick 2.15
import QtQuick.Layouts 1.15
import 'Backend.js' as Backend

Item {
    id:root
    width: Backend.getScreenWidth();
    height: Backend.getMenuHeight();

    property int mActiveMenu: 4
    property int menuCount: 6

    signal activePageChanged(int number);


    RNMenuItem{
        id: menuLogs
        mText: "Logs"
        mIconOff: Icons.log_off
        mIconOn: Icons.log_on
        mIsActive: false
        mWidth: Backend.getGridItemWidth(root.width,root.height,1,root.menuCount,1,1)
        mHeigth: parent.height
        x:Backend.getGridItemX(root.width,root.height,1,root.menuCount,1,1,1,1)
        onMClicked: {
            root.hideAll();
            console.log("sdfdfdfdf")
            mIsActive = true;
            root.activePageChanged(1);
        }
    }
    RNMenuItem{
        id: menuItercom
        mText: "Intercom"
        mIconOff: Icons.intercom_off
        mIconOn: Icons.intercom_on
        mIsActive: false
        mWidth: Backend.getGridItemWidth(root.width,root.height,1,root.menuCount,1,1)
        mHeigth: parent.height
        x:Backend.getGridItemX(root.width,root.height,1,root.menuCount,1,1,1,2)
        onMClicked: {
            root.hideAll();
            mIsActive = true;
            root.activePageChanged(2);
        }
    }
    RNMenuItem{
        id: menuMusic
        mText: "Music"
        mIconOff: Icons.music_off
        mIconOn: Icons.music_on
        mIsActive: false
        mWidth: Backend.getGridItemWidth(root.width,root.height,1,root.menuCount,1,1)
        mHeigth: parent.height
        x:Backend.getGridItemX(root.width,root.height,1,root.menuCount,1,1,1,3)
        onMClicked: {
            root.hideAll();
            mIsActive = true;
            root.activePageChanged(3);
        }
    }
    RNMenuItem{
        id: menuLight
        mText: "Lights"
        mIconOff: Icons.lighting_off
        mIconOn: Icons.lighting_on
        mIsActive: true
        mWidth: Backend.getGridItemWidth(root.width,root.height,1,root.menuCount,1,1)
        mHeigth: parent.height
        x:Backend.getGridItemX(root.width,root.height,1,root.menuCount,1,1,1,4)
        onMClicked: {
            root.hideAll();
            mIsActive = true;
            root.activePageChanged(4);
        }
    }
    RNMenuItem{
        id: menuTimer
        mText: "Timers"
        mIconOff: Icons.timers_off
        mIconOn: Icons.timers_on
        mIsActive: false
        mWidth: Backend.getGridItemWidth(root.width,root.height,1,root.menuCount,1,1)
        mHeigth: parent.height
        x:Backend.getGridItemX(root.width,root.height,1,root.menuCount,1,1,1,5)
        onMClicked: {
            root.hideAll();
            mIsActive = true;
            root.activePageChanged(5);
        }
    }
    RNMenuItem{
        id: menuAbout
        mText: "About"
        mIconOff: Icons.about_off
        mIconOn: Icons.about_on
        mIsActive: false
        mWidth: Backend.getGridItemWidth(root.width,root.height,1,root.menuCount,1,1)
        mHeigth: parent.height
        x:Backend.getGridItemX(root.width,root.height,1,root.menuCount,1,1,1,6)
        onMClicked: {
            root.hideAll();
            mIsActive = true;
            root.activePageChanged(6);
        }
    }

    function hideAll(){
        menuLogs.mIsActive = false;
        menuItercom.mIsActive = false;
        menuMusic.mIsActive = false;
        menuLight.mIsActive = false;
        menuTimer.mIsActive = false;
        menuAbout.mIsActive = false;
    }

    function setPage( id){
        hideAll();
        switch(id){
        case 1:
            menuLogs.mIsActive = true;
            break;
        case 2:
            menuItercom.mIsActive = true;
            break;
        case 3:
            menuMusic.mIsActive = true;
            break;
        case 4:
            menuLight.mIsActive = true;
            break;
        case 5:
            menuTimer.mIsActive = true;
            break;
        case 6:
            menuAbout.mIsActive = true;
            break;
        }
        root.activePageChanged(id);
    }

}
