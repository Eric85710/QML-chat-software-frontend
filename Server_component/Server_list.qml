//..Server_component/Server_list.qml
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "../Style_component"

RowLayout{
    anchors.fill: parent

    //choosing_the_server in here
    Rectangle {
        id:servers_choosing_block
        Layout.preferredWidth: 68
        Layout.fillHeight: true
        color: "transparent"

        Column {
            id:servers_icon_list

            Round_img_avatar {
                width: 56
                height: 56
                radius: width / 2
                source: "qrc:/img/after-sunset.jpg"
            }
        }
    }










    Rectangle {
        id:server_function_block
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: 12
        color: "black"
        opacity: 0.4
    }
}
