import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
           source: window.stationIcon
           anchors.top: parent.top
           anchors.left: parent.left
           width: parent.width
           height: parent.width
           opacity: 0.1
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                player.playNext()
            }
        }

        CoverAction {
            iconSource: player.isPlaying() ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: {
                if(player.isPlaying())
                    player.pause()
                else
                    player.resume()

            }
        }
    }
}


