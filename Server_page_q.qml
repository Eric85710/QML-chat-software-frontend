//server_page_q.qml
import QtQuick

Component {
    Rectangle {
        anchors.fill: parent
        opacity: 0
        color: "transparent"

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }

        // 淡入效果
        Component.onCompleted: opacity = 1






        Rectangle{
            id:server_list
            height: parent.height
            width: 300

            x:-200
            y: 60
            Component.onCompleted: {
                x = 0
                y = 0
            }

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            color: "red"
            Text {
                text: "Server Page"
                anchors.centerIn: parent
                color: "white"
            }
        }
    }
}
