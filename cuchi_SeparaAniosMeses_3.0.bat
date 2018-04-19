@echo off
setlocal enabledelayedexpansion
rem programa echo para conseguir clasificar las fotos por fecha de captura
rem tienes que tener el exiftool en el path http://www.sno.phy.queensu.ca/~phil/exiftool/ 
rem en windows 10 tiene que estar en la carpeta c:\windows nada mas.


echo                                                   _____________
echo                  _          __                 _-'             `-_
echo           ,-----' ^|   _   ^<'__`)              /     A ver si      \
echo           ^| //  : ^| -'     )o \\          ___/  este programa me  \
echo           ^| //  : ^|  ---   \__;`          `-_  resuelve el coniazo  ^|
echo           ^| //  : ^| -._      ^|\`\            ^|  de ordenar fotos  ^|
echo           `-----._^|     __  // ( \^|           \                    /
echo            _/___\_    //)_`//  ^| ^|^|]           `-_______________-'
echo      _____[_______]_[~~-_ (.L_/  ^|^|
echo     [____________________]' `\_,/'/
echo       ^|^|^| /          ^|^|^|  ,___,'./
echo       ^|^|^| \          ^|^|^|,'______^|
echo       ^|^|^| /          /^|^| I==^|^|
echo       ^|^|^| \       __/_^|^|  __^|^|__
echo   -----^|^|-/------`-._/^|^|-o--o---o---                     Dedicado a Maris
echo     ~~~~~'


echo Ejecutame dentro de una carpeta y te colocare todas las fotos en carpetas de año y luego de mes de captura. ademas copiaré todo a una que se llame cuchi_deleteme. Y las que no ha sabido las coloca en la carpeta cuchi_clasificame
echo Pulsa Enter para continuar
rem esperamos 2 segundos
rem ping 1.1.1.1 -n 1 -w 1000 > nul

rem Extraigo todas las imagenes 
FOR /f "usebackq delims=" %%f  IN ( ` DIR  /A:-D /s /b . ^| findstr /v /i "[0-9][0-9][0-9][0-9]\\[0-9][0-9]\\*   ^|  cuchi_SeparaAniosMeses_3.0.bat" ` ) DO (

echo ============================
echo  Analizando %%f
rem echo Last-Modified Date : %%~tf?

rem guardo la salida en la variable x
set c=exiftool -S -t -EXIF:CreateDate "%%f"

rem echo comando=!c!;
rem call:getResult(!c!)

rem exiftool -S -t -EXIF:CreateDate "%%f"
set Result=
FOR /f "delims=" %%A IN ('!c!') DO set Result=%%A

rem ejemplo es Result=2014:11:21 16:03:53;
echo Result=!Result!;
set anio=!Result:~0,4!
set mes=!Result:~5,2!
set dia=!Result:~8,2!
set CleanResult=!Result::=_!
set CleanResult=!CleanResult: =-!

IF "!Result!" EQU "" (
rem exiftool fallo
echo "Exiftool fallo"
set fecha_modif=%%~tf
rem ejemplo es fecha modif=18/12/2014 17:19
echo fecha modif=!fecha_modif!
set anio=!fecha_modif:~6,4!
set mes=!fecha_modif:~3,2!
set dia=!fecha_modif:~0,2!
set CleanResult=!fecha_modif:/=_!
set CleanResult=!CleanResult: =-!
set CleanResult=!CleanResult::=_!
)

echo anio=!anio!
echo mes=!mes!
echo dia=!dia!

set nombre=%%~nf
echo nombre=!nombre!
set ext=%%~xf
echo ext=!ext!

echo CleanResult=!CleanResult!
rem le a´ñado el nombre de la carpeta de origen que siempre viene bien
set FULL_PATH=%%~dpf
set FULL_PATH=!FULL_PATH:~1,-1!
for %%i in ("!FULL_PATH!") do set "PARENT_FOLDER=%%~ni"
echo ParentFolder=!PARENT_FOLDER!


set FileName=.\!anio!\!mes!\!PARENT_FOLDER!-!CleanResult!-!nombre!!ext!
echo FileName=!FileName!
rem si exiftool ha fallado, vamos a coger el modified date



IF "!anio!" EQU "~0,4" (
rem Ha habido error
call:checkDir .\cuchi_clasificame
move "%%f" .\cuchi_clasificame
) ELSE (
call:checkDir .\!anio!
call:checkDir .\!anio!\!mes!
IF EXIST !FileName! ( 
echo UN OVERWRITE!
call:checkDir .\cuchi_Overwrite
move /-Y "%%f" .\cuchi_Overwrite\
) ELSE (
echo A COPIAR A !FileName!
move "%%f" "!FileName!"
)
 
rem move %%f .\%anio%\%mes%\
)




)
pause
echo.&goto:eof

::--------------------------------------------------------
::-- Function section starts below here
::--------------------------------------------------------

:checkDir    - Funcion que mira si existe el directorio y sino lo crea
IF NOT EXIST %~1 mkdir %~1
goto:eof

:getName    - Funcion que me da el nombre
set nombre = !~nx1 
goto:eof

:getResult    - Funcion que me da el resultado de un comando en la variable result
echo Ejecutando: %~1
FOR /f "delims=" %%A IN ('%~1') DO "set Result=%%A"
echo Resultado:!Result!
goto:eof