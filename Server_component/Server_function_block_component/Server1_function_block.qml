//Server1_function_block.qml
import QtQuick
import QtQuick.Layouts


Column {
    anchors.fill: parent
    spacing: 10


    Rectangle {
        id: server_name_text_container
        width: parent.width
        height: 60
        color: "#555"
        Text {
            id: server_name_text
            text: qsTr("PC孤兒")
            font.bold: true
        }
    }

    Rectangle {
        width: 60
        height: 40
        radius: 12
        color: "#555"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        width: 60
        height: 40
        radius: 12
        color: "#777"
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
