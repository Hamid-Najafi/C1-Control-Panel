import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.nourbakhsh.SettingController 1.0
import 'Backend.js' as Backend

Item {
    id: root

    property alias sipServer: txtServerPath.text
    property alias sipPort: txtPort.text
    property alias sipProtocol: txtProtocol.text
    property alias sipUsername: txtUsername.text
    property alias sipPassword: txtSipPassword.text
    property alias audioText: cobAudioOutput.currentText
    property int selectedMenu: 1
    property bool isVoiceActive: true
    property alias voiceCommandLevel: sldVoiceCommandLevel.value

    signal cancelClicked();
    signal saveClicked();
    Component.onCompleted: {
        root.showPasswordEnter();
    }

    Rectangle{
        anchors.fill: parent
        color: "#01000000"
    }

    Rectangle{
        id: rectPassword
        anchors.centerIn: parent
        height: 200
        width: 640
        color: "transparent"
        Text {
            id: txtPasswordLabel
            text: "Password: "
            color: Colors.white1
            anchors.left: parent.left
            anchors.top: parent.top
            height: 68
            width: 240
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.family: "Far.Nazanin"
            font.pixelSize: 28
            font.styleName: "Light"
            font.weight: Font.DemiBold
            fontSizeMode: Text.Fit
        }
        Rectangle{
            id: rectInputPassword
            color: "transparent"
            anchors.left: txtPasswordLabel.right
            anchors.leftMargin: 32
            anchors.top: parent.top
            border.color: Colors.white
            border.width: 2
            clip: true
            width: 400 - 32
            height: 68
            radius: 4
            TextInput{
                id: txtPassword
                anchors.fill: parent
                color: Colors.white1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Far.Nazanin"
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
                Keys.onReturnPressed: {

                    if(txtPassword.text == "9998"){
                        root.hidePasswordEnter();

                    }
                }
            }
        }


        Rectangle{

            id: rectCancel
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.bottom: parent.bottom
            height: 68
            width: 128
            border.color: Colors.gray5
            border.width: 2
            radius: 4
            color: "transparent"
            Text {
                id: txtCancel
                text: "Cancel"
                color: Colors.gray5
                anchors.centerIn: parent
                anchors.margins: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: "Far.Nazanin"
                font.pixelSize: 28
                font.styleName: "Light"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.showPasswordEnter();
                    root.cancelClicked();
                }
            }
        }

        Rectangle{

            id: rectOk
            color: "transparent"
            anchors.right: rectCancel.left
            anchors.rightMargin: 16
            anchors.bottom: parent.bottom
            height: 68
            width: 96
            border.color: Colors.green
            border.width: 2
            radius: 4
            Text {
                id: txtOk
                text: "Ok"
                color: Colors.green
                anchors.centerIn: parent
                anchors.margins: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: "Far.Nazanin"
                font.pixelSize: 28
                font.styleName: "Light"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(txtPassword.text == "9998"){
                        root.hidePasswordEnter();

                    }
                }
            }
        }

    }


    RnTabMenutItem {
        id: menuIntercom
        mText: "Intercom"
        mIconOff: Icons.intercom_off
        mIconOn: Icons.intercom_on
        mIsActive: (root.selectedMenu == 1)
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width / 2
        height: 128
        onMClicked: {
            root.selectedMenu = 1;
        }
    }

    RnTabMenutItem {
        id: menuAudio
        mText: "Audio"
        mIconOff: Icons.musicVolume2_off
        mIconOn: Icons.musicVolume2_on
        mIsActive: (root.selectedMenu == 2)
        anchors.top: parent.top
        anchors.left: menuIntercom.right
        width: parent.width / 3
        height: 128
        onMClicked: {
            root.selectedMenu = 2;
        }
    }

    RnTabMenutItem {
        id: menuHostname
        mText: "Hostname"
        mIconOff: Icons.about_off
        mIconOn: Icons.about_on
        mIsActive: (root.selectedMenu == 3)
        anchors.top: parent.top
        anchors.left: menuAudio.right
        width: parent.width / 3
        height: 128
        onMClicked: {
            root.selectedMenu = 3;
        }
    }

    RnTabMenutItem {
        id: menuVoice
        mText: "Voic Command"
        mIconOff: Icons.musicVolume2_off
        mIconOn: Icons.musicVolume2_on
        mIsActive: (root.selectedMenu == 4)
        anchors.top: parent.top
        anchors.left: menuIntercom.right
        width: parent.width / 2
        height: 128
        onMClicked: {
            root.selectedMenu = 4;
        }
    }



    StackLayout {
        id: menuLayouts
        anchors.fill: parent
        anchors.topMargin: 128
        anchors.bottomMargin: 128
        currentIndex: root.selectedMenu - 1
        Item {
            id: homeTab
            Rectangle{
                id: rectIntercom
                anchors.centerIn: parent
                height: 640
                width: 640
                color: "transparent"
                Text {
                    id: txtServerPathLabel
                    text: "Server: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectServerPath
                    color: "transparent"
                    anchors.left: txtServerPathLabel.right
                    anchors.leftMargin: 32
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    TextInput{
                        id: txtServerPath
                        anchors.fill: parent
                        color: Colors.white1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }
                Text {
                    id: txtPortLabel
                    text: "Port: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: txtServerPathLabel.bottom
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectPort
                    color: "transparent"
                    anchors.left: txtPortLabel.right
                    anchors.leftMargin: 32
                    anchors.top: txtServerPathLabel.bottom
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    TextInput{
                        id: txtPort
                        anchors.fill: parent
                        color: Colors.white1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }
                Text {
                    id: txtProtocolLabel
                    text: "Protocol: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: txtPortLabel.bottom
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectProtocol
                    color: "transparent"
                    anchors.left: txtPortLabel.right
                    anchors.leftMargin: 32
                    anchors.top: txtPortLabel.bottom
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    TextInput{
                        id: txtProtocol
                        anchors.fill: parent
                        color: Colors.white1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }
                Text {
                    id: txtUsernameLabel
                    text: "Username: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: txtProtocolLabel.bottom
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectUsername
                    color: "transparent"
                    anchors.left: txtProtocolLabel.right
                    anchors.leftMargin: 32
                    anchors.top: txtProtocolLabel.bottom
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    TextInput{
                        id: txtUsername
                        anchors.fill: parent
                        color: Colors.white1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }
                Text {
                    id: txtSipPasswordLabel
                    text: "Password: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: txtUsernameLabel.bottom
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectSipPassword
                    color: "transparent"
                    anchors.left: txtUsernameLabel.right
                    anchors.leftMargin: 32
                    anchors.top: txtUsernameLabel.bottom
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    TextInput{
                        id: txtSipPassword
                        anchors.fill: parent
                        color: Colors.white1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }

            }

        }
        Item {
            id: discoverTab
            Rectangle{
                id: rectAudioControl
                anchors.centerIn: parent
                height: 640
                width: 640
                color: "transparent"
                Text {
                    id: txtAudioOutputLabel
                    text: "Output device: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectAudioOutput
                    color: "transparent"
                    anchors.left: txtAudioOutputLabel.right
                    anchors.leftMargin: 32
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    ComboBox{
                        id: cobAudioOutput
                        anchors.fill: parent
                        model: SettingController.getOutputAudioDevices()
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }

            }
        }
        Item {
            id: activityTab
            Rectangle{
                id: rectHostnameSet
                anchors.centerIn: parent
                height: 640
                width: 640
                color: "transparent"
                Text {
                    id: txtHostnameLabel
                    text: "Hostname: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectHostnameInput
                    color: "transparent"
                    anchors.left: txtHostnameLabel.right
                    anchors.leftMargin: 32
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    TextInput{
                        id: txtHostnameInput
                        anchors.fill: parent
                        color: Colors.white1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }
                }

            }
        }
        Item {
            id: voiceTab
            Rectangle{
                id: rectVoiceCommand
                anchors.centerIn: parent
                height: 640
                width: 640
                color: "transparent"
                Text {
                    id: txtVoiceCommandActiveLabel
                    text: "Active Voice Command: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectVoiceCommandActive
                    color: root.isVoiceActive ? Colors.orange : "transparent"
                    anchors.left: txtVoiceCommandActiveLabel.right
                    anchors.leftMargin: 32
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 2
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            root.isVoiceActive = !root.isVoiceActive;
                        }
                    }
                }
                Text {
                    id: txtVoiceCommandLevel
                    text: "Level: "
                    color: Colors.white1
                    anchors.left: parent.left
                    anchors.top: txtVoiceCommandActiveLabel.bottom
                    anchors.topMargin: 16
                    height: 68
                    width: 240
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Far.Nazanin"
                    font.pixelSize: 28
                    font.styleName: "Light"
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.Fit
                }
                Rectangle{
                    id: rectVoiceCommandLevel
                    color: "transparent"
                    anchors.left: txtVoiceCommandLevel.right
                    anchors.leftMargin: 32
                    anchors.top: txtVoiceCommandActiveLabel.bottom
                    anchors.topMargin: 16
                    border.color: Colors.white
                    border.width: 0
                    clip: true
                    width: 400 - 32
                    height: 68
                    radius: 4
                    Slider{
                        id: sldVoiceCommandLevel
                        orientation: "Horizontal"
                        from: 0
                        to: 100
                        anchors.fill: parent
                        font.family: "Far.Nazanin"
                        font.pixelSize: 36
                        font.styleName: "Light"
                        font.weight: Font.DemiBold
                    }

                }

            }

        }
    }

    Rectangle{
        id: rectButtons
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 128
        color: "transparent"
        Rectangle{

            id: rectSettingCancel
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.bottomMargin: 32
            anchors.bottom: parent.bottom
            height: 68
            width: 128
            border.color: Colors.gray5
            border.width: 2
            radius: 4
            color: "transparent"
            Text {
                id: txtSettingCancel
                text: "Cancel"
                color: Colors.gray5
                anchors.centerIn: parent
                anchors.margins: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: "Far.Nazanin"
                font.pixelSize: 28
                font.styleName: "Light"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    txtPassword.text = "";
                    root.showPasswordEnter();
                    root.cancelClicked();
                }
            }
        }
        Rectangle{

            id: rectSettingOk
            color: "transparent"
            anchors.right: rectSettingCancel.left
            anchors.rightMargin: 32
            anchors.bottomMargin: 32
            anchors.bottom: parent.bottom
            height: 68
            width: 240
            border.color: Colors.green
            border.width: 2
            radius: 4
            Text {
                id: txtSettingOk
                text: "Save & Reset"
                color: Colors.green
                anchors.centerIn: parent
                anchors.margins: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: "Far.Nazanin"
                font.pixelSize: 28
                font.styleName: "Light"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    txtPassword.text = "";
                    root.showPasswordEnter();
                    root.saveClicked();
                }
            }
        }

    }

    function showPasswordEnter(){
        rectPassword.visible = true;
        rectPassword.enabled = true;
        menuIntercom.visible = false;
        menuIntercom.enabled = false;
        menuAudio.visible = false;
        menuAudio.enabled = false;
        menuHostname.visible = false;
        menuHostname.enabled = false;
        menuLayouts.visible = false;
        menuLayouts.enabled = false;
        menuVoice.visible = false;
        menuVoice.enabled = false;
        rectButtons.visible = false;
        rectButtons.enabled = false;

    }
    function hidePasswordEnter(){

        rectPassword.visible = false;
        rectPassword.enabled = false;
        menuIntercom.visible = true;
        menuIntercom.enabled = true;
        menuAudio.visible = false;
        menuAudio.enabled = false;
        menuHostname.visible = false;
        menuHostname.enabled = false;
        menuLayouts.visible = true;
        menuLayouts.enabled = true;
        menuVoice.visible = true;
        menuVoice.enabled = true;
        rectButtons.visible = true;
        rectButtons.enabled = true;
    }

}
