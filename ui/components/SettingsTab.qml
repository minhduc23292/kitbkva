import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.1

Item {
    id: root
    anchors.fill: parent

    property alias motorSettings: motorSettings
    property alias brakeSettings: brakeSettings

    property int titleWidth: 225
    property int pixelSize: 20
    property bool isEnabled: true

    signal textEditFocus(real _yPos, real _height)
    signal btnTestConnectClicked(string _port, string _mode)
    signal btnBackClicked()
    signal btnShutdownClicked()

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
                category: "motor_settings"                

                property alias port: cbbMotorPort.currentText
                property alias portIndex: cbbMotorPort.currentIndex
                property alias accUnit: cbbMotorUnitAcc.currentIndex
                property alias ratedPower: tbxMotorRatedPower.value
                property alias ratedFrequency: tbxMotorRatedFrequency.value
                property alias ratedVolgate: tbxMotorRatedVolgate.value
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
                enabled: root.isEnabled

                SetComboBox {
                    id: cbbMotorPort
                    y: 0
                    titleWidth: root.titleWidth
                    title: "Port:"
                    model: ["COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9"]
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize
                }

                SetComboBox {
                    id: cbbMotorUnitAcc
                    y: cbbMotorPort.y + 75
                    titleWidth: root.titleWidth
                    title: "Unit of acc/dec time:"
                    model: ["1s", "0.1s", "0.01s"]
                    currentIndex: 2
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize
                }

                SetTextBox {
                    id: tbxMotorRatedPower
                    y: cbbMotorUnitAcc.y + 75
                    titleWidth: root.titleWidth
                    title: "Rated power (kW):"
                    value: "0.8"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize

                    onTextEditFocus: {
                        root.textEditFocus(grlLayout.y + itmMotor.y + itmMotorParams.y + y + _yPos, _height);
                    }
                }

                SetTextBox {
                    id: tbxMotorRatedFrequency
                    y: tbxMotorRatedPower.y + 75
                    titleWidth: root.titleWidth
                    title: "Rated frequency (Hz):"
                    value: "50.00"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize

                    onTextEditFocus: {
                        root.textEditFocus(grlLayout.y + itmMotor.y + itmMotorParams.y + y + _yPos, _height);
                    }
                }

                SetTextBox {
                    id: tbxMotorRatedVolgate
                    y: tbxMotorRatedFrequency.y + 75
                    titleWidth: root.titleWidth
                    title: "Rated volgate (V):"
                    value: "220"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize

                    onTextEditFocus: {
                        root.textEditFocus(grlLayout.y + itmMotor.y + itmMotorParams.y + y + _yPos, _height);
                    }
                }

                Item {
                    y: tbxMotorRatedVolgate.y + 75
                    height: 50
                    anchors.left: parent.left
                    anchors.right: parent.right

                    CButton {
                        id: btnMotorTestConnect
                        width: 250
                        height: parent.height
                        anchors.centerIn: parent
                        content: "🔗 TEST CONNECT"
                        pixelSize: 20

                        onClicked: btnTestConnectClicked(motorSettings.port, "motor")
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

            Settings {
                id: brakeSettings
                category: "brake_settings"

                property alias port: cbbBrakePort.currentText
                property alias portIndex: cbbBrakePort.currentIndex
                property alias ratedTorque: tbxBrakeRatedTorque.value
                property alias ratedVolgate: tbxBrakeRatedVolgate.value
            }

            SetHeader {
                id: hdrBrake
                anchors.left: parent.left
                anchors.right: parent.right
                imageSource: "../asset/brake.png"
                header: "BRAKE"
            }

            Item {
                id: itmBrakeParams
                anchors.fill: parent
                anchors.topMargin: 150
                enabled: root.isEnabled

                SetComboBox {
                    id: cbbBrakePort
                    y: 0
                    titleWidth: root.titleWidth
                    title: "Port:"
                    model: ["COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9"]
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize
                }

                SetTextBox {
                    id: tbxBrakeRatedTorque
                    y: cbbBrakePort.y + 75
                    titleWidth: root.titleWidth
                    title: "Rated torque (Nm):"
                    value: "6"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize

                    onTextEditFocus: {
                        root.textEditFocus(grlLayout.y + itmBrake.y + itmBrakeParams.y + y + _yPos, _height);
                    }
                }

                SetTextBox {
                    id: tbxBrakeRatedVolgate
                    y: tbxBrakeRatedTorque.y + 75
                    titleWidth: root.titleWidth
                    title: "Rated volgate (V):"
                    value: "24"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    pixelSize: root.pixelSize

                    onTextEditFocus: {
                        root.textEditFocus(grlLayout.y + itmBrake.y + itmBrakeParams.y + y + _yPos, _height);
                    }
                }

                Item {
                    y: tbxBrakeRatedVolgate.y + 75
                    height: 50
                    anchors.left: parent.left
                    anchors.right: parent.right

                    CButton {
                        id: btnBrakeTestConnect
                        width: 250
                        height: parent.height
                        anchors.centerIn: parent
                        content: "🔗 TEST CONNECT"
                        pixelSize: 20

                        onClicked: btnTestConnectClicked(brakeSettings.port, "brake")
                    }
                }
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
                    if (!root.saveMotorSettings()) {
                        messageDialog.text = "Please check motor parameters";
                        messageDialog.visible = true;
                        return;
                    }

                    if (!root.saveBrakeSettings()) {
                        messageDialog.text = "Please check brake parameters";
                        messageDialog.visible = true;
                        return;
                    }

                    root.btnBackClicked();
                }
            }

            CButton {
                id: btnAssembly
                width: 200
                height: parent.height
                anchors.centerIn: parent
                content: "ASSEMBLY"
                pixelSize: 20
                enabled: root.isEnabled
            }

            CButton {
                id: btnShutdown
                width: 200
                height: parent.height
                anchors.right: parent.right
                content: "SHUTDOWN"
                pixelSize: 20
                color: "red"
                enabled: root.isEnabled

                onClicked: {
                    yesNoDialog.text = "Do you want to shutdown your device?";
                    yesNoDialog.action = "quit";
                    yesNoDialog.visible = true;
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

    function saveMotorSettings() {
        if (!tbxMotorRatedPower.checkIsNumber() || !tbxMotorRatedFrequency.checkIsNumber() || !tbxMotorRatedVolgate.checkIsNumber()) {
            return false;
        }

        motorSettings.ratedPower = parseFloat(motorSettings.ratedPower).toString();
        motorSettings.ratedFrequency = parseFloat(motorSettings.ratedFrequency).toString();
        motorSettings.ratedVolgate = parseFloat(motorSettings.ratedVolgate).toString();
        return true;
    }

    function saveBrakeSettings() {
        if (!tbxBrakeRatedTorque.checkIsNumber() || !tbxBrakeRatedVolgate.checkIsNumber()) {
            return false;
        }

        brakeSettings.ratedTorque = parseFloat(brakeSettings.ratedTorque).toString();
        brakeSettings.ratedVolgate = parseFloat(brakeSettings.ratedVolgate).toString();
        return true;
    }
}
