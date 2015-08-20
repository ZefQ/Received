import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "../components/js/Utils.js" as Utils


Page {
    id: page
    property string category: ""
    property string headerTitle: ""

    SilicaListView {
        id: browseByListView
        VerticalScrollDecorator { flickable: browseByPageListView }
        anchors.fill: parent

        PullDownMenu {
                    id: pulleyMeny
                    MenuItem {
                        visible: player.isPlaying() && !player.open
                        text: qsTr("Show player")
                        onClicked: {
                            player.open = true
                        }
                    }
                    MenuItem {
                        text: qsTr("Search")
                        onClicked: {
                            pageStack.replaceAbove(
                                        pageStack.find(function(page) {
                                            return page.firstPage === true}),
                                        Qt.resolvedUrl("Stations.qml"),
                                        {listType: Utils.Search});
                        }
                    }
                }

        header: Column {
                    PageHeader {
                        title: qsTr("Browse by") + " " + headerTitle.toLocaleLowerCase()
                        width: page.width
                    }
                }

        model: ListModel {
            id: browseByModel
        }

        delegate: ListItem {
            id: listItem
            width: parent.width
            contentHeight: Theme.itemSizeSmall

            Label {
                text: title
                font.bold: true
                color: Theme.primaryColor;
                anchors.fill: parent
                anchors.leftMargin: 25
                anchors.topMargin: 7
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("Stations.qml"), {listType: new Utils.ListType(title), category: category, value: title});
            }
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../components/python'));
            setHandler('updateCategories', function(stations) {
                window.loading = false;
                populateList(stations)
            });

            importModule('api', function () {});
        }

        function getCategories(cat) {
            window.loading = true;
            call('api.radio.getCategories', [cat], function() {});
        }

        onError: {
            console.log('python error: ' + traceback);
        }

        onReceived: {
            console.log('got message from python: ' + data);
        }
    }

    function populateList(cats) {
        console.log("Number of results:", cats.length)
        browseByModel.clear()

        cats.forEach(function(cat) {
            browseByModel.append({ title: cat})
        });
    }

    Component.onCompleted: {
        python.getCategories(category.toLowerCase())
    }
}
