REM set PATH=%ProgramFiles%\mingw32\bin;%PATH%

set FREEBASIC_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\fbc.exe"
set GCC_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\bin\win32\gcc.exe"
set GCC_ASSEMBLER="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\bin\win32\as.exe"
set GCC_LINKER="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\bin\win32\ld.exe"
set ARCHIVE_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\bin\win32\ar.exe"
set DLL_TOOL="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\bin\win32\dlltool.exe"
set RESOURCE_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\bin\win32\GoRC.exe"
set COMPILER_LIB_PATH=%ProgramFiles%\FreeBASIC-1.08.1-win32-gcc-9.3.0\lib\win32
set FB_EXTRA="fbextra2.x"

%FREEBASIC_COMPILER% -gen gcc -r -maxerr 1 -w all -O 0 -s console -d UNICODE GetWebSiteData.bas
move /y GetWebSiteData.c GetWebSiteData.x86.c
%GCC_COMPILER% -nostdlib -nostdinc -Wall -Wno-unused-label -Wno-unused-function -Wno-unused-variable -Wno-main -Werror-implicit-function-declaration -fno-strict-aliasing -frounding-math -fno-math-errno -fno-exceptions -Werror -fno-ident -masm=intel -s -Ofast -mno-stack-arg-probe -fno-stack-check -fno-stack-protector -fno-unwind-tables -fno-asynchronous-unwind-tables -fdata-sections -ffunction-sections -S GetWebSiteData.x86.c -o GetWebSiteData.x86.asm
%GCC_ASSEMBLER% --strip-local-absolute GetWebSiteData.x86.asm -o GetWebSiteData.x86.o
%GCC_LINKER% -e _ENTRYPOINT@0 -m i386pe -o "GetWebSiteData.x86.exe" -subsystem console %FB_EXTRA% --stack 1048576,1048576 --major-image-version 2 --minor-image-version 0 --no-seh --nxcompat --gc-sections -s -L "%COMPILER_LIB_PATH%" -L "." "GetWebSiteData.x86.o" -ladvapi32 -lcomctl32 -lcomdlg32 -lcrypt32 -lgdi32 -lgdiplus -limm32 -lkernel32 -lmsimg32 -lmsvcrt -lmswsock -lole32 -loleaut32 -lshell32 -lshlwapi -luser32 -lversion -lwinmm -lwinspool -lws2_32 -luuid