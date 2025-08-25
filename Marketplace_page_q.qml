//Marketplace_page_q.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Component {
    Item {
        Rectangle {
            id: message_block
            anchors.fill: parent
            color: "transparent"

            //sliding animation
            Component {
                id: slideInAnimation
                ParallelAnimation {
                    //list_animation
                    NumberAnimation {
                        target: marketplace_search_bar_loadin_animation
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }


                    //member_list_animation
                    NumberAnimation {
                        target: marketplace_plugins__block_loadin_animation
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
            }






            // 淡入動畫
            states: State {
                name: "entered"
                PropertyChanges { target: message_block; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 300 }
            }

            // 初始透明，進場時淡入
            opacity: 0
            Component.onCompleted: {
                message_block.state = "entered"
                var anim = slideInAnimation.createObject(message_block)
                anim.start()

            }


            // 主排版區塊
            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                Rectangle {
                    id: marketplace_search_bar_area
                    color: "#44000000"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100

                    // 淡入動畫
                    OpacityAnimator { target: marketplace_search_bar_area; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:marketplace_search_bar_loadin_animation
                        y:100
                    }
                }


                //marketplace_plugins_container
                Rectangle {
                    id: marketplace_piugins_block
                    color: "#44000000"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    OpacityAnimator { target: marketplace_piugins_block; from: 0; to: 1; duration: 300 }

                    transform: Translate{
                        id:marketplace_plugins__block_loadin_animation
                        y:100
                    }


                    //plugins
                    ScrollView {
                        width: parent.width
                        height: parent.height

                        Column {
                            id:entire_plugin_area

                            width: parent.width
                            spacing: 60
                            Text {
                                text: entire_plugin_area.plugin_item_count
                                color: "transparent"
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                            }


                            property int plugin_item_width: 240
                            property int plugin_item_spacing: 30
                            property int plugin_item_count: Math.max(1, Math.floor(parent.width / (plugin_item_width + plugin_item_spacing)))
                            property int row_width: plugin_item_count * plugin_item_width + (plugin_item_count - 1) * plugin_item_spacing

                            Rectangle{
                                id:row_line_1
                                width: parent.width
                                height: 140
                                Row{
                                    id: row_1
                                    width: entire_plugin_area.row_width
                                    height: 140
                                    spacing: entire_plugin_area.plugin_item_spacing
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Repeater {
                                        model: entire_plugin_area.plugin_item_count
                                        delegate: Item {
                                            width: entire_plugin_area.plugin_item_width // 加上間距
                                            height: 140

                                            opacity: 0
                                            Behavior on opacity {
                                                NumberAnimation { duration: 1000 }
                                            }
                                            Component.onCompleted: opacity = 1


                                            Rectangle {
                                                width: entire_plugin_area.plugin_item_width
                                                height: parent.height
                                                color: index % 2 === 0 ? "white" : "lightgreen"
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "Item " + index
                                                }
                                            }
                                        }
                                    }

                                }
                            }

                            Rectangle{
                                id:row_line_2
                                width: parent.width
                                height: 140

                                Rectangle {
                                    anchors.fill: parent
                                    color: "red" // debug 用
                                }

                                Row{
                                    id: row_2
                                    width: entire_plugin_area.row_width
                                    height: 140
                                    spacing: entire_plugin_area.plugin_item_spacing
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Repeater {
                                        model: entire_plugin_area.plugin_item_count
                                        delegate: Item {
                                            width: entire_plugin_area.plugin_item_width // 加上間距
                                            height: 140

                                            opacity: 0
                                            Behavior on opacity {
                                                NumberAnimation { duration: 1000 }
                                            }
                                            Component.onCompleted: opacity = 1


                                            Rectangle {
                                                width: entire_plugin_area.plugin_item_width
                                                height: parent.height
                                                color: index % 2 === 0 ? "white" : "green"
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "Item " + index
                                                }
                                            }
                                        }
                                    }

                                }
                            }
                        }
                    }

                }
            }
        }
    }
}
