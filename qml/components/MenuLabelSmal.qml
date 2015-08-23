import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property alias text: text.text
    property alias color: text.color
    property real verticalOffset

    height: Theme.itemSizeExtraSmall - Theme.paddingLarge
    width: parent ? parent.width : Screen.width
    Label {
        id: text
        opacity: 0.6
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeExtraSmall
        width: parent.width - Theme.horizontalPageMargin*2
        anchors {
            verticalCenterOffset: verticalOffset
            centerIn: parent
        }
        horizontalAlignment: Text.AlignHCenter
    }
}
