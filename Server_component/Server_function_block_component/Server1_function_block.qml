//Server1_function_block.qml
import QtQuick
import QtQuick.Layouts


ColumnLayout {
    anchors.fill: parent

    Text {
        id: server1_function_text
        color: "white"
        font.pixelSize: 20
        text: "Server1"
        Layout.alignment: Qt.AlignHCenter
    }

    Rectangle {
        width: 60
        height: 40
        radius: 12
        Layout.alignment: Qt.AlignHCenter
    }
}
