
@echo off

wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "MyRestorePoint", 100, 7

pause