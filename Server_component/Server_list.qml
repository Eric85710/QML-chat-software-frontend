//..Server_component/Server_list.qml
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import "../Style_component"
import "Server_function_block_component"

RowLayout{
    anchors.fill: parent
    signal serverSelected(string serverID)
    property string current_server: ""
    property var current_server_position



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
            id: per_avatar
            width: 56
            height: 56
            radius: width / 2
            source: model.icon

            x: current_server === model.serverID
                ? (servers_icon_list.width - width) / 2
                : (servers_icon_list.width - width)


            Behavior on x {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
            Behavior on width {
                NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
            }
            Behavior on height {
                NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("你點了：", model.name, model.serverID)
                    current_server = model.serverID
                    serverSelected(model.serverID)

                    current_server_position = Qt.point(per_avatar.x, per_avatar.y + 128)
                    console.log("座標是：", current_server_position)
                }
                hoverEnabled: true
                onEntered: {
                    parent.width = 58
                    parent.height = 58
                }
                onExited: {
                    parent.width = 56
                    parent.height = 56
                }
            }
        }


        spacing: 20
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
        color: "transparent"


        //background color
        Shape {
            id: wave_sh
            width: parent.width
            height: parent.heights


            ShapePath {
                strokeWidth: 2
                strokeColor: Qt.rgba(0.2, 0.2, 0.4, 0.1)
                fillColor: Qt.rgba(0.2, 0.2, 0.2, 0.4)

                startX: 12; startY: 0

                //right
                PathLine { x:server_function_block.width - 12;  y:0}

                //radius top right
                PathQuad {
                    x:server_function_block.width
                    y:12
                    relativeControlX: 12
                    relativeControlY: 0
                }

                //down
                PathLine { x:server_function_block.width; y:server_function_block.height -12}

                //radius bottom right
                PathQuad {
                    relativeX: -12
                    relativeY: 12
                    relativeControlY: 12
                    relativeControlX: 0
                }

                //left
                PathLine { x: 12; y: server_function_block.height }

                //radius bottom left
                PathQuad {
                    relativeX: -12
                    relativeY: -12
                    relativeControlX: -12
                    relativeControlY: 0
                }


                //line to wave
                //define wave position in here
                PathLine { relativeX: 0; y: current_server_position.y }










                //wave_path1
                PathQuad {
                    relativeX: -12
                    relativeY: -44
                    relativeControlX: 0
                    relativeControlY: -12
                }

                //wave center
                PathCubic {
                    relativeX: 0
                    relativeY: -80
                    relativeControl1X: -68
                    relativeControl2X: -68
                    relativeControl1Y: 0
                    relativeControl2Y: -80
                }

                //wave_path2
                PathQuad {
                    relativeX: 12
                    relativeY: -44
                    relativeControlX: 12
                    relativeControlY: -6
                }











                //up
                PathLine { x: 0; y: 12}

                //radius
                PathQuad {
                    x: 12
                    y: 0
                    relativeControlX: 0
                    relativeControlY: -12
                }
            }
        }











        Loader {
            id: server_function_ContentLoader
            anchors.fill: parent
            sourceComponent: {
                switch (current_server) {
                    case "server1": return server1_function_area
                    case "server2": return server2_function_area
                    case "server3": return Server3Content
                    default: return DefaultServerContent
                }
            }
        }

        Component {
            id: server1_function_area
            Server1_function_block {}
        }

        Component {
            id: server2_function_area
            Server2_function_block {}
        }

    }
}
