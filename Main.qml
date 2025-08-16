import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    //background
    background: Image {
        id: bg1
        source: "qrc:/img/after-sunset.jpg"
    }



    //nav_bar
    header: ToolBar {

        height: 50

        background: Item {
            anchors.fill: parent


            Rectangle {
                id:nav_color
                anchors.fill: parent
                color: "#66000000"
            }
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 40

            ToolButton {
                id:server_btn
                text: "server"

                background: Rectangle {
                    radius: 8
                    color: "#66555555"
                }
            }


            ToolButton {
                id:marketplace_btn
                text: "marketplace"

                background: Rectangle {
                    radius: 8
                    color: "#66555555"
                }
                onClicked: console.log("go setting")

                PropertyAnimation {
                    target: marketplace_btn
                    property: "rotation"
                    from: 0
                    to: 360
                    duration: 2000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                    running: true
                }
            }

            ToolButton {
                text: "message"

                background: Rectangle {
                    radius: 8
                    color: "#66555555"
                }
                onClicked: console.log("go message")
            }
        }
    }
}
