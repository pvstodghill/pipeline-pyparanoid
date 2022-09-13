#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Running IdentifyOrthologs.py...
# ------------------------------------------------------------------------

echo 1>&2 '# Running IdentifyOrthologs.py...'

rm -rf ${ORTHOS}
mkdir -p ${ORTHOS}


for THRESHOLD in ${ORTHO_THRESHOLDS} ; do
    echo 1>&2 "## --threshold ${THRESHOLD}"
    rm -f ${PYP}/db/all_groups.hmm.ssi
    rm -rf ${ORTHOS}/${THRESHOLD}
    IdentifyOrthologs.py --use_MP --cpus ${THREADS} \
			 --threshold ${THRESHOLD}  \
			 ${PYP}/db ${ORTHOS}/${THRESHOLD}
done

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."
