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
    # This is an ugly hack. See https://github.com/ryanmelnyk/PyParanoid/issues/11.
    case X${THRESHOLD}X in
	X1X|X1.0X|X1.00X|X1.000X)
	    THRESHOLD_ARG=
	    ;;
	X*X)
	    THRESHOLD_ARG="--threshold ${THRESHOLD}"
	    ;;
	*)
	    echo 1>&2 "Cannot happen."
	    exit 1
    esac
    IdentifyOrthologs.py --use_MP --cpus ${THREADS} \
			 ${THRESHOLD_ARG}  \
			 ${PYP}/db ${ORTHOS}/${THRESHOLD}

    echo '## orthologs:' $(cat ${ORTHOS}/${THRESHOLD}/orthos.txt | wc -l)

done

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 "# Done."
