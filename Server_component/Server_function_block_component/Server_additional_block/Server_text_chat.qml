import QtQuick
import "../../../Server_Page_status"

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
                source: "qrc:/svg_icon/text-square-svgrepo-com.svg"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: text_chaanel_title
                text: qsTr("文字頻道")
                anchors.verticalCenter: parent.verticalCenter
            }
        }


        //seperate_line
        Rectangle {
            width: parent.width
            height: 2
        }

        //chat_room_column
        Column {
            width: parent.width
            topPadding: 10
            bottomPadding: 10

            // 假設你在 text_chaanel_content 裡面
            ListView {
                id: chatRoomListView
                width: parent.width
                height: contentHeight
                spacing: 8
                clip: true

                model: ListModel {
                    ListElement { name: "聊天室 A"; text_chat_room_id:"text_chat_room1" }
                    ListElement { name: "聊天室 B"; text_chat_room_id:"text_chat_room2" }
                    ListElement { name: "聊天室 C"; text_chat_room_id:"text_chat_room3" }
                }

                delegate: Rectangle {
                    width: chatRoomListView.width - 36
                    height: 30
                    radius: 8
                    color: Qt.rgba(0.8, 0.8, 0.8, 0.6)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: model.name
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Chat_room_status.current_chat_ch(model.text_chat_room_id)
                        }
                    }

                }
            }

        }
    }
}
