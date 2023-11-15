# install conda
wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p $HOME/conda

echo -e '\nexport PATH=$HOME/conda/bin:$PATH' >> $HOME/.bashrc && source $HOME/.bashrc

sudo curl -O --output-dir /usr/lib/spark/jars/  https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.0.0/delta-core_2.12-2.0.0.jar
sudo curl -O --output-dir /usr/lib/spark/jars/  https://repo1.maven.org/maven2/io/delta/delta-storage/2.0.0/delta-storage-2.0.0.jar

pip install --upgrade pip
pip install findspark
pip install schedule
pip install logging
pip install delta-spark==2.0.0

mkdir $HOME/python
mkdir $HOME/python/config