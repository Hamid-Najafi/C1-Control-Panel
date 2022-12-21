import QtQuick 2.15

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15 as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend
import com.nourbakhsh.SipController 1.0
//import AppColors 1.0
//import AppBackend 1.0
//import AppIcons 1.0

Item {
    id:root

    property int _singleWidthMargin: 8
    property int _singleHeightMargin: 8
    property int mState: 0
    property string mCallerId: ""

    property string sipServer: ""
    property string sipPort: ""
    property string sipProtocol: ""
    property string sipUsername: ""
    property string sipPassword: ""

    signal mOnCall();
    signal mCallEnded();

    SipController{
        id:controler

        onCallerIdChanged: {
            root.mCallerId = controler.callerId;
        }

        onStateChanged: {
            if(controler.state !=0)
                root.mOnCall();
            else
                root.mCallEnded();
            root.mState = controler.state;
        }
    }

    Rectangle{
        id: rectDialpad
        color: "transparent"
        property alias dialNumber: txtNumber.text
        anchors.top: parent.top
        anchors.topMargin: 48
        x: parent.width / 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        width: parent.width / 3
        Text {
            id: txtDialer
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,2,1,2,1,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,2,1,2,1,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,2,1,2) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,2,1,2) - root._singleHeightMargin * 2
            text: "Dial Pad"
            color: Colors.white
            clip: true
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            font.family: "Exo"
            font.pixelSize: 48
            font.styleName: "Semibold"
            font.weight: Font.DemiBold
            fontSizeMode: Text.Fit
        }
        Text {
            id: txtNumber
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,3,2,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,3,2,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,3) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,3) - root._singleHeightMargin * 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            color: Colors.white
            font.family: "Exo"
            fontSizeMode: Text.Fit
            font.pixelSize: 48
            font.styleName: "Light"
            font.weight: Font.DemiBold
        }
        Rectangle{
            id: rectNumberBorder
            anchors.left: txtNumber.left
            anchors.right: txtNumber.right
            anchors.bottom: txtNumber.bottom
            height: 2
            color: "transparent"
        }
        LinearGradient{
            id: grdrectNumberBorder
            anchors.fill: rectNumberBorder
            end: Qt.point(rectNumberBorder.width,0)
            start: Qt.point(0,0)

            gradient: Gradient {
                GradientStop { position: 1.0; color: "transparent" }
                GradientStop { position: 0.5; color:  Colors.white }
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
            }
        }

        Rectangle{
            id: rectNumber1
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,3,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,3,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader1
                text: "1"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "1";
                }
            }
        }
        Rectangle{
            id: rectNumber2
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,3,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,3,2) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color: Colors.menuBackgroundColor   }
            }
            radius: 4
            Text {
                id: txtHeader2
                text: "2"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "2";
                }
            }
        }
        Rectangle{
            id: rectNumber3
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,3,3) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,3,3) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader3
                text: "3"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "3";
                }
            }
        }
        Rectangle{
            id: rectNumber4
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,4,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,4,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader4
                text: "4"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "4";
                }
            }
        }
        Rectangle{
            id: rectNumber5
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,4,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,4,2) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader5
                text: "5"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "5";
                }
            }
        }
        Rectangle{
            id: rectNumber6
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,4,3) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,4,3) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader6
                text: "6"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "6";
                }
            }
        }
        Rectangle{
            id: rectNumber7
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,5,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,5,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader7
                text: "7"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "7";
                }
            }
        }
        Rectangle{
            id: rectNumber8
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,5,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,5,2) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader8
                text: "8"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "8";
                }
            }
        }
        Rectangle{
            id: rectNumber9
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,5,3) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,5,3) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader9
                text: "9"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "9";
                }
            }
        }
        Rectangle{
            id: rectNumber0
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,6,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,6,2) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeader0
                text: "0"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber += "0";
                }
            }
        }
        Rectangle{
            id: rectNumberClear
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,6,3) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,6,3) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Backend.colorTransparency(Colors.menuBackgroundColor,.5)}
                GradientStop { position: 1.0; color:  Colors.menuBackgroundColor }
            }
            radius: 4
            Text {
                id: txtHeaderClear
                text: "←"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rectDialpad.dialNumber = rectDialpad.dialNumber.substring(0 , rectDialpad.dialNumber.length - 1);
                }
            }
        }
        Rectangle{
            id: rectNumberCall
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,3,1,1,6,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,3,1,1,6,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,3,1,1) - root._singleHeightMargin * 2
            color: "#01000000"
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Colors.green }
                GradientStop { position: 1.0; color:  Backend.colorTransparency(Colors.green,.5)}
            }
            radius: 4
            Text {
                id: txtHeaderCall
                text: "✆"
                color: Colors.white1
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pixelSize: 36
                font.styleName: "Light"
                font.weight: Font.DemiBold
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    controler.call(rectDialpad.dialNumber);
                }
            }
        }

    }
    Rectangle{
        id: rectContact
        color: "transparent"
        property alias dialNumber: txtNumber.text
        anchors.top: parent.top
        anchors.topMargin: 48
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        width: parent.width * 2 / 5
        Text {
            id: txtContact
            x: Backend.getGridItemX(rectDialpad.width,rectDialpad.height,6,2,1,2,1,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectDialpad.width,rectDialpad.height,6,2,1,2,1,1) + root._singleHeightMargin
            width: Backend.getGridItemWidth(rectDialpad.width,rectDialpad.height,6,2,1,2) - root._singleWidthMargin * 2
            height: Backend.getGridItemHeight(rectDialpad.width,rectDialpad.height,6,2,1,2) - root._singleHeightMargin * 2
            text: "Contacts"
            color: Colors.white
            clip: true
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            font.family: "Exo"
            font.pixelSize: 48
            font.styleName: "Semibold"
            font.weight: Font.DemiBold
            fontSizeMode: Text.Fit
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,2,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,2,1) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "NurseStation"
            mSubHeader: "7001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,2,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,2,2) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Pharmacy"
            mSubHeader: "8001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,3,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,3,1) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Management"
            mSubHeader: "4001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,3,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,3,2) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Accounting"
            mSubHeader: "3001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,4,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,4,1) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Patient discharge"
            mSubHeader: "7004"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,4,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,4,3) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "DrugStore"
            mSubHeader: "9001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,5,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,5,1) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Doctor 1"
            mSubHeader: "7101"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,5,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,5,2) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Doctor 2"
            mSubHeader: "7001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,6,1) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,6,1) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Doctor 3"
            mSubHeader: "7001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
        ContactButton{
            x: Backend.getGridItemX(rectContact.width,rectContact.height,6,2,1,1,6,2) + root._singleWidthMargin
            y: Backend.getGridItemY(rectContact.width,rectContact.height,6,2,1,1,6,2) + root._singleHeightMargin
            mWidth: Backend.getGridItemWidth(rectContact.width,rectContact.height,6,2,1,1) - root._singleWidthMargin * 2
            mHeight: Backend.getGridItemHeight(rectContact.width,rectContact.height,6,2,1,1) - root._singleHeightMargin * 2
            mHeader: "Doctor 4"
            mSubHeader: "7001"
            onMClicked: {
                rectDialpad.dialNumber = mSubHeader;
            }
        }
    }
    function acceptCall(){
        controler.acceptCall();
    }

    function rejectCall(){
        controler.rejectCall();
    }

    function connect(){

        controler.username = root.sipUsername;// "9002";
        controler.password = root.sipPassword;// "9002";
        controler.serverAddress = root.sipServer;// "192.168.100.16";
        controler.protocol = root.sipProtocol;// "UDP";
        controler.port = +root.sipPort;// 48015;
        if(controler.username == "" ||
           controler.serverAddress == "" ||
                controler.protocol == "" ||
                controler.port == "" )
            return;
        controler.connectToServer();
        controler.registerAccount();
    }
}
