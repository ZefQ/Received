import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/js/Utils.js" as Utils

Page {
    id: browsePage

    SilicaListView {
        id: browseListView
        VerticalScrollDecorator { flickable: browsePageListView }
        anchors.fill: parent

        PullDownMenu {
                    id: pulleyMeny
                    MenuItem {
                        text: qsTr("Search")
                        onClicked: {
                            pageStack.replace(Qt.resolvedUrl("Stations.qml"), {listType: Utils.Search});
                        }
                    }
                }

        header: Column {
                    PageHeader {
                        title: qsTr("Browse")
                        width: page.width
                    }
                }

        model: ListModel {
            id: browseModel
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
                if(action === "top100") {
                    pageStack.push(Qt.resolvedUrl("Stations.qml"), {listType: Utils.Top100});
                }
                else if(action === "recommended") {
                    pageStack.push(Qt.resolvedUrl("Stations.qml"), {listType: Utils.Recommended});
                }
                else if(action === "localStations") {
                    pageStack.push(Qt.resolvedUrl("Stations.qml"), {listType: Utils.Local});
                }
                else {
                    pageStack.push(Qt.resolvedUrl("BrowseByCategory.qml"), {category: originalTitle, headerTitle: title});
                }
            }
        }
    }

    Component.onCompleted: {
        browseModel.append({ title: qsTr("Local"), action: "localStations"})
        browseModel.append({ title: qsTr("Top 100"), action: "top100"})
        browseModel.append({ title: qsTr("Recommended"), action: "recommended"})
        browseModel.append({ title: qsTr("Genre"), action: "browse", originalTitle: "genre"})
        browseModel.append({ title: qsTr("Topic"), action: "browse", originalTitle: "topic"})
        browseModel.append({ title: qsTr("Country"), action: "browse", originalTitle: "country"})
        browseModel.append({ title: qsTr("City"), action: "browse", originalTitle: "city"})
        browseModel.append({ title: qsTr("Language"), action: "browse", originalTitle: "language"})
    }
}
