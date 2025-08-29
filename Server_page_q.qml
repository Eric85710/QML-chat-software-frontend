//Server_page_q.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "Server_component"
import "Style_component"


Component {
    Item {
        Rectangle {
            id: server_block
            anchors.fill: parent
            color: "transparent"

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
                    color: "#44000000"
                    Layout.preferredWidth: 340
                    Layout.fillHeight: true
                    radius: 12

                    FrostedGlass {
                        anchors.fill: parent
                        sourceItem: bg1
                    }



                    // 淡入動畫
                    OpacityAnimator { target: server_list; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:server_list_loadin_animation
                        x:-100
                        y:100
                    }


                    Server_list{
                        id:server_list_qmlfile
                    }
                }








                //chat with your son in here
                Rectangle {
                    id: server_chat_block
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12

                    OpacityAnimator { target: server_chat_block; from: -100; to: 1; duration: 300 }

                    transform: Translate{
                        id:server_chat_block_loadin_animation
                        y:100
                    }

                    Server_chat_block {
                        id:server_message_chat_block
                    }
                }















                //all of the members will shows in here
                Rectangle {
                    id: server_member_list
                    color: "#44000000"
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    radius: 12

                    OpacityAnimator { target: server_member_list; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:server_member_list_loadin_animation
                        x:100
                        y:100
                    }
                }
            }
        }
    }
}
