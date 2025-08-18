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

        height: 50

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
                model: ["Apple", "Banana", "Cherry", "Date", "Grape", "Lemon", "Mango"]

                onIndexChanged: {
                    console.log("選中項目:", model[currentIndex])
                }

            }
        }
    }
}
