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
        Layout.preferredHeight: 200
    }
}
