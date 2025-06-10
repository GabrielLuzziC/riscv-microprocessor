@echo off
REM compile.bat - Script de compilação para Windows (cmd)

cd /d %~dp0

echo Starting compilation of RISC-V processor for lab6...

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

REM Passo 5: Compilar arquivos do lab6 e testbench
echo Compiling lab6 files...
ghdl -a reg1bit.vhd || goto :error
ghdl -a flag_registers.vhd || goto :error
ghdl -a processador_lab6_tb.vhd || goto :error

REM Passo 6: Construir o executável
echo Building the executable...
ghdl -a processador_lab6_tb.vhd || goto :error

REM Passo 7: Rodar a simulação
echo Running the simulation...
ghdl -r processador_lab6_tb --wave=processador_lab6_tb.ghw

echo Compilation and simulation completed successfully.
echo You can view the waveform using GTKWave: gtkwave processador_lab6_tb.ghw
goto :eof

:error
echo Compilation failed!
exit /b 1