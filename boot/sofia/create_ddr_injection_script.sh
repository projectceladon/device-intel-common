#!/bin/bash

if [ "$#" -ne 4 ]; then 
    echo "$0 must have 4 arguments. Usage:"
    echo "$0 <PSI_elf> <CTL_params_binary> <PHY_params_binary> <script_filename>"
    exit 1
fi

# Perhaps this variable would be candidate to specify in the variant? Could be rather confusing I guess
DDR_CTL_PARAMS_SYMBOL_NAME=denaliSdram_CTL
DDR_PHY_PARAMS_SYMBOL_NAME=denaliSdram_PHY

echo Generating DDR parameter injection script. Parameters supplied:
echo PSI ELF: $1
PSI_ELF=$1
echo DDR CTL parameter binary: $2
DDR_CTL_PARAMS_BINARY=$2
echo DDR PHY parameter binary: $3
DDR_PHY_PARAMS_BINARY=$3
echo Output script filename: $4
PSI_DDRINJECT_SCRIPT=$4

DDR_CTL_PARAMS_ADDR=$(objdump $PSI_ELF -t | grep -i $DDR_CTL_PARAMS_SYMBOL_NAME | cut -d' ' -f1)
DDR_CTL_PARAMS_SIZE=$(objdump $PSI_ELF -t | grep -i $DDR_CTL_PARAMS_SYMBOL_NAME | cut -d' ' -f8 |cut -f2)
CTL_PARAMS_FILE_SIZE=$(printf "%08x" `stat -c"%s" $DDR_CTL_PARAMS_BINARY`)

echo DDR_CTL_PARAMS_ADDR $DDR_CTL_PARAMS_ADDR
echo DDR_CTL_PARAMS_SIZE $DDR_CTL_PARAMS_SIZE
echo CTL_PARAMS_FILE_SIZE $CTL_PARAMS_FILE_SIZE

if [ "$DDR_CTL_PARAMS_SIZE" != "$CTL_PARAMS_FILE_SIZE" ]; then
    echo Size 0x$DDR_CTL_PARAMS_SIZE of symbol $DDR_CTL_PARAMS_SYMBOL_NAME DOES NOT match with size 0x$CTL_PARAMS_FILE_SIZE of file $DDR_CTL_PARAMS_BINARY.
    exit 1
else 
    echo Size 0x$DDR_CTL_PARAMS_SIZE of symbol $DDR_CTL_PARAMS_SYMBOL_NAME matches with size 0x$CTL_PARAMS_FILE_SIZE of file $DDR_CTL_PARAMS_BINARY.
fi

DDR_PHY_PARAMS_ADDR=$(objdump $PSI_ELF -t | grep -i $DDR_PHY_PARAMS_SYMBOL_NAME | cut -d' ' -f1)
DDR_PHY_PARAMS_SIZE=$(objdump $PSI_ELF -t | grep -i $DDR_PHY_PARAMS_SYMBOL_NAME | cut -d' ' -f8 |cut -f2)
PHY_PARAMS_FILE_SIZE=$(printf "%08x" `stat -c"%s" $DDR_PHY_PARAMS_BINARY`)

echo DDR_PHY_PARAMS_ADDR $DDR_PHY_PARAMS_ADDR
echo DDR_PHY_PARAMS_SIZE $DDR_PHY_PARAMS_SIZE
echo PHY_PARAMS_FILE_SIZE $PHY_PARAMS_FILE_SIZE

if [ "$DDR_PHY_PARAMS_SIZE" != "$PHY_PARAMS_FILE_SIZE" ]; then
    echo Size 0x$DDR_PHY_PARAMS_SIZE of symbol $DDR_PHY_PARAMS_SYMBOL_NAME DOES NOT match with size 0x$PHY_PARAMS_FILE_SIZE of file $DDR_PHY_PARAMS_BINARY.
    exit 1
else 
    echo Size 0x$DDR_PHY_PARAMS_SIZE of symbol $DDR_PHY_PARAMS_SYMBOL_NAME matches with size 0x$PHY_PARAMS_FILE_SIZE of file $DDR_PHY_PARAMS_BINARY.
fi

echo Creating injection script here: $PSI_DDRINJECT_SCRIPT
echo LOG >$PSI_DDRINJECT_SCRIPT
echo >>$PSI_DDRINJECT_SCRIPT
echo Section BOOT_CORE_PSI >>$PSI_DDRINJECT_SCRIPT
echo ImportBinary 0x$DDR_CTL_PARAMS_ADDR $DDR_CTL_PARAMS_BINARY >>$PSI_DDRINJECT_SCRIPT
echo ImportBinary 0x$DDR_PHY_PARAMS_ADDR $DDR_PHY_PARAMS_BINARY >>$PSI_DDRINJECT_SCRIPT
echo >>$PSI_DDRINJECT_SCRIPT
echo END >>$PSI_DDRINJECT_SCRIPT

