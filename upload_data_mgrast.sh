#!/bin/bash/

# this program uploads raw fastq to MG-RAST data inbox through MG-RAST API 

path="/Users/rx32940/Downloads/Lepto_met_rawdata"
for file in $path/*/*; do
    fastq=$(basename "$file")
    curl -X POST -H "auth: E2HqYqsTyxS5J9fNmFF5tcBac" -F "upload=@\"$file\"" "http://api.mg-rast.org/inbox" # \"\" needed in path of the file is included
    echo "$fastq uploaded"
done

