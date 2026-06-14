// Nav_wheel.qml：水平選單輪盤元件
import QtQuick
import App 1.0

Item {
    id: root



    // 📦 外部可設定的屬性
    property var model: []          // 選項列表資料
    property int currentIndex: 0    // 當前選中的索引
    property int displayIndex: currentIndex // 正在過渡顯示的索引
    property int itemWidth: 150     // 每個選項的寬度
    property int selectionWidth: itemWidth
    property int selectionHeight: 40
    property bool allowScroll: false // 滾輪切換時的視覺狀態
    property int lastWheelDirection: 0
    property int transitionDuration: 240
    property bool wheelScrolling: false
    property real wheelGestureStartX: 0
    property int wheelGestureDirection: 0
    property real wheelCommitThreshold: itemWidth * 0.06
    property real wheelPixelGain: 1.1
    readonly property int maxIndex: Math.max(0, itemCount() - 1)

    onCurrentIndexChanged: {
        if (!commitIndexTimer.running && root.displayIndex !== root.currentIndex) {
            root.displayIndex = clampIndex(root.currentIndex)
            snapToIndex(root.displayIndex, false)
        }
    }

    function itemCount() {
        return root.model ? root.model.length : 0
    }

    function clampIndex(index) {
        return Math.max(0, Math.min(index, root.maxIndex))
    }

    function contentXForIndex(index) {
        return clampIndex(index) * root.itemWidth
    }

    function clampContentX(contentX) {
        return Math.max(0, Math.min(contentX, contentXForIndex(root.maxIndex)))
    }

    function nearestIndex() {
        if (root.itemCount() <= 0) {
            return 0
        }

        return clampIndex(Math.round(nav_flickable.contentX / root.itemWidth))
    }

    function syncDisplayIndex() {
        root.displayIndex = nearestIndex()
    }

    function centerDistance(index) {
        return Math.abs(index - nav_flickable.contentX / root.itemWidth)
    }

    function centerAmount(index) {
        return Math.max(0, 1 - centerDistance(index))
    }

    function commitDisplayIndex() {
        if (root.currentIndex !== root.displayIndex) {
            root.currentIndex = root.displayIndex
            root.indexChanged(root.currentIndex)
        }
    }

    function snapToIndex(index, animated) {
        index = clampIndex(index)
        const targetX = contentXForIndex(index)

        if (animated) {
            snapAnimation.stop()
            snapAnimation.to = targetX
            snapAnimation.start()
        } else {
            snapAnimation.stop()
            nav_flickable.contentX = clampContentX(targetX)
        }
    }

    function settleToNearest() {
        if (root.itemCount() <= 0) {
            return
        }

        const index = nearestIndex()
        root.displayIndex = index
        root.allowScroll = true
        snapToIndex(index, true)
        commitIndexTimer.restart()
        scrollStateTimer.restart()
        whole_app_window.returnFocusToMain()
    }

    function settleWheelGesture() {
        if (root.itemCount() <= 0) {
            return
        }

        const moved = nav_flickable.contentX - root.wheelGestureStartX
        const movedAbs = Math.abs(moved)
        const startIndex = clampIndex(Math.round(root.wheelGestureStartX / root.itemWidth))
        let index = nearestIndex()
        if (movedAbs >= root.wheelCommitThreshold
                && root.wheelGestureDirection !== 0
                && index === startIndex) {
            index = clampIndex(startIndex + root.wheelGestureDirection)
        }

        root.displayIndex = index
        root.allowScroll = true
        snapToIndex(index, true)
        commitIndexTimer.restart()
        scrollStateTimer.restart()
        whole_app_window.returnFocusToMain()
    }

    function wheelAxisDelta(x, y) {
        return Math.abs(x) > Math.abs(y) ? -x : -y
    }

    function wheelDeviceType(wheel) {
        return wheel && wheel.device ? wheel.device.type : InputDevice.Unknown
    }

    function isMouseWheel(wheel) {
        return wheelDeviceType(wheel) === InputDevice.Mouse
    }

    function isAngleOnlyWheel(wheel) {
        const angleX = wheelValue(wheel.angleDelta, "x")
        const angleY = wheelValue(wheel.angleDelta, "y")
        const pixelX = wheelValue(wheel.pixelDelta, "x")
        const pixelY = wheelValue(wheel.pixelDelta, "y")
        return (Math.abs(angleX) > 0 || Math.abs(angleY) > 0)
                && Math.abs(pixelX) <= 0
                && Math.abs(pixelY) <= 0
    }

    function isTouchPadWheel(wheel) {
        return wheelDeviceType(wheel) === InputDevice.TouchPad
    }

    function isMouseLikeTouchPadWheel(wheel) {
        if (!root.isTouchPadWheel(wheel) || wheel.phase !== Qt.NoScrollPhase) {
            return false
        }

        const pixel = wheelAxisDelta(wheelValue(wheel.pixelDelta, "x"),
                                    wheelValue(wheel.pixelDelta, "y"))
        const angle = wheelAxisDelta(wheelValue(wheel.angleDelta, "x"),
                                    wheelValue(wheel.angleDelta, "y"))
        if (Math.abs(pixel) <= 0 || Math.abs(angle) <= 0) {
            return false
        }

        return Math.abs(Math.abs(angle) - Math.abs(pixel) * 2) < 0.01
    }

    function mouseWheelDistance(wheel) {
        const angleX = wheelValue(wheel.angleDelta, "x")
        const angleY = wheelValue(wheel.angleDelta, "y")
        const angle = wheelAxisDelta(angleX, angleY)
        if (Math.abs(angle) > 0) {
            return angle / 120 * root.itemWidth
        }

        const pixelX = wheelValue(wheel.pixelDelta, "x")
        const pixelY = wheelValue(wheel.pixelDelta, "y")
        return wheelAxisDelta(pixelX, pixelY)
    }

    function mouseLikeTouchPadDistance(wheel) {
        const angleX = wheelValue(wheel.angleDelta, "x")
        const angleY = wheelValue(wheel.angleDelta, "y")
        const angle = wheelAxisDelta(angleX, angleY)
        return angle / 240 * root.itemWidth
    }

    function touchpadWheelDistance(wheel) {
        const pixelX = wheelValue(wheel.pixelDelta, "x")
        const pixelY = wheelValue(wheel.pixelDelta, "y")
        if (Math.abs(pixelX) > 0 || Math.abs(pixelY) > 0) {
            const pixelDistance = wheelAxisDelta(pixelX, pixelY)
            return pixelDistance * root.wheelPixelGain
        }

        const angleX = wheelValue(wheel.angleDelta, "x")
        const angleY = wheelValue(wheel.angleDelta, "y")
        const angle = wheelAxisDelta(angleX, angleY)
        return angle / 120 * root.itemWidth
    }

    function scrollByPixels(distance) {
        if (Math.abs(distance) < 0.01) {
            return
        }

        snapAnimation.stop()
        nav_flickable.cancelFlick()

        if (!root.wheelScrolling) {
            root.wheelGestureStartX = nav_flickable.contentX
            root.wheelGestureDirection = 0
        }

        const startX = nav_flickable.contentX
        const targetX = clampContentX(startX + distance)
        nav_flickable.contentX = targetX
        root.syncDisplayIndex()
        root.wheelGestureDirection = distance > 0 ? 1 : -1
        root.allowScroll = true
        root.wheelScrolling = true
        wheelSettleTimer.restart()
        scrollStateTimer.restart()
    }

    function switchByWheelStep(step) {
        if (step === 0 || root.itemCount() <= 0) {
            return
        }

        wheelSettleTimer.stop()
        root.wheelScrolling = false
        root.switchToIndex(root.displayIndex + step)
    }

    function wheelValue(point, axis) {
        if (!point) {
            return 0
        }

        if (axis === "x") {
            return point.x !== undefined ? point.x : 0
        }

        return point.y !== undefined ? point.y : 0
    }

    function handleMacOsWheel(wheel) {
        const mouseLikeTouchPad = root.isMouseLikeTouchPadWheel(wheel)
        if (mouseLikeTouchPad) {
            const distance = root.mouseLikeTouchPadDistance(wheel)
            root.scrollByPixels(distance)
        } else if (root.isMouseWheel(wheel)) {
            const distance = root.mouseWheelDistance(wheel)
            root.scrollByPixels(distance)
        } else {
            const distance = root.touchpadWheelDistance(wheel)
            root.scrollByPixels(distance)
        }
    }

    function handleWindowsWheel(wheel) {
        if (root.isMouseWheel(wheel) || root.isAngleOnlyWheel(wheel)) {
            const step = SystemScroll.navigationStep(wheelValue(wheel.angleDelta, "x"),
                                                     wheelValue(wheel.angleDelta, "y"),
                                                     wheelValue(wheel.pixelDelta, "x"),
                                                     wheelValue(wheel.pixelDelta, "y"))
            root.switchByWheelStep(step)
            return
        }

        const distance = root.touchpadWheelDistance(wheel)
        root.scrollByPixels(distance)
    }

    function handleBasicWheel(wheel) {
        const step = SystemScroll.navigationStep(wheelValue(wheel.angleDelta, "x"),
                                                 wheelValue(wheel.angleDelta, "y"),
                                                 wheelValue(wheel.pixelDelta, "x"),
                                                 wheelValue(wheel.pixelDelta, "y"))
        root.switchByWheelStep(step)
    }

    function handleWheel(wheel) {
        if (SystemScroll.platform === "Windows") {
            root.handleWindowsWheel(wheel)
        } else if (SystemScroll.platform === "macOS") {
            root.handleMacOsWheel(wheel)
        } else {
            root.handleBasicWheel(wheel)
        }
    }

    function switchToIndex(index) {
        index = clampIndex(index)
        if (index < 0 || index >= root.itemCount()) {
            return false
        }

        root.allowScroll = true
        root.lastWheelDirection = index > root.displayIndex ? 1
                              : index < root.displayIndex ? -1
                              : root.lastWheelDirection
        scrollStateTimer.restart()

        if (index === root.displayIndex) {
            return false
        }

        root.displayIndex = index
        snapToIndex(index, true)
        commitIndexTimer.restart()
        whole_app_window.returnFocusToMain()
        return true
    }






    // 📢 當選中索引改變時發出訊號
    signal indexChanged(int index)





    // 📐 元件尺寸設定
    implicitWidth: whole_app_window.width
    implicitHeight: 70

    onWidthChanged: Qt.callLater(function() {
        root.snapToIndex(root.currentIndex, false)
    })





    Timer {
        id: scrollStateTimer
        interval: root.transitionDuration + 40
        repeat: false
        onTriggered: root.allowScroll = false
    }

    Timer {
        id: wheelSettleTimer
        interval: 140
        repeat: false
        onTriggered: {
            root.wheelScrolling = false
            root.settleWheelGesture()
        }
    }

    Timer {
        id: commitIndexTimer
        interval: root.transitionDuration
        repeat: false
        onTriggered: {
            root.commitDisplayIndex()
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 10
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.ArrowCursor
        onWheel: (wheel) => {
            root.handleWheel(wheel)
            wheel.accepted = true
        }
    }






    // 📜 水平 Flickable：選項中心精確對齊固定選中框中心
    Flickable {
        id: nav_flickable
        anchors.fill: parent
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        maximumFlickVelocity: 1800
        flickDeceleration: 3200
        contentWidth: root.itemCount() > 0
                      ? root.itemCount() * root.itemWidth + Math.max(0, width - root.itemWidth)
                      : width
        contentHeight: height
        clip: true

        Row {
            height: nav_flickable.height

            Item {
                width: Math.max(0, nav_flickable.width / 2 - root.itemWidth / 2)
                height: nav_flickable.height
            }

            Repeater {
                model: root.model

                delegate: Item {
                    width: root.itemWidth
                    height: nav_flickable.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: (mouse) => {
                            root.switchToIndex(index)
                            mouse.accepted = true
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        width: root.itemWidth - 24
                        horizontalAlignment: Text.AlignHCenter

                        property real selectedAmount: root.centerAmount(index)

                        color: Qt.rgba(0.67 + selectedAmount * 0.33,
                                       0.67 + selectedAmount * 0.33,
                                       0.67 + selectedAmount * 0.33,
                                       1)
                        scale: 0.6 + selectedAmount * 0.4

                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                }
            }

            Item {
                width: Math.max(0, nav_flickable.width / 2 - root.itemWidth / 2)
                height: nav_flickable.height
            }
        }

        onContentXChanged: {
            if (dragging || flicking || root.wheelScrolling || snapAnimation.running) {
                root.allowScroll = true
                scrollStateTimer.restart()
            }
        }

        onDraggingChanged: {
            if (!dragging && !flicking) {
                root.settleToNearest()
            }
        }

        onFlickingChanged: {
            if (!flicking && !dragging) {
                root.settleToNearest()
            }
        }

        onMovementEnded: {
            if (!root.wheelScrolling) {
                root.settleToNearest()
            }
        }
        Component.onCompleted: root.snapToIndex(root.currentIndex, false)
        onWidthChanged: Qt.callLater(function() {
            root.snapToIndex(root.currentIndex, false)
        })

        NumberAnimation {
            id: snapAnimation
            target: nav_flickable
            property: "contentX"
            duration: root.transitionDuration
            easing.type: Easing.OutCubic
        }
    }











    // 中間選中框：視覺提示目前選中項目
    Rectangle {
        id: choosing_rect
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: root.selectionWidth
        height: root.allowScroll ? 46 : root.selectionHeight

        // 🎞️ 動畫：高度變化
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        color: "#80808080" // 半透明灰色
        radius: 10
        z: 1
    }
}
