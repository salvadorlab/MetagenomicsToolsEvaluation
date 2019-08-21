#!/bin/bash

# building Clark-s database

path="/scratch/rx32940"

# set up the database
$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --species
$path/CLARK/CLARKSCV1.2.6.1/set_targets.sh $path/CLARK/DB bacteria viruses --genus

echo "set target done"


# database of discriminative 31-mers
$path/CLARK/CLARKSCV1.2.6.1/classify_metagenome.sh -P $path/CLARK/sample.L.txt $path/CLARK/sample.R.txt -R /scratch/rx32940/CLARK/output/result

echo "classify_metagenome done"

# databases of discriminative spaced 31-mers
$path/CLARK/CLARKSCV1.2.6.1/buildSpacedDB.sh
