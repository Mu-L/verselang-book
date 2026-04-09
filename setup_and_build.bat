@ECHO OFF

REM To activate the UTF-8 Support in the terminal.
CHCP 65001 >nul

REM Allows running the script multiple times without closing the terminal.
SET PY_PATH=

REM Setup for Forground Colors
SETLOCAL EnableExtensions
SETLOCAL DisableDelayedExpansion

for /F %%a in ('ECHO prompt $E ^| cmd') do (
  set "ESC=%%a"
)

SETLOCAL EnableDelayedExpansion
SET RED=%ESC%[31m
SET GREEN=%ESC%[32m
SET YELLOW=%ESC%[33m

REM No Color
SET NC=%ESC%[0m

ECHO %GREEN%=== Verse Documentation Setup ^& Build Script ===%NC%

:CheckPythonInstallation
REM This will find the Install path from the registry key for python
FOR /f "delims=" %%a IN ('REG QUERY "HKLM\SOFTWARE\Python\PythonCore" /s ^| FINDSTR InstallPath') DO  (
  SET Key=%%a
)

REM This will give the actual path for Python
FOR /f "tokens=2*" %%a IN ('REG QUERY %Key% /ve') DO SET "PY_PATH=%%bpython.exe"

IF NOT DEFINED PY_PATH (
  ECHO %Yellow%No Python Installation Found%NC%

  ECHO %Yellow%Installing Python using available Package Managers...%NC%
  FOR /f "delims=," %%a IN ("choco,scoop,winget") DO (
    REM Check Chocolatey Installation
    WHERE /Q %%a 2>NUL
    IF %ERRORLEVEL% EQU 0 (
      SET InstallCmd=choco install python
      GOTO ExecInstallCmd
    )
  
    REM Check Scoop Installation
    WHERE /Q %%b 2>NUL
    IF %ERRORLEVEL% EQU 0 (
      SET InstallCmd=scoop install python
      GOTO ExecInstallCmd
    )

  REM Check Winget Installation
    WHERE /Q %%c 2>NUL
    IF %ERRORLEVEL% EQU 0 (
      SET InstallCmd=winget install --id Python.Python.3.12
      GOTO ExecInstallCmd
    )
  )
) ELSE (
  ECHO %GREEN%Python Installation Found. Testing if Version is greater than 3.8%NC%
  FOR /f %%i in ('CALL "%PY_PATH%" "-c" "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"') DO (
    SET VERSION=%%i
    GOTO TestVersion
  )
)

:ExecInstallCmd
IF DEFINED DRY_RUN (
  ECHO Dry Run: %InstallCmd%
  EXIT /B 0
) ELSE (
  CALL "%InstallCmd%"
  GOTO CheckPythonInstallation
)

:TestVersion
IF DEFINED VERSION (
  FOR /F "tokens=1,2 delims=." %%a in ("%VERSION%") do (
    SET /a MAJOR=%%a
    SET /a MINOR=%%b

    IF !MAJOR! GEQ 3 (
      IF !MINOR! GEQ 8 (
        ECHO %GREEN%Python^(%VERSION%^) is a supported version%NC%
        GOTO ActivateVirtualEnv
      )  
    )

    ECHO %RED%Please Install a Python Version greater than 3.8
    EXIT /B 1
  )
)

:ActivateVirtualEnv
SET venv_rel_path=venv\
SET venv_activate_path=%venv_rel_path%Scripts\activate.bat

ECHO %YELLOW%Creating Python virtual environment...%NC%
IF EXIST %venv_rel_path% (
  ECHO %GREEN%Python virtual environment already exists at %venv_rel_path%%NC%
  GOTO InstallDependencies
) ELSE (
  CALL "%PY_PATH%" -m venv venv 2>nul
  IF %ERRORLEVEL% NEQ 0 (
    ECHO %YELLOW%Virtual environment creation failed. Trying with --without-pip...%NC%
    CALL "%PY_PATH%" -m venv --without-pip venv
    CALL %venv_activate_path%
    curl -sS https://bootstrap.pypa.io/get-pip.py | python
    if %ERRORLEVEL% NEQ 0 (
      ECHO %RED%Failed to install pip. Please install python3-venv package%NC%
      EXIT /B 1
    )
  )
)

:InstallDependencies
ECHO %YELLOW%Activating virtual environment...%NC%
CALL %venv_activate_path%

ECHO %YELLOW%Upgrading pip...%NC%
CALL python -m pip install --upgrade pip

REM Install required packages
ECHO %YELLOW%Installing MkDocs and dependencies...%NC%
CALL python -m pip install -r requirements.txt

REM Install the custom Verse lexer
ECHO %YELLOW%Installing custom Verse syntax highlighter...%NC%

IF EXIST setup.py (
  CALL pip install -e .
  ECHO %GREEN%Custom Verse lexer installed%NC%
) else (
  ECHO %YELLOW%setup.py not found, skipping Verse lexer installation...%NC%
)

REM Build the documentation
ECHO %YELLOW%Building documentation site...%NC%
CALL mkdocs build --verbose

REM Check if build was successful
IF EXIST site\ (
    ECHO %GREEN%✓ Documentation built successfully!%NC%
    ECHO %GREEN% Static site generated in: site\%NC%
    ECHO( 
    ECHO %YELLOW%Next steps:%NC%
    ECHO   1. To view the site locally:
    ECHO      %venv_activate_path% ^&^& mkdocs serve ^&^& deactivate
    ECHO      Then open http://localhost:8000
    ECHO(
    ECHO   2. To deploy the static site:
    ECHO      Copy the contents of ./site/ to your web server
    ECHO( 
) ELSE (
  ECHO %RED%✗ Build failed. Please check the output above for errors.%NC%
  EXIT /B 1
)

ECHO %GREEN%=== Setup Complete ===%NC%
