#!/bin/bash
set -x
EVEREST_THREADS=4
./everest reset &&
env OTHERFLAGS='--admit_smt_queries true' ./everest -j $EVEREST_THREADS FStar make kremlin make quackyducky make &&
env OTHERFLAGS='--admit_smt_queries true' make -j $EVEREST_THREADS -C mitls-fstar/src/lowparse &&
rm -rf mitls-fstar/src/parsers/{generated,*.gen} &&
make -C mitls-fstar/src/parsers gen genmakefile &&
make -C mitls-fstar/src/parsers/generated depend &&
{ { { time make -C mitls-fstar/src/parsers/generated -j $EVEREST_THREADS cache/Parsers.ClientHelloExtension.fst.checked ; } 2>&1 ; } | tee outtimes.clienthelloextension.txt ; }
