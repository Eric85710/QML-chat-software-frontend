// Chat_room_status.qml
pragma Singleton
import QtQuick

QtObject {
    signal pageChanged(string key)

    function changePage(key) {
        console.log("Chat_room_status 發送:", key)
        pageChanged(key)   // ✅ 直接呼叫 signal（這裡才可以）
    }
}
