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
    property real animWaveY: 0
    property real waveDepth: 0
    property real serverListWidth: 68
    property real serverIconSize: 56
    property real serverIconX: (serverListWidth - serverIconSize) / 2
    property real selectedIconRadius: serverIconSize / 2
    property real waveHalfHeight: selectedIconRadius * 1.5
    property real waveActiveDepth: selectedIconRadius * 0.5


    property bool waveAnimated: false


    Behavior on animWaveY {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on waveDepth {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }


    onCurrent_server_positionChanged: {
        if (!current_server_position) {
            return
        }

        animWaveY = current_server_position.y

        if (!waveAnimated) {
            waveDepth = 0
            return
        }

        waveDepth = waveActiveDepth
    }






    //choosing_the_server in here
    ListView {
        id: servers_icon_list
        Layout.preferredWidth: serverListWidth
        Layout.fillHeight: true
        model: ListModel {
            ListElement { serverID: "add_server"; name: "日落伺服器"; icon: "qrc:/svg_icon/plus-circle-svgrepo-com.svg"; unread: 3 }
            ListElement { serverID: "server1"; name: "日落伺服器"; icon: "qrc:/img/after-sunset.jpg"; unread: 3 }
            ListElement { serverID: "server2"; name: "個人空間"; icon: "qrc:/img/avatar.png"; unread: 0 }
            ListElement { serverID: "server3"; name: "開發群組"; icon: "qrc:/img/after-sunset.jpg"; unread: 12 }
        }



        delegate: Item {
            width: serverIconSize
            height: serverIconSize




            Round_img_avatar {
                id: per_avatar
                width: parent.width
                height: parent.height
                radius: width / 2
                source: model.icon
                x: serverIconX

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        current_server = model.serverID
                        serverSelected(model.serverID)
                        waveAnimated = true



                        let mappedPos = per_avatar.mapToItem(servers_icon_list, 0, 0)
                        current_server_position = Qt.point(mappedPos.x, mappedPos.y + per_avatar.height / 2)
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
                    current_server = ""

                    let firstDelegate = servers_icon_list.contentItem.children[0]
                    if (firstDelegate) {
                        let mappedPos = firstDelegate.mapToItem(servers_icon_list, 0, 0)
                        current_server_position = Qt.point(mappedPos.x, mappedPos.y + firstDelegate.height / 2)
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
            height: parent.height

            property real cornerRadius: 12
            property real topY: Math.max(cornerRadius, animWaveY - waveHalfHeight)
            property real bottomY: Math.min(server_function_block.height - cornerRadius, animWaveY + waveHalfHeight)
            property real upperSpan: Math.max(1, animWaveY - topY)
            property real lowerSpan: Math.max(1, bottomY - animWaveY)
            property real shoulderTension: 0.45
            property real crestTension: 0.62
            property real crestShoulder: 0.16


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
                    y:wave_sh.cornerRadius
                    controlX: server_function_block.width
                    controlY: 0
                }

                //down
                PathLine { x:server_function_block.width; y:server_function_block.height - wave_sh.cornerRadius}

                //radius bottom right
                PathQuad {
                    x: server_function_block.width - wave_sh.cornerRadius
                    y: server_function_block.height
                    controlX: server_function_block.width
                    controlY: server_function_block.height
                }

                //left
                PathLine { x: wave_sh.cornerRadius; y: server_function_block.height }

                //radius bottom left
                PathQuad {
                    x: 0
                    y: server_function_block.height - wave_sh.cornerRadius
                    controlX: 0
                    controlY: server_function_block.height
                }


                //line to selection cradle
                PathLine { x: 0; y: wave_sh.bottomY }

                //lower half of the smooth cradle
                PathCubic {
                    x: -waveDepth
                    y: animWaveY
                    control1X: 0
                    control1Y: wave_sh.bottomY - wave_sh.lowerSpan * wave_sh.shoulderTension
                    control2X: -waveDepth + selectedIconRadius * wave_sh.crestShoulder
                    control2Y: animWaveY + wave_sh.lowerSpan * wave_sh.crestTension
                }

                //upper half of the smooth cradle
                PathCubic {
                    x: 0
                    y: wave_sh.topY
                    control1X: -waveDepth + selectedIconRadius * wave_sh.crestShoulder
                    control1Y: animWaveY - wave_sh.upperSpan * wave_sh.crestTension
                    control2X: 0
                    control2Y: wave_sh.topY + wave_sh.upperSpan * wave_sh.shoulderTension
                }


                //up
                PathLine { x: 0; y: wave_sh.cornerRadius}

                //radius
                PathQuad {
                    x: wave_sh.cornerRadius
                    y: 0
                    controlX: 0
                    controlY: 0
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
