@echo off
REM filepath: c:\Users\gabri\Documents\Faculdade\Arq. Comp\VHDL\lab5\compile.bat

REM Muda para o diretório do script
cd /d "%~dp0"

echo ===========================================
echo Compilando ULA do lab2...
ghdl -a ..\lab2\ULA.vhd || goto :error

echo Compilando componentes do lab3...
ghdl -a ..\lab3\reg16bits.vhd || goto :error
ghdl -a ..\lab3\banco_reg.vhd || goto :error
ghdl -a ..\lab3\acumulador.vhd || goto :error
ghdl -a ..\lab3\reg_ULA.vhd || goto :error

echo Compilando componentes do lab4...
ghdl -a ..\lab4\PC.vhd || goto :error
ghdl -a ..\lab4\PC_soma.vhd || goto :error
ghdl -a ..\lab4\ROM.vhd || goto :error
ghdl -a ..\lab4\PC_ROM.vhd || goto :error
ghdl -a ..\lab4\maquina_estados.vhd || goto :error
ghdl -a ..\lab4\unidade_de_controle.vhd || goto :error

echo Compilando arquivos do lab5...
ghdl -a processador.vhd || goto :error
ghdl -a processador_tb.vhd || goto :error

echo Elaborando o testbench...
ghdl -e processador_tb || goto :error

echo Rodando a simulacao...
ghdl -r processador_tb --wave=processador_tb.ghw || goto :error

echo ===========================================
echo Compilacao e simulacao concluida com sucesso!
echo Veja o waveform com: gtkwave processador_tb.ghw
goto :eof

:error
echo Houve um erro na compilacao ou simulacao.
pause