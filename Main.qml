import QtQuick
import QtQuick.Window
import QtQuick.Controls

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    background: Image {
        id: bg1
        source: "qrc:/img/after-sunset.jpg"
    }
}
