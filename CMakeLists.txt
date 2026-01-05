cmake_minimum_required(VERSION 3.16)

project(SmartCarDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appSmartCarDashboard
    main.cpp
)

qt_add_qml_module(appSmartCarDashboard
    URI SmartCarDashboard
    QML_FILES
        Main.qml
        RESOURCES qml/themes/qmldir
        qml/themes/Theme.qml
        qml/themes/DarkTheme.qml
        qml/themes/LightTheme.qml
        qml/components/DashboardCard.qml
RESOURCES build/Qt_6_10_1_for_macOS-Debug/SmartCarDashboard/qml/components/qmldir build/Qt_6_10_1_for_macOS-Debug/SmartCarDashboard/qml/themes/qmldir
QML_FILES build/Qt_6_10_1_for_macOS-Debug/SmartCarDashboard/qml/components/DashboardCard.qml build/Qt_6_10_1_for_macOS-Debug/SmartCarDashboard/qml/themes/DarkTheme.qml build/Qt_6_10_1_for_macOS-Debug/SmartCarDashboard/qml/themes/LightTheme.qml build/Qt_6_10_1_for_macOS-Debug/SmartCarDashboard/qml/themes/Theme.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSmartCarDashboard PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSmartCarDashboard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSmartCarDashboard
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appSmartCarDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
