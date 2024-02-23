@echo off
REM Script para tentar corrigir a conexão com o servidor time.windows.com

REM Lista de servidores de horário
set "servers=pool.ntp.org"

REM Definição do tempo máximo para cada teste (em segundos)
set "timeout=30"
set "found=false"

REM Percorre a lista de servidores
for %%s in (%servers%) do (
    set "counter=%timeout%"
    set "server=Testando o servidor: %%s"

    <nul set /p "=%server%  "
    call :countdown
    echo.

    echo Tentando sincronizar com o servidor %%s
    w32tm /config /manualpeerlist:%%s /syncfromflags:manual /reliable:yes /update
    net stop w32time
    net start w32time
    w32tm /resync /force
    w32tm /config /update
    w32tm /resync
    w32tm /query /status | findstr /i "sincronizado"
    if not errorlevel 1 (
        echo Sincronizado com sucesso com o servidor %%s
        tzutil /s "E. South America Standard Time"
        set "found=true"
        goto :end
    ) else (
        echo Falha ao sincronizar com o servidor %%s
    )
)

if "%found%"=="false" (
    echo Nenhum servidor foi capaz de sincronizar o relógio.
)

:end
pause
exit /b

:countdown
    setlocal enabledelayedexpansion
    for /l %%i in (1,1,%timeout%) do (
        set /a "remaining=!counter! - %%i"
        <nul set /p "=!remaining! segundos restantes..." >nul
        ping -n 2 127.0.0.1 >nul
        <nul set /p "=%BS%" >nul
    )
    endlocal
exit /b
