
pacman::p_load(
  rio,             # import/export
  here,            # relative file paths
  tidyverse,       # general data management and visualization
  ape,             # to import and export phylogenetic files
  ggtree,          # to visualize phylogenetic files
  treeio,          # to visualize phylogenetic files
  ggnewscale, ggtreeExtra,ggstar)      # to add additional layers of color schemes
devtools::install_github("xiangpin/ggtreeExtra")
library(ggstar) 
library(ggtreeExtra)
install.packages("ggtreeExtra")

setwd("~/R/another_trial/phylo_trial/raw_data")
setwd("~/R/another_trial/phylo_trial/raw_data/my tree")

  tree <- ape::read.tree("all.psba.no27.wc3gulf.aligned.fasta.clean_names.contree")

tree

x <- as_tibble(tree)
view(x)
#head(x)
#write.csv(file= "edit_this", x)

sample_data <- import("sample_data_phyoTrial.csv")
head(tree$tip.label) 
colnames(sample_data)  

sample_data$Source

sample_data <- sample_data %>% 
rename(c("Source" = "group"))

head(sample_data$Sample_ID)
View(sample_data)

sample_data$Sample_ID %in% tree$tip.label ### check if labels are similar 
#levels(as.factor(sample_data$source))

## make tree together with meta data of samples 

p <- ggtree(tree, layout="circular")  ## basic tree 

p1 <- p%<+% sample_data                 ## add metadata
 
p2 <- p1 +                                 ### show only specific names on the tree - the names of my samples , all start with _mo
  geom_tiplab(aes(label=print,subset=grepl("_mo",time)),size=1)

p3 <- p2+                                    ### add the information of the origin of the data 
  geom_tippoint(
    mapping = aes(colour= Sample_origin),          # tip color by continent. You may change shape adding "shape = "
    size = 0.75,stroke=0.75, alpha= 0.4 )+                             # define the size of the point at the tip
  scale_colour_brewer(
    name = "Data origin",                    # name of your color scheme (will show up in the legend like this)
    palette = "Set1",guide=guide_legend(keywidth=0.3,
                                        keyheight=0.3,
                                        ncol=2,
                                        override.aes=list(size=2,alpha=1),
                                        order=1)) +
  theme(legend.position = "bottom",legend.box = "horizontal",
        legend.title=element_text(size=5),
        legend.text=element_text(size=4),
        legend.spacing.y = unit(0.02, "cm")
  )
p3

p4 <- p3 + 
  geom_fruit(                                    #adding information about the lineage of the lgae symbionts around the tree (circle)
    geom=geom_tile,                              # this function is from ggtreeExtra pck 
    mapping=aes(fill=Lineage),
    width=0.03,
    offset=0.2,
  ) +
  scale_fill_manual(
    name="Algae symbiont",                             ### this is from the my sample data file 
    # palette = "Set1",
    values=c("C1"= '#c2e699',  "C27" = '#d7b5d8',
             "C3"=  'gray75', "C3gulf"='#ffffcc', "Cladocopium sp."= 'forestgreen',"C64"='#006837',"C7"= '#7a0177'),
    guide=guide_legend(
      keywidth=0.3,
      keyheight=0.3,
      order=3
    ),
    na.translate=FALSE
  ) +  
  geom_treescale(fontsize=2, linesize=1, offset=.5) +
  theme(legend.position = "bottom",
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 10),
        legend.box = "horizontal", legend.key.size = unit(3,"line"))
p4 


ggsave(plot=p4, device = tiff, file="new_version", dpi= 600,width =26 , height = 25,
       units = "cm")


################################not using from here #######################

p1 <- ggtree(tree, layout = "circular", branch.length = 'none') %<+% sample_data + # %<+% adds dataframe with sample data to tree
  aes(color = (Source))+              # color the branches according to a variable in your dataframe
  scale_color_manual(
    name = "Source",                      # name of your color scheme (will show up in the legend like this)
    breaks = c("Current" , "other"),                     # the different options in your variable
    labels = c("Current" , "other"),aes(size=3),        # how you want the different options named in your legend, allows for formatting                  # the color you want to assign to the variable 
    na.value = "black",  
       # how you want the, different options named in your legend, allows for formatting
    values = c("#de2d26", "black")                # the color you want to assign to the variable 
  )+
 new_scale_color()+                             # allows to add an additional color scheme for another variable
  geom_tippoint(
    mapping = aes(color = Lineage),          # tip color by continent. You may change shape adding "shape = "
    size = 1.5)+                             # define the size of the point at the tip
  scale_color_brewer(
    name = "Algal-symbiont",                    # name of your color scheme (will show up in the legend like this)
    palette = "Set2")+                      # we choose a set of colors coming with the brewer package
    #na.value = "gray")    +           # for the NA values we choose the color grey
  #geom_tiplab(                             # adds name of sample to tip of its branch 
  #color = 'black',                       # (add as many text lines as you wish with + , but you may need to adjust offset value to place them next to each other)
   # offset = 1,
  #  size = 1,
   # geom = "text",
    #align = TRUE)+
  geom_tiplab(                          # add isolation year as a text label at the tips
    aes(label = time),
    color = 'black',
    offset = 1.5,
    size = 1.5,
    linetype = "blank" ,
    geom = "text",
    align = TRUE)+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.box = "horizontal", legend.key.size = unit(2,"line"))
  
p1

ggsave(plot=treex, device = tiff, file="psbA_phylo_circular_tree", dpi= 600,width =20 , height = 20,
       units = "cm")


# also not using all this highlight does not look nice


p_nodes <- ggtree(tree,layout = "circular") +  
  #geom_tiplab(size = 4) +
  geom_text2(aes(subset=!isTip, label=node), # labels all the nodes in the tree
             size = 2,
             color = "darkred", 
             hjust = 1, 
             vjust = 1) 
p_nodes

ggsave(plot=p, device = tiff, file="node_version", dpi= 600,width =20 , height = 20,
       units = "cm")



trial <- ggtree(tree, layout = "circular") %<+% sample_data + # %<+% adds dataframe with sample data to tree
  aes(color = (Source))+              # color the branches according to a variable in your dataframe
  scale_color_manual(
    name = "Source",                      # name of your color scheme (will show up in the legend like this)
    breaks = c("Current" , "other"),                     # the different options in your variable
    labels = c("Current" , "other"),aes(size=1.5),        # how you want the different options named in your legend, allows for formatting                  # the color you want to assign to the variable 
    na.value = "black",  
    # how you want the, different options named in your legend, allows for formatting
    values = c("#de2d26", "black")                # the color you want to assign to the variable 
  )+
  new_scale_color()+                             # allows to add an additional color scheme for another variable
  geom_tippoint(
    mapping = aes(color = Source),          # tip color by continent. You may change shape adding "shape = "
    size = 0.75)+                             # define the size of the point at the tip
  scale_color_brewer(
    name = "Algal-symbiont",                    # name of your color scheme (will show up in the legend like this)
    palette = "Set2")+                      # we choose a set of colors coming with the brewer package
  #na.value = "gray")    +           # for the NA values we choose the color grey
  #geom_tiplab(                             # adds name of sample to tip of its branch 
  #color = 'black',                       # (add as many text lines as you wish with + , but you may need to adjust offset value to place them next to each other)
   #offset = .1,
  #  size = 1,
  # geom = "text",
  #align = TRUE)+
  geom_tiplab(                          # add isolation year as a text label at the tips
    aes(label = time),
    color = 'black',
  offset = 0.015,
    size = 0.75,
    linetype = "blank" ,
    geom = "text")+geom_treescale(fontsize=3, linesize=1.5, offset=1.5)+ 
    #align = TRUE)+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.box = "horizontal", legend.key.size = unit(1,"line"))

trial
library(ggrepel)


trial1 <- ggtree(tree, layout = "circular") %<+% sample_data + # %<+% adds dataframe with sample data to tree               # the color you want to assign to the variable 
  new_scale_color()+                             # allows to add an additional color scheme for another variable
  geom_tippoint(
    mapping = aes(color = Sample_origin),          # tip color by continent. You may change shape adding "shape = "
    size = 0.75)+                             # define the size of the point at the tip
  scale_color_brewer(
    name = "",                    # name of your color scheme (will show up in the legend like this)
    palette = "Set2")+                      # we choose a set of colors coming with the brewer package
  #na.value = "gray")    +           # for the NA values we choose the color grey
  #geom_tiplab(                             # adds name of sample to tip of its branch 
  #color = 'black',                       # (add as many text lines as you wish with + , but you may need to adjust offset value to place them next to each other)
  #offset = .1,
  #  size = 1,
  # geom = "text",
  #align = TRUE)+
  geom_tiplab(                          # add isolation year as a text label at the tips
    aes(label = node),
    color = 'black',
    offset = 0.015,
    size = 0.75,
    linetype = "blank" ,
    geom = "text")+geom_treescale(fontsize=3, linesize=1.5, offset=1.5)+ 
  #align = TRUE)+
  theme(legend.position = "bottom",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.box = "horizontal", legend.key.size = unit(1,"line"))

trial1


x
trail_2 <- ggtree(tree, layout = "circular") +geom_hilight(node=489, fill="forestgreen", alpha=0.3)+  #C1
                                              geom_hilight(node=589, fill="blue", alpha=0.3)+          ### my pther group
                                              geom_hilight(node=c(428), fill="coral", alpha=0.3)+       #c7/c27
                                              geom_hilight(node=c(593), fill="#ffffcc")+          #c3gulf
                                              geom_hilight(node=c(617), fill="purple", alpha=0.3)+     #c3 part 
                                              geom_hilight(node=c(558), fill="#006837", alpha=0.5)+
                                              geom_hilight(node=c(654), fill="purple", alpha=0.3)+  #c3 part 
                                              geom_hilight(node=c(702), fill="purple", alpha=0.3)+  #c3 part 
                                              geom_hilight(node=c(381), fill="purple", alpha=0.3)+
                                              geom_hilight(node=c(665), fill="purple", alpha=0.3) + #t#c3 part 
                                              geom_hilight(node=c(697), fill="purple", alpha=0.3)+  #t#c3 part 
                                               geom_hilight(node=c(700), fill="purple", alpha=0.3)+
                                              geom_hilight(node=c(698), fill="purple", alpha=0.3)+
                                              geom_hilight(node=c(371), fill="purple", alpha=0.3)
                                             # geom_hilight(node=c(330), fill="purple", alpha=0.3)#t#c3 part 
  trail_2                                                        # ,geom_tiplab(size=4, hjust=0
  
  +     #c3 part 
    geom_hilight(node=c(558), fill="#006837", alpha=0.5)+
    geom_hilight(node=c(654), fill="purple", alpha=0.3)+  #c3 part 
    geom_hilight(node=c(702), fill="purple", alpha=0.3)+  #c3 part 
    geom_hilight(node=c(381), fill="purple", alpha=0.3)+
    geom_hilight(node=c(665), fill="purple", alpha=0.3) + #t#c3 part 
    geom_hilight(node=c(697), fill="purple", alpha=0.3)+  #t#c3 part 
    geom_hilight(node=c(700), fill="purple", alpha=0.3)+
    geom_hilight(node=c(698), fill="purple", alpha=0.3)+
    geom_hilight(node=c(371), fill="purple", alpha=0.3)
  # geom_hilight(node=c(330), fill="purple", alpha=0.3)#t#c3 part 
  trail_2              
  
  
  ###############################3
  trail_3 <- ggtree(tree, layout = "circular") +
    # geom_hilight(node=513, fill="coral", alpha=0.3)+  #C1
    geom_hilight(node=559, fill="coral", alpha=0.3) +
    geom_hilight(node=c(589), fill="coral", alpha=0.3)+### my group
    geom_hilight(node=c(590), fill="coral", alpha=0.3)+
    geom_hilight(node=c(595), fill="coral", alpha=0.3)+
    geom_hilight(node=c(513), fill="coral", alpha=0.3)+
    geom_hilight(node=c(588), fill="coral", alpha=0.3)
  
  #geom_hilight(node=c(595), fill="coral", alpha=0.3)
  
  trail_3
treex = trail_3%<+% sample_data + 
  new_scale_color()+                             # allows to add an additional color scheme for another variable
  geom_tippoint(
    mapping = aes( color=Sample_origin),          # tip color by continent. You may change shape adding "shape = "
    size = 0.75)+                             # define the size of the point at the tip
  scale_color_brewer(
    name = "Origin",                    # name of your color scheme (will show up in the legend like this)
    palette = "Set1")+
  geom_tiplab(                          # add isolation year as a text label at the tips
    aes(label = time),
    color = 'black',
    offset = 0.015,
    size = 0.75,
    linetype = "blank" ,
    geom = "text")+geom_treescale(fontsize=3, linesize=1.5, offset=1.5)+ 
  #align = TRUE)+
  theme(legend.position = "",
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.box = "horizontal", legend.key.size = unit(3,"line"))+
        geom_cladelab(node=227, label="C3gulf",geom='label',offset.text=.25,fontsize=3)+
  geom_cladelab(node=98, label="C7",geom='label',offset.text=.25,fontsize=3)+
  geom_cladelab(node=40, label="C3",geom='label',offset.text=.25,fontsize=3)+
  geom_cladelab(node=140, label="C1",geom='label',offset.text=.25,fontsize=3)+
  geom_cladelab(node=440, label="C27",geom='label',offset.text=.25,fontsize=3)+
  geom_cladelab(node=210, label="C64",geom='label',offset.text=.25,fontsize=3) + hexpand(.1)+vexpand(.1)

treex



ggsave(plot=treex, device = tiff, file="node_version", dpi= 600,width =20 , height = 20,
       units = "cm")










ggtree(tree, layout = "circular") +geom_hilight(data= sample_data,mapping=aes(node=label, fill=Lineage))
  


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
