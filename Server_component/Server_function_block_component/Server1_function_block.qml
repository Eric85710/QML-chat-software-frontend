//Server1_function_block.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


Column {
    anchors.fill: parent
    spacing: 20



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





    Rectangle {
        id:server1_function_area_search_bar
        width: parent.width-20
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







    //Gallery and Video
    Rectangle {
        id:gallery_and_video_Rect
        width: parent.width - 20
        height: 86
        radius: 12
        color: "#777"
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors.fill: parent
            spacing: 10
            padding: 10


            //gallery
            Rectangle {
                width: (gallery_and_video_Rect.width / 2) - 15
                height: 70
                radius: 12
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(180/255, 180/255, 180/255, 1.0)

                Row {
                    anchors.fill: parent
                    spacing: 4
                    padding: 10

                    Image {
                        width: 32
                        height: 32
                        id: server_gallery_icon
                        source: "qrc:/svg_icon/gallery-svgrepo-com.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: qsTr("Gallery")
                        color: "black"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 16
                    }
                }
            }

            Rectangle {
                width: (gallery_and_video_Rect.width / 2) - 15
                height: 70
                radius: 12
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(180/255, 180/255, 180/255, 1.0)

                Row {
                    anchors.fill: parent
                    spacing: 4
                    padding: 10

                    Image {
                        width: 32
                        height: 32
                        id: server_video_icon
                        source: "qrc:/svg_icon/video-library-svgrepo-com.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: qsTr("Video")
                        color: "black"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 16
                    }
                }
            }
        }
    }








    Rectangle {
        id: text_chaanel_rect
        width: parent.width - 20
        radius: 12
        color: "#777"
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: text_chaanel_content.implicitHeight + 2

        Column {
            anchors.fill: parent
            id:text_chaanel_content

            //text function title
            Row {
                width: parent.width
                height: 32
                padding: 10
                spacing: 2

                Image {
                    width: 20
                    height: 20
                    id: text_chaanel_icon
                    source: "qrc:/svg_icon/text-square-svgrepo-com.svg"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: text_chaanel_title
                    text: qsTr("文字頻道")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }


            //seperate_line
            Rectangle {
                width: parent.width
                height: 2
            }

            Column {
                width: parent.width
                spacing: 8
                padding: 10

                Rectangle {
                    width: parent.width - 36
                    height: 30
                    radius: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: parent.width - 36
                    height: 30
                    radius: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: parent.width - 36
                    height: 30
                    radius: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
