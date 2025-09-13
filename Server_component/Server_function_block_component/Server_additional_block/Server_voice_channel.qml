import QtQuick

Rectangle {
    id: text_chaanel_rect
    width: parent.width - 20
    radius: 12
    color: Qt.rgba(0.8, 0.8, 0.8, 0.4)
    anchors.horizontalCenter: parent.horizontalCenter
    implicitHeight: text_chaanel_content.implicitHeight + 2

    Column {
        anchors.fill: parent
        id:text_chaanel_content

        //text function title
        Row {
            width: parent.width
            height: 32
            padding: 10
            spacing: 2

            Image {
                width: 20
                height: 20
                id: text_chaanel_icon
                source: "qrc:/svg_icon/sound-loud-svgrepo-com.svg"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: text_chaanel_title
                text: qsTr("阿拉瓜瓜")
                anchors.verticalCenter: parent.verticalCenter
            }
        }


        //seperate_line
        Rectangle {
            width: parent.width
            height: 2
        }

        Column {
            width: parent.width
            spacing: 8
            padding: 10

            Rectangle {
                width: parent.width - 36
                height: 30
                radius: 8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: parent.width - 36
                height: 30
                radius: 8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: parent.width - 36
                height: 30
                radius: 8
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
