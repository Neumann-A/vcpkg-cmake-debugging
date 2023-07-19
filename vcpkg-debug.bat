@ECHO OFF
SETLOCAL EnableDelayedExpansion

set call_cmake=1
REM Call CMake always except if the debugger should be attached
FOR %%a IN (%*) do (
    set "_arg_=%%a"
    if !_arg_!==--debugger set call_cmake=0
)

@ECHO OFF
if !call_cmake!==1 cmake.exe %* && Exit /B %ERRORLEVEL%

REM Call vcpkg with debugger options
set keep_next=0
FOR %%b IN (%*) do (
    set "_arg_=%%b"
    if !keep_next!==1 (
        set "_arg_list_=!_arg_list_! --x-cmake-args=!_arg_!"
        set /a "_cnt+=1+0"
    )
    set keep_next=0
    if !_arg_!==--debugger (
        set "_arg_list_=!_arg_list_! --x-cmake-args=!_arg_!" 
        set /a "_cnt+=1+0"
    )
    if !_arg_!==--debugger-pipe (
        set "_arg_list_=!_arg_list_! --x-cmake-args=!_arg_!"
        set /a "_cnt+=1+0"
        set keep_next=1
    )
    if !_arg_!==--debugger-dap-log (
        set "_arg_list_=!_arg_list_! --x-cmake-args=!_arg_!"
        set /a "_cnt+=1+0"
        set keep_next=1
    )
)

set vcpkg_exe=E:/vcpkg_folders/vcpkg_clean/vcpkg.exe
set ports_to_install=zlib
set triplet=x64-windows-release
set host_triplet=!triplet! 
set more_opts=

REM Remove ports for debugging so that they get rebuild
call !vcpkg_exe! remove !ports_to_install! --triplet !triplet!
REM --editable forces a rebuild of the ports and skips the binary cache
REM Don't reroute stdout since the VS extension is waiting for a certain string on stdout
call !vcpkg_exe! install !ports_to_install! --triplet !triplet! --host-triplet !host_triplet! !more_opts! --editable !_arg_list_!
