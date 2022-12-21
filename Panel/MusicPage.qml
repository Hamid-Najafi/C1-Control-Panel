import QtQuick 2.15
import com.nourbakhsh.MusicController 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15 as Sh
import QtGraphicalEffects 1.15
import 'Backend.js' as Backend
//import AppColors 1.0
//import AppBackend 1.0
//import AppIcons 1.0

Item {
    id: root
    property bool isOnCall: false
    property bool isPlaying: false

    onIsOnCallChanged: {
        if(isOnCall)
        {
            isPlaying = controler.state == 1;
            controler.pause();
        }
        else{
            if(isPlaying)
                controler.play();
        }
    }

    MusicController{
        id: controler
        Component.onCompleted: {
            console.log(controler.filesList);
            positionSlider.enabled = false;
            volumeSlider.mMax = 100;
            volumeSlider.mMin = 0;
            for(let i = 0;i< controler.filesList.length;i++){
                console.log(controler.filesList[i]);
                console.log(controler.filesList[i].name);
                console.log(controler.filesList[i].itemType);
            }
        }
        onStateChanged: {
            console.log(state)
        }
        onPositionChanged: {
            //positionSlider.mValue = controler.position / 1000;
        }
        onDurationChanged: {
            positionSlider.enabled = true;
            positionSlider.mMin = 0;
            positionSlider.mMax = controler.duration / 1000
        }

        onVolumeChanged: {
            volumeSlider.mValue = controler.volume
        }

        onMetadataChanged: {
            let find = false;
            for(let i =0 ;i< controler.metadata.keys().length;i++){
                if(controler.metadata.keys()[i] == 25)
                {
                    coverImage.source = controler.imageToUrl(controler.metadata.value(controler.metadata.keys()[i]));
                    find = true;
                }


                //console.log(controler.metadata.keys()[i])
                //console.log(controler.metadata.value(controler.metadata.keys()[i]))
                //if(controler.metadata.value(controler.metadata.ThumbnailImage))
                // console.log(controler.metadata.ThumbnailImage)
                //if(controler.metadata.value(controler.metadata.CoverArtImage))
                // console.log(controler.metadata.CoverArtImage)
            }
            if(!find){
                coverImage.source = "qrc:/Images/empyCover.png"
            }
        }

    }
    Component {
        id: itemDelegate
        Item{
            height: 48

//            Text {
//                id: txtIcon
//                anchors.left: parent.left
//                anchors.top: parent.top
//                anchors.bottom: parent.bottom
//                anchors.leftMargin: 8
//                anchors.topMargin: 8
//                anchors.bottomMargin: 8
//                width: 32
//                height: 32
//                horizontalAlignment: Text.AlignRight
//                verticalAlignment: Text.AlignVCenter
//                font.family: "onlinewebfonts"
//                fontSizeMode: Text.Fit
//                font.pointSize: 100
//                color: controler.filesList[index].itemType == 0 ?
//                           (Colors.circleProgressGradiantBottom) :
//                           (controler.filesList[index].itemType == 1 ?
//                                (Colors.circleProgressGradiantTop) :
//                                (Colors.green) )
//                text: controler.filesList[index].itemType == 0 ?
//                          (Icons.angleLeft) :
//                          (controler.filesList[index].itemType == 1 ?
//                               (Icons.m_folder_off) :
//                               (Icons.m_music_off) )
//            }

            Rectangle{
                id: rectIcon
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                color: "#01000000"
                width: 32
                height: 32
                Image {
                    id: imgIcon
                    anchors.fill: parent
                    source: controler.filesList[index].itemType == 0 ?
                                (Icons.musicBack_off) :
                                (controler.filesList[index].itemType == 1 ?
                                     (Icons.musicFolder_off) :
                                     (Icons.musicFile_off) )
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size( rectIcon.width, rectIcon.height )
                    Image {
                        id: img
                        source: parent.source
                        width: 0
                        height: 0
                    }
                }
                ColorOverlay{
                    id: coImgIcon
                    anchors.fill: imgIcon
                    source: imgIcon
                    color: controler.filesList[index].itemType == 0 ?
                               (Colors.red) :
                               (controler.filesList[index].itemType == 1 ?
                                    (Colors.blue) :
                                    (Colors.green) )
                }
            }


            Text {
                id: txtSubHeader
                color: Colors.white
                anchors.left: rectIcon.right
                anchors.leftMargin: 8
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.top: parent.top
                anchors.topMargin: 8
                wrapMode:Text.NoWrap
                width: 254
                height: 32
                clip: true
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: "Exo"
                font.pixelSize: 22
                font.styleName: "Semibold"
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
                text:  controler.filesList[index].name
            }

            Rectangle{

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 318
                height: 32
                color:Backend.colorTransparency( Colors.blue , .3)
                visible:((controler.filesList.length > 0 && controler.filesList[0].itemType == 0 )? (controler.playlistCurrentIndex == (index-1)) : (controler.playlistCurrentIndex == index))
            }

            MouseArea {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 318
                height: 32
                onClicked:((controler.filesList.length > 0 && controler.filesList[0].itemType == 0 )?  (controler.playlistCurrentIndex = index -1 ) : (controler.playlistCurrentIndex = index))
                onDoubleClicked: {
                    controler.listItemDoubleClicked(controler.filesList[index].name)
                }
            }

        }


    }

    Rectangle{
        id: rectFilesListBackground

        property int headerHeigth: 48
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        width: 350
        //opacity: .7
        color: Backend.colorTransparency(Colors.menuBackgroundColor , .6);//  "transparent"

        Sh.Shape {
            anchors.fill: parent
            antialiasing: true
            layer.enabled: true
            id: lineShape
            Sh.ShapePath {
                id: lineShapePath
                fillColor: Colors.gray6
                fillGradient:  Sh.LinearGradient {
                    x1:0
                    y1:rectFilesListBackground.headerHeigth
                    x2:rectFilesListBackground.width
                    y2:rectFilesListBackground.headerHeigth
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Colors.white }
                    GradientStop { position: 1.0; color: "transparent" }

                }
                strokeColor: "transparent"
                strokeWidth: 2
                capStyle: Sh.ShapePath.RoundCap
                startX: 16
                startY: 16 + rectFilesListBackground.headerHeigth - 1
                PathLine{
                    x: 16
                    y: 16 + rectFilesListBackground.headerHeigth + 1
                }
                PathLine{
                    x: rectFilesListBackground.width - 16
                    y: 16 + rectFilesListBackground.headerHeigth + 1
                }
                PathLine{
                    x: rectFilesListBackground.width - 16
                    y: 16 + rectFilesListBackground.headerHeigth - 1
                }
            }

        }
        Text {
            id: txtHeader
            text: "Files List"
            color: Colors.white1
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: parent.top
            anchors.topMargin: 8
            height: rectFilesListBackground.headerHeigth
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: "Exo"
            font.pixelSize: 36
            font.styleName: "Light"
            font.weight: Font.DemiBold
            fontSizeMode: Text.Fit
        }
        Rectangle{
            anchors.top: txtHeader.bottom
            anchors.topMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            color:  Backend.colorTransparency(Colors.menuBackgroundColor , .26);
            ListView {
                id: lstFiles
                anchors.fill: parent
                model: controler.filesList.length
                delegate: itemDelegate
            }
        }


    }

    Rectangle{
        id: rectControles
        property int _singleWidthMargin: 8
        property int _singleHeightMargin: 8
        anchors.left: rectFilesListBackground.right
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        height: 150
        color: "transparent"// Backend.colorTransparency(Colors.topBarBackgroundDark , .6);
        Rectangle{
            id: rectPrevious
            x: Backend.getGridItemX(parent.width,parent.height - 50,1,6,1,1,1,2) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 50,1,6,1,1,1,2) + parent._singleHeightMargin + 50
            width: Backend.getGridItemWidth(parent.width,parent.height- 50,1,6,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 50,1,6,1,1) - parent._singleHeightMargin * 2
            color: "#01000000"
//            Text {
//                id: txtPrevious
//                anchors.fill: parent
//                anchors.margins: 16
//                text: Icons.backward
//                horizontalAlignment: Text.AlignRight
//                verticalAlignment: Text.AlignVCenter
//                font.weight: Font.Bold
//                font.family: "Font Awesome 6 Pro"
//                fontSizeMode: Text.Fit
//                font.pointSize: 100
//                color: Colors.white
//            }
            Image {
                id: imgPrevious
                anchors.fill: parent
                anchors.margins: 16
                source: Icons.musicPrevious_off
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( imgPrevious.width, imgPrevious.height )
                Image {
                    id: imgimgPrevious
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgPrevious
                anchors.fill: imgPrevious
                source: imgPrevious
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent
                onClicked: controler.previous()
            }
        }
        Rectangle{
            id: rectStop
            x: Backend.getGridItemX(parent.width,parent.height- 50,1,6,1,1,1,3) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 50,1,6,1,1,1,3) + parent._singleHeightMargin+ 50
            width: Backend.getGridItemWidth(parent.width,parent.height- 50,1,6,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 50,1,6,1,1) - parent._singleHeightMargin * 2
            color: "#01000000"
//            Text {
//                id: txtStop
//                anchors.fill: parent
//                anchors.margins: 16
//                text: Icons.stop
//                horizontalAlignment: Text.AlignRight
//                verticalAlignment: Text.AlignVCenter
//                font.weight: Font.Bold
//                font.family: "Font Awesome 6 Pro"
//                fontSizeMode: Text.Fit
//                font.pointSize: 100
//                color: Colors.white
//            }
            Image {
                id: imgStop
                anchors.fill: parent
                anchors.margins: 16
                source: Icons.musicStop_off
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( imgStop.width, imgStop.height )
                Image {
                    id: imgimgStop
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgStop
                anchors.fill: imgStop
                source: imgStop
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent
                onClicked: controler.stop()
            }
        }
        Rectangle{
            id: rectPlay
            x: Backend.getGridItemX(parent.width,parent.height- 50,1,6,1,1,1,4) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 50,1,6,1,1,1,4) + parent._singleHeightMargin+ 50
            width: Backend.getGridItemWidth(parent.width,parent.height- 50,1,6,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 50,1,6,1,1) - parent._singleHeightMargin * 2
            color: "#01000000"
//            Text {
//                id: txtPlay
//                anchors.fill: parent
//                anchors.margins: 16
//                text: controler.state == 1 ? Icons.pause : Icons.play
//                horizontalAlignment: Text.AlignRight
//                verticalAlignment: Text.AlignVCenter
//                font.weight: Font.Bold
//                font.family: "Font Awesome 6 Pro"
//                fontSizeMode: Text.Fit
//                font.pointSize: 100
//                color: Colors.white
//            }
            Image {
                id: imgPlay
                anchors.fill: parent
                anchors.margins: 16
                source: controler.state == 1 ? Icons.musicPause_off : Icons.musicPlay_off
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( imgPlay.width, imgPlay.height )
                Image {
                    id: imgimgPlay
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgPlay
                anchors.fill: imgPlay
                source: imgPlay
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent
                onClicked: controler.playPauseClicked()
            }
        }
        Rectangle{
            id: rectNext
            x: Backend.getGridItemX(parent.width,parent.height- 50,1,6,1,1,1,5) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 50,1,6,1,1,1,5) + parent._singleHeightMargin+ 50
            width: Backend.getGridItemWidth(parent.width,parent.height- 50,1,6,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 50,1,6,1,1) - parent._singleHeightMargin * 2
            color: "#01000000"
            Image {
                id: imgNext
                anchors.fill: parent
                anchors.margins: 16
                source: Icons.musicNext_off
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( imgNext.width, imgNext.height )
                Image {
                    id: imgimgNext
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgNext
                anchors.fill: imgNext
                source: imgNext
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent
                onClicked: controler.next()
            }
        }
        Rectangle{
            id: rectMediaTimer
            x: Backend.getGridItemX(parent.width,parent.height - 100,1,10,1,1,1,2) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 100,1,10,1,1,1,2)
            width: Backend.getGridItemWidth(parent.width,parent.height- 100,1,10,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 100,1,10,1,1)
            color: "transparent"
            Text {
                id: txtMediaTimer
                anchors.fill: parent
                anchors.topMargin: 16
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                text: root.postionToTimer()
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
                font.weight: Font.Bold
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pointSize: 100
                color: Colors.white
            }

        }

        Rectangle{
            id: rectSlider
            x: Backend.getGridItemX(parent.width,parent.height - 100,1,10,1,4,1,3) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 100,1,10,1,4,1,3)
            width: Backend.getGridItemWidth(parent.width,parent.height- 100,1,10,1,4) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 100,1,10,1,4)
            color: "transparent"
            HSlider{
                id: positionSlider
                x:0
                y:16
                mValue: controler.position / 1000
                seekEnabled: false
                mWidth: parent.width
                mHeight: parent.height
                onNewValue: function(value){
                    //controler.setPositionWithoutNotify(mValue * 1000);
//                    console.log(controler.duration)
//                    console.log(mValue)
                    //controler.position = value;

                }
            }
        }
        Rectangle{
            id: rectMediaDuration
            x: Backend.getGridItemX(parent.width,parent.height - 100,1,10,1,1,1,7) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 100,1,10,1,1,1,7)
            width: Backend.getGridItemWidth(parent.width,parent.height- 100,1,10,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 100,1,10,1,1)
            color: "transparent"
            Text {
                id: txtMediaDuration
                anchors.fill: parent
                anchors.topMargin: 16
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                text: root.durationToTimer()
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                font.weight: Font.Bold
                font.family: "Exo"
                fontSizeMode: Text.Fit
                font.pointSize: 100
                color: Colors.white
            }
        }
        Rectangle{
            id: rectMuteIcon
            x: Backend.getGridItemX(parent.width,parent.height - 100,1,10,1,1,1,8) + parent._singleWidthMargin + 32
            y: Backend.getGridItemY(parent.width,parent.height- 100,1,10,1,1,1,8)
            width: Backend.getGridItemWidth(parent.width,parent.height- 100,1,10,1,1) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 100,1,10,1,1)
            color: "transparent"
//            Text {
//                id: txtMuteIcon
//                anchors.fill: parent
//                anchors.topMargin: 32
//                anchors.leftMargin: 16
//                anchors.rightMargin: 16
//                text: root.getVolumIcon()
//                horizontalAlignment: Text.AlignRight
//                verticalAlignment: Text.AlignBottom
//                font.weight: Font.Bold
//                font.family: "onlinewebfonts"
//                fontSizeMode: Text.Fit
//                font.pointSize: 100
//                color: Colors.white
//            }
            Image {
                id: imgMuteIcon
                anchors.fill: parent
                anchors.topMargin: 32
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                source: root.getVolumIcon()
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size( imgMuteIcon.width, imgMuteIcon.height )
                Image {
                    id: imgimgMuteIcon
                    source: parent.source
                    width: 0
                    height: 0
                }
            }
            ColorOverlay{
                id: coimgMuteIcon
                anchors.fill: imgMuteIcon
                source: imgMuteIcon
                color: Colors.white
            }
            MouseArea{
                anchors.fill: parent
                onClicked: controler.isMuted = !controler.isMuted
            }
        }
        Rectangle{
            id: rectVolume
            x: Backend.getGridItemX(parent.width,parent.height - 100,1,10,1,2,1,9) + parent._singleWidthMargin
            y: Backend.getGridItemY(parent.width,parent.height- 100,1,10,1,2,1,9)
            width: Backend.getGridItemWidth(parent.width,parent.height- 100,1,10,1,2) - parent._singleWidthMargin * 2
            height: Backend.getGridItemHeight(parent.width,parent.height- 100,1,10,1,2)
            color: "transparent"
            HSlider{
                id: volumeSlider
                x:0
                y:16
                mWidth: parent.width
                mHeight: parent.height
                mValue : controler.volume
                onNewValue: function(value){
                    controler.setVolumeWithoutNotify(mValue);
                    //console.log(mValue)
                    //controler.position = value;

                }
            }
        }
    }
    LinearGradient{
        id: grdrectControles
        anchors.fill: rectControles
        start: Qt.point(0,0)
        end: Qt.point(0,rectControles.height)
        gradient: Gradient {
            GradientStop { position: 0.0; color:  "transparent" }
            GradientStop { position: 1.0; color:  Colors.menuBackgroundColor  }
        }
    }

    Rectangle{
        id: rectMusic
        anchors.left: rectFilesListBackground.right
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.bottom: rectControles.top
        anchors.bottomMargin: 16
        color: "transparent"
        AnimatedImage {
            id: animation;
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Images/media.gif"
            cache: true
            playing: controler.state == 1
            onPlayingChanged: {
                if(!playing)
                    currentFrame = frameCount -1 ;
            }
        }


        Rectangle{
            id: rectCoverMask
            //anchors.centerIn: parent
            color: "#50000000"
            radius: height /2
            width: root.getCoverRectWidth()
            height: root.getCoverRectHeight()
            x: root.getCoverRectX()
            y: root.getCoverRectY()

        }
        Image {
            id: coverImage
            anchors.fill: rectCoverMask
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            source : "qrc:/Images/empyCover.png"
            layer.effect: OpacityMask {
                maskSource: rectCoverMask
            }
        }



    }

    //    LinearGradient{
    //        id: grdrectFilesListBackground
    //        anchors.fill: rectFilesListBackground
    //        start: Qt.point(0,0)
    //        end: Qt.point(0,rectFilesListBackground.height)
    //        gradient: Gradient {
    //            GradientStop { position: 1.0; color:  "transparent" }
    //            GradientStop { position: 0.9; color:  Colors.topBarBackgroundDark }
    //            GradientStop { position: 0.1; color:  Colors.topBarBackgroundDark }
    //            GradientStop { position: 0.0; color:  Colors.topBarBackgroundDark }
    //        }
    //    }
    function postionToTimer(){
        let total = controler.position / 1000;
        let hour = Math.floor(( total / 3600));
        let minuts = Math.floor((total - (hour * 3600)) / 60);
        let second = Math.floor(total - (hour * 3600) - (minuts * 60));
        let str = ((hour < 10)? "0"+hour:hour) + ":"+
            ((minuts < 10)? "0"+minuts:minuts) + ":"+
            ((second < 10)? "0"+second:second);
        return str;
    }
    function durationToTimer(){
        let total = controler.duration / 1000;
        let hour = Math.floor(( total / 3600));
        let minuts = Math.floor((total - (hour * 3600)) / 60);
        let second = Math.floor(total - (hour * 3600) - (minuts * 60));
        let str = ((hour < 10)? "0"+hour:hour) + ":"+
            ((minuts < 10)? "0"+minuts:minuts) + ":"+
            ((second < 10)? "0"+second:second);
        return str;
    }

    function getVolumIcon(){
        if(controler.isMuted) return Icons.musicVolumeMute_on;
        if(controler.volume < 1) return Icons.musicVolume1_on;
        if(controler.volume < 25) return Icons.musicVolume2_on;
        if(controler.volume < 50) return Icons.musicVolume3_on;
        if(controler.volume < 75) return Icons.musicVolume4_on;
        return Icons.musicVolume5_on;
    }

    function getCoverRectWidth(){
        let pWidth = rectMusic.width;
        let pHeight = rectMusic.height;
        let w = 343;
        let ws = 52;
        let we = 317;
        let h = 426;
        let hs = 100;
        let he = 366;
        if(pHeight / pWidth < h / w){
            // go with height
            let nw = pHeight * w / h;
            let nws = nw * ws / w;
            let nwe = nw * we / w;
            let nhs = pHeight * hs / h;
            let nhe = pHeight * he / h;
            return nwe - nws;
        }
        else{
            // go with width
        }
        return 100;
    }
    function getCoverRectX(){
        let pWidth = rectMusic.width;
        let pHeight = rectMusic.height;
        let w = 343;
        let ws = 52;
        let we = 317;
        let h = 426;
        let hs = 100;
        let he = 366;
        if(pHeight / pWidth < h / w){
            // go with height
            let nw = pHeight * w / h;
            let nws = nw * ws / w;
            let nwe = nw * we / w;
            let nhs = pHeight * hs / h;
            let nhe = pHeight * he / h;
            return (pWidth - nw) / 2 + nws;
        }
        else{
            // go with width
        }
        return 100;
    }
    function getCoverRectHeight(){
        let pWidth = rectMusic.width;
        let pHeight = rectMusic.height;
        let w = 343;
        let ws = 52;
        let we = 317;
        let h = 426;
        let hs = 100;
        let he = 366;
        if(pHeight / pWidth < h / w){
            // go with height
            let nw = pHeight * w / h;
            let nws = nw * ws / w;
            let nwe = nw * we / w;
            let nhs = pHeight * hs / h;
            let nhe = pHeight * he / h;
            return nhe - nhs;
        }
        else{
            // go with width
        }
        return 100;
    }
    function getCoverRectY(){
        let pWidth = rectMusic.width;
        let pHeight = rectMusic.height;
        let w = 343;
        let ws = 52;
        let we = 317;
        let h = 426;
        let hs = 100;
        let he = 366;
        if(pHeight / pWidth < h / w){
            // go with height
            let nw = pHeight * w / h;
            let nws = nw * ws / w;
            let nwe = nw * we / w;
            let nhs = pHeight * hs / h;
            let nhe = pHeight * he / h;
            return  nhs;
        }
        else{
            // go with width
        }
        return 100;
    }

    function setMusicState(state: int){
        switch(state)
        {
        case 0:
            // Play
            if(isOnCall||isPlaying)
                return;
            controler.fillPlayList();
            controler.play();
            break;
        case 1:
            // Stop
            controler.stop();
            break;
        case 2:
            // Next
            controler.next();
            break;
        case 3:
            // Previous
            controler.previous();
            break;
        case 4:
            // Mute
            controler.mute();
            break;
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
