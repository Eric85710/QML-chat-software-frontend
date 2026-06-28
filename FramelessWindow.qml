import QtQuick
import QtQuick.Window
import QtQuick.Controls
import App 1.0

ApplicationWindow {
    id: root

    property alias windowChrome: systemWindowChrome
    property alias chromeDragArea: systemWindowChrome.dragArea
    property alias chromeMaximizeButton: systemWindowChrome.maximizeButton

    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint
           | Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    SystemWindowChrome {
        id: systemWindowChrome
        window: root
    }
}
