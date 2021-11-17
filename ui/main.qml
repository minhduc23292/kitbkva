import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.VirtualKeyboard 2.0
import QtQuick.Dialogs 1.1

import './components'

Window {
    id: window
    visible: true
    width: 1280
    height: 720
    //    flags: "FramelessWindowHint"
    title: qsTr("BKVA")

    property real ratio: Math.min(window.width / itmMain.width, window.height / itmMain.height)

    signal btnTestConnectClicked(string _port, string _mode)
    signal testConnectionFinished(bool result)

    signal btnRunClicked(bool _isRunning)
    signal motorStarted()
    signal motorStopped()
    signal motorSettingsUpdated(string _port, int _accUnit, string _ratedPower, string _ratedFrequency, string _ratedVolgate)
    signal brakeSettingsUpdated(string _port, string _ratedTorque, string _ratedVolgate)
    signal motorParametersUpdated(int _type, string _max, string _min, string _interval)
    signal brakeParametersUpdated(int _type, string _max, string _min, string _interval)

    Component.onCompleted: {
        //        window.showFullScreen();
    }

    onTestConnectionFinished: {
        if (result === true) {
            messageDialog.text = "Connection successful!";
        } else {
            messageDialog.text = "Connection failed!";
        }

        messageDialog.visible = true;
    }

    onMotorStarted: {
        actionTab.isRunning = true;
    }

    onMotorStopped: {
        actionTab.isRunning = false;
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        onActiveChanged: {
            if (!inputPanel.active) {
                itmContent.changePosition(0, 0);
            }
        }

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }

        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Item {
        id: itmMain
        width: 1280
        height: 720
        anchors.centerIn: parent
        scale: ratio

        Item {
            id: itmContent
            width: 1280
            height: 720

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    forceActiveFocus();
                }
            }

            ActionTab {
                id: actionTab
                anchors.fill: parent

                onTextEditFocus: {
                    itmContent.changePosition(_yPos, _height);
                }

                onBtnSettingsClicked: {
                    actionTab.visible = false
                    settingsTab.visible = true
                }

                onBtnManualClicked: {
                    actionTab.visible = false
                    manualTab.visible = true
                }

                onBtnRunClicked: {
                    if (actionTab.isRunning) {
                        window.motorSettingsUpdated(settingsTab.motorSettings.port, settingsTab.motorSettings.accUnit, settingsTab.motorSettings.ratedPower, settingsTab.motorSettings.ratedFrequency, settingsTab.motorSettings.ratedVolgate);
                        window.brakeSettingsUpdated(settingsTab.brakeSettings.port, settingsTab.brakeSettings.ratedTorque, settingsTab.brakeSettings.ratedVolgate);

                        switch (actionTab.motorParams.type) {
                        case 0:
                            window.motorParametersUpdated(actionTab.motorParams.type, actionTab.motorParams.constantValue.toString(), actionTab.motorParams.constantValue.toString(), '1');
                            break;

                        case 1:
                            window.motorParametersUpdated(actionTab.motorParams.type, actionTab.motorParams.zigzagMax.toString(), actionTab.motorParams.zigzagMin.toString(), actionTab.motorParams.zigzagInterval.toString());
                            break;

                        case 2:
                            window.motorParametersUpdated(actionTab.motorParams.type, actionTab.motorParams.sinMax.toString(), actionTab.motorParams.sinMin.toString(), actionTab.motorParams.sinInterval.toString());
                            break;

                        default:
                            break;
                        }

                        switch (actionTab.brakeParams.type) {
                        case 0:
                            window.brakeParametersUpdated(actionTab.brakeParams.type, actionTab.brakeParams.constantValue.toString(), actionTab.brakeParams.constantValue.toString(), '1');
                            break;

                        case 1:
                            window.brakeParametersUpdated(actionTab.brakeParams.type, actionTab.brakeParams.zigzagMax.toString(), actionTab.brakeParams.zigzagMin.toString(), actionTab.brakeParams.zigzagInterval.toString());
                            break;

                        case 2:
                            window.brakeParametersUpdated(actionTab.brakeParams.type, actionTab.brakeParams.sinMax.toString(), actionTab.brakeParams.sinMin.toString(), actionTab.brakeParams.sinInterval.toString());
                            break;

                        default:
                            break;
                        }
                    }
                    window.btnRunClicked(actionTab.isRunning);
                }
            }

            SettingsTab {
                id: settingsTab
                anchors.fill: parent
                visible: false
                isEnabled: !actionTab.isRunning

                onTextEditFocus: {
                    itmContent.changePosition(_yPos, _height);
                }

                onBtnTestConnectClicked: {
                    if (_mode == 'motor') {
                        motor_control.test_connection(_port);
                    }
                    // window.btnTestConnectClicked(_port, _mode);
                }

                onBtnBackClicked: {
                    actionTab.visible = true;
                    settingsTab.visible = false;
                    //                    if (!actionTab.isRunning) {
                    //                        window.connectSettingsUpdated(settingsTab.connectSettings.port, parseInt(settingsTab.connectSettings.baud), parseInt(settingsTab.connectSettings.dataBits), parseInt(settingsTab.connectSettings.stopBits), settingsTab.connectSettings.parity);
                    //                    }
                }

                onBtnShutdownClicked: {
                    Qt.quit();
                }
            }

            ManualTab {
                id: manualTab
                anchors.fill: parent
                visible: false

                onTextEditFocus: {
                    itmContent.changePosition(_yPos, _height);
                }

                onBtnMotorConnectClicked: {
                    motor_control.connect(settingsTab.motorSettings.port);
                }

                onBtnMotorDisconnectClicked: {
                    motor_control.disconnect();
                }

                onBtnMotorRunClicked: {
                    motor_control.run_manual();
                }

                onBtnMotorPauseClicked: {
                    motor_control.pause_manual();
                }

                onBtnMotorUpdateFrequencyClicked: {
                    motor_control.update_frequency(_frequency);
                }

                onBtnBackClicked: {
                    actionTab.visible = true;
                    manualTab.visible = false;
                }
            }

            MessageDialog {
                id: messageDialog
                title: "BKVA"
                icon: StandardIcon.Information
                visible: false
            }

            NumberAnimation on y {
                id: positionAnimation
                duration: 250
                easing.type: Easing.InOutQuad
            }

            function changePosition(_yPos, _height) {
                console.log(_yPos, _height)
                let emptyHeight = (window.height - inputPanel.height) / window.ratio;
                let newYPos;
                if (_yPos + _height / 2 <= emptyHeight / 2) {
                    newYPos = 0;
                } else {
                    newYPos = emptyHeight / 2 - _yPos - _height / 2;
                }

                if (newYPos !== itmContent.y) {
                    positionAnimation.to = newYPos;
                    positionAnimation.start();
                }
            }
        }
    }

    Connections {
        target: motor_control

        function onConnectionFinished(result) {
            if (result == true) {
                messageDialog.text = "Connection successful!";
            } else {
                messageDialog.text = "Connection failed!";
            }

            messageDialog.visible = true;
        }

        function onErrorOccurred(error) {
            messageDialog.text = error;
            messageDialog.visible = true;
        }
    }
}
