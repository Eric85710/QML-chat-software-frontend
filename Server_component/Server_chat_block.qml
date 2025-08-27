import QtQuick 2.15
import QtQuick.Layouts

ColumnLayout{
    anchors.fill: parent

    Rectangle {
        id:chat_message_block
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    Rectangle {
        id: message_input_block
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        color: "transparent"

        Rectangle {
            id: message_input_button_area
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 40
            radius: 12
            color: "black"
            opacity: 0.6
        }
    }
}
