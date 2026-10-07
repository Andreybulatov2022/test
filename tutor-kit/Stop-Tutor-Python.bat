@echo off
chcp 65001 >nul
taskkill /f /t /im open-webui.exe >nul 2>&1
taskkill /f /im "ollama app.exe" >nul 2>&1
taskkill /f /im ollama.exe >nul 2>&1
echo Занятие окончено. До завтра!
timeout /t 3 >nul
