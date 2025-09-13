import QtQuick

//Gallery and Video
Rectangle {
    id:gallery_and_video_Rect
    width: parent.width - 20
    height: 86
    radius: 12
    color: Qt.rgba(0.8, 0.8, 0.8, 0.4)
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
