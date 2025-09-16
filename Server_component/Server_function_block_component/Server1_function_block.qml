//Server1_function_block.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "Server_additional_block"


Column {
    anchors.fill: parent
    spacing: 10

    Rectangle {
        width: parent.width
        height: server_name_text.height + 10  // 高度略加 margin 空間
        color: "transparent"

        Text {
            id: server_name_text
            text: qsTr("PC孤兒")
            font.bold: true
            font.pixelSize: 28
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20
            color: "white"
            opacity: 0.8
        }
    }


    //sperate line
    Rectangle {
        id: seperate_line_forserver_title
        width: parent.width
        height: 4
        color: "black"
        opacity: 0.2
    }







    //scrollable area
    ScrollView {
        width: parent.width
        height: parent.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        //all the scrollable function in here
        Column {
            width: parent.width
            spacing: 20
            padding: 10


            signal chatRoomClicked(string text_chat_room_id)





            Server_function_search_bar {
                id:server_fun_searchBar_anim
                transform: Translate { id: trans1; y: 100 }

                Component.onCompleted: SequentialAnimation {
                    NumberAnimation {
                        target: trans1
                        property: "y"
                        to: 0
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
            }





            Server_gallery_and_video {
                id:server_g_v_anim
                transform: Translate { id: trans2; y: 100 }
                opacity: 0

                Component.onCompleted: SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: server_g_v_anim
                            property: "opacity"
                            to: 1
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: trans2
                            property: "y"
                            to: 0
                            duration: 260
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }







            Server_text_chat {
                id:server_t_anim
                transform: Translate { id:trans3; y: 100}
                opacity: 0

                Component.onCompleted: SequentialAnimation {
                    PauseAnimation { duration: 40 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: server_t_anim
                            property: "opacity"
                            to: 1
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: trans3
                            property: "y"
                            to: 0
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }





            Server_voice_channel{
                id:server_v_anim
                transform: Translate { id:trans4; y: 100}
                opacity: 0

                Component.onCompleted: SequentialAnimation {
                    PauseAnimation { duration: 80 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: server_v_anim
                            property: "opacity"
                            to: 1
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: trans4
                            property: "y"
                            to: 0
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
