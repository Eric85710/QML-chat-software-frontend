cmake_minimum_required(VERSION 3.16)

project(qrc_test VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appqrc_test
    main.cpp
    ${RESOURCE_ADDED}
)

qt_add_qml_module(appqrc_test
    URI qrc_test
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES resources.qrc
        QML_FILES Nav_wheel.qml
        QML_FILES Text_width_calulator.qml
        QML_FILES Server_page_q.qml
        QML_FILES Message_page_q.qml
        QML_FILES Marketplace_page_q.qml
        QML_FILES Server_component/Server_list.qml
        QML_FILES Server_component/Server_chat_block.qml
        QML_FILES Server_component/Round_img_avatar.qml
        QML_FILES Style_component/Style_Component.qml
        QML_FILES Style_component/FrostedGlass.qml
        QML_FILES Server_component/Server_function_block_component/Server1_function_block.qml
        QML_FILES Server_component/Server_function_block_component/Server2_function_block.qml
        RESOURCES svg_icon/gallery-svgrepo-com.svg
        RESOURCES svg_icon/video-library-svgrepo-com.svg
        RESOURCES svg_icon/search-svgrepo-com.svg
        RESOURCES svg_icon/text-square-svgrepo-com.svg
        QML_FILES Server_component/Server_function_block_component/Server_additional_block/Server_voice_channel.qml
        QML_FILES Server_component/Server_function_block_component/Server_additional_block/Server_text_chat.qml
        QML_FILES Server_component/Server_function_block_component/Server_additional_block/Server_gallery_and_video.qml
        QML_FILES Server_component/Server_function_block_component/Server_additional_block/Server_function_search_bar.qml
        RESOURCES svg_icon/sound-loud-svgrepo-com.svg
        QML_FILES Server_component/Server_members_list_block.qml
        QML_FILES Message_component/Friends_chat_list_v1.qml
        QML_FILES Setting_page_q.qml
        QML_FILES Setting_page_component/Setting_list_v2.qml
        QML_FILES Setting_page_component/Settting_option_pages/Profile_setting.qml
        QML_FILES Setting_page_component/Settting_option_pages/Theme_page_q.qml
        QML_FILES Style_component/FrostedGlass_V2.qml
        RESOURCES svg_icon/plus-svgrepo-com.svg
        RESOURCES svg_icon/plus-circle-svgrepo-com.svg
        QML_FILES Server_component/Server_function_windows/Group_text_chat.qml
        QML_FILES Server_component/Server_function_windows/Server_function_windows_component/Gallery_filter.qml
        QML_FILES Server_component/Server_function_windows/Server_function_windows_component/Server_chat_block.qml Server_component/Server_function_windows/Server_function_windows_component/Server_members_list_block.qml
        QML_FILES Server_component/Server_function_windows/Server_function_windows_component/Round_img_avatar.qml
        QML_FILES Server_Page_status/Chat_room_status.qml
        SOURCES Server_Page_status/eventbus.h
        QML_FILES Server_component/Server_function_windows/Group_gallery.qml
        QML_FILES Server_component/Server_function_windows/Group_video.qml
        QML_FILES Message_component/Message_chat_area.qml
        QML_FILES Message_component/message_display/message_room_style_V1.qml
        RESOURCES svg_icon/plus-svgrepo-com.svg
        RESOURCES svg_icon/image-plus-svgrepo-com.svg
        RESOURCES svg_icon/face-smile-svgrepo-com.svg
        RESOURCES svg_icon/gallery-minimalistic-svgrepo-com.svg
        RESOURCES svg_icon/send-alt-1-svgrepo-com.svg
)


qt_add_resources(appqrc_test "icons"
    PREFIX "/"
    FILES img/after-sunset.jpg
    FILES
        img/avatar.png
        svg_icon/gallery-svgrepo-com.svg
        svg_icon/video-library-svgrepo-com.svg
        svg_icon/search-svgrepo-com.svg
        svg_icon/text-square-svgrepo-com.svg
        svg_icon/sound-loud-svgrepo-com.svg
        svg_icon/plus-svgrepo-com.svg
        svg_icon/plus-circle-svgrepo-com.svg
        svg_icon/plus-svgrepo-com.svg
        svg_icon/image-plus-svgrepo-com.svg
        svg_icon/face-smile-svgrepo-com.svg
        svg_icon/gallery-minimalistic-svgrepo-com.svg
        svg_icon/send-alt-1-svgrepo-com.svg
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appqrc_test PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appqrc_test
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appqrc_test
    PRIVATE Qt6::Quick
)
target_link_libraries(appqrc_test PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appqrc_test
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
