import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "./js/utils/log.js" as DebugLogger
import "./js/Storage.js" as DB
import "./js/Favorites.js" as FavoritesUtils

DockedPanel {
    id: player
    property var stationData: null;
    property bool isFavorite: false

    function pause() {
        audio.pause()
    }

    function resume() {
        audio.play()
    }

    function isPlaying() {
        return audio.isPlaying()
    }

    function playNext() {
        var nextStation = FavoritesUtils.getNextFavorite(stationData)
        console.log("Playing next favorite", nextStation)
        radioAPI.playStationById(nextStation.id);
    }

    width: parent.width
    height: Theme.itemSizeExtraLarge + Theme.paddingLarge
    dock: Dock.Bottom

    opacity: Qt.inputMethod.visible || !open ? 0.0 : 1.0
    Behavior on opacity { FadeAnimation {duration: 300}}

//    Timer {
//        interval: 10000; running: true; repeat: true
//        onTriggered: {
//            DebugLogger.logMetaData(audio)
//        }
//    }

    Item {
        anchors.fill: parent

        MouseArea {
            id: opener
            anchors.fill: parent
            onClicked: appWindow.showFullControls = !appWindow.showFullControls
        }

        Row {
            id: quickControlsItem
            anchors.fill: parent
            spacing: Theme.paddingLarge

            Image {
                id: stationIcon
                sourceSize.height: parent.height
                sourceSize.width: player.height
                source: window.stationIcon

                smooth: true
                fillMode: Image.PreserveAspectFit
                cache: true
            }

            Column {
                id: trackInfo
                width: parent.width - stationIcon.width - Theme.paddingLarge
                height: parent.height
                spacing: -Theme.paddingSmall

                Label {
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    text: stationData ? stationData.name : ""
                }
                Label {
                    width: parent.width
                    font.pixelSize: Theme.fontSizeSmall
                    truncationMode: TruncationMode.Fade
                    color: Theme.secondaryColor
                    text: stationData ? stationData.genres.toString() : "";
                }

                ProgressBar {
                    id: progressBar
                    value: audio.bufferProgress
                    width: parent.width
                    visible: audio.isLoading()

                    Behavior on value {
                        NumberAnimation {}
                    }
                }

                Row {
                    id: controls
                    width: parent.width
                    property real itemWidth: width / 4
                    visible: !audio.isLoading()

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: isFavorite ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
                        onClicked: {
                            if(!isFavorite) {
                                var station = {
                                    id: player.stationData.id,
                                    name: player.stationData.name,
                                    pictureBaseURL: player.stationData.pictureBaseURL,
                                    picture1Name: player.stationData.picture1Name,
                                    country: player.stationData.country,
                                    oneGenre: player.stationData.oneGenre
                                }
                                FavoritesUtils.addFavorite(station)
                            }
                            else {
                                FavoritesUtils.removeFavorite(stationData)
                            }

                            isFavorite = DB.stationExists(stationData)
                        }
                    }

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: "image://theme/icon-m-previous-song"
                        onClicked: {
                            var prevStation = FavoritesUtils.getPrevFavorite(stationData)
                            console.log("Playing prev favorite", prevStation)
                            radioAPI.playStationById(prevStation.id);
                        }
                    }

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: audio.isPlaying() ? "image://theme/icon-m-pause" : "image://theme/icon-m-play"
                        onClicked: audio.isPlaying() ? audio.pause() : audio.play()
                    }

                    IconButton {
                        width: controls.itemWidth
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: "image://theme/icon-m-next-song"
                        onClicked: {
                            playNext()
                        }
                    }
                }
            }
        }
    }

    function play(station) {
        if(!player.expanded)
            player.open = true;

        player.stationData = station
        window.stationIcon = stationData.pictureBaseURL + stationData.picture4Name
        player.isFavorite = DB.stationExists(stationData)

        var streamURL = station.streamURL
        if(station.streamUrls) {
            for(var i=0; i<station.streamUrls.length; i++) {
                var su = station.streamUrls[i];
                if(su.streamStatus === "VALID") {
                    console.log("Changeing to:", su.streamUrl)
                    streamURL = su.streamUrl
                    if(su.metaDataUrl)
                        break;
                }
            }
        }
        audio.source = streamURL
    }

    Audio {
        id: audio

        autoLoad: false
        autoPlay: false

        onError: {
            console.log("AudioPlayer: onError: ", error)
            var errorMessage = "";

            switch (error) {
            case Audio.NoError:
                return;

            case Audio.ResourceError:
                errorMessage = "The stream URL is not valid."
                break;

            case Audio.FormatError:
                errorMessage = "The stream format is not supported."
                break;

            case Audio.NetworkError:
                errorMessage = "The network is not available."
                break;

            case Audio.AccessDenied:
                errorMessage = "No permessions to access the stream."
                break;

            case Audio.ServiceMissing:
                errorMessage = "The audio service could not be instantiated."
                break;

            default:
                errorMessage = "An unknown error occured."
                break;
            }

            console.log(errorMessage)
        }

        onStatusChanged: {
            console.log("AudioPlayer: Status changed: ", audio.state)

            switch(audio.state) {
                case Audio.NoMedia:
                    audio.stop()
                    console.log("Status: NoMedia")
                    break;
                case Audio.Loading:
                    audio.stop()
                    console.log("Status: Loading")
                    break;
                case Audio.Loaded:
                    console.log("Status: Loaded")
                    break;
                case Audio.Buffering:
                    console.log("Status: Buffering")
                    break;
                case Audio.Stalled:
                    console.log("Status: Stalled")
                    break;
                case Audio.Buffered:
                    console.log("Status: Buffered")
                    break;
                case Audio.EndOfMedia:
                    console.log("Status: EndOfMedia")
                    break;
                case Audio.InvalidMedia:
                    console.log("Status: InvalidMedia")
                    break;
                case Audio.UnknownStatus:
                    console.log("Status: UnknownStatus")
                    break;
            }
        }

        onSourceChanged: {
            switch(playbackState) {
                case Audio.PlayingState:
                    stop()
                    console.log("AudioPlayer: Playing")
                    break;
                case Audio.PausedState:
                    stop()
                    console.log("AudioPlayer: Paused")
                    break;
                case Audio.StoppedState:
                    console.log("AudioPlayer: Stopped")
                    break;
            }

            play();
        }

        onPlaybackStateChanged: {
            console.log("AudioPlayer PlaybackState changed: ", playbackState)
        }

        function isPlaying() {
            return audio.playbackState == Audio.PlayingState
        }

        function isLoading() {
            return status === Audio.Buffering || status === Audio.Stalled || status === Audio.Loading
        }
    }
}
