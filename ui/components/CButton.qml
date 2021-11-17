import QtQuick 2.9
import QtQuick.Controls 2.4

Button {
    id: root
    width: 150
    height: 50

    property int pixelSize: 25
    property string content: ""
    property string color: "green"

    background: Rectangle {
        id: background
        color: "gainsboro"
        border.width: 1
        border.color: root.color
        radius: root.height / 8
    }

    contentItem: Item {
        anchors.fill: parent

        Text {
            anchors.fill: parent
            text: root.content
            color: root.color
            font.pixelSize: root.pixelSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    onPressedChanged: {
        if (pressed) {
            background.opacity = 0.75;
        } else {
            background.opacity = 1
        }
    }
}
