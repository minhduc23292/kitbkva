import QtQuick 2.9
import QtQuick.Controls 2.4

Item {
    id: root
    height: 50

    property alias titleWidth: text.width
    property alias title: text.text
    property alias model: comboBox.model
    property alias currentIndex: comboBox.currentIndex
    property alias currentText: comboBox.currentText
    property int pixelSize: 25
    property string color: "darkblue"

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

    ComboBox {
        id: comboBox
        height: root.height
        anchors.left: text.right
        anchors.right: root.right
        font.pixelSize: root.pixelSize

        background: Rectangle {
            id: background
            color: "gainsboro"
            radius: root.height / 8
        }

        delegate: ItemDelegate {
            width: comboBox.width
            contentItem: Text {
                text: comboBox.textRole ? (Array.isArray(comboBox.model) ? modelData[comboBox.textRole] : model[comboBox.textRole]) : modelData
                color: root.color
                font: comboBox.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            font.weight: comboBox.currentIndex === index ? Font.DemiBold : Font.Normal
            font.family: comboBox.font.family
            font.pixelSize: comboBox.font.pixelSize
            highlighted: comboBox.highlightedIndex === index
            hoverEnabled: comboBox.hoverEnabled
        }

        contentItem: Item {
            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                text: comboBox.displayText
                color: root.color
                font: comboBox.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
