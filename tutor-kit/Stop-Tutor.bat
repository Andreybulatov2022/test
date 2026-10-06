@echo off
chcp 65001 >nul
docker stop open-webui
taskkill /f /im "ollama app.exe" >nul 2>&1
taskkill /f /im ollama.exe >nul 2>&1
taskkill /f /im "Docker Desktop.exe" >nul 2>&1
wsl --shutdown
echo Занятие окончено. До завтра!
timeout /t 3 >nul
