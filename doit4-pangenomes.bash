#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Computing pangenome(s)
# ------------------------------------------------------------------------

echo 1>&2 '# Computing pangenome(s)'

rm -rf ${PANGENOMES}
mkdir -p ${PANGENOMES}

${PIPELINE}/compute-pangenomes.pl < ${PYP}/db/homolog_matrix.txt > ${PANGENOMES}/ortho_scores.txt
