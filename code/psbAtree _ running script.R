
pacman::p_load(
  rio,             # import/export
  here,            # relative file paths
  tidyverse,       # general data management and visualization
  ape,             # to import and export phylogenetic files
  ggtree,          # to visualize phylogenetic files
  treeio,          # to visualize phylogenetic files
  ggnewscale)      # to add additional layers of color schemes


setwd("~/R/another_trial/phylo_trial/raw_data")
  tree <- ape::read.tree("all.psba.no27.wc3gulf.aligned.fasta.clean_names.contree")

tree

x <- as_tibble(tree)
#write.csv(file= "edit_this", x)

sample_data <- import("sample_data_phyoTrial.csv")
head(tree$tip.label) 
colnames(sample_data)  

sample_data$Source

sample_data <- sample_data %>% 
rename(c("Source" = "Sample_origin"))

head(sample_data$Sample_ID)
View(sample_data)

sample_data$Sample_ID %in% tree$tip.label ### check if labels are similar 
#levels(as.factor(sample_data$source))

## make tree together with meta data of samples 

p1 <- ggtree(tree, layout = "circular", branch.length = 'none') %<+% sample_data + # %<+% adds dataframe with sample data to tree
  aes(color = (Source))+              # color the branches according to a variable in your dataframe
  scale_color_manual(
    name = "Source",                      # name of your color scheme (will show up in the legend like this)
    breaks = c("Current_study" ,"Hume et al. 2015", "LaJeunesse & Thornhill 2011", "Other"),                     # the different options in your variable
    labels = c("Current study" ,"Hume et al. 2015" ,"LaJeunesse & Thornhill 2011", "Other"),aes(size=4),        # how you want the different options named in your legend, allows for formatting                  # the color you want to assign to the variable 
    na.value = "black",  
       # how you want the, different options named in your legend, allows for formatting
    values = c("#e34a33", "#2ca25f","#3182bd","black","black")                # the color you want to assign to the variable 
  )+
 new_scale_color()+                             # allows to add an additional color scheme for another variable
  geom_tippoint(
    mapping = aes(color = Lineage),          # tip color by continent. You may change shape adding "shape = "
    size = 1.5)+                             # define the size of the point at the tip
  scale_color_brewer(
    name = "Algal-symbiont",                    # name of your color scheme (will show up in the legend like this)
    palette = "Set1",                      # we choose a set of colors coming with the brewer package
    na.value = "black")    +           # for the NA values we choose the color grey
  #geom_tiplab(                             # adds name of sample to tip of its branch 
  #color = 'black',                       # (add as many text lines as you wish with + , but you may need to adjust offset value to place them next to each other)
   # offset = 1,
  #  size = 1,
   # geom = "text",
    #align = TRUE)+
  geom_tiplab(                          # add isolation year as a text label at the tips
    aes(label = time),
    color = 'black',
    offset = 1,
    size = 1.5,
    linetype = "blank" ,
    geom = "text",
    align = TRUE)+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.box = "vertical", legend.key.size = unit(1,"line"))
  
p1

ggsave(plot=p1, device = tiff, file="psbA_phylo_circular_tree", dpi= 600,width =20 , height = 20,
       units = "cm")

################################not using from here #######################
#add to this tree 
sample_data

p <- ggtree(tree, branch.length='none', layout='circular') %<+% sample_data +
  geom_tiplab(size =1) + 
  theme(
    legend.position = "bottom",
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    plot.title = element_text(
      size = 12,
      face = "bold",
      hjust = 0.5,
      vjust = -15))
p


Lineage <- data.frame("Lineage" = sample_data[,c("Lineage")])
rownames(Lineage) <- sample_data$label                              ## problem , my lables have duplicates, therefore this cant work currently. 

head(sample_data)
head(Lineage)

p2 <- p + new_scale_fill() 

p2 <-  gheatmap(p, Lineage,                                 # we add a heatmap layer of the gender dataframe to our tree plot
                offset = 10,                               # offset shifts the heatmap to the right,
                width = 0.10,                              # width defines the width of the heatmap column,
                color = NULL,                              # color defines the boarder of the heatmap columns
                colnames = FALSE) +                               # hides column names for the heatmap
  scale_fill_manual(name = "Lineage",                       # define the coloring scheme and legend for gender
                    values = c("#00d1b1", "purple", "yellow", "coral", "green", "steelblue", "black"),
                    breaks = c("C1", "C27","C3","C3gulf", "C64", "C7", "na"),
                    labels = c("C1", "C27","C3","C3gulf", "C64", "C7", "na")) +
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.box = "vertical", legend.margin = margin())


p2




########################################

#write.csv(file="tree_dat", x)
d <- read.csv("~/R/another_trial/phylo_trial/processed data/tree_dat_edited.csv")
d <- as_tibble(d)

head()
y <- full_join(x, d, by = c("parent", "node"))
head(y)
y1 <- as.treedata(y)


# Visualise the nodes for annotation
p_nodes = ggtree(y1, layout="circular") + geom_text(aes(label=node), hjust=-.3, size=1)
p_nodes

# node 137 is C301
# 715 is C40


p_labels = ggtree(tree, layout="circular") + geom_tiplab(size=1)
p <- ggtree(y1,layout="circular")

p+ 
  scale_color_brewer(
  name = "Source",                    # name of your color scheme (will show up in the legend like this)
  palette = "Set1",                      # we choose a set of colors coming with the brewer package
  na.value = "grey") 

 
  geom_label(aes(x=branch, label=Source), fill='lightgreen')  
p  

p+ geom_text2(aes(subset=!isTip, label=node), hjust=-.3, size=4) 


p <- ggtree(y1,layout="circular")
p + geom_text(aes(color=Source, label=time), hjust=1, vjust=-0.4, size=3)


p + geom_hilight(aes(fill=source,
                 type = "roundrect"))
  

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
