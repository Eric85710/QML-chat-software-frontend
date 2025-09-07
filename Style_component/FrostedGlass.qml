import QtQuick 2.15
import QtQuick.Effects

Item {
    anchors.fill: parent

    ShaderEffectSource {
        id: cap
        sourceItem: wave_sh
        anchors.fill: parent
        visible: false
        live: true
    }

    MultiEffect {
        anchors.fill: parent
        source: cap
        brightness: 0.2
        saturation: 0.2
        blurEnabled: true
        blurMax: 32
        blur: 0.6
        colorization: 0.3
        colorizationColor: "#000000"
    }

}
