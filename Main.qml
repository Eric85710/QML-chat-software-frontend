import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

ApplicationWindow {
    id:whole_app_window
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
        id:nav_bar

        property int nav_bar_h: 50

        height: nav_bar_h

        //nav bar color
        background: Item {
            anchors.fill: parent


            Rectangle {
                id:nav_color
                anchors.fill: parent
                color: "#66000000"
            }
        }

        //nav_wheel_layout
        RowLayout{

            anchors.centerIn: parent


            Nav_wheel{
                id: pickerWheel
                anchors.centerIn: parent
                model: ["message", "server", "marketplace", "setting", "workspace"]

                onIndexChanged: {
                    console.log("選中項目:", model[currentIndex])
                }

            }
        }
    }



    Loader {
        id: pageLoader
        anchors.fill: parent
        anchors.topMargin: 10
        sourceComponent: {
            switch (pickerWheel.model[pickerWheel.currentIndex]) {
                case "message": return message_Page
                case "server": return server_Page
                case "marketplace": return marketplace_Page
                case "setting": return setting_Page
                case "workspace": return workspace_Page
                default: return server_Page
            }
        }
    }




    //server
    Server_page_q{
        id:server_Page
    }


    //Message
    Message_page_q{
        id: message_Page
    }

    //marketplace
    Marketplace_page_q{
        id:marketplace_Page
    }




}
