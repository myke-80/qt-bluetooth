TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += src/main.cpp

RESOURCES += src/qml.qrc \
    resources/qt-bt-scanner.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = 

# Default rules for deployment.
include(src/deployment.pri)

