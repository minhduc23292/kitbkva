import QtQuick 2.9

Item {
    id: root
    height: 50
    anchors.left: parent.left
    anchors.right: parent.right

    property alias titleWidth: header.width
    property alias title: header.text
    property alias unit: unit.text
    property alias value: textEdit.text
    property int pixelSize: 25
    property string color: "darkblue"

    signal textEditFocus(real _yPos, real _height)
    signal textChanged()

    Text {
        id: header
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
        anchors.left: header.right
        anchors.right: unit.left
        anchors.rightMargin: 5
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
            text: ""
            color: root.color

            onFocusChanged: {
                if (focus) {
                    root.textEditFocus(rectangle.y + y, height);
                }
            }

            onTextChanged: {
                if (root.checkIsNumber()) {
                    root.textChanged();
                }
            }
        }
    }

    Text {
        id: unit
        width: 50
        height: root.height
        anchors.right: root.right
        text: ""
        font.pixelSize: root.pixelSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: root.color
    }

    function checkIsNumber() {
        return !isNaN(parseFloat(root.value));
    }
}
