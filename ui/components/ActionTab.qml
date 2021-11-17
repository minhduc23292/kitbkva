import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.1

Item {
    id: root
    anchors.fill: parent

    property alias motorParams: motorParams
    property alias brakeParams: brakeParams

    property bool isRunning: false
    signal btnSettingsClicked()
    signal btnManualClicked()
    signal textEditFocus(real _yPos, real _height)
    signal btnRunClicked()

    Settings {
        id: motorParams
        category: "motor_params"

        property alias type: hdrMotor.currentIndex
        property double constantValue: 25
        property double zigzagMax: 50
        property double zigzagMin: 10
        property double zigzagInterval: 10
        property double sinMax: 50
        property double sinMin: 10
        property double sinInterval: 10
    }

    Settings {
        id: brakeParams
        category: "brake_params"

        property alias type: hdrBrake.currentIndex
        property double constantValue: 2
        property double zigzagMax: 5
        property double zigzagMin: 1
        property double zigzagInterval: 10
        property double sinMax: 5
        property double sinMin: 1
        property double sinInterval: 10
    }

    GridLayout {
        id: grlLayout
        anchors.fill: parent
        anchors.margins: 15

        rows: 3
        columns: 2
        rowSpacing: 10
        columnSpacing: 10

        ActHeader {
            id: hdrMotor
            Layout.row: 0
            Layout.column: 0
            Layout.fillHeight: true
            Layout.preferredHeight: Layout.rowSpan

            width: 150
            imageSource: "../asset/motor.png"
            model: ListModel {
                ListElement { uid: "constant"; image: "../asset/constant.png" }
                ListElement { uid: "zigzag"; image: "../asset/zigzag.png" }
                ListElement { uid: "sin"; image: "../asset/sin.png" }
            }
            textRole: "image"
            enabled: !root.isRunning

            onCurrentIndexChanged: {
                chtMotor.updateParams(motorParams);
                chtMotor.paramState = hdrMotor.model.get(hdrMotor.currentIndex).uid;
                chtMotor.initParamChart(chtMotor.paramState);
            }
        }

        ActChart {
            id: chtMotor
            Layout.row: 0
            Layout.column: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: Layout.columnSpan
            Layout.preferredHeight: Layout.rowSpan

            seriName: "Frequency"
            state: "param"
            paramState: "constant"
            unit: "(Hz)"

            onTextEditFocus: {
                root.textEditFocus(grlLayout.y + y + _yPos, _height);
            }

            Component.onCompleted: {
                chtMotor.updateParams(motorParams);
                chtMotor.initParamChart(chtMotor.paramState);
            }
        }

        ActHeader {
            id: hdrBrake
            Layout.row: 1
            Layout.column: 0
            Layout.fillHeight: true
            Layout.preferredHeight: Layout.rowSpan

            width: 150
            imageSource: "../asset/brake.png"
            model: ListModel {
                ListElement { uid: "constant"; image: "../asset/constant.png" }
                ListElement { uid: "zigzag"; image: "../asset/zigzag.png" }
                ListElement { uid: "sin"; image: "../asset/sin.png" }
            }
            textRole: "image"
            enabled: !root.isRunning

            onCurrentIndexChanged: {
                chtBrake.updateParams(brakeParams);
                chtBrake.paramState = hdrBrake.model.get(hdrBrake.currentIndex).uid;
                chtBrake.initParamChart(chtBrake.paramState);
            }
        }

        ActChart {
            id: chtBrake
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: Layout.columnSpan
            Layout.preferredHeight: Layout.rowSpan

            seriName: "Torque"
            state: "param"
            paramState: "constant"
            unit: "(Nm)"

            onTextEditFocus: {
                root.textEditFocus(grlLayout.y + y + _yPos, _height);
            }

            Component.onCompleted: {
                chtBrake.updateParams(brakeParams);
                chtBrake.initParamChart(chtBrake.paramState);
            }
        }

        Item {
            id: itmControl
            Layout.row: 2
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredWidth: Layout.columnSpan

            height: 50

            CButton {
                id: btnSettings
                width: 200
                height: parent.height
                content: "⚙️ SETTINGS"
                pixelSize: 20

                onClicked: root.btnSettingsClicked()
            }

            CButton {
                id: btnManual
                width: 200
                height: parent.height
                anchors.left: btnSettings.right
                anchors.leftMargin: 25
                content: "MANUAL"
                pixelSize: 20

                onClicked: root.btnManualClicked()
            }

            CButton {
                id: btnRun
                width: 200
                height: parent.height
                anchors.centerIn: parent
                content: "▶️ START"
                pixelSize: 20

                states: [
                    State {
                        name: "start"
                        PropertyChanges {
                            target: btnRun
                            content: "▶️ START"
                            color: "limegreen"
                        }
                    },

                    State {
                        name: "stop"
                        PropertyChanges {
                            target: btnRun
                            content: "■ STOP"
                            color: "red"
                        }
                    }
                ]

                onClicked: {
                    root.isRunning = !root.isRunning;
                    if (root.isRunning) {
                        if (!chtMotor.saveParams(motorParams)) {
                            root.isRunning = false;
                            messageDialog.text = "Please check motor parameters";
                            messageDialog.visible = true;
                            return;
                        }

                        if (!chtBrake.saveParams(brakeParams)) {
                            root.isRunning = false;
                            messageDialog.text = "Please check brake parameters";
                            messageDialog.visible = true;
                            return;
                        }

                        btnRun.state = "stop";
                        chtMotor.state = "chart";
                        chtBrake.state = "chart";
                        chtMotor.removeAllSeries();
                        chtBrake.removeAllSeries();
                    } else {
                        btnRun.state = "start";
                        chtMotor.state = "param";
                        chtBrake.state = "param";
                        chtMotor.initParamChart(chtMotor.paramState);
                        chtBrake.initParamChart(chtBrake.paramState);
                    }

                    root.btnRunClicked();
                }
            }

            CButton {
                id: btnLoadData
                width: 200
                height: parent.height
                anchors.right: parent.right
                content: "🗎 LOAD DATA"
                pixelSize: 20
                enabled: !root.isRunning
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "BKVA"
        icon: StandardIcon.Information
        visible: false
    }
}
