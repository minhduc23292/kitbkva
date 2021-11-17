import sys
import os

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

import motor

os.environ["QT_IM_MODULE"] = "qtvirtualkeyboard"

app = QGuiApplication(sys.argv)
app.setOrganizationName("bkva")
app.setOrganizationDomain("bkva.vn")

motor_control = motor.Motor()

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.rootContext().setContextProperty('motor_control', motor_control)
engine.load('ui/main.qml')

sys.exit(app.exec())