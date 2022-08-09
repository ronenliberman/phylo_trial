"""
Script to append the ITS2 information to the current samples names
E.g. the Lajeunesse sequences currently just have accessions
but it would be useful to have the ITS2 designation
We will get this information from their supplementary material here
which we have put into a text file.
https://onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1111%2Fevo.12270&file=evo12270-sup-0003-tableS3.pdf
"""

import pandas as pd

new_list = []
with open("/home/humebc/projects/liberman/laj.all.seqs.raw.text.txt", "r") as f:
    for line in f:
        new_line = line.replace("B1,", "").replace("C1b-f", "C1bf")
        new_list.append(new_line.split()[:3])
        print(new_line.split()[:3])
df = pd.DataFrame(new_list, columns=["name", "ITS2", "accession"])

tree_path = "/home/humebc/projects/liberman/all.psba.no27.wc3gulf.aligned.fasta.contree"
with open(tree_path, "r") as f:
    tree = [_.rstrip() for _ in f][0]

for ind, (name, its2, accession) in df.iterrows():
    tree = tree.replace(accession, f"{its2}_{accession}")


with open(tree_path.replace(".contree", ".clean_names.contree"), "w") as f:
    f.write(f"{tree}\n")

foo = "bar"
