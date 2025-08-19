import QtQuick
import QtQuick.Controls

Item {
    id: root
    property var model: []          // 選項列表
    property int currentIndex: 0    // 當前選中
    property int itemWidth: 100     // 每個項目寬度

    signal indexChanged(int index)

    width: whole_app_window.width
    height: whole_app_window.height


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



        delegate: Item {                    //each option repeat in here
            width: root.itemWidth
            height: parent.height

            MouseArea {                     //點選功能
                anchors.fill: parent
                onClicked: {
                    nav_listView.currentIndex = index
                    console.log("選取值", modelData)
                }
            }

            Text {
                anchors.centerIn: parent
                text: modelData
                font.pixelSize: 20
                font.weight: Font.Bold


                //是否為選中項目
                property bool isNavSelected: index === root.currentIndex

                //顏色與縮放
                color: isNavSelected ? "#ffffff" : "#aaaaaa"
                scale: isNavSelected ? 1.0 : 0.6

                //動畫效果
                Behavior on scale {
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                //顏色動畫
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
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
