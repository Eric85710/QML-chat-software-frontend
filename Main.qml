import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

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

    //glass effectbox
    Rectangle {
           width: parent.width * 0.8
           height: parent.height * 0.8
           anchors.centerIn: parent
           color: "#333"
           opacity: 0.6
           radius: 12
           Rectangle {
               anchors.fill: parent
               opacity: 0.1
               radius: 12
               gradient: Gradient {
                   GradientStop {
                       position: 0.0; color: "white"
                   }
                   GradientStop {
                       position: 1.0; color: "black"
                   }
               }
           }

           MouseArea {
               anchors.fill: parent
               onWheel: {
                   // wheel.angleDelta.y 通常滑鼠滾輪是 120 的倍數
                   if (Math.abs(wheel.angleDelta.y) < 120) {
                       console.log(wheel.angleDelta)
                   } else {
                       console.log("可能是滑鼠滾輪")
                }
            }
        }
    }
}
