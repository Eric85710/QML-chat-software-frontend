//Message_page_q.qml
import QtQuick

Component {
    Item {
        Rectangle {
            id: message_block
            anchors.fill: parent
            opacity: 0
            color: "transparent"

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            Component.onCompleted: {
                opacity = 1
                state = "entered"
            }







            states: State {
                name: "entered"
                PropertyChanges { target: chat_list; x: 0 }
                PropertyChanges { target: chat_block; x: parent.width - chat_block.width }
                PropertyChanges { target: chat_list; y: 0 }
                PropertyChanges { target: chat_block; y: parent.height - chat_block.height }
            }

            transitions: Transition {
                NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "y"; duration: 300; easing.type: Easing.InOutQuad }
            }

            Rectangle {
                id: chat_list
                color: "#44000000"
                width: 360
                height: parent.height
                radius: 12
                x: -chat_list.width
                y: chat_list.height
            }

            Rectangle {
                id: chat_block
                color: "#44000000"
                width: message_block.width - chat_list.width - 20
                height: parent.height
                radius: 12
                x: parent.width
                y: parent.height

                Column {
                        id: messageColumn
                        anchors.fill: parent
                        spacing: 8
                        padding: 12

                        // 範例訊息
                        Repeater {
                            model: 5  // 你可以改成動態 model
                            delegate: Rectangle {
                                width: parent.width
                                height: implicitHeight
                                color: "#eeeeee"
                                radius: 8
                                border.color: "#cccccc"
                                border.width: 1

                            }
                        }
                }
            }
        }
    }
}
