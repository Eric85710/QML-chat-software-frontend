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
        Layout.preferredWidth: 68
        Layout.fillHeight: true
        model: ListModel {
            ListElement { serverID: "server1"; name: "日落伺服器"; icon: "qrc:/img/after-sunset.jpg"; unread: 3 }
            ListElement { serverID: "server2"; name: "個人空間"; icon: "qrc:/img/avatar.png"; unread: 0 }
            ListElement { serverID: "server3"; name: "開發群組"; icon: "qrc:/img/after-sunset.jpg"; unread: 12 }
        }
        delegate: Round_img_avatar {
            width: 56
            height: 56
            radius: width / 2
            source: model.icon
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("你點了：", model.name, model.serverID)
                }
            }
        }

        spacing: 16
        orientation: ListView.Vertical
        clip: true

        header: Item {
            width: servers_icon_list.width
            height: 16 // 你想要的間距高度
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
