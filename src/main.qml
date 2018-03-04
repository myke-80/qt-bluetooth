import QtQuick 2.3
import QtQuick.Window 2.2
import QtBluetooth 5.3

Window
{
    width: 200
    height: 200
    title: "Qt-Quick-Test"
    visible: true
    visibility: Window.FullScreen

    property BluetoothService currentService

    FontLoader
    {
        id: myTahoma;
        source: "/font/tahoma.ttf"
        onStatusChanged: if (loader.status === FontLoader.Ready) console.log('Loaded')
    }

    BluetoothDiscoveryModel
    {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onDiscoveryModeChanged:
        {
            txStatus.text = qsTr("Discovery mode: " + discoveryMode);
            console.log("Discovery mode: " + discoveryMode);
        }
        onServiceDiscovered:
        {
            txStatus.text = qsTr("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
            console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
        }
        onDeviceDiscovered:
        {
            txStatus.text = qsTr("New device: " + device);
            console.log("New device: " + device)
        }
        onErrorChanged:
        {
            switch (btModel.error)
            {
            case BluetoothDiscoveryModel.PoweredOffError:
                txStatus.text = qsTr("Error: Bluetooth device not turned on")
                console.log("Error: Bluetooth device not turned on");
                break;
            case BluetoothDiscoveryModel.InputOutputError:
                txStatus.text = qsTr("Error: Bluetooth I/O Error")
                console.log("Error: Bluetooth I/O Error");
                break;
            case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                txStatus.text = qsTr("Error: Invalid Bluetooth Adapter Error")
                console.log("Error: Invalid Bluetooth Adapter Error");
                break;
            case BluetoothDiscoveryModel.NoError:
                txStatus.text = qsTr("All is fine")
                console.log("No error");
                break;
            default:
                txStatus.text = qsTr("Error: Unknown Error")
                console.log("Error: Unknown Error"); break;
            }
        }
    }

    Item
    {
        focus: true
        Keys.onEscapePressed:
        {
            event.accepted = true;
            Qt.quit();
        }
    }

    Rectangle
    {
        id: rctMainContainer
        color: "#e3fab3"
        border.color: "#037724"
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        anchors.fill: parent

        Rectangle
        {
            id: rctStatus
            y: 159
            height: 21
            color: "#cdf677"
            border.color: "#a4f006"
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1

            Text
            {
                id: txStatus
                x: 5
                y: -139
                text: qsTr("")
                styleColor: "#000000"
                font.family: myTahoma.name
                anchors.top: parent.top
                anchors.topMargin: 2
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pixelSize: 15
            }
        }

        Rectangle
        {
            id: rctListView
            color: "#00000000"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.bottom: rctStatus.top
            anchors.bottomMargin: 1
            anchors.top: parent.top
            anchors.topMargin: 1

            ListView
            {
                id: btList
                width: 178
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5

                clip: true

                model: btModel
                delegate: Rectangle
                {
                    id: btDelegate
                    width: parent.width
                    height: column.height + 10

                    property bool expended: false;
                    clip: true
                    color: "#00000000"

                    Column
                    {
                        id: column

                        Text
                        {
                            id: bttext
                            text: deviceName ? deviceName : name
                            font.family: myTahoma.name
                            font.pixelSize: 15
                        }

                        Text
                        {
                            id: details

                            function get_details(s)
                            {
                                if (btModel.discoveryMode == BluetoothDiscoveryModel.DeviceDiscovery)
                                {
                                    return "Address: " + remoteAddress;
                                }
                                else
                                {
                                    var str = "Address: " + s.deviceAddress;
                                    if (s.serviceName) { str += "<br>Service: " + s.serviceName; }
                                    if (s.serviceDescription) { str += "<br>Description: " + s.serviceDescription; }
                                    if (s.serviceProtocol) { str += "<br>Protocol: " + s.serviceProtocol; }
                                    return str;
                                }
                            }

                            visible: opacity !== 0
                            opacity: btDelegate.expended ? 1 : 0.0
                            text: get_details(service)
                            font.family: myTahoma.name
                            font.pixelSize: 13

                            Behavior on opacity
                            {
                                NumberAnimation { duration: 200}
                            }
                        }
                    }

                    Behavior on height
                    {
                        NumberAnimation { duration: 200}
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: btDelegate.expended = !btDelegate.expended
                    }
                }

                focus: true
            }
        }
    }
}

