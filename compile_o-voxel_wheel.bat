@echo off
@if not defined DevEnvDir (
    set "InstalledVSPath="
    set "VsWherePath="

    setlocal enabledelayedexpansion

    @if exist "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" (
        set "VsWherePath=C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
    )

    @if exist "C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe" (
        set "VsWherePath=C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe"
    )

    if not defined VsWherePath (
        echo.
        echo #############################################################
        echo No Visual-Studio or VS-Build-Tools installation was detected.
        echo #############################################################
        exit /b 1
    )

    for /f "usebackq tokens=*" %%i in (
        `"!VsWherePath!" -products * -latest -property installationPath`
    ) do set "InstalledVSPath=%%i"

    if defined InstalledVSPath (
        if exist "!InstalledVSPath!\VC\Auxiliary\Build\vcvarsall.bat" (
            call "!InstalledVSPath!\VC\Auxiliary\Build\vcvarsall.bat" x64
        ) else (
            echo.
            echo ################################
            echo Error: vcvarsall.bat not found.
            echo ################################
            exit /b 1
        )
    ) else (
        echo.
        echo #############################################################
        echo No Visual-Studio or VS-Build-Tools installation was detected.
        echo #############################################################
        exit /b 1
    )
)

set DISTUTILS_USE_SDK=1

pip wheel .\o-voxel --no-build-isolation --no-deps -w dist

