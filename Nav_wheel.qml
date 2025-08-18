// PickerWheel.qml
import QtQuick
import QtQuick.Controls

Item {
    id: root
    property var model: []          // 選項列表
    property int currentIndex: 0    // 當前選中
    property int itemWidth: 100     // 每個項目寬度

    signal indexChanged(int index)   // ✅ signal 名稱不帶 on 開頭

    width: 100
    height: nav_bar.height

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: row_list.childrenRect.width
        interactive: true
        clip: true

        Row {
            id: row_list
            height: parent.height
            spacing: 10

            Repeater {
                model: root.model.length
                delegate: Item {
                    width: root.itemWidth
                    height: parent.height

                    Text {
                        anchors.centerIn: parent
                        text: root.model[index]
                        font.pixelSize: 20

                        // 動態縮放和顏色
                        property real distanceToCenter: Math.abs((index*root.itemWidth + root.itemWidth/2) - (flick.contentX + flick.width/2))
                        scale: Math.max(0.8, 1 - distanceToCenter/200)
                        color: distanceToCenter < root.itemWidth/2 ? "blue" : "black"
                    }
                }
            }
        }

        onMovementEnded: {
            // 自動對齊到最近項目
            var target = Math.round((contentX + flick.width/2 - root.itemWidth/2) / root.itemWidth) * root.itemWidth - flick.width/2 + root.itemWidth/2;
            contentX = target;
            root.currentIndex = Math.round(contentX / root.itemWidth)
            root.indexChanged(root.currentIndex)   // ✅ 發出 signal
        }

        // 拖動過程中更新當前 index
        onContentXChanged: {
            root.currentIndex = Math.round(contentX / root.itemWidth)
        }
    }

    // 中間選中框
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: root.itemWidth - 8
        height: nav_bar.height - 8
        color: "#80808080"
        radius: 10
    }
}
