#!/bin/bash
# filepath: /home/gefgu/repos/riscv-microprocessor/validacao/compile.bash

# Set the working directory to validacao
cd "$(dirname "$0")"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Starting compilation of RISC-V processor for validation (with RAM)...${NC}"
echo -e "${GREEN}============================================${NC}"

# Step 1: Compile ULA from lab2
echo -e "${GREEN}Compiling ULA from lab2...${NC}"
ghdl -a ../lab2/ULA.vhd || { echo -e "${RED}Failed to compile ULA${NC}"; exit 1; }

# Step 2: Compile components from lab3
echo -e "${GREEN}Compiling components from lab3...${NC}"
ghdl -a ../lab3/reg16bits.vhd || { echo -e "${RED}Failed to compile reg16bits${NC}"; exit 1; }
ghdl -a ../lab3/banco_reg.vhd || { echo -e "${RED}Failed to compile banco_reg${NC}"; exit 1; }
ghdl -a ../lab3/acumulador.vhd || { echo -e "${RED}Failed to compile acumulador${NC}"; exit 1; }
ghdl -a ../lab3/reg_ULA.vhd || { echo -e "${RED}Failed to compile reg_ULA${NC}"; exit 1; }

# Step 3: Compile components from lab4
echo -e "${GREEN}Compiling components from lab4...${NC}"
ghdl -a ../lab4/PC.vhd || { echo -e "${RED}Failed to compile PC${NC}"; exit 1; }
ghdl -a ../lab4/PC_soma.vhd || { echo -e "${RED}Failed to compile PC_soma${NC}"; exit 1; }
ghdl -a ../lab4/ROM.vhd || { echo -e "${RED}Failed to compile ROM${NC}"; exit 1; }
ghdl -a ../lab4/PC_ROM.vhd || { echo -e "${RED}Failed to compile PC_ROM${NC}"; exit 1; }
ghdl -a ../lab4/maquina_estados.vhd || { echo -e "${RED}Failed to compile maquina_estados${NC}"; exit 1; }
ghdl -a ../lab4/unidade_de_controle.vhd || { echo -e "${RED}Failed to compile unidade_de_controle${NC}"; exit 1; }

# Step 4: Compile components from lab5
echo -e "${GREEN}Compiling components from lab5...${NC}"
ghdl -a ../lab5/processador.vhd || { echo -e "${RED}Failed to compile processador${NC}"; exit 1; }

# Step 5: Compile components from lab6
echo -e "${GREEN}Compiling components from lab6...${NC}"
ghdl -a ../lab6/reg1bit.vhd || { echo -e "${RED}Failed to compile reg1bit${NC}"; exit 1; }
ghdl -a ../lab6/flag_registers.vhd || { echo -e "${RED}Failed to compile flag_registers${NC}"; exit 1; }

# Step 6: Compile lab7 files (RAM)
echo -e "${GREEN}Compiling lab7 files (RAM)...${NC}"
ghdl -a ../lab7/RAM.vhd || { echo -e "${RED}Failed to compile RAM${NC}"; exit 1; }

# Step 7: Compile testbench
echo -e "${GREEN}Compiling testbench...${NC}"
ghdl -a processador_val_tb.vhd || { echo -e "${RED}Failed to compile processador_val_tb${NC}"; exit 1; }

# Step 8: Build the executable
echo -e "${GREEN}Building the executable...${NC}"
ghdl -e processador_val_tb || { echo -e "${RED}Failed to build the executable${NC}"; exit 1; }

# Step 9: Run the simulation
echo -e "${GREEN}Running the simulation...${NC}"
ghdl -r processador_val_tb --wave=processador_val_tb.ghw

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Compilation and simulation completed successfully.${NC}"
echo -e "${GREEN}You can view the waveform using GTKWave: gtkwave processador_val_tb.ghw${NC}"
echo -e "${GREEN}============================================${NC}"