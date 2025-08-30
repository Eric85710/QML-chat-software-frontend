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
        model: [
            "qrc:/img/after-sunset.jpg",
            "qrc:/img/avatar.png",
            "qrc:/img/after-sunset.jpg"
        ]
        delegate: Round_img_avatar {
            width: 56
            height: 56
            radius: width / 2
            source: modelData
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("你點了：", modelData)
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
