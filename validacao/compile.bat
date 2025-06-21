@echo off
REM compile.bat - Script de compilação para Windows (cmd) - lab7

cd /d %~dp0

echo ============================================
echo Starting compilation of RISC-V processor for lab7 (with RAM)...
echo ============================================

REM Passo 1: Compilar ULA do lab2
echo Compiling ULA from lab2...
ghdl -a ..\lab2\ULA.vhd || goto :error

REM Passo 2: Compilar componentes do lab3
echo Compiling components from lab3...
ghdl -a ..\lab3\reg16bits.vhd || goto :error
ghdl -a ..\lab3\banco_reg.vhd || goto :error
ghdl -a ..\lab3\acumulador.vhd || goto :error
ghdl -a ..\lab3\reg_ULA.vhd || goto :error

REM Passo 3: Compilar componentes do lab4
echo Compiling components from lab4...
ghdl -a ..\lab4\PC.vhd || goto :error
ghdl -a ..\lab4\PC_soma.vhd || goto :error
ghdl -a ..\lab4\ROM.vhd || goto :error
ghdl -a ..\lab4\PC_ROM.vhd || goto :error
ghdl -a ..\lab4\maquina_estados.vhd || goto :error
ghdl -a ..\lab4\unidade_de_controle.vhd || goto :error

REM Passo 4: Compilar componentes do lab5
echo Compiling components from lab5...
ghdl -a ..\lab5\processador.vhd || goto :error

REM Passo 5: Compilar componentes do lab6
echo Compiling components from lab6...
ghdl -a ..\lab6\reg1bit.vhd || goto :error
ghdl -a ..\lab6\flag_registers.vhd || goto :error

REM Passo 6: Compilar arquivos do lab7 (RAM)
echo Compiling lab7 files (RAM)...
ghdl -a ..\lab7\RAM.vhd || goto :error

REM Passo 7: Compilar testbench
echo Compiling testbench...
ghdl -a processador_val_tb.vhd || goto :error

REM Passo 8: Construir o executável
echo Building the executable...
ghdl -e processador_val_tb || goto :error

REM Passo 9: Rodar a simulação
echo Running the simulation...
ghdl -r processador_val_tb --wave=processador_val_tb.ghw

echo ============================================
echo Compilation and simulation completed successfully.
echo You can view the waveform using GTKWave: gtkwave processador_val_tb.ghw
echo ============================================
pause
goto :eof

:error
echo ============================================
echo Compilation failed!
echo ============================================
pause
exit /b 1