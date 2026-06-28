import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Effects
import App 1.0
import "Style_component"

Item {
    id: appController

    property var loginWindow: null
    property var mainWindow: null

    Component.onCompleted: {
        loginWindow = loginShellWindowComponent.createObject(null)
        loginWindow.show()
    }

    function openMainWindow(sourceWindow) {
        if (!mainWindow) {
            mainWindow = mainAppWindowComponent.createObject(null)
        }

        mainWindow.show()
        mainWindow.raise()
        mainWindow.requestActivate()

        if (sourceWindow) {
            sourceWindow.destroy()
        }
    }

    component WindowControlButton: Rectangle {
        id: controlButton

        required property string iconName
        property bool danger: false
        property bool nativeHover: false
        property bool nativePressed: false
        readonly property bool hot: controlMouse.containsMouse || nativeHover || nativePressed
        readonly property bool down: controlMouse.pressed || nativePressed
        readonly property color iconColor: "#f5f5f5"
        readonly property color hoverColor: danger ? "#e81123" : "#c7c7c7"
        readonly property color pressedColor: danger ? "#c50f1f" : "#adadad"
        signal triggered()

        width: 46
        height: 32
        color: down ? pressedColor : (hot ? hoverColor : "transparent")

        Item {
            anchors.centerIn: parent
            width: 14
            height: 14

            Rectangle {
                visible: controlButton.iconName === "minimize"
                width: 12
                height: 1.4
                radius: 1
                anchors.centerIn: parent
                color: controlButton.iconColor
            }

            Rectangle {
                visible: controlButton.iconName === "maximize"
                width: 11
                height: 11
                anchors.centerIn: parent
                color: "transparent"
                border.color: controlButton.iconColor
                border.width: 1.4
            }

            Item {
                visible: controlButton.iconName === "restore"
                anchors.fill: parent

                Rectangle {
                    x: 4
                    y: 2
                    width: 8
                    height: 8
                    color: "transparent"
                    border.color: controlButton.iconColor
                    border.width: 1.2
                }

                Rectangle {
                    x: 2
                    y: 5
                    width: 8
                    height: 8
                    color: "transparent"
                    border.color: controlButton.iconColor
                    border.width: 1.2
                }
            }

            Rectangle {
                visible: controlButton.iconName === "close"
                width: 14
                height: 1.4
                radius: 1
                anchors.centerIn: parent
                rotation: 45
                color: controlButton.iconColor
            }

            Rectangle {
                visible: controlButton.iconName === "close"
                width: 14
                height: 1.4
                radius: 1
                anchors.centerIn: parent
                rotation: -45
                color: controlButton.iconColor
            }
        }

        MouseArea {
            id: controlMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.ArrowCursor
            onClicked: controlButton.triggered()
        }
    }

    Component {
        id: loginShellWindowComponent

        FramelessWindow {
            id: loginShell

            width: 640
            height: 480
            minimumWidth: 480
            minimumHeight: 360
            color: "#a3a3a3"
            title: qsTr("Login")
            chromeDragArea: loginWindow.dragArea
            chromeMaximizeButton: loginShell.windowChrome.usesSystemTitleButtons ? null : loginMaximizeWindowButton

            Component.onDestruction: {
                if (appController.loginWindow === loginShell) {
                    appController.loginWindow = null
                }
            }

            LoginWindow {
                id: loginWindow
                anchors.fill: parent
                windowChrome: loginShell.windowChrome
                windowTrailingInset: loginWindowControls.width

                onLoginAccepted: appController.openMainWindow(loginShell)
            }

            Row {
                id: loginWindowControls
                visible: !loginShell.windowChrome.usesSystemTitleButtons
                width: visible ? implicitWidth : 0
                anchors.top: parent.top
                anchors.right: parent.right
                height: 32
                z: 200

                WindowControlButton {
                    iconName: "minimize"
                    onTriggered: loginShell.windowChrome.showMinimized()
                }

                WindowControlButton {
                    id: loginMaximizeWindowButton
                    iconName: loginShell.windowChrome.maximized ? "restore" : "maximize"
                    onTriggered: loginShell.windowChrome.toggleMaximized()
                }

                WindowControlButton {
                    iconName: "close"
                    danger: true
                    onTriggered: loginShell.windowChrome.close()
                }
            }
        }
    }

    Component {
        id: mainAppWindowComponent

        FramelessWindow {
            id: whole_app_window

            width: 640
            height: 480
            minimumWidth: 480
            minimumHeight: 360
            color: "#ffffff"
            title: qsTr("Hello World")
            chromeDragArea: windowDragArea
            chromeMaximizeButton: whole_app_window.windowChrome.usesSystemTitleButtons ? null : maximizeWindowButton

            Component.onDestruction: {
                if (appController.mainWindow === whole_app_window) {
                    appController.mainWindow = null
                }
            }

            Theme_mode {
                id: theme
            }

            Item {
                id: mainFocusItem
                focus: true
                visible: false
                Keys.onPressed: {
                    console.log("主界面收到鍵盤事件:", event.key)
                }

                Keys.forwardTo: [ pickerWheel, pageLoader ]
            }

            function returnFocusToMain() {
                mainFocusItem.focus = true
            }

            property Item blurBackdropSource: backdropLayer

            // 需要被 BlurCard 实时采样的背景组件放在这个层里，BlurCard 本身不要放进来。
            Item {
                id: backdropLayer
                anchors.fill: parent

                Image {
                    id: bg1
                    anchors.fill: parent
                    source: theme.backgroundImage
                    fillMode: Image.PreserveAspectCrop
                    cache: false
                }
            }

            header: ToolBar {
                id: nav_bar

                property int nav_bar_h: 76
                property int windowDragAreaHeight: 24

                height: nav_bar_h
                topPadding: 0
                bottomPadding: 0
                leftPadding: 0
                rightPadding: 0
                spacing: 0
                clip: true

                background: Item {
                    anchors.fill: parent

                    BlurCard {
                        width: parent.width
                        height: parent.height
                        blurSource: whole_app_window.blurBackdropSource
                        borderRadius: 0
                        layer.enabled: true
                    }
                }

                Nav_wheel {
                    id: pickerWheel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: nav_bar.windowDragAreaHeight
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    model: ["message", "server", "marketplace", "setting", "workspace"]

                    onIndexChanged: {
                        console.log("選中項目:", model[currentIndex])
                    }
                }

                Item {
                    id: windowDragArea
                    x: whole_app_window.windowChrome.leadingInset
                    y: 0
                    width: Math.max(0, parent.width - x - windowControls.width)
                    height: nav_bar.windowDragAreaHeight
                    z: 30

                    DragHandler {
                        target: null
                        acceptedButtons: Qt.LeftButton
                        onActiveChanged: {
                            if (active) {
                                whole_app_window.windowChrome.startSystemMove()
                            }
                        }
                    }

                    TapHandler {
                        acceptedButtons: Qt.LeftButton
                        onDoubleTapped: whole_app_window.windowChrome.toggleMaximized()
                    }
                }

                Row {
                    id: windowControls
                    visible: !whole_app_window.windowChrome.usesSystemTitleButtons
                    width: visible ? implicitWidth : 0
                    anchors.top: parent.top
                    anchors.right: parent.right
                    height: 32
                    z: 40

                    WindowControlButton {
                        iconName: "minimize"
                        onTriggered: whole_app_window.windowChrome.showMinimized()
                    }

                    WindowControlButton {
                        id: maximizeWindowButton
                        iconName: whole_app_window.windowChrome.maximized ? "restore" : "maximize"
                        onTriggered: whole_app_window.windowChrome.toggleMaximized()
                    }

                    WindowControlButton {
                        iconName: "close"
                        danger: true
                        onTriggered: whole_app_window.windowChrome.close()
                    }
                }
            }

            Item {
                id: pageContentArea
                property int contentTopSpacing: 10

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: Math.max(contentTopSpacing,
                                            nav_bar.mapToItem(parent, 0, nav_bar.height).y + contentTopSpacing)
                clip: true

                Loader {
                    id: pageLoader
                    anchors.fill: parent
                    active: true
                    visible: true
                    sourceComponent: {
                        switch (pickerWheel.model[pickerWheel.currentIndex]) {
                            case "message": return message_Page
                            case "server": return server_Page
                            case "marketplace": return marketplace_Page
                            case "setting": return setting_page
                            case "workspace": return blur_iii
                            default: return server_Page
                        }
                    }
                }
            }

            Server_page_q {
                id: server_Page
            }

            Message_page_q {
                id: message_Page
            }

            Marketplace_page_q {
                id: marketplace_Page
            }

            Setting_page_q {
                id: setting_page
            }

            Component {
                id: blur_iii
                BlurCard {
                    blurSource: whole_app_window.blurBackdropSource
                    borderRadius: 35
                    anchors.centerIn: parent
                    layer.enabled: true
                }
            }
        }
    }
}
