import QtQuick
import QtQuick.Controls

Item {
    width: 160
    height: 400

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
        spacing: 6
        clip: true


        header: Item {
            width: 160
            height: 16 // 你想要的間距高度
        }

        delegate: Rectangle {
            width: 160
            height: 48
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
