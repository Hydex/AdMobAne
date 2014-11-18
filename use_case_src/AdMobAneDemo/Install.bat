@echo off
set PAUSE_ERRORS=1
call bat\SetupSDK.bat
call bat\SetupApplication.bat

:menu
echo.
echo Menu
echo.
echo Android:
echo.
echo  [1] install on iOS
echo  [2] install on Android
echo.

:choice
set /P C=[Choice]: 
echo.

set PLATFORM=android
set OPTIONS=
if "%C%"=="1" goto ios-install
if "%C%"=="2" goto and-install

:ios-install
echo Installing application on iOS
echo.
call adt -installApp -platform ios -package "D:\Workspace\Projects\air_applications\AdMobAneDemo\App\dist\AdMobAneDemo.ipa"
if errorlevel 1 goto installfail
goto end

:and-install
echo Installing application on Android
echo.
adb -d install -r "D:\Workspace\Projects\air_applications\AdMobAneDemo\App\dist\AdMobAneDemo.apk"
if errorlevel 1 goto installfail
goto end

:installfail
echo.
echo Installing the app on the device failed

:end
pause
