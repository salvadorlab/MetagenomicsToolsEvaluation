##############################################################
#
# this script is used to summarise profiling output after lca 
# for each read is identified by MEGAN's utility script: blast2lca (in conda env megan)
# 
# lca: if a read were assigned to more than one taxon with same score, 
# the lowest common ancestor for these taxa were taken as the final assignment for this read
# 
#  USAGE: python summarise_megan_lca [INPUT][INPUTTAXID][OUTPUT] 
#  [INPUT]: megan blast2lca, filtered unclassified, dropped columns with multiple species mapped
#  [INPUTTAXID]: same as [input], with -tid specified when running blast2lca, taxonID instead of taxonName
# 
##############################################################

import sys
import os
import pandas as pd
import numpy as np

filtered_lca=sys.argv[1]
filtered_lcaID=sys.argv[2]
summarised_report=sys.argv[3]


# filtered_lca="/scratch/rx32940/metagenomics/blastn/output/R22.K_filtered2.txt"
# filtered_lcaID="/scratch/rx32940/metagenomics/blastn/output/R22.K_lcaTaxID_filtered2.txt"

file_pd=pd.read_csv(filtered_lca, sep=";",index_col=False, header=None, names=range(30))
file_IDpd=pd.read_csv(filtered_lcaID, sep=";",index_col=False, header=None,names=range(30))


def isNaN(string):
    return string != string

# get eukaryota read and virus count summary
# np.r_: Translates slice objects to concatenation along the first axis.
eu_pd=file_pd.loc[isNaN(file_pd[29]) != True]
eu_pd=eu_pd.iloc[:,np.r_[0,2,16:29:2]] 
eu_pd = eu_pd.rename({0:"read", 2:"Domain", 16:"Kingdom", 18:"Phylum", 20: "Class", 22: "Order",24:"Family", 26: "Genus", 28:"Species"}, axis=1)
eu_IDpd=file_IDpd.loc[isNaN(file_pd[29]) != True]
lca_taxID=[]
for row in eu_IDpd.iterrows():
    i=28
    while isNaN(row[1][i]):
        i -=2
    lca_taxID.append(row[1][i])

eu_IDpd.loc[:,"TaxID"]=lca_taxID
eu_IDpd.loc[:,"TaxID"] = eu_IDpd["TaxID"].apply(lambda x: x.split("__")[1])
eu_IDpd=eu_IDpd.rename({0:"read"},axis=1)
eu_IDpd = eu_IDpd.loc[:,["read","TaxID"]]
eu_ID_Taxa = pd.merge(eu_IDpd,eu_pd,  how="left", on="read")
eu_taxa =eu_ID_Taxa.loc[:,["TaxID","Domain","Kingdom","Phylum","Class","Order","Family","Genus","Species"]].drop_duplicates()
eu_count=eu_ID_Taxa.groupby(["TaxID"]).count().iloc[:,0:1]
eu_summary=pd.merge(eu_count, eu_taxa, on="TaxID", how="left" )

# get rest of read count summary
pro_pd=file_pd.loc[isNaN(file_pd[29]) == True]
pro_pd=pro_pd.iloc[:,np.r_[0:16:2]] # np.r_: Translates slice objects to concatenation along the first axis.
pro_pd = pro_pd.rename({0:"read", 2:"Domain", 4:"Phylum", 6: "Class", 8: "Order",10:"Family", 12: "Genus", 14:"Species"}, axis=1)
pro_pd["Kingdom"] = "NA"
pro_IDpd=file_IDpd.loc[isNaN(file_pd[29]) == True]

lca_taxID=[]
for row in pro_IDpd.iterrows():
    i=14
    while isNaN(row[1][i]):
        i -=2
    lca_taxID.append(row[1][i])

pro_IDpd.loc[:,"TaxID"]=lca_taxID
pro_IDpd.loc[:,"TaxID"] = pro_IDpd["TaxID"].apply(lambda x: x.split("__")[1])
pro_IDpd=pro_IDpd.rename({0:"read"},axis=1)
pro_IDpd = pro_IDpd.loc[:,["read","TaxID"]]
pro_ID_Taxa = pd.merge(pro_IDpd,pro_pd,  how="left", on="read")
pro_taxa =pro_ID_Taxa.loc[:,["TaxID","Domain","Kingdom","Phylum","Class","Order","Family","Genus","Species"]].drop_duplicates()
Prop_count=pro_ID_Taxa.groupby(["TaxID"]).count().iloc[:,0:1]
Prop_summary=pd.merge(Prop_count, pro_taxa, on="TaxID", how="left" )

combined_df = pd.concat([eu_summary,Prop_summary])

combined_df.to_csv(summarised_report, sep=";", index=False)




