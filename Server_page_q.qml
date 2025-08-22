//server_page_q.qml
import QtQuick

Component {
    Rectangle {
        anchors.fill: parent
        opacity: 0
        color: "transparent"

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        // 淡入效果
        Component.onCompleted: opacity = 1






        Rectangle{
            id:server_list
            height: parent.height
            width: 300

            color: "red"
            Text {
                text: "Server Page"
                anchors.centerIn: parent
                color: "white"
            }


            NumberAnimation {
                target: server_list
                property: "x"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
