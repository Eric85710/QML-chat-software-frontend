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
    property real waveY: 0   // 最终目标
    property real animWaveY: 200 // 实际动画用的值
    property real wave_end: 12
    property real have_radi: -12
    property real have_end_wave: 0
    property real have_cen_wave1x: 0
    property real have_cen_wave2x: 0
    property real have_cen_control2y: 0

    property real have_wavePath1_x: 0
    property real have_wavePath1_y: -44
    property real have_wavePath1_controlx: 0
    property real have_wavePath1_controly: 0

    property real have_wavePath2_x: 0
    property real have_wavePath2_controlx: 0
    property real have_wavePath2_controly: 0


    property bool waveAnimated: false


    Behavior on animWaveY {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_end_wave {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_radi {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on wave_end {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_cen_wave1x {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_cen_wave2x {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_cen_control2y {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath1_x {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath1_y {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath1_controlx {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath1_controly {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath2_x {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath2_controlx {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on have_wavePath2_controly {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }


    // 只有超過 150 才更新目標位置
    onCurrent_server_positionChanged: {
        if (!waveAnimated) {
            // waveAnimated 為 false 時，只更新數值，不做動畫
            have_cen_wave1x = 0
            have_cen_wave2x = 0
            have_cen_control2y = 0

            have_wavePath1_x = 0
            have_wavePath1_y = -44
            have_wavePath1_controlx = 0
            have_wavePath1_controly = 0

            have_wavePath2_x = 0
            have_wavePath2_controlx = 0
            have_wavePath2_controly = 0

            return
        }

        // waveAnimated 為 true 時，開啟動畫
        if (current_server_position.y >= 150) {
            have_end_wave = -44
            have_radi = -12
            wave_end = 12
            waveY = current_server_position.y
            animWaveY = waveY

            have_cen_wave1x = -60
            have_cen_wave2x = -60
            have_cen_control2y = -80

            have_wavePath1_x = -12
            have_wavePath1_y = -44
            have_wavePath1_controlx = 0
            have_wavePath1_controly = -38

            have_wavePath2_x = 12
            have_wavePath2_controlx = 12
            have_wavePath2_controly = -6

        //Don't have end wave
        } else {
            have_end_wave = 0
            have_radi = 0
            wave_end = 0
            waveY = current_server_position.y
            animWaveY = waveY

            have_cen_wave1x = -60
            have_cen_wave2x = -60
            have_cen_control2y = -80

            have_wavePath1_x = -12
            have_wavePath1_y = -44
            have_wavePath1_controlx = 0
            have_wavePath1_controly = -38

            have_wavePath2_x = 12
            have_wavePath2_controlx = 12
            have_wavePath2_controly = -6
        }
    }






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
                x: current_server === model.serverID ? 18 : (servers_icon_list.width - width) / 2




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
                        waveAnimated = true



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
                    current_server = ""

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
                PathLine { relativeX: 0; y: animWaveY }










                //wave_path1
                PathQuad {
                    relativeX: have_wavePath1_x
                    relativeY: have_wavePath1_y
                    relativeControlX: 0
                    relativeControlY: have_wavePath1_controly
                }

                //wave center
                PathCubic {
                    relativeX: 0
                    relativeY: -80
                    relativeControl1X: have_cen_wave1x
                    relativeControl2X: have_cen_wave2x
                    relativeControl1Y: 0
                    relativeControl2Y: have_cen_control2y
                }

                //wave_path2
                PathQuad {
                    relativeX: have_wavePath2_x
                    relativeY: have_end_wave
                    relativeControlX: have_wavePath2_controlx
                    relativeControlY: have_wavePath2_controly
                }











                //up
                PathLine { x: 0; y: wave_end}

                //radius
                PathQuad {
                    x: 12
                    y: 0
                    relativeControlX: 0
                    relativeControlY: have_radi
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
