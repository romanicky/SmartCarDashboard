cmake_minimum_required(VERSION 3.16)

project(SmartCarDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Network Location Positioning Multimedia)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appSmartCarDashboard
    main.cpp
    src/CarInfoModel.cpp
    src/CarDataReceiver.cpp
)

qt_add_qml_module(appSmartCarDashboard
    URI SmartCarDashboard
    QML_FILES
    Main.qml
    qml/themes/Theme.qml
    qml/themes/DarkTheme.qml
    qml/themes/LightTheme.qml
    qml/components/MusicCard.qml
    qml/components/DashboardCard.qml
    qml/components/WeatherCard.qml
    qml/components/MapCard.qml
    qml/components/CarInfoCard.qml
    qml/components/TopBar.qml
    qml/components/BottomBar.qml
    qml/components/StatItem.qml
    qml/components/GearButton.qml
    qml/components/CameraCard.qml
    qml/components/CarRunningCard.qml

    RESOURCES
    qml/themes/qmldir
    asset/images/car_left.svg
    asset/images/car_left.png
    asset/images/album_cover.png
    asset/icons/expand_music.svg
    asset/icons/search.svg
    asset/icons/play.svg
    asset/icons/pause.svg
    asset/icons/prev.svg
    asset/icons/next.svg
    asset/icons/sunny.svg
    asset/icons/cloud.svg
    asset/icons/rainny.svg
    asset/icons/moon.svg
    asset/icons/tire_pressure.svg
    asset/icons/headlights.svg

    asset/wea/6h_8h.png
    asset/wea/8h_15h.png
    asset/wea/15h_18h.png
    asset/wea/18h_6h.png
    asset/wea/cloud.png
    asset/wea/rain.png
    asset/wea/cloudy.png
    asset/wea/moon.png
    asset/wea/rainicon.png
    asset/wea/sun.png

    SOURCES musicplayer.h musicplayer.cpp
    RESOURCES asset/images/car_light.png asset/images/car.png
    RESOURCES asset/icons/left.svg asset/icons/right.svg
    RESOURCES asset/images/charge.png
    RESOURCES asset/images/charge.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSmartCarDashboard PROPERTIES

    # MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSmartCarDashboard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSmartCarDashboard
    PRIVATE Qt6::Quick Qt6::Network Qt6::Location Qt6::Positioning Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appSmartCarDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
