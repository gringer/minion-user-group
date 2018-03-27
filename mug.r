#!/usr/bin/Rscript

library(gsheet);
library(ggplot2);
library(grid);

## see https://stackoverflow.com/questions/22873602/importing-data-into-r-from-google-spreadsheet

## load metadata from google spreadsheet [for paper]
data.tbl <- gsheet2tbl("docs.google.com/spreadsheets/d/1480qh5zNRN5ghm0qWisfcf6pCLoPs4xuzs5aMSeKg5Q");
#### load metadata from google spreadsheet [for live version]
##data.tbl <- gsheet2tbl("docs.google.com/spreadsheets/d/19Tl5Cv_SnQ4gA2zcGAMxmxqLz6lyGnSp0sG_r9h7z2E");

## custom cleaning of data
data.tbl <- data.tbl[-1,]; # remove first line (very short run)
data.tbl$`Flowcell run time` <- as.numeric(sub(" h$","",data.tbl$`Flowcell run time`)); # convert run time to hours
data.tbl$`Final library input [ng]` <- # set negative input to 0
    as.numeric(sub("^< ","",data.tbl$`Final library input [ng]`));
data.tbl$`Size selection?` <- # replace long strings
    sub("freeze.*$","freeze/thaw",data.tbl$`Size selection?`);

## Set up X-Y dotplots
data.plots <- lapply(seq_len(ncol(data.tbl)), function(ci){
    xCol = "GB data called";
    plot.res <- ggplot(data.tbl, aes_string(x=as.name(colnames(data.tbl)[ci]),
                                            y=as.name("GB data called"))) + geom_point() +
        geom_quantile(formula = y ~ x);
    if(is.numeric(data.tbl[[ci]])){ # add correlation test for numeric values
        res <- cor.test(data.tbl$`GB data called`, as.numeric(data.tbl[[ci]]));
        rval <- round(res$estimate,2);
        ## http://www.cs.utexas.edu/~cannata/dataVis/Class%20Notes/Beautiful%20plotting%20in%20R_%20A%20ggplot2%20cheatsheet%20_%20Technical%20Tidbits%20From%20Spatial%20Analysis%20&%20Data%20Science.pdf
        plot.res <- plot.res + annotation_custom(grobTree(textGrob(label=sprintf("r = %0.2f", rval), just="right",
                                                                   x=0.5, y=0.1, hjust=0, gp=gpar(fontsize=15))));
    }
    plot.res;
 });

pdf("out_MUG.pdf", width=16, height=12);
##png("out_MUG.png", width=1600, height=1200);
## Create matrix for plot output
## based on http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
layout.mat <- matrix(seq(1,length(data.plots)), ncol=ceiling(sqrt(length(data.plots))));
grid.newpage();
pushViewport(viewport(layout = grid.layout(nrow(layout.mat), ncol(layout.mat))));
## Write plots to matrix output
for(ci in 1:length(layout.mat)){
    poss <- as.data.frame(which(layout.mat == ci, arr.ind=TRUE));
    print(data.plots[[ci]], vp = viewport(layout.pos.row=poss$row,
                                          layout.pos.col=poss$col));
}
invisible(dev.off());
