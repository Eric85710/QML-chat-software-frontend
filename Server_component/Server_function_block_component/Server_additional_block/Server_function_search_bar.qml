import QtQuick
import QtQuick.Controls

//function search bar
Rectangle {
    id:server1_function_area_search_bar
    width: parent.width - 20
    height: 40
    radius: 12
    color: "black"
    opacity: 0.2
    anchors.horizontalCenter: parent.horizontalCenter

    Row {
        anchors.fill: parent
        spacing: 6
        padding: 10

        Image {
            width: 30
            height: 30
            id: server1_function_area_search_bar_icon
            source: "qrc:/svg_icon/search-svgrepo-com.svg"
            anchors.verticalCenter: parent.verticalCenter
        }

        TextField {
            id: server_searchInput
            placeholderText: "Search server's function"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
