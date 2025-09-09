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
            ListElement { serverID: "add_server"; name: "日落伺服器"; icon: "qrc:/svg_icon/plus-circle-svgrepo-com.svg"; unread: 3 }
            ListElement { serverID: "server1"; name: "日落伺服器"; icon: "qrc:/img/after-sunset.jpg"; unread: 3 }
            ListElement { serverID: "server2"; name: "個人空間"; icon: "qrc:/img/avatar.png"; unread: 0 }
            ListElement { serverID: "server3"; name: "開發群組"; icon: "qrc:/img/after-sunset.jpg"; unread: 12 }
        }



        delegate: Item {
            width: 56
            height: 56


            Round_img_avatar {
                id: per_avatar
                width: parent.width
                height: parent.height
                radius: width / 2
                source: model.icon
                x: current_server === model.serverID ? 14 : (servers_icon_list.width - width) / 2
                Behavior on x {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }

                transform: Scale {
                    id: avatarScale
                    origin.x: per_avatar.width / 2
                    origin.y: per_avatar.height / 2
                    xScale: current_server === model.serverID ? 0.714 : 1.0
                    yScale: current_server === model.serverID ? 0.714 : 1.0
                }

                Behavior on transform {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        current_server = model.serverID
                        serverSelected(model.serverID)



                        let mappedPos = per_avatar.mapToItem(servers_icon_list, 0, 0)
                        current_server_position = Qt.point(mappedPos.x, mappedPos.y + 105)
                        console.log("Mapped Y:", current_server_position.y)
                    }
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

        Component.onCompleted: {
            if (servers_icon_list.model.count > 0) {
                Qt.callLater(function() {
                    const firstServer = servers_icon_list.model.get(0)
                    current_server = firstServer.serverID

                    let firstDelegate = servers_icon_list.contentItem.children[0]
                    if (firstDelegate) {
                        let mappedPos = firstDelegate.mapToItem(servers_icon_list, 0, 0)
                        current_server_position = Qt.point(mappedPos.x, mappedPos.y + 105)
                    }

                    serverSelected(firstServer.serverID)
                })
            }
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
                    relativeControl1X: -60
                    relativeControl2X: -60
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
