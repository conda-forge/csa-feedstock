@echo on

cd csa
if errorlevel 1 exit /b 1
copy config.h.in config.h
if errorlevel 1 exit /b 1

cl /nologo /I. "%RECIPE_DIR%\test_rounding.c" /Fe:test_rounding.exe
if errorlevel 1 exit /b 1
test_rounding.exe
if errorlevel 1 exit /b 1

cl /nologo /c /O2 /I. csa.c svd.c
if errorlevel 1 exit /b 1
lib /nologo /out:csa_static.lib csa.obj svd.obj
if errorlevel 1 exit /b 1
link /nologo /dll /out:csa.dll /implib:csa.lib /def:"%RECIPE_DIR%\csa.def" csa.obj svd.obj
if errorlevel 1 exit /b 1

cl /nologo /O2 /I. /DCSA_STANDALONE csa.c svd.c minell.c /Fe:csabathy.exe
if errorlevel 1 exit /b 1

for %%d in ("%LIBRARY_LIB%" "%LIBRARY_INC%" "%LIBRARY_BIN%") do (
    if not exist "%%~d" mkdir "%%~d"
    if errorlevel 1 exit /b 1
)
copy csa.lib "%LIBRARY_LIB%\"
if errorlevel 1 exit /b 1
copy csa_static.lib "%LIBRARY_LIB%\"
if errorlevel 1 exit /b 1
copy csa.h "%LIBRARY_INC%\"
if errorlevel 1 exit /b 1
copy csa.dll "%LIBRARY_BIN%\"
if errorlevel 1 exit /b 1
copy csabathy.exe "%LIBRARY_BIN%\"
if errorlevel 1 exit /b 1
