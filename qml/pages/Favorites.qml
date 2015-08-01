import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/js/Utils.js" as Utils
import "../components/js/Favorites.js" as FavoritesUtils


Page {
    id: favoritePage
    allowedOrientations: Orientation.All

    SilicaListView {
        id: favoritesListView
        VerticalScrollDecorator { flickable: issuesPageListView }
        anchors.fill: parent

        PullDownMenu {
                    id: pulleyMeny
                    MenuItem {
                        text: "Top 100"
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("Browse.qml"), {listType: Utils.Top100});
                        }
                    }
                    MenuItem {
                        text: "Search"
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("Browse.qml"), {listType: Utils.Search});
                        }
                    }
                }


        header: Column {
                    PageHeader {
                        title: "Favorites"
                        width: favoritePage.width
                    }
                }

        model: ListModel {
            id: favoriteModel
        }

        delegate: ListItem {
            id: favoritItem
            menu: favoriteContextMenu
            width: parent.width
            contentHeight: Theme.itemSizeLarge

            Row {
                anchors.fill: parent
                spacing: Theme.paddingLarge

                Image {
                    id: stationIcon
                    source: pictureBaseURL + picture1Name

                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    cache: true

                    sourceSize.height: parent.height - 20
                }

                Column {
                    id: stationInfo
                    width: parent.width - stationIcon.width - Theme.paddingLarge
                    height: parent.height
                    spacing: -Theme.paddingSmall

                    Label {
                        id: stationName
                        text: name
                    }

                    Label {
                        width: parent.width
                        font.pixelSize: Theme.fontSizeExtraSmall
                        truncationMode: TruncationMode.Fade
                        color: Theme.secondaryColor
                        text: "From " + country + ": " + genre
                    }
                }
            }

            onClicked: {
                radioAPI.playStationById(id);
            }

            Component {
                id: favoriteContextMenu
                ContextMenu {
                    MenuItem {
                        text: "Remove from favorite"
                        onClicked: {
                            remove()
                        }
                    }
                }
            }

            function remove() {
                remorseAction("Deleteing", function() {
                    var station = favoriteModel.get(index);
                    FavoritesUtils.removeFavorite(station);
                });
            }
        }
    }

    Component.onCompleted: {
         FavoritesUtils.init(favoriteModel)
    }
}


