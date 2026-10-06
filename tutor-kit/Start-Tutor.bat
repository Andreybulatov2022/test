@echo off
chcp 65001 >nul
echo Запускаю репетитора, подожди минутку...

rem Модель сама выгрузится из видеопамяти через 10 минут без запросов
set OLLAMA_KEEP_ALIVE=10m
start "" /min ollama serve

docker info >nul 2>&1
if errorlevel 1 (
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    :waitdocker
    timeout /t 3 >nul
    docker info >nul 2>&1
    if errorlevel 1 goto waitdocker
)

docker start open-webui
timeout /t 8 >nul
start http://localhost:3000
