REM set PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin;%PATH%

set FREEBASIC_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\fbc.exe"
set GCC_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\bin\win64\gcc.exe"
set GCC_ASSEMBLER="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\bin\win64\as.exe"
set GCC_LINKER="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\bin\win64\ld.exe"
set ARCHIVE_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\bin\win64\ar.exe"
set DLL_TOOL="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\bin\win64\dlltool.exe"
set RESOURCE_COMPILER="%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\bin\win64\GoRC.exe"
set COMPILER_LIB_PATH=%ProgramFiles%\FreeBASIC-1.08.1-win64-gcc-9.3.0\lib\win64
set FB_EXTRA="fbextra2.x"

%FREEBASIC_COMPILER% -gen gcc -r -maxerr 1 -w all -O 0 -s console -d UNICODE GetWebSiteData.bas
move /y GetWebSiteData.c GetWebSiteData.x64.c
%GCC_COMPILER% -nostdlib -nostdinc -Wall -Wno-unused-label -Wno-unused-function -Wno-unused-variable -Wno-main -Werror-implicit-function-declaration -fno-strict-aliasing -frounding-math -fno-math-errno -fno-exceptions -Werror -fno-ident -m64 -march=x86-64 -masm=intel -s -Ofast -mno-stack-arg-probe -fno-stack-check -fno-stack-protector -fno-unwind-tables -fno-asynchronous-unwind-tables -fdata-sections -ffunction-sections -S GetWebSiteData.x64.c -o GetWebSiteData.x64.asm
%GCC_ASSEMBLER% --64 --strip-local-absolute GetWebSiteData.x64.asm -o GetWebSiteData.x64.o
%GCC_LINKER% -m i386pep -o "GetWebSiteData.x64.exe" -subsystem console -e ENTRYPOINT %FB_EXTRA% --stack 1048576,1048576 --gc-sections -s -L "%COMPILER_LIB_PATH%" -L "." --major-image-version 1 --minor-image-version 0 --no-seh --nxcompat "GetWebSiteData.x64.o" -ladvapi32 -lcomctl32 -lcomdlg32 -lcrypt32 -lgdi32 -lgdiplus -limm32 -lkernel32 -lmsimg32 -lmsvcrt -lmswsock -lole32 -loleaut32 -lshell32 -lshlwapi -luser32 -lversion -lwinmm -lwinspool -lws2_32 -luuid