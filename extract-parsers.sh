#!/bin/bash
set -x
unset FSTAR_HOME KREMLIN_HOME MITLS_HOME QD_HOME
EVEREST_THREADS=24
./everest reset &&
env OTHERFLAGS='--admit_smt_queries true' ./everest -j $EVEREST_THREADS FStar make kremlin make quackyducky make &&
env OTHERFLAGS='--admit_smt_queries true' make -j $EVEREST_THREADS -C mitls-fstar/src/lowparse &&
rm -rf mitls-fstar/src/parsers/{generated,*.gen} &&
make -C mitls-fstar/src/parsers gen genmakefile &&
make -C mitls-fstar/src/parsers/generated depend &&
{ { { time env OTHERFLAGS='--admit_smt_queries true' make -C mitls-fstar/src/parsers/generated -j $EVEREST_THREADS codegen ; } 2>&1 ; } | tee outtimes.extract.txt ; }
