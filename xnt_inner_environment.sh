#!/bin/bash

echo "Clearing environment variables"
unset PYTHONPATH
for VAR in X509_CERT_DIR X509_VOMS_DIR; do
    VALUE=${!VAR}
    if [ "X$VALUE" != "X" ]; then
        echo "WARNING: $VAR is set set and could lead to problems when using this environment"
    fi
done

echo "Activating conda environment"
source /opt/XENONnT/anaconda/bin/activate XENONnT_development
which conda
conda --version
which python
python --version

echo "Setting environment variables"

# prepend to LD_LIBRARY_PATH - non-Python tools might be using it
# Why is this necessary? shouldn't conda do it?
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib64${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}

# Development python packages (not needed later)
DEV_PYDIR=/project2/lgrandi/xenonnt/development

export PYTHONPATH=$DEV_PYDIR/lib/python3.6/site-packages:$PYTHONPATH
export PATH=$DEV_PYDIR/bin:$PATH

# gfal2
export GFAL_CONFIG_DIR=$CONDA_PREFIX/etc/gfal2.d
export GFAL_PLUGIN_DIR=$CONDA_PREFIX/lib64/gfal2-plugins/

# rucio
#export RUCIO_HOME=$CONDA_PREFIX  #developer Rucio catalogue
export RUCIO_HOME=/cvmfs/xenon.opensciencegrid.org/software/rucio-py27/1.8.3/rucio #production catalogue
export RUCIO_ACCOUNT=xenon-analysis
export X509_USER_PROXY=/project2/lgrandi/grid_proxy/xenon_service_proxy
if [ "x$X509_CERT_DIR" = "x" ]; then
    export X509_CERT_DIR=/etc/grid-security/certificates
fi
#SOURCE THE RUCIO PRODUCTION CATALOGUE (TEMP. FIX!)
source xnt_rucio_old

# stuff
#alias py_dev_install='python setup.py develop --prefix=$DEV_PYDIR'
alias llt='ls -ltrh'
alias la='ls -a'
alias ll='ls -la'

echo "Testing strax/straxen import"
python -c 'import strax; import straxen; [print(f"{x.__name__} {x.__version__}") for x in [strax, straxen]]'

# Start your code:
echo '--------------------'
echo '-  START YOUR JOB  -'
echo '-  Command: '$*
echo '--------------------'

$*

echo '--------------------'
echo '-  JOB Finished -'
echo '-  Command: '$*
echo '--------------------'
#you need to exit the container afterwards
exit
