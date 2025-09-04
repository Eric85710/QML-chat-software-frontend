import QtQuick
import "../../Server_component"


Column {
    anchors.fill: parent
    padding: 60

    Rectangle {
        width: 600
        height: 366
        radius: 12
        color: "#40FFFFFF"



        Column {
            anchors.fill: parent
            padding: 20
            spacing: 20


            Row {
                spacing: 20

                Round_img_avatar {
                    width: 100
                    height: 100
                    radius: 50
                    source: "qrc:/img/after-sunset.jpg"
                }

                Text {
                    id: name_own
                    text: qsTr("陳奕呈")
                    font.pointSize: 40
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                width: parent.width - 40
                height: 200
                radius: 12
            }
        }
    }
}
