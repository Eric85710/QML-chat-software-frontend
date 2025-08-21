cmake_minimum_required(VERSION 3.16)

project(qrc_test VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

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
)


qt_add_resources(appqrc_test "icons"
    PREFIX "/"
    FILES img/after-sunset.jpg
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

include(GNUInstallDirs)
install(TARGETS appqrc_test
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
