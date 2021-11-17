import QtQuick 2.9

Item {
    id: root
    height: 50

    property alias titleWidth: text.width
    property alias title: text.text
    property alias value: textEdit.text
    property int pixelSize: 25
    property string color: "darkblue"

    signal textEditFocus(real _yPos, real _height)

    Text {
        id: text
        width: 150
        height: root.height
        anchors.left: root.left
        text: ""
        font.pixelSize: root.pixelSize
        verticalAlignment: Text.AlignVCenter
        color: root.color
    }

    Rectangle {
        id: rectangle
        height: root.height
        anchors.left: text.right
        anchors.right: root.right
        border.width: 1
        border.color: color
        color: "gainsboro"
        radius: height / 8

        TextEdit {
            id: textEdit
            height: root.height
            anchors.fill: parent
            anchors.margins: 2
            font.pixelSize: root.pixelSize
            verticalAlignment: Text.AlignVCenter
            textMargin: 10
            color: root.color

            onFocusChanged: {
                if (focus) {
                    root.textEditFocus(rectangle.y + y, height);
                }
            }
        }
    }

    function checkIsNumber() {
        return !isNaN(parseFloat(root.value));
    }
}
