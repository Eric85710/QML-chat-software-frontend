import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

ColumnLayout {
    width: parent.width
    height: parent.height
    spacing: 8







    ColumnLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 188



        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            color: "transparent"

            Text {
                text: qsTr("2025-8-12")
                font.pointSize: 18
                font.bold: true
                color: Qt.rgba(0.8, 0.8, 0.8, 0.8)
            }
        }

        RowLayout {
            id: row
            Layout.fillWidth: true
            Layout.preferredHeight: 160

            property int rectSize: 160
            property int spacingSize: 4

            // 根據 RowLayout 的寬度計算可放多少個
            property int rectCount: Math.floor((width + spacingSize) / (rectSize + spacingSize))

            onRectCountChanged: console.log("rectCount =", rectCount)

            Repeater {
                model: row.rectCount
                Rectangle {
                    width: row.rectSize
                    height: row.rectSize
                    color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                }
            }
        }
    }
}
