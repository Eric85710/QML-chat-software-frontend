//Server1_function_block.qml
import QtQuick
import QtQuick.Layouts


Column {
    anchors.fill: parent
    spacing: 10



    Rectangle {
        width: parent.width
        height: server_name_text.height + 10  // 高度略加 margin 空間
        color: "transparent"

        Text {
            id: server_name_text
            text: qsTr("PC孤兒")
            font.bold: true
            font.pixelSize: 32
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20
            color: "white"
            opacity: 0.8
        }
    }


    //sperate line
    Rectangle {
        id: seperate_line_forserver_title
        width: parent.width
        height: 4
        color: "black"
        opacity: 0.2
    }

    //Gallery and Video
    Rectangle {
        width: parent.width - 20
        height: 100
        radius: 12
        color: "#555"
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors.fill: parent

            Rectangle {
                width: 30
                height: 20
                radius: 12
            }

            Rectangle {
                width: 30
                height: 20
                radius: 12
            }
        }
    }

    Rectangle {
        width: 60
        height: 40
        radius: 12
        color: "#777"
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
