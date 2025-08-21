//server_page_q.qml
import QtQuick

Component {
    id: server_Page
    Rectangle {
        anchors.fill: parent
        color: "red"
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        // 淡入效果
        Component.onCompleted: opacity = 1

        Text {
            text: "Server Page"
            anchors.centerIn: parent
            color: "white"
        }
    }
}
