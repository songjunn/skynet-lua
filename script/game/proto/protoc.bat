@echo off

@set SRC_DIR=.

cd %SRC_DIR%

for /f "delims=" %%i in ('dir /b /a-h "*.proto"') do (
	echo %%i
	call protoc.exe -o ../message/%%~ni.pb %%i
)

@pause