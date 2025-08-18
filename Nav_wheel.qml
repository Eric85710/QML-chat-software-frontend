import QtQuick
import QtQuick.Controls

Item {
    id: root
    property var model: []          // 選項列表
    property int currentIndex: 0    // 當前選中
    property int itemWidth: 100     // 每個項目寬度

    signal indexChanged(int index)

    width: 300
    height: 200

    MouseArea{
        id:nav_touch_area
        anchors.fill: whole_app_window
        drag.target: nav_listView
        drag.axis: Drag.XAxis
        cursorShape: Qt.OpenHandCursor
    }

    ListView {
        id: nav_listView
        anchors.fill: parent
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
        highlightMoveDuration: 200
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width - root.itemWidth) / 2
        preferredHighlightEnd: (width + root.itemWidth) / 2
        clip: true

        model: root.model
        currentIndex: root.currentIndex

        delegate: Item {
            width: root.itemWidth
            height: parent.height

            Text {
                anchors.centerIn: parent
                text: modelData
                font.pixelSize: 20
                font.weight: Font.Bold

                // 動態縮放與顏色
                property real distanceToCenter: Math.abs((ListView.view.contentX + index * root.itemWidth + root.itemWidth / 2) - (ListView.view.contentX + ListView.view.width / 2))
                scale: Math.max(0.8, 1 - distanceToCenter / 200)
                color: distanceToCenter < root.itemWidth / 2 ? "blue" : "black"
            }
        }

        onCurrentIndexChanged: {
            root.currentIndex = currentIndex
            root.indexChanged(currentIndex)
        }
    }

    // 中間選中框
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.itemWidth
        height: 40
        color: "#80808080"
        radius: 10
        z: 1
    }
}
