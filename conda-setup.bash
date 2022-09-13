#! /bin/bash

set -e

CONDA_PREFIX=$(dirname $(dirname $(type -p conda)))
. "${CONDA_PREFIX}/etc/profile.d/conda.sh"

PACKAGES=

PACKAGES+=" pip"

PACKAGES+=" cd-hit" # =4.8.1
PACKAGES+=" diamond" # =2.0.13
PACKAGES+=" hmmer" # =3.3.2
PACKAGES+=" mcl" # =14-137
PACKAGES+=" muscle=3.8.1551"

PACKAGES+=" fasttree"
PACKAGES+=" gblocks"
PACKAGES+=" clipkit"

set -x

conda env remove -y --name pipeline-pyparanoid
conda create -y --name pipeline-pyparanoid
conda activate pipeline-pyparanoid

conda install -y ${PACKAGES}

pip install pyparanoid
