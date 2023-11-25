@echo off
wsl ls /home/abrax/.config > NUL 2>&1
if %errorlevel% == 0 (
    echo true
    wsl /home/abrax/bin
) else (
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Set-ExecutionPolicy RemoteSigned -Scope CurrentUser}"
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {irm get.scoop.sh | iex}"
    wsl --install
    @echo on
    echo
    echo "please restart after wsl installation"
    pause
)
