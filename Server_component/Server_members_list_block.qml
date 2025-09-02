import QtQuick 2.15
import QtQuick.Controls 2.15

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

        delegate: Rectangle {
            width: 160
            height: 48
            color: index % 2 === 0 ? "#f8f8f8" : "#ffffff"
            radius: 3



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
                        text: role
                        font.bold: true
                        font.pointSize: 14
                        color: "#333"
                        elide: Text.ElideRight
                    }

                    Text {
                        text: name
                        font.pointSize: 10
                        color: "#333"
                        elide: Text.ElideRight
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Clicked:", name)
                hoverEnabled: true
                onEntered: parent.color = "#d0eaff"
                onExited: parent.color = index % 2 === 0 ? "#f8f8f8" : "#ffffff"
            }
        }
    }
}
