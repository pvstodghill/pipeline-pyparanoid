#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${PYP}
mkdir -p ${PYP}

# ------------------------------------------------------------------------

echo 1>&2 '# Setting up .pep directories...'

rm -rf ${PYP}/core-genomes/pep
mkdir -p ${PYP}/core-genomes/pep

(
    shopt -s nullglob    
    for f in ${GENOMES}/*.faa ; do
	name=$(basename $f .faa)
	cp $f ${PYP}/core-genomes/pep/${name}.pep.fa
    done

    for name in ${OUTGROUPS} ; do
	rm -f ${PYP}/core-genomes/pep/${name}.pep.fa
    done
)

sed -E -i -e 's/^>gnl\|[a-zA-Z0-9]+\|/>/' ${PYP}/core-genomes/pep/*.pep.fa

if [ "$PROP_PEP_FA_DIR" ] ; then
    rm -rf ${PYP}/prop-genomes/pep
    mkdir -p ${PYP}/prop-genomes/pep
    cp ${PROP_PEP_FA_DIR}/*.pep.fa ${PYP}/prop-genomes/pep/
    sed -E -i -e 's/^>gnl\|[a-zA-Z0-9]+\|/>/' ${PYP}/prop-genomes/pep/*.pep.fa
fi


# ------------------------------------------------------------------------

echo 1>&2 '# Creating core genome list...'

for f in ${PYP}/core-genomes/pep/*.pep.fa ; do
    name=$(basename $f .pep.fa)
    echo $name >> ${PYP}/core-genomes.txt
done


# ------------------------------------------------------------------------

echo 1>&2 '# Running BuildGroups.py...'

rm -rf ${PYP}/db

ARGS=
if [ "$BUILDGROUPS_THRESHOLD" ] ; then
    ARGS+=" --threshold $BUILDGROUPS_THRESHOLD"
fi

BuildGroups.py --use_MP --clean --verbose  --cpus ${THREADS} \
	       ${ARGS} \
	       ${PYP}/core-genomes ${PYP}/core-genomes.txt ${PYP}/db

# ------------------------------------------------------------------------

if [ "$PROP_PEP_FA_DIR" ] ; then
    echo 1>&2 '# Running PropagateGroups.py...'

    for f in ${PYP}/prop-genomes/pep/*.pep.fa ; do
	name=$(basename $f .pep.fa)
	echo $name >> ${PYP}/prop-genomes.txt
    done

    PropagateGroups.py ${PYP}/prop-genomes ${PYP}/prop-genomes.txt ${PYP}/db
else
    echo 1>&2 '# [not] Running PropagateGroups.py...'
    touch ${PYP}/db/prop_strainlist.txt ${PYP}/db/prop_homolog.faa
fi

# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

