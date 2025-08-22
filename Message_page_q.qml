//Message_page_q.qml
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
            width: 600
            height: parent.height

            color: "white"
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
            Text {
                text: "Server Page"
                anchors.centerIn: parent
                color: "white"
            }
        }
    }
}
