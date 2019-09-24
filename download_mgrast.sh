#!/bin/bash

for i in {390..401}; do
    cd /Users/rx32940/Downloads
    curl -H "auth: E2HqYqsTyxS5J9fNmFF5tcBac" --output /Users/rx32940/Downloads/mgm4860$i.fna https://api-ui.mg-rast.org/download/mgm4860$i.3?file=150.1&auth=mgrast%20E2HqYqsTyxS5J9fNmFF5tcBac&browser=1 
done

curl -H "auth: E2HqYqsTyxS5J9fNmFF5tcBac" --output /Users/rx32940/Downloads/mgm4860572.fna https://api-ui.mg-rast.org/download/mgm4860572.3?file=150.1&auth=mgrast%20E2HqYqsTyxS5J9fNmFF5tcBac&browser=1