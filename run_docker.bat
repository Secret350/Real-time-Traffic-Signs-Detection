@echo off
REM -------------------------------------------------------------
REM  run_docker.bat  —  Chạy VN Traffic Detection trên Windows
REM  Yêu cầu: Docker Desktop + VcXsrv
REM  Cách dùng:
REM    GPU : run_docker.bat
REM    CPU : run_docker.bat cpu
REM -------------------------------------------------------------

setlocal EnableDelayedExpansion

echo   VN Traffic Detection -- Docker Launcher
echo.

docker info >nul 2>&1
if errorlevel 1 (
    echo [LOI] Docker Desktop chua chay!
    echo       Hay mo Docker Desktop truoc roi thu lai.
    pause & exit /b 1
)
echo [OK]  Docker Desktop dang chay.

taskkill /f /im vcxsrv.exe >nul 2>&1

set VCXSRV_PATH=
if exist "C:\Program Files\VcXsrv\vcxsrv.exe" (
    set VCXSRV_PATH=C:\Program Files\VcXsrv\vcxsrv.exe
)
if exist "C:\Program Files (x86)\VcXsrv\vcxsrv.exe" (
    set VCXSRV_PATH=C:\Program Files (x86)\VcXsrv\vcxsrv.exe
)

if "%VCXSRV_PATH%"=="" (
    echo [LOI] Khong tim thay VcXsrv!
    echo       Cai dat bang lenh: winget install marha.VcXsrv
    pause & exit /b 1
)

echo [INFO] Dang khoi dong VcXsrv...
start "" "%VCXSRV_PATH%" :0 -multiwindow -clipboard -wgl -ac -silent-dup-error
timeout /t 2 /nobreak >nul
echo [OK]  VcXsrv da khoi dong tai display :0

set DISPLAY=host.docker.internal:0.0
echo [INFO] DISPLAY = %DISPLAY%

set MODE=%1
if /i "%MODE%"=="cpu" (
    echo [INFO] Che do: CPU fallback
    echo.
    docker compose --profile cpu up --build
) else (
    echo [INFO] Che do: GPU ^(RTX 4050^)
    echo.
    docker compose --profile default up --build
)

echo.
echo [INFO] Container da dung. Dong VcXsrv...
taskkill /f /im vcxsrv.exe >nul 2>&1
echo [OK]  Hoan tat.
pause