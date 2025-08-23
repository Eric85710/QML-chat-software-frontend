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
                    radius: 12

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
                    radius: 12

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
                            width: parent.width
                            spacing: 10

                            Repeater {
                                model: 20
                                delegate: Rectangle {
                                    width: parent.width
                                    height: 40
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
            }
        }
    }
}
