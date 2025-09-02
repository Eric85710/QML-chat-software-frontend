import QtQuick 2.15
import QtQuick.Controls 2.15

ScrollView {
    width: parent.width
    height: parent.height
    clip: true

    Column {
        width: parent.width
        spacing: 8

        Repeater {
            model: 16
            Rectangle {
                width: parent.width - 16
                height: 40
                radius: 6
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0)

                Text {
                    anchors.centerIn: parent
                    text: "Item " + (index + 1)
                    color: "white"
                    font.bold: true
                }
            }
        }
    }
}
