//Server_page_q.qml
import QtQuick

Component {
    Item {
        Rectangle {
            id: server_block
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
            }

            transitions: Transition {
                NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.InOutQuad }
            }

            Rectangle {
                id: chat_list
                color: "#44000000"
                width: 100
                height: parent.height
                radius: 12
                x: -chat_list.width
                y: 0
            }

            Rectangle {
                id: chat_block
                color: "#44000000"
                width: server_block.width - chat_list.width - 20
                height: parent.height
                radius: 12
                x: parent.width
                y: 0
            }
        }
    }
}
