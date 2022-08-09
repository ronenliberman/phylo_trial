if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

library(DESeq2)
library(ggtree)
library(tidyverse)
tidyverse_update()

tree <- read.tree("all.psba.no27.wc3gulf.aligned.fasta.clean_names.contree")

View(tree)

x <- as_tibble(tree)
x

write.csv(file="tree_dat", x)

# Visualise the nodes for annotation
p_nodes = ggtree(tree, layout="circular") + geom_text(aes(label=node), hjust=-.3, size=1)
p_nodes

# node 137 is C301
# 715 is C40


p_labels = ggtree(tree, layout="circular") + geom_tiplab(size=1)
p <- ggtree(tree,layout="circular") 

p+ geom_text2(aes(subset=!isTip, label=node), hjust=-.3, size=4) 



p + geom_hilight(node="35", linetype = 3) 
  
  
p+geom_nodelab(size=2.5,hjust=-.3)+theme_tree()
  
d <- data.frame(node=c(17, 21), type=c("A", "B"))

ggtree(tree)+geom_balance(node=16, fill='steelblue', color='white', alpha=0.6, extend=1)
    
    
p+geom_hilight(node="64", fill="steelblue", alpha=.6) 
    
x <- read.nhx(system.file("extdata/NHX/ADH.nhx", package="treeio"))
  
x
tree
  
  p+
    geom_balance(node="16", fill='steelblue', color='white', alpha=0.6, extend=1) +
    geom_balance(node="19", fill='darkgreen', color='white', alpha=0.6, extend=1) 
    
  ggtree(tree)+geom_hilight(mapping=aes(subset = node %in% c(34, 38), 
                               fill = S),
                   type = "gradient", gradient.direction = 'rt',
                   alpha = .8) +
      scale_fill_manual(values=c("steelblue", "darkgreen"))
    
    
  geom_cladelabel(node=64, label="C1",  color="black", align=TRUE, horizontal=TRUE) 
  
    
    
    geom_cladelabel(node=209, label="C64",  color="black", align=TRUE, horizontal=TRUE)+
  theme_tree()

require(treeio)


p+ geom_tiplab(aes(subset=(node %in% c(200:220))))+  geom_hilight(node=17, fill="gold") 
