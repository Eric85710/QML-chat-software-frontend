//Marketplace_page_q.qml
import QtQuick

Component {
    Rectangle {
        anchors.fill: parent
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        // 淡入效果
        Component.onCompleted: opacity = 1

        Rectangle{
            anchors.fill: parent
            color: "Blue"
            Text {
                text: "Server Page"
                anchors.centerIn: parent
                color: "white"
            }
        }
    }
}
