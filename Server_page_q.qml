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
                PropertyChanges { target: server_list; x: 0 }
                PropertyChanges { target: chat_block; x: parent.width - chat_block.width }
                PropertyChanges { target: server_list; y: 0 }
                PropertyChanges { target: chat_block; y: parent.height - chat_block.height }
            }

            transitions: Transition {
                NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "y"; duration: 300; easing.type: Easing.InOutQuad }
            }

            Rectangle {
                id: server_list
                color: "#44000000"
                width: 100
                height: parent.height
                radius: 12
                x: -server_list.width
                y: server_list.height
            }

            Rectangle {
                id: chat_block
                color: "#44000000"
                width: server_block.width - server_list.width - 20
                height: parent.height
                radius: 12
                x: parent.width
                y: parent.height
            }

            Rectangle {

            }
        }
    }
}
