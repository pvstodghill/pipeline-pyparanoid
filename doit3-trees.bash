#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${TREES}

# ------------------------------------------------------------------------

if [ -z "$TREE_THRESHOLDS" ] ; then
    TREE_THRESHOLDS="$ORTHO_THRESHOLDS"
fi

for THRESHOLD in ${TREE_THRESHOLDS} ; do

    echo 1>&2 ''
    echo 1>&2 '#'
    echo 1>&2 '# Threshold = '${THRESHOLD}
    echo 1>&2 '#'
    echo 1>&2 ''

    PHYLO=${TREES}/${THRESHOLD}
    mkdir -p ${PHYLO}

    # ------------------------------------------------------------------------

    echo 1>&2 '# Making local copy of master alignment'

    cp ${ORTHOS}/${THRESHOLD}/master_alignment.faa ${PHYLO}
    if [ ! -s ${PHYLO}/master_alignment.faa ] ; then
	echo 1>&2 "# Empty master alignment!"
	continue
    fi

    # ------------------------------------------------------------------------

    if [ "$USE_GBLOCKS" = "yes" ] ; then
	
	echo 1>&2 '# Running GBlocks'
	set +e
	Gblocks ${PHYLO}/master_alignment.faa -t=p # -t=p == protein
	set -e

	# Gblocks returns non-0 status? This is a hack
	if [ ! -s ${PHYLO}/master_alignment.faa-gb ] ; then
	    echo 1>&2 '# Gblocks failed!'
	    continue
	fi

	TRIMMED=${PHYLO}/master_alignment.faa-gb

    else

	echo 1>&2 '# Running ClipKIT'
	clipkit ${PHYLO}/master_alignment.faa
	TRIMMED=${PHYLO}/master_alignment.faa.clipkit

    fi

    # ------------------------------------------------------------------------

    echo 1>&2 '# Running FastTree'

    (
	export OMP_NUM_THREADS=${THREADS}
	FastTreeMP < ${TRIMMED} > ${PHYLO}/tree.phy

    )

    # ------------------------------------------------------------------------

done

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."
