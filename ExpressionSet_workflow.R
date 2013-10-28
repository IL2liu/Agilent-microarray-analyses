#setwd("~/My Dropbox/HBOI/sponge raw data")
library(Biobase)
library(limma)
library("arrayQualityMetrics")
#http://www.bioconductor.org/packages/2.12/bioc/html/arrayQualityMetrics.html
source('~/My Dropbox/HBOI/sponge raw data/microarray_data_formatting_refnumber.R')
sponge_data<-getdata()
sponge_dataframe<-data.frame(sponge_data)
annotation<-read.csv("FeatAnnotFile_SEE_10-18-12.csv")
an<-new("AnnotatedDataFrame",data=annotation)
refnum<-annotation$RefNumber
refnum_rows<-rownames(sponge_data)
sponge_dataframe$RefNum<-refnum_rows
sponge_dataframe_sort<-sponge_dataframe[order(as.numeric(sponge_dataframe$RefNum)),]
sponge_data_matrix<-as.matrix(sponge_dataframe_sort)
ncol(sponge_data)
blockrange<-1:8
chiprange<-1:(ncol(sponge_data)/blockrange[8])
colnames<-character()
for (i in chiprange){
  for (j in blockrange){
    new<-paste(i,'_',j)
    new_x<-gsub(" ","",new)
    colnames<-c(colnames,new_x)
  }
}
sample_info<-read.csv("targets_experiment_sample_info.csv")
blockrange<-1:8
chiprange<-1:(ncol(sponge_data)/blockrange[8])
sample_rownames<-character()
for (i in chiprange){
  for (j in blockrange){
    new<-paste(i,'_',j)
    new_x<-gsub(" ","",new)
    sample_rownames<-rbind(sample_rownames,new_x)
  }
}
colnames(sponge_data_matrix)<-colnames
rownames(sample_info)<-sample_rownames
class(sponge_data_matrix)<-"numeric"
sponge_data_matrix<-sponge_data_matrix[,-73]
experimentData<-new("MIAME",name="Sara Edge, Lisa Cohen",
                    lab="Marine Genomics, HBOI",
                    contact="lcohen49@hboi.fau.edu",
                    title="Sponge Oil Dispersant Exposure Experiment",
                    abstract="ExpressionSet for Sponge Microarray Data",
                    other=list(notes="Created from GenePix *.gal files"))
pd<-new("AnnotatedDataFrame",data=sample_info)
sponge_ExpressionSet<-new("ExpressionSet",exprs=sponge_data_matrix,phenoData=pd,experimentData=experimentData,featureData=an)
QA<-arrayQualityMetrics(expressionset = sponge_ExpressionSet,outdir = "report1",force = TRUE)
