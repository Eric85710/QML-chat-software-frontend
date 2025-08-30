//..Server_component/Server_list.qml
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Effects
import "../Style_component"

RowLayout{
    anchors.fill: parent

    //choosing_the_server in here
    ListView {
        id: servers_icon_list
        anchors.fill: parent
        model: [
            "qrc:/img/after-sunset.jpg",
            "qrc:/img/after-sunset.jpg",
            "qrc:/img/after-sunset.jpg"
        ]
        delegate: Round_img_avatar {
            width: 56
            height: 56
            radius: width / 2
            source: modelData
            anchors.horizontalCenter: parent.horizontalCenter
        }

        spacing: 12
        orientation: ListView.Vertical
        clip: true
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
