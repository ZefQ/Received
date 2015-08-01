import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "pages"
import "components"

ApplicationWindow
{
    id: window
    property bool loading: false
    property string stationIcon: ""
    allowedOrientations: Orientation.All
    bottomMargin: player.visibleSize
    initialPage: favorites
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Favorites {
        id: favorites
    }

    AudioPlayer {
        id: player
    }

    BusyIndicator {
        id: pageBusy
        anchors.centerIn: parent
        running: loading
        z: 1
    }

    Python {
        id: radioAPI

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./components/python'));

            setHandler('gotStation', function(station) {
                loading = false;
                console.log("Station:", JSON.stringify(station))
                player.play(station)
            });

            setHandler('log', function(msg) {
                console.log("Pyton log:", msg)
            });

            importModule('api', function () {});
        }

        function playStationById(id) {
            loading = true;
            call('api.radio.getStationById', [''+id], function() {});
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        onReceived: {
            console.log('got message from python: ' + data);
        }
    }

    Component.onCompleted: {
        console.log(player.visibleSize)
        player.open
    }
}


