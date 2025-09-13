//Round_img_avatar.qml
import QtQuick
import QtQuick.Effects

Image {
    id: avatar
    property alias radius: avatar_mask.radius

    layer.enabled: true
    layer.effect: MultiEffect {
        maskEnabled: true
        maskSource: avatar_mask
    }



    Rectangle {
        id: avatar_mask
        anchors.fill: parent
        layer.enabled: true

        visible: false
    }
}
