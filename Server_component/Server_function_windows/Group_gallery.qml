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

    RowLayout {
        id: row2
        Layout.fillWidth: true
        Layout.preferredHeight: 168

        property int rectSize: 160
        property int spacingSize: 4

        // 根據 RowLayout 的寬度計算可放多少個
        property int rectCount: Math.floor((width + spacingSize) / (rectSize + spacingSize))

        onRectCountChanged: console.log("rectCount =", rectCount)

        Repeater {
            model: row2.rectCount
            Rectangle {
                width: row2.rectSize
                height: row2.rectSize
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            }
        }
    }

    RowLayout {
        id: row3
        Layout.fillWidth: true
        Layout.preferredHeight: 168

        property int rectSize: 160
        property int spacingSize: 4

        // 根據 RowLayout 的寬度計算可放多少個
        property int rectCount: Math.floor((width + spacingSize) / (rectSize + spacingSize))

        onRectCountChanged: console.log("rectCount =", rectCount)

        Repeater {
            model: row3.rectCount
            Rectangle {
                width: row3.rectSize
                height: row3.rectSize
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            }
        }
    }
}
