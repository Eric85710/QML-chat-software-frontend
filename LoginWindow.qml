import QtQuick

Item {
    id: root

    signal loginAccepted()

    property alias dragArea: authDragArea
    property var windowChrome: null
    property string mode: "welcome"
    property int windowTrailingInset: 0
    readonly property int backButtonMargin: 18
    readonly property int backButtonTopOffset: root.windowChrome && root.windowChrome.usesSystemTitleButtons ? 22 : 0
    readonly property int windowLeadingInset: root.windowChrome ? root.windowChrome.leadingInset : 0

    function openMainPage() {
        root.loginAccepted()
    }

    Rectangle {
        anchors.fill: parent
        color: "#a3a3a3"
    }

    Item {
        id: authDragArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: root.windowLeadingInset
        anchors.rightMargin: root.windowTrailingInset
        height: 20

        DragHandler {
            target: null
            acceptedButtons: Qt.LeftButton
            onActiveChanged: {
                if (active && root.windowChrome) {
                    root.windowChrome.startSystemMove()
                }
            }
        }

        TapHandler {
            acceptedButtons: Qt.LeftButton
            onDoubleTapped: {
                if (root.windowChrome) {
                    root.windowChrome.toggleMaximized()
                }
            }
        }
    }

    component AuthButton: Rectangle {
        id: authButton

        signal clicked()

        property string label: ""
        property color normalColor: "#ff9148"
        property int labelSize: 20

        width: 112
        height: 46
        radius: 8
        clip: true
        color: normalColor

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: buttonMouse.pressed ? "#00000024"
                                       : (buttonMouse.containsMouse ? "#00000018" : "transparent")
        }

        Text {
            anchors.centerIn: parent
            text: authButton.label
            color: "#ffffff"
            font.pixelSize: authButton.labelSize
            font.bold: true
        }

        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: authButton.clicked()
        }
    }

    component BackButton: Rectangle {
        id: backButton

        signal clicked()

        width: 26
        height: 26
        radius: 13
        color: "#050505"

        Text {
            anchors.centerIn: parent
            text: "←"
            color: "#bdbdbd"
            font.pixelSize: 18
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: backButton.clicked()
        }
    }

    component TextInputBlock: Column {
        id: inputBlock

        required property string label
        property bool password: false
        property alias text: textInput.text

        spacing: 8
        width: 334

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: inputBlock.label
            color: "#ffffff"
            font.pixelSize: 16
            font.bold: true
        }

        Rectangle {
            width: parent.width
            height: 54
            radius: 8
            color: "#403e3e"
            clip: true

            TextInput {
                id: textInput

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                color: "#ffffff"
                font.pixelSize: 18
                echoMode: inputBlock.password ? TextInput.Password : TextInput.Normal
                verticalAlignment: TextInput.AlignVCenter
                selectByMouse: true
            }
        }
    }

    component FinderPattern: Item {
        id: finder

        width: 42
        height: 42

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: "#000000"
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 7
            radius: 3
            color: "#d1c7c7"
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 15
            radius: 2
            color: "#000000"
        }
    }

    component QrPreview: Rectangle {
        id: qrPreview

        width: 204
        height: width
        radius: 14
        color: "#d1c7c7"

        Item {
            id: qr

            readonly property real cell: width / 9

            width: parent.width * 0.62
            height: width
            anchors.centerIn: parent

            FinderPattern {
                x: 0
                y: 0
            }

            FinderPattern {
                x: qr.width - width
                y: 0
            }

            FinderPattern {
                x: 0
                y: qr.height - height
            }

            Repeater {
                model: [
                    [3, 3], [4, 3], [6, 3],
                    [2, 4], [4, 4], [5, 4], [7, 4],
                    [3, 5], [5, 5], [6, 5], [8, 5],
                    [2, 6], [4, 6], [6, 6],
                    [3, 7], [5, 7], [7, 7],
                    [4, 8], [6, 8]
                ]

                Rectangle {
                    x: modelData[0] * qr.cell
                    y: modelData[1] * qr.cell
                    width: qr.cell
                    height: qr.cell
                    color: "#000000"
                }
            }
        }
    }

    Item {
        id: welcomePage
        anchors.fill: parent
        visible: root.mode === "welcome"

        Rectangle {
            id: welcomeCard

            anchors.fill: parent
            radius: 0
            color: "#a3a3a3"

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Math.max(80, parent.height * 0.25)
                text: "Welcome"
                color: "#ffffff"
                font.pixelSize: Math.min(76, parent.width * 0.13)
                font.bold: true
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Math.max(46, parent.height * 0.09)
                spacing: Math.max(40, parent.width * 0.10)

                AuthButton {
                    width: 194
                    height: 70
                    label: "login"
                    labelSize: 30
                    normalColor: "#d5d5d5"
                    onClicked: root.mode = "login"
                }

                AuthButton {
                    width: 194
                    height: 70
                    label: "Register"
                    labelSize: 30
                    normalColor: "#ffbd4f"
                    onClicked: root.mode = "register"
                }
            }
        }
    }

    Item {
        id: loginPage
        anchors.fill: parent
        visible: root.mode === "login"

        Rectangle {
            id: loginCard

            readonly property bool compact: width < 560

            anchors.fill: parent
            radius: 0
            color: "#a3a3a3"

            BackButton {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: root.backButtonMargin
                anchors.topMargin: root.backButtonMargin + root.backButtonTopOffset
                onClicked: root.mode = "welcome"
            }

            Row {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 14
                spacing: loginCard.compact ? 0 : 58

                Column {
                    width: loginCard.compact ? Math.min(334, loginCard.width - 88) : 334
                    spacing: 24

                    TextInputBlock {
                        width: parent.width
                        label: "username"
                    }

                    TextInputBlock {
                        width: parent.width
                        label: "password"
                        password: true
                    }

                    Item {
                        width: 1
                        height: 22
                    }

                    AuthButton {
                        width: 99
                        height: 46
                        anchors.horizontalCenter: parent.horizontalCenter
                        label: "login"
                        labelSize: 20
                        onClicked: root.openMainPage()
                    }
                }

                Column {
                    visible: !loginCard.compact
                    spacing: 28

                    QrPreview {}

                    AuthButton {
                        width: 100
                        height: 36
                        anchors.horizontalCenter: parent.horizontalCenter
                        label: "Refresh"
                        labelSize: 16
                        normalColor: "#dedede"
                    }
                }
            }
        }
    }

    Item {
        id: registerPage
        anchors.fill: parent
        visible: root.mode === "register"

        Rectangle {
            id: registerCard

            anchors.fill: parent
            radius: 0
            color: "#a3a3a3"

            BackButton {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: root.backButtonMargin
                anchors.topMargin: root.backButtonMargin + root.backButtonTopOffset
                onClicked: root.mode = "welcome"
            }

            Column {
                width: Math.min(334, parent.width - 118)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Math.max(58, parent.height * 0.12)
                spacing: 18

                TextInputBlock {
                    width: parent.width
                    label: "displayName"
                }

                TextInputBlock {
                    width: parent.width
                    label: "UserName"
                }

                TextInputBlock {
                    width: parent.width
                    label: "Password"
                    password: true
                }

                Item {
                    width: 1
                    height: 12
                }

                AuthButton {
                    width: 113
                    height: 46
                    anchors.horizontalCenter: parent.horizontalCenter
                    label: "Register"
                    labelSize: 20
                    onClicked: root.openMainPage()
                }
            }
        }
    }
}
