#!/usr/local/bin/Rscript --vanilla

# this script plots followings
# 1. PCA - variance
# 2. PCA - pc1/pc2 with vectors
# 3. PCA - pc1/pc2 without vectors
# 4. distance matrix
# 5. distance in 3D with respect to two ENVs

# lasted modifed 20080905

##############################################################################
########## READ DATA #########################################################
dist_table <- read.table("./aa_sub.txt");
pca<-prcomp(dist_table, scale=TRUE);
num<- length(row.names(pca$x))
summary(pca);
##############################################################################

#print out
#write.table(pca$sdev, file='pca.sdev.txt')
#write.table(pca$center, file='pca.center.txt')
#write.table(pca$scale, file='pca.scale.txt')
#write.table(pca$x, file='pca.x.txt')

##############################################################################
########## PLOT ##############################################################
#plot variances
plot(pca, main="Variance of pricipal components", xlab="Pricipal Components");
#draw PCA
biplot(pca, cex=0.6);
# pca in 2D
# plot PCA for 48 ENVs
plot(pca$x, main="PCA for No-ACC ENVs", type="n"); text(pca$x[,1], pca$x[,2], labels=rownames(pca$x), cex=0.7);
# append line at (0,0)
x<-c(0, 0);y<-c(min(pca$x[,2]), max(pca$x[,2]));lines(x,y,col="red", lty=2);
x<-c(min(pca$x[,1]),max(pca$x[,1],0));y<-c(0, 0);lines(x,y,col="red", lty=2);
# pca in 3D
#library(scatterplot3d)
pca3d<-scatterplot3d::scatterplot3d(x=pca$x[,1],y=pca$x[,2],z=pca$x[,3], type='n', xlab='PC1', ylab='PC2', zlab='PC3', main='PCA for No-ACC ENVs', col.grid="lightblue");
text(pca3d$xyz.convert(pca$x),  labels=rownames(pca$x), cex=0.6)
# draw a distance matrix
# as.matrix() converts data.frame to matrix where each row/colum is a named vector
x<-y<-(1:length(names(dist_table)));
image(x,y,as.matrix(dist_table), axes=FALSE,  main="Distance Matrix of No-ACC envrionments", xlab="Envrionments", ylab="Environments");
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

#2. By the class of secondary structure 
cv.ss<-vector()
for(i in grep('C', rownames(pca$x))) cv.ss[i]<-'yellow'
for(i in grep('E', rownames(pca$x))) cv.ss[i]<-'blue'
for(i in grep('H', rownames(pca$x))) cv.ss[i]<-'red'
for(i in grep('P', rownames(pca$x))) cv.ss[i]<-'black'

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

#write.table(data.frame(esst=rownames(pca$x),color=cv.prop), file='/BiO/cv_prop.txt', quote=FALSE, col.names = FALSE, row.names = FALSE)
#rgb coolour
#write.table(t(col2rgb(cv.prop)), file='/BiO/Research/Toccata/ESST/Modules/Distance/48ESSTs/cv_prob_rgb.txt', quote=FALSE, sep=",", col.names = FALSE, row.names = FALSE)
##############################################################################

#RGL (OpenGL)
#open3d()
library(rgl);

#cv<-cv.prop;
cv<-cv.ss;

cv<-cv.hb.n;
cv<-cv.hb.o;
cv<-cv.hb.s;
cv<-cv.hb.son;
cv<-cv.hb;

rgl::plot3d(pca$x, main='PCA for No-ACC ENV (AA subt)', type='n'); text3d(pca$x, text=rownames(pca$x), cex=0.6, col=palette(cv)); bg3d("lightgray")
