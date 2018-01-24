#!/usr/local/bin/Rscript --vanilla
require(graphics)

##############################################################################
########## READ DATA #########################################################
dist_table <- read.table("./aa_sub.txt")
pca<-prcomp(dist_table, scale=TRUE)
summary(pca)
##############################################################################


##############################################################################
########## PLOT ##############################################################
#plot variances
plot(pca, main="Variance of pricipal components", xlab="Pricipal Components")
#draw PCA
biplot(pca)
# pca in 2D (PC1, PC2)
plot(pca$x, main="PCA for 8 Hbond types", type="n"); text(pca$x[,1], pca$x[,2], labels=labels(pca$x[,2]), col=rainbow(4))
# append a line at (x,y)=(0,0)
x<-c(0, 0);y<-c(min(pca$x[,2]), max(pca$x[,2]));lines(x,y,col="red", lty=2);
x<-c(min(pca$x[,1]),max(pca$x[,1],0));y<-c(0, 0);lines(x,y,col="red", lty=2);
# pca in 3D
pca3d<-scatterplot3d::scatterplot3d(x=pca$x[,1],y=pca$x[,2],z=pca$x[,3], type='n', xlab='PC1', ylab='PC2', zlab='PC3', main='PCA for 8 Hbond types', col.grid="lightblue");
text(pca3d$xyz.convert(pca$x),  labels=labels(pca$x[,2]))
# draw a distance matrix
# as.matrix() converts data.frame to matrix where each row/colum is a named vector
x<-y<-(1:length(names(dist_table)));
image(x,y,as.matrix(dist_table), axes=FALSE,  main="Distance Matrix of 8 Hbond types", xlab="Envrionments", ylab="Environments");
#label x-axis
axis(1, at=seq(1:length(names(dist_table))), labels=names(dist_table));
#label y-axis
axis(2, at=seq(1:length(names(dist_table))), labels=names(dist_table));
#others
#contour(as.matrix(dist_table), add=TRUE)
persp(as.matrix(dist_table))
##############################################################################


##############################################################################
################  COLOUR VECTOR (cv)  ########################################
# 1. By a proporstion of amino acids
num<-8 

#3. By Hbonds (from side-chain)
#3.1 side chain to NH
cv.hb.n<-vector()
for(i in grep('N', rownames(pca$x))) cv.hb.n[i]<-'blue'
for(i in grep('n', rownames(pca$x))) cv.hb.n[i]<-'black'

#3.2 side chain to CO 
cv.hb.o<-vector()
for(i in grep('O', rownames(pca$x))) cv.hb.o[i]<-'red'
for(i in grep('o', rownames(pca$x))) cv.hb.o[i]<-'black'

#3.3 NH and CO
cv.hb.co<-vector()
for(i in grep('ON', rownames(pca$x))) cv.hb.co[i]<-'green'
for(i in grep('On', rownames(pca$x))) cv.hb.co[i]<-'red'
for(i in grep('oN', rownames(pca$x))) cv.hb.co[i]<-'blue'
for(i in grep('on', rownames(pca$x))) cv.hb.co[i]<-'black'

#3.2 side chain to side-chain 
cv.hb.s<-vector()
for(i in grep('S', rownames(pca$x))) cv.hb.s[i]<-'yellow'
for(i in grep('s', rownames(pca$x))) cv.hb.s[i]<-'black'
#3.3 son vs non-son
cv.hb.son<-vector()
for(i in grep('son', rownames(pca$x))) cv.hb.son[i]<-'yellow'
for(i in setdiff(1:num, grep('son', rownames(pca$x)))) cv.hb.son[i]<-'black'
#3.4 "SON" "SOn" "SoN" "Son" "sON" "sOn" "soN" "son"
cv.hb<-vector()
hb.type<-c("SON"=1, "SOn"=2, "SoN"=3, "Son"=4, "sON"=5, "sOn"=6, "soN"=7, "son"=8)
for(i in names(hb.type)){
	for(j in grep(i, rownames(pca$x))) cv.hb[j]<-rainbow(length(hb.type))[hb.type[i]]
}
##############################################################################

#RGL (OpenGL)
#open3d()
library(rgl);
cv<-cv.prob;
rgl::plot3d(pca$x, main='PCA for 8 H-bond (AA Subst)', type='n'); text3d(pca$x, text=rownames(pca$x),col=palette(cv)); bg3d("lightgray");
