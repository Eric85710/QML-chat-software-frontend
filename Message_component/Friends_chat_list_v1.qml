import QtQuick
import QtQuick.Controls
import "../Server_component/"

Item {
    id:whole_friends_chat_list
    width: parent.width
    height: parent.height

    ListModel {
        id: memberModel
        ListElement { name: "Alice"; role: "Designer" }
        ListElement { name: "Bob"; role: "Developer" }
        ListElement { name: "Charlie"; role: "Manager" }
        ListElement { name: "Diana"; role: "QA" }
    }

    ListView {
        anchors.fill: parent
        model: memberModel
        orientation: ListView.Vertical
        clip: true


        header: Item {
            width: whole_friends_chat_list.width
            height: 60 // 你想要的間距高度

            Rectangle {
                id: friends_chat_searchBar
                width: parent.width - 20
                height: 40
                radius: 6
                anchors.centerIn: parent
                opacity: 0.4

                Row {
                    anchors.fill: parent
                    padding: 10
                    Image {
                        id: friends_chat_list_searchBar_icon
                        width: 28
                        height: 28
                        source: "qrc:/svg_icon/search-svgrepo-com.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

            }
        }

        delegate: Rectangle {
            width: whole_friends_chat_list.width
            height: 64
            color: "transparent"
            radius: 6



            Row {
                id:member_info
                spacing: 6
                anchors.fill: parent
                padding: 10

                Round_img_avatar {
                    width: 40
                    height: 40
                    radius: 20
                    source: "qrc:/img/after-sunset.jpg"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text: name
                        font.bold: true
                        font.pointSize: 14
                        color: "#90b0e0f0"
                        elide: Text.ElideRight
                    }

                    Text {
                        text: role
                        font.pointSize: 10
                        color: "#90b0e0f0"
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 2
                opacity: 0.1
            }

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Clicked:", name)
                hoverEnabled: true
                onEntered: parent.color = "#90a3d5e5"
                onExited: parent.color = "transparent"
            }
        }
    }
}
