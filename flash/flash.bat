@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title uwuAOSP elish 刷机脚本
cd /d "%~dp0"

echo ============================================================
echo   uwuAOSP 17.0.181   elish / enuma
echo   版本: 20261105-RELEASE
echo ============================================================
echo.
echo 刷机前请确认:
echo   1. Bootloader 已解锁
echo   2. 设备已进入 fastboot 模式，关机后按住 音量下 和 电源
echo   3. 数据线连接正常，驱动已安装
echo.
echo 分区说明:
echo   super.img        动态分区(system/product/vendor/odm/system_ext)
echo   boot.img         正常启动内核
echo   boot_root_apatch.img  带 APatch root 的启动内核
echo   vendor_boot.img  厂商启动镜像
echo   dtbo.img         DTBO
echo   vbmeta.img       校验信息
echo   vbmeta_system.img  system 侧校验信息
echo.

set MISSING=0
for %%f in (boot.img boot_root_apatch.img vendor_boot.img dtbo.img vbmeta.img vbmeta_system.img super.img) do (
    if not exist "%%f" (
        echo [错误] 缺少文件: %%f
        set MISSING=1
    )
)
if "!MISSING!"=="1" (
    echo.
    echo 请把所有分区镜像和本脚本放在同一个文件夹内。
    pause
    exit /b 1
)

echo 正在检测设备，请稍候...
set FDEV=
for /f "tokens=1,2" %%a in ('fastboot devices 2^>^&1') do (
    if /i "%%b"=="fastboot" set FDEV=%%a
)
if "!FDEV!"=="" (
    echo.
    echo [错误] 未检测到 fastboot 设备。
    echo 请检查: 是否已进入 fastboot 模式、驱动是否安装、数据线是否正常。
    pause
    exit /b 1
)
set DEV=
for /f "tokens=2" %%a in ('fastboot getvar product 2^>^&1 ^| findstr /i "^product:"') do set DEV=%%a
if "!DEV!"=="" (
    echo.
    echo [错误] 无法读取设备型号。
    pause
    exit /b 1
)
echo 检测到设备: !DEV!
if /i "!DEV!"=="elish" goto DEV_OK
if /i "!DEV!"=="enuma" goto DEV_OK
echo.
echo [错误] 本刷机包仅支持 elish 或 enuma。
echo 当前设备为 !DEV!，为防止变砖已停止。
pause
exit /b 1
:DEV_OK

echo.
echo ------------------------------------------------------------
echo 是否清除数据 (wipe)？
echo   从 MIUI / HyperOS 刷入: 必须选 y
echo   从其他类原生系统刷入: 可先选 n，出现异常再清除
echo ------------------------------------------------------------
:ASK_WIPE
set /p WIPE=请输入 y 清除数据 / n 保留数据，然后回车:
if /i "!WIPE!"=="y" goto WIPE_OK
if /i "!WIPE!"=="n" goto WIPE_OK
echo 输入无效，请重新输入 y 或 n。
goto ASK_WIPE
:WIPE_OK

echo.
echo ------------------------------------------------------------
echo 是否需要 root (APatch)？
echo   y: 刷入 boot_root_apatch.img
echo   n: 刷入正常 boot.img
echo ------------------------------------------------------------
:ASK_ROOT
set /p ROOT=请输入 y 需要 / n 不需要，然后回车:
if /i "!ROOT!"=="y" goto ROOT_OK
if /i "!ROOT!"=="n" goto ROOT_OK
echo 输入无效，请重新输入 y 或 n。
goto ASK_ROOT
:ROOT_OK

if /i "!ROOT!"=="y" (
    set BOOTIMG=boot_root_apatch.img
) else (
    set BOOTIMG=boot.img
)

echo.
echo ============================================================
echo 开始刷入
echo   设备      : !DEV!
echo   boot 镜像 : !BOOTIMG!
echo   清除数据  : !WIPE!
echo ============================================================
echo.

echo 正在设置当前槽位为 a ...
fastboot --set-active=a
if errorlevel 1 goto FAIL

call :FLASH boot !BOOTIMG!
if errorlevel 1 goto FAIL
call :FLASH vendor_boot vendor_boot.img
if errorlevel 1 goto FAIL
call :FLASH dtbo dtbo.img
if errorlevel 1 goto FAIL
call :FLASH vbmeta vbmeta.img
if errorlevel 1 goto FAIL
call :FLASH vbmeta_system vbmeta_system.img
if errorlevel 1 goto FAIL

echo.
echo 正在刷入 super（约 5GB，请耐心等待，不要拔线）...
fastboot flash super super.img
if errorlevel 1 goto FAIL

if /i "!WIPE!"=="y" (
    echo.
    echo 正在清除数据 ...
    fastboot -w
    if errorlevel 1 goto FAIL
)

echo.
echo 刷入完成，正在重启 ...
fastboot reboot

echo.
echo ============================================================
echo 全部完成。首次开机可能需要 5-10 分钟，请耐心等待。
echo ============================================================
pause
exit /b 0

:FLASH
echo 正在刷入 %~1 ...
fastboot flash %~1 %~2
if errorlevel 1 (
    echo [错误] 刷入 %~1 失败
    exit /b 1
)
exit /b 0

:FAIL
echo.
echo [错误] 刷机中断，请检查上面的输出。
pause
exit /b 1
