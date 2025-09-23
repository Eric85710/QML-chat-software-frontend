// Nav_wheel.qml：水平選單輪盤元件
import QtQuick
import QtQuick.Controls
import "Style_component"

Item {
    id: root

    // 📦 外部可設定的屬性
    property var model: []          // 選項列表資料
    property int currentIndex: 0    // 當前選中的索引
    property int itemWidth: 100     // 每個選項的寬度
    property bool allowScroll: false // 是否允許滑動（Ctrl/Command觸發）

    // 🔑 鍵盤事件：按下 Ctrl 或 Command 時啟用滑動
    focus: true
    Keys.onPressed: {
        if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.MetaModifier) {
            root.allowScroll = true
            event.accepted = true
        }
    }





    // 📢 當選中索引改變時發出訊號
    signal indexChanged(int index)





    // 📐 元件尺寸設定
    width: whole_app_window.width
    height: whole_app_window.height * 2

    // 📜 水平 ListView：顯示選項列表
    ListView {
        id: nav_listView
        anchors.fill: parent
        orientation: ListView.Horizontal
        interactive: root.allowScroll
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
        highlightMoveDuration: 200
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width - nav_listView.currentItem.width) / 2
        preferredHighlightEnd: (width + nav_listView.currentItem.width) / 2
        clip: true

        model: root.model
        currentIndex: root.currentIndex













        // 🔁 每個選項的 delegate
        delegate: Item {
            // 📏 計算文字寬度元件（自訂）
            Text_width_calulator {
                id: widthCalc
                text: modelData
                fontSize: 20
                bold: true
                padding: 40
            }

            width: widthCalc.calculatedWidth
            height: parent.height

            // 🟦 背景矩形 + 點擊區域
            Rectangle {
                id: localNavColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 50  // 與 ToolBar 的 nav_bar_h 一致
                color: "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        nav_listView.currentIndex = index
                        whole_app_window.returnFocusToMain() // 焦點回主界面
                        event.accepted = true
                    }
                }
            }

            // 🔤 顯示選項文字
            Text {
                anchors.centerIn: parent
                text: modelData
                font.pixelSize: 20
                font.weight: Font.Bold

                // ✅ 是否為選中項目
                property bool isNavSelected: index === root.currentIndex

                // 🎨 顏色與縮放效果
                color: isNavSelected ? "#ffffff" : "#aaaaaa"
                scale: isNavSelected ? 1.0 : 0.6

                // 🎞️ 動畫：縮放
                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                // 🎞️ 動畫：顏色漸變
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }

        // 當選中索引改變時更新 root 並發出訊號
        onCurrentIndexChanged: {
            root.currentIndex = currentIndex
            root.indexChanged(currentIndex)
        }

        // 停止滑動後關閉 scroll 模式（避免 snap bug）
        onMovementEnded: root.allowScroll = false
        onFlickEnded: root.allowScroll = false
    }

    // 中間選中框：視覺提示目前選中項目
    Rectangle {
        id: choosing_rect
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: root.allowScroll ? root.itemWidth * 1.2 : root.itemWidth
        height: root.allowScroll ? 60 : 40

        // 🎞️ 動畫：高度變化
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        // 🎞️ 動畫：寬度變化
        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutBounce
            }
        }

        color: "#80808080" // 半透明灰色
        radius: 10
        z: 1
    }
}
