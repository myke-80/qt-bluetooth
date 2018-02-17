QT = core bluetooth quick
SOURCES += src/qmlscanner.cpp

TARGET = qml_scanner
TEMPLATE = app

RESOURCES += \
    scanner.qrc

OTHER_FILES += \
    src/scanner.qml \
    src/Button.qml \
    src/default.png

#DEFINES += QMLJSDEBUGGER

INSTALLS += target
