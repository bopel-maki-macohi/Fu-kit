@echo off

lime build windows -clean

cd export/release/windows/bin
wsl 7z a "windows.zip" *
wsl mv "windows.zip" ../../../../export/
