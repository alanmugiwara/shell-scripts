@echo off

REM Executa o comando pyinstaller para criar o executável
pyinstaller --onefile "%~1"

