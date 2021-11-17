import QtQuick 2.9
import QtCharts 2.2

Item {
    id: root

    property alias paramState: itmParams.state
    property alias maxValue: tbxMax.value
    property alias minValue: tbxMin.value
    property alias interval: tbxInterval.value
    property int titleWidth: 100
    property int pixelSize: 20
    property string seriName
    property double xRange: 60
    property string unit: ""

    signal textEditFocus(real _yPos, real _height)

    Item {
        id: itmParams
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.right: root.right
        anchors.topMargin: 25
        anchors.rightMargin: 25
        width: 300
        state: "constant"

        ActTextBox {
            id: tbxMax
            y: 0
            titleWidth: root.titleWidth
            title: "Max:"
            value: "50"
            unit: root.unit
            pixelSize: root.pixelSize

            onTextEditFocus: {
                root.textEditFocus(itmParams.y + tbxMax.y + _yPos, _height);
            }

            onTextChanged: root.initParamChart(root.paramState)
        }

        ActTextBox {
            id: tbxMin
            y: 75
            titleWidth: root.titleWidth
            title: "Min:"
            value: "10"
            unit: root.unit
            pixelSize: root.pixelSize

            onTextEditFocus: {
                root.textEditFocus(itmParams.y + tbxMin.y + _yPos, _height);
            }

            onTextChanged: root.initParamChart(root.paramState)
        }

        ActTextBox {
            id: tbxInterval
            y: 150
            titleWidth: root.titleWidth
            title: "Interval:"
            value: "10"
            unit: "(s)"
            pixelSize: root.pixelSize

            onTextEditFocus: {
                root.textEditFocus(itmParams.y + tbxInterval.y + _yPos, _height);
            }

            onTextChanged: root.initParamChart(root.paramState)
        }

        states: [
            State {
                name: "constant"
                PropertyChanges {
                    target: tbxMax
                    title: "Value:"
                }
                PropertyChanges {
                    target: tbxMin
                    visible: false
                }
                PropertyChanges {
                    target: tbxInterval
                    visible: false
                }
            },
            State {
                name: "zigzag"
                PropertyChanges {
                    target: tbxMax
                    title: "Max:"
                }
                PropertyChanges {
                    target: tbxMin
                    visible: true
                }
                PropertyChanges {
                    target: tbxInterval
                    visible: true
                }
            },
            State {
                name: "sin"
                PropertyChanges {
                    target: tbxMax
                    title: "Max:"
                }
                PropertyChanges {
                    target: tbxMin
                    visible: true
                }
                PropertyChanges {
                    target: tbxInterval
                    visible: true
                }
            }
        ]
    }

    // ChartView {
    //     id: cvwChart
    //     anchors.fill: parent
    //     anchors.rightMargin: itmParams.width + 25
    //     antialiasing: true

    //     property LineSeries series

    //     ValueAxis {
    //         id: axisX
    //         min: 0
    //         max: root.xRange
    //         gridVisible: true
    //     }

    //     ValueAxis {
    //         id: axisY
    //         gridVisible: true
    //         tickCount: 5
    //         min: root.getYMin(root.minValue, root.maxValue)
    //         max: root.getYMax(root.minValue, root.maxValue)
    //     }
    // }

    // states: [
    //     State {
    //         name: "chart"
    //         PropertyChanges {
    //             target: cvwChart
    //             anchors.rightMargin: 0
    //         }
    //     },

    //     State {
    //         name: "param"
    //         PropertyChanges {
    //             target: cvwChart
    //             anchors.rightMargin: itmParams.width + 25
    //         }
    //     }
    // ]

    // transitions: [
    //     Transition {
    //         from: "chart"
    //         to: "param"
    //         reversible: true
    //         ParallelAnimation {
    //             NumberAnimation {
    //                 target: cvwChart
    //                 properties: "anchors.rightMargin"
    //                 duration: 250
    //                 easing.type: Easing.InOutQuad
    //             }
    //         }
    //     },

    //     Transition {
    //         from: "param"
    //         to: "chart"
    //         reversible: true
    //         ParallelAnimation {
    //             NumberAnimation {
    //                 target: cvwChart
    //                 properties: "anchors.rightMargin"
    //                 duration: 250
    //                 easing.type: Easing.InOutQuad
    //             }
    //         }
    //     }
    // ]

    function getYMin(min, max) {
        let _min = parseFloat(min);
        let _max = parseFloat(max);
        if (isNaN(_min)) {
            return 0;
        }

        if (isNaN(_max)) {
            return Math.max(0, _min * 4 / 5);
        }

        return (_min - (_max - _min) / 5) < 0 ? 0 : _min - (_max -_min) / 5;
    }

    function getYMax(min, max) {
        let _min = parseFloat(min);
        let _max = parseFloat(max);
        if (isNaN(_max)) {
            return 10;
        }

        if (isNaN(_min)) {
            return _max * 6 / 5;
        }

        return _max + (_max - _min) / 5;
    }

    function updateParams(params) {
        switch (params.type) {
        case 0:
            root.maxValue = params.constantValue.toString();
            root.minValue = '0';
            root.interval = '10';
            break;

        case 1:
            root.maxValue = params.zigzagMax.toString();
            root.minValue = params.zigzagMin.toString();
            root.interval = params.zigzagInterval.toString();
            break;

        case 2:
            root.maxValue = params.sinMax.toString();
            root.minValue = params.sinMin.toString();
            root.interval = params.sinInterval.toString();
            break;
        }
    }

    function saveParams(params) {
        switch (params.type) {
        case 0:
            if (!tbxMax.checkIsNumber()) {
                return false;
            }

            let _constantValue = parseFloat(root.maxValue);
            if (_constantValue < 0) {
                return false;
            }

            params.constantValue = _constantValue;
            root.maxValue = _constantValue.toString();
            return true;

        case 1:
            if (!tbxMax.checkIsNumber() || !tbxMin.checkIsNumber() || !tbxInterval.checkIsNumber()) {
                return false;
            }

            let _zigzagMax = parseFloat(root.maxValue);
            let _zigzagMin = parseFloat(root.minValue);
            let _zigzagInterval = parseFloat(root.interval);
            if (_zigzagMin < 0 || _zigzagMax <= _zigzagMin || _zigzagInterval <= 0) {
                return false;
            }

            params.zigzagMax = _zigzagMax;
            root.maxValue = _zigzagMax.toString();
            params.zigzagMin = _zigzagMin;
            root.minValue = _zigzagMin.toString();
            params.zigzagInterval = _zigzagInterval;
            root.interval = _zigzagInterval.toString();
            return true;

        case 2:
            if (!tbxMax.checkIsNumber() || !tbxMin.checkIsNumber() || !tbxInterval.checkIsNumber()) {
                return false;
            }

            let _sinMax = parseFloat(root.maxValue);
            let _sinMin = parseFloat(root.minValue);
            let _sinInterval = parseFloat(root.interval);
            if (_sinMin < 0 || _sinMax <= _sinMin || _sinInterval <= 0) {
                return false;
            }

            params.sinMax = _sinMax;
            root.maxValue = _sinMax.toString();
            params.sinMin = _sinMin;
            root.minValue = _sinMin.toString();
            params.sinInterval = _sinInterval;
            root.interval = _sinInterval.toString();
            return true;

        default:
            return false;
        }
    }

    function removeAllSeries() {
        // cvwChart.removeAllSeries();
    }

    function initSeries() {
        // cvwChart.series = cvwChart.createSeries(ChartView.SeriesTypeLine, root.seriName, axisX, axisY);
        // axisX.max = root.xRange;
        // axisX.min = 0;
    }

    function appendData(x, y) {
        // cvwChart.series.append(x, y);
        // if (x > root.xRange) {
        //     axisX.max = x;
        //     axisX.min = x - root.xRange;
        // }
    }

    function initParamChart(param_state) {
        removeAllSeries();
        initSeries();
        var x;
        var y;
        var _max_value = parseFloat(root.maxValue);
        var _min_value = parseFloat(root.minValue);
        var _interval = parseFloat(root.interval);

        if (isNaN(_max_value) || isNaN(_min_value) || isNaN(_interval) || _min_value < 0 || _max_value < _min_value || _interval <= 0) {
            return;
        }

        if (param_state === 'constant') {
            appendData(0, _max_value);
            appendData(xRange, _max_value);
        } else if (param_state === 'zigzag') {
            x = 0;
            while (x < root.xRange) {
                appendData(x, _min_value);
                if (x + _interval / 2 <= root.xRange) {
                    x += _interval / 2;
                    appendData(x, _max_value);
                } else {
                    y = _min_value + (_max_value - _min_value) * (root.xRange - x) / _interval * 2;
                    appendData(root.xRange, y);
                    break;
                }

                if (x + _interval / 2 <= root.xRange) {
                    x += _interval / 2;
                    appendData(x, _min_value);
                } else {
                    y = _max_value - (_max_value - _min_value) * (root.xRange - x) / _interval * 2;
                    appendData(root.xRange, y);
                    break;
                }
            }
        } else if (param_state === 'sin') {
            x = 0;
            while (x < root.xRange) {
                y = _min_value + (_max_value - _min_value) / 2 * (1 + Math.sin(2 * Math.PI / _interval * x - Math.PI / 2));
                appendData(x, y);
                x += Math.max(_interval / 100, 0.1);
            }
        }
    }
}
