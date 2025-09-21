//Message_page_q.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "Message_component/"
import "Message_component/message_display/"
import App 1.0

Component {
    Item {
        Rectangle {
            id: message_block
            anchors.fill: parent
            color: "transparent"

            //sliding animation
            Component {
                id: slideInAnimation
                ParallelAnimation {
                    //list_animation
                    NumberAnimation {
                        target: friends_list_loadin_animation
                        property: "x"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: friends_list_loadin_animation
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }


                    //member_list_animation
                    NumberAnimation {
                        target: message_chat_block_loadin_animation
                        property: "x"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: message_chat_block_loadin_animation
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
                PropertyChanges { target: message_block; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 300 }
            }

            // 初始透明，進場時淡入
            opacity: 0
            Component.onCompleted: {
                message_block.state = "entered"
                var anim = slideInAnimation.createObject(message_block)
                anim.start()

            }


            // 主排版區塊
            RowLayout {
                anchors.fill: parent
                spacing: 12

                Rectangle {
                    id: chat_room_list
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0.2, 0.2, 0.2, 0.4) }
                        GradientStop { position: 1.0; color: Qt.rgba(0.2, 0.2, 0.2, 0.2) }
                    }
                    Layout.preferredWidth: 320
                    Layout.fillHeight: true
                    radius: 12

                    // 淡入動畫
                    OpacityAnimator { target: chat_room_list; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:friends_list_loadin_animation
                        x:-100
                        y:100
                    }

                    Friends_chat_list_v1 {
                        id:friends_chat_list_block
                    }

                }










                Rectangle {
                    id: message_chat_block
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.fillHeight: true


                    OpacityAnimator { target: message_chat_block; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:message_chat_block_loadin_animation
                        x:100
                        y:100
                    }


                    property string currentMessage: ""

                    Connections {
                        target: EventBus
                        function onChatWith(userId) {
                            message_chat_block.currentMessage = userId
                        }
                    }



                    Loader {
                        id: message_chat_loader
                        anchors.fill: parent
                        sourceComponent: {
                            switch (message_chat_block.currentMessage) {
                                case "user1": return chat_room1
                                case "user2": return chat_room2
                                case "user3": return Server3Content
                                case "user4": return group_gallery_q
                                default: return DefaultServerContent
                            }
                        }
                    }

                    Component {
                        id:chat_room1
                        Message_chat_area{}
                    }

                    Component {
                        id:chat_room2
                        Message_chat_area{}
                    }

                }
            }
        }
    }
}
