#!/bin/sh
cd `dirname $0`
export BIGWIG=$PWD/_build/default/lib
echo $BIGWIG/*/ebin

make clean && make
mkdir -p log/sasl
erl -sname bigwig -pa $BIGWIG/*/ebin -boot start_sasl -config sys.config -s reloader -s bigwig
