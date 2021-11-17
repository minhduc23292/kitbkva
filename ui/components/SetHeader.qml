import QtQuick 2.9

Item {
    id: root
    height: 100

    property alias imageSource: image.source
    property alias header: text.text
    property int pixelSize: 50
    property string color: "darkblue"

    Image {
        id: image
        width: root.height * 3 / 2
        height: root.height
        anchors.left: root.left
    }

    Text {
        id: text
        height: root.height
        anchors.left: image.right
        anchors.right: root.right
        font.pixelSize: root.pixelSize
        verticalAlignment: Text.AlignVCenter
        color: root.color
    }
}
