import QtQuick 2.9
import QtQuick.Controls 2.4

Item {
    id: root

    property alias imageSource: image.source
    property alias model: comboBox.model
    property alias textRole: comboBox.textRole
    property alias currentIndex: comboBox.currentIndex

    Image {
        id: image
        anchors.left: parent.left
        anchors.right: parent.right
        height: width * 2 / 3
    }

    ComboBox {
        id: comboBox
        height: 50
        anchors.top: image.bottom
        anchors.topMargin: 15
        anchors.left: root.left
        anchors.right: root.right

        background: Rectangle {
            id: background
            color: "gainsboro"
            radius: comboBox.height / 8
        }

        delegate: ItemDelegate {
            width: comboBox.width
            height: comboBox.height
            highlighted: comboBox.highlightedIndex === index
            hoverEnabled: comboBox.hoverEnabled

            Rectangle {
                width: comboBox.width
                height: comboBox.height
                color: comboBox.currentIndex === index ? "gainsboro" : "white"

                Image {
                    fillMode: Image.PreserveAspectFit
                    height: comboBox.height - 10
                    width: height * 2
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    source: model.image
                }
            }
        }

        contentItem: Item {
            Image {
                id: imageContent
                fillMode: Image.PreserveAspectFit
                height: comboBox.height - 10
                width: height * 2
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                source: comboBox.displayText
            }
        }
    }
}
