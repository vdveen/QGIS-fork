cmake_minimum_required(VERSION 3.16)
project(qgis_modern_ui_poc VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

# ─── Find Qt6 ────────────────────────────────────────────────────────────────
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Quick
    Qml
    QuickControls2
    Svg
)

# ─── Find QGIS ───────────────────────────────────────────────────────────────
# When building standalone, point QGIS_PREFIX_PATH to your QGIS install:
#   cmake -DQGIS_PREFIX_PATH=/usr/local ...
# When building inside the QGIS tree, these targets are already available.

if(TARGET qgis_core AND TARGET qgis_quick)
    message(STATUS "Building inside QGIS tree — using in-tree targets")
else()
    message(STATUS "Building standalone — looking for QGIS libraries")
    find_library(QGIS_CORE_LIB NAMES qgis_core PATHS ${QGIS_PREFIX_PATH}/lib)
    find_library(QGIS_QUICK_LIB NAMES qgis_quick PATHS ${QGIS_PREFIX_PATH}/lib)
    find_path(QGIS_INCLUDE_DIR qgis.h PATHS ${QGIS_PREFIX_PATH}/include/qgis)

    if(NOT QGIS_CORE_LIB OR NOT QGIS_QUICK_LIB OR NOT QGIS_INCLUDE_DIR)
        message(FATAL_ERROR
            "Could not find QGIS libraries. Set -DQGIS_PREFIX_PATH=<install-prefix>.")
    endif()

    add_library(qgis_core SHARED IMPORTED)
    set_target_properties(qgis_core PROPERTIES
        IMPORTED_LOCATION ${QGIS_CORE_LIB}
        INTERFACE_INCLUDE_DIRECTORIES ${QGIS_INCLUDE_DIR}
    )
    add_library(qgis_quick SHARED IMPORTED)
    set_target_properties(qgis_quick PROPERTIES
        IMPORTED_LOCATION ${QGIS_QUICK_LIB}
        INTERFACE_INCLUDE_DIRECTORIES ${QGIS_INCLUDE_DIR}
    )
endif()

# ─── QML Resources ───────────────────────────────────────────────────────────
qt_add_resources(QML_RESOURCES resources.qrc)

# ─── Executable ──────────────────────────────────────────────────────────────
add_executable(qgis_modern_ui
    main.cpp
    qgsmodernuiapplication.cpp
    qgsmodernuiapplication.h
    qgslayerlistmodel.cpp
    qgslayerlistmodel.h
    ${QML_RESOURCES}
)

target_link_libraries(qgis_modern_ui PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Svg
    qgis_core
    qgis_quick
)

target_include_directories(qgis_modern_ui PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src/quickgui
    ${CMAKE_SOURCE_DIR}/src/core
)
