@echo off
chcp 65001 >nul
echo Запускаю репетитора, подожди минутку...

rem Модель сама выгрузится из видеопамяти через 10 минут без запросов
set OLLAMA_KEEP_ALIVE=10m
rem Модели лежат на диске D (см. раздел «Перенос на диск D» в инструкции)
if exist D:\Ollama\models set OLLAMA_MODELS=D:\Ollama\models
start "" /min ollama serve

rem Данные чата (аккаунты, история, учебники) хранятся здесь
set DATA_DIR=C:\Tutor\data
start "Open WebUI" /min open-webui serve --port 3000

rem Open WebUI запускается 20-60 секунд
timeout /t 30 >nul
start http://localhost:3000
