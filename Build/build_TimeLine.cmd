@echo off

set NAME=TimeLine
set RCC= C:\Qt\Qt5.2.0\5.2.0\msvc2010\bin\rcc.exe
set SRC=..\
set OUTPUT=..\Deploy

if not exist %OUTPUT%\. md %OUTPUT%

copy %SRC%\%NAME%.cfg %OUTPUT%
%RCC% -threshold 70 -binary -o %OUTPUT%/%NAME%.rcc %SRC%/%NAME%.qrc