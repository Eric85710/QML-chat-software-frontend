//Server_page_q.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "Server_component"
import "Server_component/Server_function_block_component/Server_additional_block"
import "Style_component"
import "Server_component/Server_function_windows"
import "Server_Page_status"


Component {
    Item {
        Rectangle {
            id: server_block
            anchors.fill: parent
            color: "transparent"

            property string current_function_display :"text_chat_room1"

            //sliding animation
            Component {
                id: slideInAnimation
                ParallelAnimation {
                    //list_animation
                    NumberAnimation {
                        target: server_list_loadin_animation
                        property: "x"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: server_list_loadin_animation
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }

                    //chat_box_animtion
                    NumberAnimation {
                        target: server_chat_block_loadin_animation
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }

                    //member_list_animation
                    NumberAnimation {
                        target: server_member_list_loadin_animation
                        property: "x"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: server_member_list_loadin_animation
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
            }






            // 淡入動畫
            states: State {
                name: "entered"
                PropertyChanges { target: server_block; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 300 }
            }

            // 初始透明，進場時淡入
            opacity: 0
            Component.onCompleted: {
                server_block.state = "entered"
                var anim = slideInAnimation.createObject(server_list_loadin_animation)
                anim.start()

            }









            // 主排版區塊
            RowLayout {
                anchors.fill: parent
                spacing: 12





                //choosing the server here
                Rectangle {
                    id: server_list
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0.2, 0.2, 0.2, 0.4) }
                        GradientStop { position: 1.0; color: Qt.rgba(0.2, 0.2, 0.2, 0.2) }
                    }

                    Layout.preferredWidth: 340
                    Layout.fillHeight: true
                    radius: 12


                    transform: Translate{
                        id:server_list_loadin_animation
                        x:-100
                        y:100
                    }


                    Server_list{
                        id:server_list_qmlfile
                        onServerSelected: {
                            server_function_text.text = serverID
                        }
                    }
                }





                RowLayout {
                    id:server_function_display_area
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // Loader 那邊
                    Connections {
                        target: Chat_room_status
                        onPageChanged: key => {
                                           console.log("收到 pageChanged 訊號:", key)
                            switch (key) {
                            case "text_chat_room1": contentLoader.source = group_text_chat_q; break
                            case "text_chat_room2": contentLoader.source = "Page2.qml"; break
                            }
                        }
                    }



                    //text_chat
                    Component {
                        id: group_text_chat_q
                        Group_text_chat {}
                    }
                }

            }
        }
    }
}
