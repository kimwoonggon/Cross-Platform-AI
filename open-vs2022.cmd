@echo off
set "SOLUTION=%~dp0build\vs2022-x64\CrossPlatformAI_08_13.sln"
if not exist "%SOLUTION%" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-vs2022.ps1"
    if errorlevel 1 exit /b 1
)
start "" "D:\microsoft\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" "%SOLUTION%"
