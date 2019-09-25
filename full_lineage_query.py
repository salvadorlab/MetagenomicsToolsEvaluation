from Bio import Entrez
from Bio import SeqIO

path = "/Users/rx32940/Dropbox/5. Rachel's projects/Metagenomic_Analysis/KRAKEN2:BRACKEN/genus/"
taxids_filename = path + "taxid_only_all_braken.txt"  # Replace with the path to your Tax IDs file!

with open(taxids_filename) as f:
    tax_ids = f.read().split('\n')

Entrez.email = 'user@example.org'  # Put your email here
handle = Entrez.efetch('taxonomy', id=tax_ids, rettype='xml')
response = Entrez.read(handle)

for entry in response:
    sci_name = entry.get('ScientificName')
    lineage_taxa = entry.get('LineageEx')
    lineages=""
    for dict in lineage_taxa:
        if dict['Rank'] == "superkingdom":
            lineages = lineages + "Domain:" + dict['ScientificName'] + "\t"
        if dict['Rank'] == "phylum":
            lineages = lineages + "phylum:" + dict['ScientificName'] + "\t"
        if dict['Rank'] == "family":
            lineages = lineages + "family:" + dict['ScientificName'] + "\t"
        if dict['Rank'] == "genus":
            lineages = lineages + "genus:" + dict['ScientificName'] + "\t"
    #lineages = lineage_taxa[]
    lineages = lineages + sci_name +"\n"
  

    with open(path + "full_lineage.txt","a+") as f:
        f.write(lineages)
