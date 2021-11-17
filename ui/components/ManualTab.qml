import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.1

Item {
    id: root
    anchors.fill: parent

    property int pixelSize: 20
    property string color: "darkblue"

    signal textEditFocus(real _yPos, real _height)
    signal btnMotorConnectClicked()
    signal btnMotorDisconnectClicked()
    signal btnMotorRunClicked()
    signal btnMotorPauseClicked()
    signal btnMotorUpdateFrequencyClicked(real _frequency)
    signal btnBackClicked()

    GridLayout {
        id: grlLayout
        anchors.fill: parent
        anchors.margins: 15

        columns: 2
        rows: 2
        rowSpacing: 10
        columnSpacing: 25

        Item {
            id: itmMotor
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: Layout.columnSpan
            Layout.preferredHeight: Layout.rowSpan

            Settings {
                id: motorSettings
                category: "motor_manual_settings"                

                property alias frequency: tbxMotorFrequence.text
            }

            SetHeader {
                id: hdrMotor
                anchors.left: parent.left
                anchors.right: parent.right
                imageSource: "../asset/motor.png"
                header: "MOTOR"
            }

            Item {
                id: itmMotorParams
                anchors.fill: parent
                anchors.topMargin: 150

                CButton {
                    id: btnMotorConnect
                    height: 50
                    
                    content: "CONNECT"
                    pixelSize: 20

                    onClicked: {
                        root.btnMotorConnectClicked();
                    }
                }

                CButton {
                    id: btnMotorDisconnect
                    width: btnMotorConnect.width
                    height: btnMotorConnect.height
                    anchors.left: btnMotorConnect.right
                    anchors.leftMargin: 25
                    
                    content: "DISCONNECT"
                    pixelSize: 20

                    onClicked: {
                        root.btnMotorDisconnectClicked();
                    }
                }

                CButton {
                    id: btnMotorRun
                    width: btnMotorConnect.width
                    height: btnMotorConnect.height
                    anchors.left: btnMotorConnect.left
                    anchors.top: btnMotorConnect.bottom
                    anchors.topMargin: 10
                    
                    content: "RUN"
                    pixelSize: 20

                    onClicked: {
                        root.btnMotorRunClicked();
                    }
                }

                CButton {
                    id: btnMotorPause
                    width: btnMotorRun.width
                    height: btnMotorRun.height
                    anchors.top: btnMotorRun.top
                    anchors.left: btnMotorRun.right
                    anchors.leftMargin: 25
                    
                    content: "PAUSE"
                    pixelSize: 20

                    onClicked: {
                        root.btnMotorPauseClicked();
                    }
                }

                Text {
                    id: lblMotorFrequency
                    width: btnMotorRun.width
                    height: btnMotorRun.height
                    anchors.left: btnMotorRun.left
                    anchors.top: btnMotorRun.bottom
                    anchors.topMargin: 10

                    text: "Frequency (Hz)"
                    font.pixelSize: root.pixelSize
                    verticalAlignment: Text.AlignVCenter
                    color: root.color
                }

                Rectangle {
                    id: rtgMotorFrequency
                    width: lblMotorFrequency.width
                    height: lblMotorFrequency.height
                    anchors.top: lblMotorFrequency.top
                    anchors.left: lblMotorFrequency.right
                    anchors.leftMargin: 25

                    border.width: 1
                    border.color: color
                    color: "gainsboro"
                    radius: height / 8

                    TextEdit {
                        id: tbxMotorFrequence
                        height: parent.height
                        anchors.fill: parent
                        anchors.margins: 2
                        font.pixelSize: root.pixelSize
                        verticalAlignment: Text.AlignVCenter
                        textMargin: 10
                        color: root.color
                        text: '25'

                        onFocusChanged: {
                            if (focus) {
                                root.textEditFocus(grlLayout.y + itmMotor.y + itmMotorParams.y + rtgMotorFrequency.y + y, height);
                            }
                        }
                    }
                }

                CButton {
                    id: btnMotorUpdateFrequency
                    width: rtgMotorFrequency.width
                    height: rtgMotorFrequency.height
                    anchors.top: rtgMotorFrequency.top
                    anchors.left: rtgMotorFrequency.right
                    anchors.leftMargin: 25
                    
                    content: "UPDATE"
                    pixelSize: 20

                    onClicked: {
                        var frequency = parseFloat(tbxMotorFrequence.text);
                        if (isNaN(frequency)) {
                            messageDialog.text = "Frequency is invalid";
                            messageDialog.visible = true;
                            return;
                        }
                        motorSettings.frequency = parseFloat(motorSettings.frequency).toString();

                        root.btnMotorUpdateFrequencyClicked(frequency);
                    }
                }
            }
        }

        Item {
            id: itmBrake
            Layout.row: 0
            Layout.column: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: Layout.columnSpan
            Layout.preferredHeight: Layout.rowSpan

            SetHeader {
                id: hdrBrake
                anchors.left: parent.left
                anchors.right: parent.right
                imageSource: "../asset/brake.png"
                header: "BRAKE"
            }
        }

        Item {
            id: itmControl
            Layout.row: 1
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredWidth: Layout.columnSpan

            height: 50

            CButton {
                id: btnBack
                width: 200
                height: parent.height
                content: "🡰 BACK"
                pixelSize: 20

                onClicked: {
                    root.btnBackClicked();
                }
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "BKVA"
        icon: StandardIcon.Information
        visible: false
    }

    MessageDialog {
        id: yesNoDialog
        icon: StandardIcon.Warning
        title: "BKVA"
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            if (action === "quit") {
                btnShutdownClicked();
            }
        }

        property string action: ""
    }
}
