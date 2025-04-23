@echo off
echo Compilation du jeu d'aventure...
swiftc main.swift Game.swift Player.swift Room.swift Item.swift Puzzle.swift Parser.swift JSONLoader.swift -o aventure.exe
if %errorlevel% neq 0 (
    echo Erreur de compilation !
    exit /b %errorlevel%
)
echo Compilation réussie. Lancez le jeu avec : aventure.exe
