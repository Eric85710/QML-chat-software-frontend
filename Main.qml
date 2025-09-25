import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "Style_component"

ApplicationWindow {
    id:whole_app_window
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")






    Theme_mode{
        id:theme
    }






    Item {
        id: mainFocusItem
        focus: true
        visible: false // 不影響畫面
        Keys.onPressed: {
            console.log("主界面收到鍵盤事件:", event.key)
        }

        Keys.forwardTo: [ pickerWheel, pageLoader ]
    }

    function returnFocusToMain() {
        mainFocusItem.focus = true
    }








    //background
    Image {
        id: bg1
        anchors.fill: parent
        source: theme.backgroundImage
        fillMode: Image.PreserveAspectCrop
        cache: false
    }






    //nav_bar
    header: ToolBar {
        id:nav_bar

        property int nav_bar_h: 50

        height: nav_bar_h

        //nav bar color
        background: Item {
            anchors.fill: parent


            BlurCard {
                width: parent.width
                height: parent.height
                blurSource: bg1
                borderRadius: 0
                layer.enabled: true
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



    //page loader
    Loader {
        id: pageLoader
        anchors.fill: parent
        anchors.topMargin: 10
        sourceComponent: {
            switch (pickerWheel.model[pickerWheel.currentIndex]) {
                case "message": return message_Page
                case "server": return server_Page
                case "marketplace": return marketplace_Page
                case "setting": return setting_page
                case "workspace": return blur_iii
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
        id: marketplace_Page
    }

    Setting_page_q {
        id: setting_page
    }


    Component {
        id: blur_iii
        BlurCard {
            blurSource: bg1
            borderRadius: 35
            anchors.centerIn: parent
            layer.enabled: true
        }
    }




}
