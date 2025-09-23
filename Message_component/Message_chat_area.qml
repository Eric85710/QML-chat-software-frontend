import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import "../Server_component"


ColumnLayout{
    anchors.fill: parent





    //message will shows in here
    Rectangle {
        id:chat_message_block
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                whole_app_window.returnFocusToMain() // 焦點回主界面
                event.accepted = true
            }
        }

        ColumnLayout {
            id:showing_the_chat_message
            anchors.fill: parent





            //how the message looks like
            Rectangle {
                id:message_own
                Layout.fillWidth: true
                color: "transparent"

                Row {
                    id: entire_message_row
                    spacing: 10


                    //crop the image
                    Round_img_avatar {
                        width: 50
                        height: 50
                        radius: width / 2
                        source: "qrc:/img/after-sunset.jpg"
                    }




                    Rectangle {
                        id: message_background_color
                        color: "#4033ccff"
                        radius: 8

                        Column {
                            id:message_text_column
                            padding: 10
                            Text {
                                id: message_sender
                                text: qsTr("Walnut")
                                font.pixelSize: 18
                                font.bold: true
                                color: "#904d4ca7"
                            }

                            Text {
                                id: message_test
                                text: qsTr("yooooooo  婊子")
                                wrapMode: Text.Wrap
                                font.pixelSize: 22
                                color: "white"
                            }
                        }
                        implicitHeight: message_text_column.implicitHeight
                        implicitWidth: message_text_column.implicitWidth
                    }
                }
                implicitHeight: entire_message_row.implicitHeight + 10
            }
        }
    }
































    //input bar in here
    Rectangle {
        id: message_input_block
        Layout.fillWidth: true
        Layout.preferredHeight: message_input_button_area.height + 10
        color: "transparent"

        //input_bar_rect
        Rectangle {
            id: message_input_button_area
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: Math.min(Math.max(message_input.contentHeight, 40), 200) + 16
            radius: 12
            color: Qt.rgba(0.4, 0.4, 0.4, 0.4)

            anchors.bottom: parent.bottom


            //smoother transition for autoheight
            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }





            RowLayout {
                anchors.fill: parent
                anchors.margins: 2
                spacing: 0






                //plus icon
                Item {
                    id: plus_input_container
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    anchors.bottom: parent.bottom

                    Image {
                        id: plus_input
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        source: "qrc:/svg_icon/plus-svgrepo-com.svg"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            whole_app_window.returnFocusToMain()
                            event.accepted = true
                        }
                    }
                }


                //img_icon
                Item {
                    id: img_input_container
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 50
                    anchors.bottom: parent.bottom

                    Image {
                        id: img_input
                        width: parent.width
                        height: parent.height-10
                        anchors.centerIn: parent
                        source: "qrc:/svg_icon/image-plus-svgrepo-com.svg"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            whole_app_window.returnFocusToMain()
                            event.accepted = true
                        }
                    }
                }

                //emoji_icon
                Item {
                    id: emoji_input_container
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    anchors.bottom: parent.bottom

                    Image {
                        id: emoji_input
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: "qrc:/svg_icon/face-smile-svgrepo-com.svg"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            whole_app_window.returnFocusToMain()
                            event.accepted = true
                        }
                    }
                }













                Flickable {
                    id: message_input_flickable
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(message_input.contentHeight, message_input.maximumHeight)
                    contentHeight: message_input.contentHeight
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.VerticalFlick

                    TextEdit {
                        id: message_input
                        property int maximumHeight: 200
                        width: parent.width
                        wrapMode: TextEdit.Wrap
                        font.pixelSize: 24
                        color: "white"
                        height: contentHeight
                        anchors.top: parent.top

                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                if (event.modifiers & Qt.ShiftModifier) {
                                    event.accepted = false
                                } else {
                                    console.log("Send:", message_input.text)
                                    message_input.text = ""
                                    event.accepted = true
                                }
                            } else if (event.key === Qt.Key_Escape) {
                                whole_app_window.returnFocusToMain()
                                event.accepted = true
                            }
                        }
                    }

                    // 不顯示任何滾動條
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AlwaysOff
                    }
                }







                //send_icon
                Item {
                    id: send_input_container
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    anchors.bottom: parent.bottom

                    Image {
                        id: send_input
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: "qrc:/svg_icon/send-alt-1-svgrepo-com.svg"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            whole_app_window.returnFocusToMain()
                            event.accepted = true
                        }
                    }
                }


            }
        }
    }
}
