import QtQuick
import QtQuick.Controls

Item {
    id:whole_friends_chat_list
    width: parent.width
    height: parent.height
    
    signal optionSelected(string option)

    ListModel {
        id: setting_optionModel
        ListElement { setting_option: "profile" }
        ListElement { setting_option: "theme" }
        ListElement { setting_option: "devices" }
        ListElement { setting_option: "marketplace" }
        ListElement { setting_option: "subscribetion" }
        ListElement { setting_option: "hardware" }
        ListElement { setting_option: "shortcut" }
        ListElement { setting_option: "language" }
        ListElement { setting_option: "payment" }
    }

    ListView {
        height: parent.height
        width: parent.width - 20
        model: setting_optionModel
        orientation: ListView.Vertical
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter


        header: Item {
            width: parent.width
            height: 60 // 你想要的間距高度

            Rectangle {
                id: setting_option_searchBar
                width: parent.width - 20
                height: 40
                radius: 6
                opacity: 0.4
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    anchors.fill: parent
                    padding: 10
                    Image {
                        id: friends_chat_list_searchBar_icon
                        width: 28
                        height: 28
                        source: "qrc:/svg_icon/search-svgrepo-com.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

            }
        }

        delegate: Rectangle {
            width: whole_friends_chat_list.width
            height: 72
            color: "transparent"
            radius: 6



            Rectangle {
                id:setting_button_block
                width: whole_friends_chat_list.width - 40
                height: 64
                color: "#10FFFFFF"
                radius: 12

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    padding: 10
                    Text {
                        text: setting_option
                        font.bold: true
                        font.pointSize: 24
                        color: "#90b0e0f0"
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Clicked:", setting_option)
                        whole_friends_chat_list.optionSelected(setting_option)
                        currentSettingOption = setting_option
                    }
                    hoverEnabled: true
                    onEntered: parent.color = "#90a3d5e5"
                    onExited: parent.color = "#10FFFFFF"
                }
            }
        }
    }
}
