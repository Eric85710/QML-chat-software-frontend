import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls


ColumnLayout{
    anchors.fill: parent



    //message will shows in here
    Rectangle {
        id:chat_message_block
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"

        ColumnLayout {
            id:showing_the_chat_message
            anchors.fill: parent





            //how the message looks like
            Rectangle {
                id:message_own
                Layout.fillWidth: true

                Row {
                    id: entire_message_row

                    //crop the image
                    Round_img_avatar {
                        width: 100
                        height: 100
                        radius: 50
                        source: "qrc:/img/after-sunset.jpg"
                    }







                    Text {
                        id: message_test
                        text: qsTr("yooooooo  婊子")
                        wrapMode: Text.Wrap
                        font.pixelSize: 20
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
        Layout.preferredHeight: 80
        color: "transparent"

        //input_bar_rect
        Rectangle {
            id: message_input_button_area
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 60
            radius: 12
            color: "black"
            opacity: 0.6


            RowLayout {
                anchors.fill: parent
                anchors.margins: 2

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "type..."
                    font.pixelSize: 16
                    background: null
                    onAccepted: {
                        console.log("搜尋關鍵字:", searchField.text)
                                // 這裡可以觸發搜尋邏輯
                    }
                }
            }
        }
    }
}
