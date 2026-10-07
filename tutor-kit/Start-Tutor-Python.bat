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

rem Ждём, пока Open WebUI действительно ответит
echo Жду, пока загрузится чат (обычно 1-2 минуты)...
set /a tries=0
:waitwebui
timeout /t 3 >nul
set /a tries+=1
curl -s -f -o nul http://localhost:3000/health
if not errorlevel 1 goto webuiok
if %tries% lss 100 goto waitwebui
echo Чат не запустился за 5 минут. Попробуй ещё раз или позови взрослого.
pause
exit /b 1
:webuiok
set "CHROME="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if defined CHROME (start "" "%CHROME%" http://localhost:3000) else (start "" http://localhost:3000)
