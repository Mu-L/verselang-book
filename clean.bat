@ECHO OFF

IF EXIST site\ (
    rmdir /S /Q site\
)

IF EXIST venv\ (
    rmdir /S /Q venv\
)

IF EXIST verse_lexer.egg-info\ (
    rmdir /S /Q verse_lexer.egg-info\
)