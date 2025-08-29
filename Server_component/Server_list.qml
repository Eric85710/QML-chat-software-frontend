//..Server_component/Server_list.qml
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Effects

RowLayout{
    anchors.fill: parent

    Rectangle {
        id:servers_choosing_block
        Layout.preferredWidth: 68
        Layout.fillHeight: true
        color: "transparent"
    }

    Rectangle {
        id:server_function_block
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: 12
        color: "black"
        opacity: 0.2
    }
}
