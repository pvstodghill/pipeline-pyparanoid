# directory into which the results are written.
#DATA=.
#DATA=data # default

# ------------------------------------------------------------------------

GENOMES=FIXME # path to directory full of STRAIN1.faa, STRAIN2,faa, ...

# ------------------------------------------------------------------------

#FIXME: core and prop?
#FIXME: pyparanoid parameters?

## "minimum size of groups, defaults to 2 which ignores singletons,
## set to 1 to include singleton"
#BUILDGROUPS_THRESHOLD=2

# ------------------------------------------------------------------------

ORTHO_THRESHOLDS=
ORTHO_THRESHOLDS+=" 0.95"

# USE_GBLOCKS=yes # use GBlocks for trimming master alignments
USE_GBLOCKS=no # use ClipKIT for trimming master alignments

# ------------------------------------------------------------------------

#TREE_THRESHOLDS= # defaults to ${ORTHO_THRESHOLDS}

# ------------------------------------------------------------------------

# # Uncomment to get packages from HOWTO
# PACKAGES_FROM=howto

# uncomment to use conda
PACKAGES_FROM=conda
CONDA_ENV=pipeline-pyparanoid

#THREADS=$(nproc --all)

# ------------------------------------------------------------------------
