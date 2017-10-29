#!/bin/sh

PYTHON_BIN=./environment/bin/python
TEST_LIB_FILE="./test/orb_teste.py"
ERROR=false

readonly PYTHON_BIN TEST_LIB_FILE

# test the libs of the project
test_lib()
{
	$PYTHON_BIN $TEST_LIB_FILE
}

if [ -z $1 ]; then
	echo "Nenhum argumento foi passado" 
	ERROR=true
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
	echo "'teste': executa o código exemplo"
	echo "'python': abre o interpretador do ambiente"
fi
