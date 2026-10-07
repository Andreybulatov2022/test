@echo off
chcp 65001 >nul
echo Запускаю репетитора, подожди минутку...
echo.

rem Модель сама выгрузится из видеопамяти через 10 минут без запросов
set OLLAMA_KEEP_ALIVE=10m
rem Модели лежат на диске D (см. раздел «Перенос на диск D» в инструкции)
if exist D:\Ollama\models set OLLAMA_MODELS=D:\Ollama\models

rem ---- 1. Ollama ----
echo [1/3] Запускаю Ollama...
ollama list >nul 2>&1
if not errorlevel 1 goto ollamaok
start "Ollama - не закрывать" /min ollama serve
:waitollama
timeout /t 2 >nul
ollama list >nul 2>&1
if errorlevel 1 goto waitollama
:ollamaok
echo       Ollama готова.

rem ---- 2. Docker ----
echo [2/3] Запускаю Docker...
docker info >nul 2>&1
if not errorlevel 1 goto dockerok
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
:waitdocker
timeout /t 3 >nul
docker info >nul 2>&1
if errorlevel 1 goto waitdocker
:dockerok
docker start open-webui >nul
echo       Docker готов.

rem ---- 3. Ждём, пока Open WebUI действительно ответит ----
echo [3/3] Жду, пока загрузится чат (обычно 1-2 минуты)...
set /a tries=0
:waitwebui
timeout /t 3 >nul
set /a tries+=1
curl -s -f -o nul http://localhost:3000/health
if not errorlevel 1 goto webuiok
if %tries% lss 100 goto waitwebui
echo.
echo Чат не запустился за 5 минут. Попробуй ещё раз или позови взрослого.
pause
exit /b 1
:webuiok
echo       Готово! Открываю браузер.

rem ---- Открываем в Chrome, если он установлен, иначе в браузере по умолчанию ----
set "CHROME="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if defined CHROME (start "" "%CHROME%" http://localhost:3000) else (start "" http://localhost:3000)
timeout /t 3 >nul
