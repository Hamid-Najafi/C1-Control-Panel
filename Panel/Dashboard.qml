import QtQuick 2.15
import QtQuick.Controls 2.15
import 'Backend.js' as Backend
import QtGraphicalEffects 1.15
import com.nourbakhsh.ModbusController 1.0
import com.nourbakhsh.TimeController 1.0
import com.nourbakhsh.VoiceController 1.0
import Qt.labs.settings 1.0

Item {
    id: root

    property var locale: Qt.locale()
    property date currentTime: new Date()
    property bool inSettings: false

    Settings{
        id: appSettings
        property alias sipServer: settings.sipServer
        property alias sipPort: settings.sipPort
        property alias sipProtocol: settings.sipProtocol
        property alias sipUsername: settings.sipUsername
        property alias sipPassword: settings.sipPassword
        property alias audioText: settings.audioText
        property alias isVoiceCommandActive: settings.isVoiceActive
        property alias voiceCommandLevel: settings.voiceCommandLevel
        Component.onCompleted: {
            pgIntercom.sipServer = sipServer;
            pgIntercom.sipPort = sipPort;
            pgIntercom.sipProtocol = sipProtocol;
            pgIntercom.sipUsername = sipUsername;
            pgIntercom.sipPassword = sipPassword;
            pgIntercom.connect();
        }
        onIsVoiceCommandActiveChanged: {
            voiceController.setActive(isVoiceCommandActive);
        }

        onVoiceCommandLevelChanged: {
            voiceController.setLevel(voiceCommandLevel);
        }
    }

    onWidthChanged: {
        Backend.setScreenWidth(root.width)
        console.log(Backend.screenWidth)
    }
    onHeightChanged: {
        Backend.setScreenHeigth(root.height)
        console.log(Backend.screenHeight)
    }

    VoiceController{
        id: voiceController
        onNewCommand:function(command) {
            console.log("command: " + command);
            switch (command)
            {
            case 0:
                //  both toggle off
                pgLight.setToggleLights(0,false);
                pgLight.setToggleLights(1,false);
                modbusController.setCoilWithId(0,false);
                modbusController.setCoilWithId(1,false);
                break;
            case 1:
                // toggle 1 off
                pgLight.setToggleLights(0,false);
                modbusController.setCoilWithId(0,false);
                break;
            case 2:
                // toggle 2 off
                pgLight.setToggleLights(1,false);
                modbusController.setCoilWithId(1,false);
                break;
            case 3:
                //  both toggle on
                pgLight.setToggleLights(0,true);
                pgLight.setToggleLights(1,true);
                modbusController.setCoilWithId(0,true);
                modbusController.setCoilWithId(1,true);
                break;
            case 4:
                //  toggle 1 on
                pgLight.setToggleLights(0,true);
                modbusController.setCoilWithId(0,true);
                break;
            case 5:
                //  toggle 2 on
                pgLight.setToggleLights(1,true);
                modbusController.setCoilWithId(1,true);
                break;
            case 6:
                // both prismatic lights off
                pgLight.setSliderLight(1,0);
                pgLight.setSliderLight(2,0);
                modbusController.setHoldingRegisterWithId(1,0);
                modbusController.setCoilWithId(6,false);
                modbusController.setHoldingRegisterWithId(2,0);
                modbusController.setCoilWithId(7,false);
                break;
            case 7:
                // prismatic light 1 off
                pgLight.setSliderLight(1,0);
                modbusController.setHoldingRegisterWithId(1,0);
                modbusController.setCoilWithId(6,false);
                break;
            case 8:
                // prismatic light 2 off
                pgLight.setSliderLight(2,0);
                modbusController.setHoldingRegisterWithId(2,0);
                modbusController.setCoilWithId(7,false);
                break;
            case 9:
                // both prismatic lights 10%
                pgLight.setSliderLight(1,10);
                pgLight.setSliderLight(2,10);
                modbusController.setHoldingRegisterWithId(1,10);
                modbusController.setCoilWithId(6,true);
                modbusController.setHoldingRegisterWithId(2,10);
                modbusController.setCoilWithId(6,true);
                break;
            case 10:
                // both prismatic lights 20%
                pgLight.setSliderLight(1,20);
                pgLight.setSliderLight(2,20);
                modbusController.setHoldingRegisterWithId(1,20);
                modbusController.setCoilWithId(6,true);
                modbusController.setHoldingRegisterWithId(2,20);
                modbusController.setCoilWithId(7,true);
                break;
            case 11:
                // both prismatic lights 30%
                pgLight.setSliderLight(1,30);
                pgLight.setSliderLight(2,30);
                modbusController.setHoldingRegisterWithId(1,30);
                modbusController.setCoilWithId(6,true);
                modbusController.setHoldingRegisterWithId(2,30);
                modbusController.setCoilWithId(7,true);
                break;
            case 12:
                // both prismatic lights 40%
                pgLight.setSliderLight(1,40);
                pgLight.setSliderLight(2,40);
                modbusController.setHoldingRegisterWithId(1,40);
                modbusController.setHoldingRegisterWithId(2,40);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 13:
                // both prismatic lights 50%
                pgLight.setSliderLight(1,50);
                pgLight.setSliderLight(2,50);
                modbusController.setHoldingRegisterWithId(1,50);
                modbusController.setHoldingRegisterWithId(2,50);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 14:
                // both prismatic lights 60%
                pgLight.setSliderLight(1,60);
                pgLight.setSliderLight(2,60);
                modbusController.setHoldingRegisterWithId(1,60);
                modbusController.setHoldingRegisterWithId(2,60);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 15:
                // both prismatic lights 70%
                pgLight.setSliderLight(1,70);
                pgLight.setSliderLight(2,70);
                modbusController.setHoldingRegisterWithId(1,70);
                modbusController.setHoldingRegisterWithId(2,70);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 16:
                // both prismatic lights 80%
                pgLight.setSliderLight(1,80);
                pgLight.setSliderLight(2,80);
                modbusController.setHoldingRegisterWithId(1,80);
                modbusController.setHoldingRegisterWithId(2,80);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 17:
                // both prismatic lights 90%
                pgLight.setSliderLight(1,90);
                pgLight.setSliderLight(2,90);
                modbusController.setHoldingRegisterWithId(1,90);
                modbusController.setHoldingRegisterWithId(2,90);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 18:
                // both prismatic lights 100%
                pgLight.setSliderLight(1,100);
                pgLight.setSliderLight(2,100);
                modbusController.setHoldingRegisterWithId(1,100);
                modbusController.setHoldingRegisterWithId(2,100);
                modbusController.setCoilWithId(6,true);
                modbusController.setCoilWithId(7,true);
                break;
            case 19:
                // prismatic light 1 10%
                pgLight.setSliderLight(1,10);
                modbusController.setHoldingRegisterWithId(1,10);
                modbusController.setCoilWithId(6,true);
                break;
            case 20:
                // prismatic light 1 20%
                pgLight.setSliderLight(1,20);
                modbusController.setHoldingRegisterWithId(1,20);
                modbusController.setCoilWithId(6,true);
                break;
            case 21:
                // prismatic light 1 30%
                pgLight.setSliderLight(1,30);
                modbusController.setHoldingRegisterWithId(1,30);
                modbusController.setCoilWithId(6,true);
                break;
            case 22:
                // prismatic light 1 40%
                pgLight.setSliderLight(1,40);
                modbusController.setHoldingRegisterWithId(1,40);
                modbusController.setCoilWithId(6,true);
                break;
            case 23:
                // prismatic light 1 50%
                pgLight.setSliderLight(1,50);
                modbusController.setHoldingRegisterWithId(1,50);
                modbusController.setCoilWithId(6,true);
                break;
            case 24:
                // prismatic light 1 60%
                pgLight.setSliderLight(1,60);
                modbusController.setHoldingRegisterWithId(1,60);
                modbusController.setCoilWithId(6,true);
                break;
            case 25:
                // prismatic light 1 70%
                pgLight.setSliderLight(1,70);
                modbusController.setHoldingRegisterWithId(1,70);
                modbusController.setCoilWithId(6,true);
                break;
            case 26:
                // prismatic light 1 80%
                pgLight.setSliderLight(1,80);
                modbusController.setHoldingRegisterWithId(1,80);
                modbusController.setCoilWithId(6,true);
                break;
            case 27:
                // prismatic light 1 90%
                pgLight.setSliderLight(1,90);
                modbusController.setHoldingRegisterWithId(1,90);
                modbusController.setCoilWithId(6,true);
                break;
            case 28:
                // prismatic light 1 100%
                pgLight.setSliderLight(1,100);
                modbusController.setHoldingRegisterWithId(1,100);
                modbusController.setCoilWithId(6,true);
                break;
            case 29:
                // prismatic light 1 10%
                pgLight.setSliderLight(2,10);
                modbusController.setHoldingRegisterWithId(2,10);
                modbusController.setCoilWithId(7,true);
                break;
            case 30:
                // prismatic light 1 20%
                pgLight.setSliderLight(2,20);
                modbusController.setHoldingRegisterWithId(2,20);
                modbusController.setCoilWithId(7,true);
                break;
            case 31:
                // prismatic light 1 30%
                pgLight.setSliderLight(2,30);
                modbusController.setHoldingRegisterWithId(2,30);
                modbusController.setCoilWithId(7,true);
                break;
            case 32:
                // prismatic light 1 40%
                pgLight.setSliderLight(2,40);
                modbusController.setHoldingRegisterWithId(2,40);
                modbusController.setCoilWithId(7,true);
                break;
            case 33:
                // prismatic light 1 50%
                pgLight.setSliderLight(2,50);
                modbusController.setHoldingRegisterWithId(2,50);
                modbusController.setCoilWithId(7,true);
                break;
            case 34:
                // prismatic light 1 60%
                pgLight.setSliderLight(2,60);
                modbusController.setHoldingRegisterWithId(2,60);
                modbusController.setCoilWithId(7,true);
                break;
            case 35:
                // prismatic light 1 70%
                pgLight.setSliderLight(2,70);
                modbusController.setHoldingRegisterWithId(2,70);
                modbusController.setCoilWithId(7,true);
                break;
            case 36:
                // prismatic light 1 80%
                pgLight.setSliderLight(2,80);
                modbusController.setHoldingRegisterWithId(2,80);
                modbusController.setCoilWithId(7,true);
                break;
            case 37:
                // prismatic light 1 90%
                pgLight.setSliderLight(2,90);
                modbusController.setHoldingRegisterWithId(2,90);
                modbusController.setCoilWithId(7,true);
                break;
            case 38:
                // prismatic light 1 100%
                pgLight.setSliderLight(2,100);
                modbusController.setHoldingRegisterWithId(2,100);
                modbusController.setCoilWithId(7,true);
                break;
            case 39:
                // UV light off
                pgLight.setToggleLights(3,false);
                //modbusController.setCoilWithId(3,false);
                break;
            case 40:
                // UV light on
                pgLight.setToggleLights(3,true);
                //modbusController.setCoilWithId(3,true);
                break;
            case 41:
                // Negatoscope off
                pgLight.setToggleLights(2,false);
                modbusController.setCoilWithId(2,false);
                break;
            case 42:
                // Negatoscope on
                pgLight.setToggleLights(2,true);
                modbusController.setCoilWithId(2,true);
                break;
            case 43:
                // Occupation: Ready
                pgLight.setOccupy(1);
                modbusController.setHoldingRegisterWithId(0,1);
                break;
            case 44:
                // Occupation: Cleaning
                pgLight.setOccupy(2);
                modbusController.setHoldingRegisterWithId(0,2);
                break;
            case 45:
                // Occupation: Occupied
                pgLight.setOccupy(3);
                modbusController.setHoldingRegisterWithId(0,0);
                break;
            case 46:
                // Music: Play
                pgMusic.setMusicState(0);
                break;
            case 47:
                // Music: Stop
                pgMusic.setMusicState(1);
                break;
            case 48:
                // Music: Next
                pgMusic.setMusicState(2);
                break;
            case 49:
                // Music: Previous
                pgMusic.setMusicState(3);
                break;
            case 50:
                // Music: Mute
                pgMusic.setMusicState(4);
                break;
            case 51:
                // Timer1: Start
                //pgMusic.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 52:
                // Timer1: Stop
                //pgMusic.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 53:
                // Timer1: Reset
                //pgTimer.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 54:
                // Timer2: Start
                //pgMusic.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 55:
                // Timer2: Stop
                //pgMusic.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 56:
                // Timer2: Reset
                //pgTimer.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 57:
                // Timer3: Start
                //pgMusic.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 58:
                // Timer3: Stop
                //pgMusic.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 59:
                // Timer3: Reset
                //pgTimer.??(0);
                //modbusController.setHoldingRegisterWithId(3,0);
                break;
            case 60:
                // Lighting Page
                mainMenu.setPage(4);

                break;
            case 61:
                // Timers Page
                mainMenu.setPage(5);
                break;
            case 62:
                // Music Page
                mainMenu.setPage(3);
                break;
            case 63:
                // Intercom Page
                mainMenu.setPage(2);
                break;
            case 64:
                // Logs Page
                mainMenu.setPage(1);
                break;
            case 65:
                // About Page
                mainMenu.setPage(6);
                break;
            }
        }
    }

    ModbusController{
        id: modbusController
        onConnectionMessageChanged: {
            txtModbusError.text = connectionMessage;
        }

        onCoilUpdated: function(id,val){
            pgLight.setToggleLights(id, val);
        }
        onHoldingRegisterUpdated: function(id,val){
            if(id == 0)
            {
                val = val >3 ? 3 : val;
                val = val <1 ? 1 : val;
                pgLight.setOccupy(val);
            }else if(id == 1){
                val = val >100 ? 100 : val;
                val = val <0 ? 0 : val;
                pgLight.setSliderLight(id , val);
            }
            else if(id == 2){
                val = val >100 ? 100 : val;
                val = val <0 ? 0 : val;
                pgLight.setSliderLight(id , val);
            }
        }
        onInputRegisterUpdated: function(id, val){
            if(id == 0){
                // temp
                let temp = val / 100 / 2;
                temp = temp.toFixed(0);
                txtTempratureValue.text = temp+"°";
            }
            if( id ==1){
                // hum

                let hum = val / 100;
                hum = hum.toFixed(0);
                txtHumidityValue.text = hum+"%";
            }
            if( id ==2){
                // air pollution

                let air = val / 100 * 5;
                air = air.toFixed(0);
                airPollution.mValue = air;
            }
        }

        onDiscreteInputUpdated: function(id,val){
            alarmsPage.setActiveMode(id,!val);
        }
    }

    TimeController{
        id: timeController
    }

    Rectangle{
        id: rectTopMenu
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: root.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.right: root.right
        height: Backend.getTopMenuHeight()
        color: Colors.black
        Text {
            id: txtModbusError
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            text: ""
            color : modbusController.isConnected ? Colors.white : Colors.red
            font.family: "Cooper Hewitt"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
            font.styleName: Font.Light
            fontSizeMode: Text.Fit
        }
        Text {
            id: txtVoiceError
            anchors.left: txtModbusError.right
            anchors.leftMargin: 32
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            text: ""
            color : voiceController.isConnected ? Colors.white : Colors.red
            font.family: "Cooper Hewitt"
            verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
            font.styleName: Font.Light
            fontSizeMode: Text.Fit
        }

        Image {
            id: imgSetting
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            anchors.bottom: parent.bottom
            source: "qrc:/Images/gear-solid.svg"
            width: Backend.getTopMenuHeight() - 16
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size( Backend.getTopMenuHeight()- 16, Backend.getTopMenuHeight() - 16)
            Image {
                id: imgSettingInner
                source: parent.source
                width: 0
                height: 0
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.inSettings = true;
                    rectPages.enabled = false;
                }
            }
        }



        ColorOverlay{
            id: coImgSetting
            anchors.fill: imgSetting
            source: imgSetting
            color: Colors.white
        }
    }

    Rectangle{
        id: rectPages
        anchors.left: root.left
        anchors.right: root.right
        anchors.top: rectTopMenu.bottom
        anchors.bottom: rectMenuBackground.top
        anchors.leftMargin: 32
        anchors.rightMargin: Backend.getSideMenuWidth()
        anchors.topMargin: 32
        anchors.bottomMargin: 32
        color: "transparent"

        LightingPage{
            id: pgLight
            anchors.fill: parent
            opacity: 1
            visible: true
            onToggleLightChanged: function(id,val){
                modbusController.setCoilWithId(id - 1,val);
            }
            onOccupationChanged: function(val){
                modbusController.setHoldingRegisterWithId(0,val);
                modbusController.setCoilWithId(3,val == 1);
                modbusController.setCoilWithId(4,val == 2);
                modbusController.setCoilWithId(5,val == 3);
            }
            onSliderLightChanged: function(id,val){
                if(id == 1)
                {
                    modbusController.setCoilWithId(6,val >10);
                }
                else if(id == 2)
                {
                    modbusController.setCoilWithId(7,val >10);
                }

                modbusController.setHoldingRegisterWithId(id,val);
            }
        }

        MusicPage{
            id: pgMusic
            anchors.fill: parent
            opacity: 0
            isOnCall: rectCallOverlay.visible
            visible: false
        }

        IntercomPage{
            id: pgIntercom
            anchors.fill: parent
            opacity: 0
            visible: false
            onMOnCall: {
                rectCallOverlay.visible = true;
                rectPages.enabled = false;
                voiceController.setOnCall(true);
                console.log("##################################");
            }
            onMCallEnded: {
                voiceController.setOnCall(false);
                rectCallOverlay.visible = false;
                rectPages.enabled = true;
                console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
            }
        }

        TimersPage{
            id: pgTimer
            anchors.fill: parent
            opacity: 0
            visible: false
        }

        AboutPage{
            id: pgAbout
            anchors.fill: parent
            opacity: 0
            visible: false
            onResetClicked: {
                timeController.resetDevice();
            }
        }
        LogPage{
            id: pgLogs
            anchors.fill: parent
            opacity: 0
            visible: false
        }
    }

    NumberAnimation{
        id: animPgLightHide
        target: pgLight
        properties: "opacity"
        onStopped: {
            target.visible = false;
        }

        to: 0
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgLightShow
        target: pgLight
        properties: "opacity"
        onStarted: {
            target.visible = true;
        }

        to: 1
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgMusicHide
        target: pgMusic
        properties: "opacity"
        onStopped: {
            target.visible = false;
        }
        to: 0
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgMusicShow
        target: pgMusic
        properties: "opacity"
        onStarted: {
            target.visible = true;
        }
        to: 1
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgLogsHide
        target: pgLogs
        properties: "opacity"
        onStopped: {
            target.visible = false;
        }
        to: 0
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgLogsShow
        target: pgLogs
        properties: "opacity"
        onStarted: {
            target.visible = true;
            pgLogs.updateLog()
        }
        to: 1
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgIntercomHide
        target: pgIntercom
        properties: "opacity"
        onStopped: {
            target.visible = false;
        }
        to: 0
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgIntercomShow
        target: pgIntercom
        properties: "opacity"
        onStarted: {
            target.visible = true;
        }
        to: 1
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgTimerHide
        target: pgTimer
        properties: "opacity"
        onStopped: {
            target.visible = false;
        }
        to: 0
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgTimerShow
        target: pgTimer
        properties: "opacity"
        onStarted: {
            target.visible = true;
        }
        to: 1
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgAboutHide
        target: pgAbout
        properties: "opacity"
        onStopped: {
            target.visible = false;
        }
        to: 0
        duration: 400
        running: false
        loops: 1
    }

    NumberAnimation{
        id: animPgAboutShow
        target: pgAbout
        properties: "opacity"
        onStarted: {
            target.visible = true;
        }
        to: 1
        duration: 400
        running: false
        loops: 1
    }


    Rectangle{
        id: rectMenuBackground
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        height: Backend.getMenuHeight()
        color: Backend.colorTransparency(Colors.menuBackgroundColor , .9)

        MainMenu{
            id: mainMenu
            property int lastPage: 4
            anchors.fill: parent

            onActivePageChanged: function(index) {
                if(lastPage == index)
                    return;
                // hide last
                if(lastPage == 1){
                    animPgLogsHide.start();
                }
                if(lastPage == 2){
                    animPgIntercomHide.start();
                }
                if(lastPage == 3){
                    animPgMusicHide.start();
                }
                if(lastPage == 4){
                    animPgLightHide.start();
                }
                if(lastPage == 5){
                    animPgTimerHide.start();
                }
                if(lastPage == 6){
                    animPgAboutHide.start();
                }

                // show current
                if(index == 1){
                    animPgLogsShow.start();
                }
                if(index == 2){
                    animPgIntercomShow.start();
                }
                if(index == 3){
                    animPgMusicShow.start();
                }
                if(index == 4){
                    animPgLightShow.start();
                }
                if(index == 5){
                    animPgTimerShow.start();
                }
                if(index == 6){
                    animPgAboutShow.start();
                }

                lastPage = index;
            }
        }
    }

    Rectangle{
        id: rectCallOverlay
        anchors.fill: parent
        visible: false
        color: Backend.colorTransparency(Colors.menuBackgroundColor,0.8)
        z: 100
        Text {
            id: txtCallerId
            color: Colors.white
            anchors.centerIn: parent
            wrapMode:Text.NoWrap
            text: pgIntercom.mState == 2?
                      "Call from " + pgIntercom.mCallerId:
                      "Calling " +  pgIntercom.mCallerId
            clip: true
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: "Far.Nazanin"
            font.pixelSize: 48
            font.styleName: "Semibold"
            font.weight: Font.DemiBold
        }

        Rectangle{
            anchors.top: txtCallerId.bottom
            anchors.topMargin: 32
            x: txtCallerId.x + txtCallerId.width / 2 - width - 16
            width: 100
            height: 100
            color: Colors.menuBackgroundColor
            radius: width / 2
            Image {
                id: imgIconAnswer
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: Icons.callAnswer
                sourceSize: Qt.size( 100, 100)
                Image {
                    id: imgAns
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgIconAnswer
                anchors.fill: imgIconAnswer
                source: imgIconAnswer
                color: pgIntercom.mState == 3 ||pgIntercom.mState == 5 || pgIntercom.mState == 1 ? Colors.gray4 : Colors.green
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pgIntercom.acceptCall()
                }
            }
        }

        Rectangle{
            anchors.top: txtCallerId.bottom
            anchors.topMargin: 32
            x: txtCallerId.x + txtCallerId.width / 2 + 16
            width: 100
            height: 100
            color: Colors.menuBackgroundColor
            radius: width / 2
            Image {
                id: imgIconHangup
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: Icons.callHangup
                sourceSize: Qt.size( 100, 100)
                Image {
                    id: imgHup
                    source: parent.source
                    width: 0
                    height: 0
                }
            }

            ColorOverlay{
                id: coimgIconHangup
                anchors.fill: imgIconHangup
                source: imgIconHangup
                color: Colors.red
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    pgIntercom.rejectCall()
                }
            }
        }


    }

    Rectangle{
        id: rectSpeechOverlay
        anchors.fill: parent
        visible: voiceController.isWakeUp
        color: Backend.colorTransparency(Colors.menuBackgroundColor,0.8)
        z: 100
        AnimatedImage {
            id: animation;
            anchors.centerIn: parent
            width: 200
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Images/speech.gif"
            cache: true
            playing: true
        }
    }

    Rectangle{
        id: rectSettingOverlay
        anchors.fill: parent
        visible: root.inSettings
        color: Colors.menuBackgroundColor
        z: 99
        SettingsPage{
            id: settings
            anchors.fill: parent
            onCancelClicked: {
                root.inSettings = false;
                rectPages.enabled = true;
            }
            onSaveClicked:{

                //timeController.resetDevice();
            }
        }

    }


    Rectangle{
        id: rectSideMenu
        anchors.left: rectPages.right
        anchors.right: root.right
        anchors.top: rectTopMenu.bottom
        anchors.bottom: rectMenuBackground.top
        anchors.leftMargin: 32
        anchors.rightMargin: 32
        anchors.topMargin: 32
        anchors.bottomMargin: 32
        color: "transparent"

        Text {
            id: txtDate
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.top: parent.top
            anchors.topMargin: 32
            height: 64
            text: timeController.currentDate
            color : Colors.white
            font.family: "Cooper Hewitt"
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 68
            font.styleName: Font.Light
            fontSizeMode: Text.Fit
        }
        Text {
            id: txtTime
            anchors.top: txtDate.bottom
            anchors.topMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 32
            height: 128
            text: timeController.currentTime
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            color : Colors.white
            font.family: "Cooper Hewitt"
            font.pixelSize: 200
            font.styleName: Font.Thin
            fontSizeMode: Text.Fit
        }

        AlarmPage{
            id: alarmsPage
            anchors.top: txtTime.bottom
            anchors.topMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 32
            height: 300
        }

        Rectangle{
            id: rectTempHum
            anchors.top: alarmsPage.bottom
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 32
            //anchors.bottom: parent.bottom
            height: 90
            anchors.bottomMargin: 32
            color: "transparent"
            //            Text {
            //                id: txtTemprature
            //                text: Icons.m_temperature
            //                color: Colors.white
            //                font.family: "onlinewebfonts"
            //                font.pixelSize: 40
            //                fontSizeMode: Text.Fit
            //                font.styleName: "Light"
            //                font.weight: Font.DemiBold
            //                anchors.top: parent.top
            //                anchors.left: parent.left
            //                anchors.bottom: parent.bottom
            //                anchors.topMargin: 16
            //                anchors.leftMargin: 16
            //                width: parent.width / 6
            //                verticalAlignment: Text.AlignVCenter
            //            }

            Image {
                id: imgTemprature
                source: Icons.temperature
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.topMargin: 16
                anchors.leftMargin: 16
                width: parent.width / 8
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(  parent.width / 8, parent.width / 8 )
                Image {
                    id: img
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coImgIcon
                anchors.fill: imgTemprature
                source: imgTemprature
                color:  Colors.white
            }

            Text {
                id: txtTempratureValue
                text: "19°"
                color: Colors.white
                font.family: "Cooper Hewitt"
                font.pixelSize: 64
                font.styleName: "Thin"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
                anchors.top: parent.top
                anchors.left: imgTemprature.right
                anchors.leftMargin: 16
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.topMargin: 16
                width: parent.width / 4
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            //            Text {
            //                id: txtHumidity
            //                text: Icons.m_humedity
            //                color: Colors.white
            //                font.family: "onlinewebfonts"
            //                font.pixelSize: 40
            //                font.styleName: "Light"
            //                fontSizeMode: Text.Fit
            //                font.weight: Font.DemiBold
            //                anchors.top: parent.top
            //                anchors.bottom: parent.bottom
            //                anchors.left: txtTempratureValue.right
            //                anchors.topMargin: 16
            //                anchors.leftMargin: 16
            //                width: parent.width / 6
            //                verticalAlignment: Text.AlignVCenter
            //            }

            Image {
                id: imgHumidity
                source: Icons.humidity
                anchors.top: parent.top
                anchors.right: txtHumidityValue.left
                anchors.bottom: parent.bottom
                anchors.topMargin: 16
                anchors.rightMargin: 16
                width: parent.width / 8
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(  parent.width / 8,  parent.width / 8 )
                Image {
                    id: imgimgHumidity
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgHumidity
                anchors.fill: imgHumidity
                source: imgHumidity
                color:  Colors.white
            }
            Text {
                id: txtHumidityValue
                text: "50%"
                color: Colors.white
                font.family: "Cooper Hewitt"
                font.pixelSize: 64
                font.styleName: "Thin"
                fontSizeMode: Text.Fit
                font.weight: Font.DemiBold
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.topMargin: 16
                width: parent.width / 4
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
        }
        Rectangle{
            anchors.top: rectTempHum.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 32
            color: "transparent"
            Text{
                id: txtAQI
                text: "Air Quality Index"
                color: Colors.white1
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.top: parent.top
                anchors.topMargin: 8
                height: 32
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: "Far.Nazanin"
                font.pixelSize: 28
                font.styleName: "Light"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
            }

            WeatherCondition{
                id: airPollution
                mValue: 0
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.top: txtAQI.bottom
                anchors.topMargin: 8
                anchors.bottom: parent.bottom
            }
        }





    }

    function getDate(){
        root.currentTime = new Date();
        return root.currentTime.getDate() + ' / ' + root.currentTime.getMonth() + ' / ' + root.currentTime.getFullYear();
    }

    function getTime(){
        root.currentTime = new Date();
        let min = (root.currentTime.getMinutes() < 10 ? "0" + root.currentTime.getMinutes() : root.currentTime.getMinutes()) + "";
        let sec = (root.currentTime.getSeconds() < 10 ? "0" + root.currentTime.getSeconds() : root.currentTime.getSeconds()) + "";
        let hour = (root.currentTime.getHours() < 10 ? "0" + root.currentTime.getHours() : root.currentTime.getHours()) + "";
        return hour + ' : ' + min + ' : ' + sec;
    }
}
