//Marketplace_page_q.qml
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
            id:market_search_bar
            height: 60
            width: 300
            anchors.centerIn: parent
            color: "Blue"
            Text {
                text: "Server Page"
                anchors.centerIn: parent
                color: "white"
            }
        }
    }
}
