// EBlurCard
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    // --- 公共属性 ---
    property Item blurSource
    property real blurAmount: 1
    property bool dragable: false

    property real blurMax: 32
    property real blurPadding: Math.ceil(blurMax * 0.75)
    property int downsampleFactor: 2
    property bool live: true
    property real borderRadius: 24
    property color borderColor: "transparent"
    property real borderWidth: 0

    property rect currentSourceRect: Qt.rect(0, 0, 1, 1)

    default property alias content: contentItem.data

    width: 300
    height: 200

    onXChanged: updateSourceRect()
    onYChanged: updateSourceRect()
    onWidthChanged: updateSourceRect()
    onHeightChanged: updateSourceRect()
    onBlurPaddingChanged: updateSourceRect()
    onBlurSourceChanged: updateSourceRect()
    Component.onCompleted: updateSourceRect()

    // --- 拖动功能 ---
    MouseArea {
        anchors.fill: parent
        drag.target: root
        drag.axis: Drag.XAndYAxis
        enabled: root.dragable
    }

    function sourceRectForCard() {
        const source = root.blurSource
        if (!source || root.width <= 0 || root.height <= 0) {
            return Qt.rect(0, 0, 1, 1)
        }

        const pad = Math.max(0, root.blurPadding)
        const topLeft = root.mapToItem(source, -pad, -pad)
        const bottomRight = root.mapToItem(source,
                                           root.width + pad,
                                           root.height + pad)

        return Qt.rect(Math.min(topLeft.x, bottomRight.x),
                       Math.min(topLeft.y, bottomRight.y),
                       Math.max(1, Math.abs(bottomRight.x - topLeft.x)),
                       Math.max(1, Math.abs(bottomRight.y - topLeft.y)))
    }

    function updateSourceRect() {
        const nextRect = sourceRectForCard()
        if (currentSourceRect.x !== nextRect.x
                || currentSourceRect.y !== nextRect.y
                || currentSourceRect.width !== nextRect.width
                || currentSourceRect.height !== nextRect.height) {
            currentSourceRect = nextRect
        }
    }

    Timer {
        interval: 16
        repeat: true
        running: root.live && root.visible && root.blurSource
        onTriggered: root.updateSourceRect()
    }

    // --- 实时捕获背景层到 GPU 纹理 ---
    ShaderEffectSource {
        id: effectSource
        readonly property real captureWidth: Math.max(1, root.width + root.blurPadding * 2)
        readonly property real captureHeight: Math.max(1, root.height + root.blurPadding * 2)

        width: captureWidth
        height: captureHeight
        sourceItem: root.blurSource
        sourceRect: root.currentSourceRect
        live: root.live
        recursive: false
        smooth: true
        textureSize: Qt.size(Math.max(1, Math.ceil(captureWidth / Math.max(1, root.downsampleFactor))),
                             Math.max(1, Math.ceil(captureHeight / Math.max(1, root.downsampleFactor))))
        visible: false
    }

    // === 创建遮罩 ===
    Item {
        id: maskItem
        width: effectSource.width
        height: effectSource.height
        layer.enabled: true
        layer.smooth: true
        visible: false
        Rectangle {
            x: root.blurPadding
            y: root.blurPadding
            width: root.width
            height: root.height
            radius: root.borderRadius
            color: "white"  // 必须是不透明色，否则遮罩无效
        }
    }

    // === 启用遮罩 ===
    MultiEffect {
        x: -root.blurPadding
        y: -root.blurPadding
        width: effectSource.width
        height: effectSource.height
        source: effectSource
        autoPaddingEnabled: false
        blurEnabled: true
        blurMax: root.blurMax
        blur: root.blurAmount
        maskEnabled: true
        maskSource: maskItem
    }

    // ====叠加主题色, 避免过亮/过透明 ====
    Rectangle {
        anchors.fill: parent
        radius: root.borderRadius
        color: theme.blurOverlayColor
        z: 1
        opacity: 1.0
        border.color: root.borderColor
        border.width: root.borderWidth
    }

    // 内容容器
    Item {
        id: contentItem
        anchors.fill: parent
        clip: true
        z: 2
    }
}
