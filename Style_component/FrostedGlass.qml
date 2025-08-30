// FrostedGlass.qml
import QtQuick 2.15
import QtQuick.Effects

Item {
    id: frostedGlass
    property Item sourceItem  // 要模糊的背景元件
    property real blurAmount: 0.6
    property color overlayColor: "gray"
    property real overlayOpacity: 0.2
    property int radius: 12

    width: 200
    height: 200
    clip: true

    ShaderEffectSource {
        id: blurSource
        sourceItem: frostedGlass.sourceItem
        live: true
        hideSource: false
        anchors.fill: parent
        sourceRect: Qt.rect(frostedGlass.x, frostedGlass.y, frostedGlass.width, frostedGlass.height)
    }

    MultiEffect {
        anchors.fill: parent
        source: blurSource
        blurEnabled: true
        blur: frostedGlass.blurAmount
    }

    Rectangle {
        anchors.fill: parent
        color: frostedGlass.overlayColor
        opacity: frostedGlass.overlayOpacity
        radius: frostedGlass.radius
    }

    Rectangle {
        anchors.fill: parent
        radius: frostedGlass.radius
        color: "transparent"
    }
}
