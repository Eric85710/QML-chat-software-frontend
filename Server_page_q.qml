import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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

                Rectangle {
                    id: server_list
                    color: "#44000000"
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                    radius: 12

                    // 淡入動畫
                    OpacityAnimator { target: server_list; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:server_list_loadin_animation
                        x:-100
                        y:100
                    }

                }

                Rectangle {
                    id: server_chat_block
                    color: "#44000000"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12

                    OpacityAnimator { target: server_chat_block; from: -100; to: 1; duration: 300 }
                }

                Rectangle {
                    id: server_member_list
                    color: "#44000000"
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    radius: 12

                    OpacityAnimator { target: server_member_list; from: 0; to: 1; duration: 300 }
                }
            }
        }
    }
}
