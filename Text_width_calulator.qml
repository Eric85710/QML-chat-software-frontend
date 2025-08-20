//text_width_calulator.qml

import QtQuick

Item {
    id: root
    property string text: ""
    property int fontSize: 20
    property bool bold: true
    property int padding: 40
    property int calculatedWidth: textItem.paintedWidth + padding

    implicitWidth: calculatedWidth
    implicitHeight: textItem.implicitHeight

    Text {
        id: textItem
        text: root.text
        font.pixelSize: root.fontSize
        font.bold: root.bold
        visible: false  // 不顯示，只用來計算寬度
    }
}
