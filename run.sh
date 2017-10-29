#!/bin/sh

PYTHON_BIN=./environment/bin/python
PIP_BIN=./environment/bin/pip
REQUERIMENTS="./requeriments.txt"
TEST_LIB_FILE="./test/orb_teste.py"
ERROR=false

readonly PYTHON_BIN TEST_LIB_FILE REQUERIMENTS

## Run a code of test 
test_lib()
{

	$PYTHON_BIN $TEST_LIB_FILE
}

## Install the libs contained in requeriments
install_libs()
{
	$PIP_BIN install -r $REQUERIMENTS
}

if [ -z $1 ]; then
	echo "Nenhum argumento foi passado" 
	ERROR=true
elif [ $1 == "init" ]; then
	install_libs
elif [ $1 == "teste" ]; then
	test_lib
elif [ $1 == "python" ]; then
	$PYTHON_BIN
else
	echo "Argumento inválido" 
	ERROR=true
fi

if $ERROR ; then
	echo ""
	echo "init: instala as bibliotecas"
	echo "'teste': executa o código exemplo"
	echo "'python': abre o interpretador do ambiente"
fi
