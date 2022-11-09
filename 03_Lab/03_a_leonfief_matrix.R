##################################################
#   URP-5493: Planning & Econ Development
#   Prof: Esteban Lopez Ochoa, PhD
#   Lab 3_a: IO Industry network construction
#################################################

library(data.table)
library(networkD3)
library(readxl)

#reading Implan Data and generating the inter-industry flows (Z matrix)

V_make<-read_excel("03_Lab/IO_accounts.xlsx",col_names = T,sheet = "V_make")# Industry(435) x Product(510)
ind_codes<-V_make$`Row Labels`
V_make[is.na(V_make)]<-0

V_make<-as.matrix(V_make[,2:511])
row.names(V_make)<-ind_codes

U_use<-read_excel("03_Lab/IO_accounts.xlsx",col_names = T,sheet = "U_use")# Product(510) x Industry(435)
prod_codes<-U_use$`Row Labels`
U_use[is.na(U_use)]<-0

U_use<-as.matrix(cbind(U_use[,2:430],matrix(0,510,1),U_use[,431:435])) # adding inds 525 missing
row.names(U_use)<-prod_codes

Exports<-read_excel("03_Lab/IO_accounts.xlsx",col_names = T,sheet = "E_exports")# Industry(435) x D&F (2)
Exports[is.na(Exports)]<-0
Exports<-as.matrix(Exports[,2:3])
rownames(Exports)<-ind_codes


Imports<-read_excel("03_Lab/IO_accounts.xlsx",col_names = T,sheet = "M_imports")# Industry(435) x D&F (2)
Imports[is.na(Imports)]<-0
Imports<-as.matrix(Imports[,2:436])
rownames(Imports)<-colnames(Exports)

X<-rowSums(cbind(as.matrix(rowSums(V_make)),Exports))
Q<-colSums(V_make)
index0<-which(is.na(Q)==TRUE | Q<=0.000001)
Q[index0]<-0.0001

D<-V_make %*% solve(diag(Q))

B<-U_use %*% solve(diag(X))

Z<-D %*% B %*% diag(X)

shares<-as.matrix(colSums(Z)/X)
row.names(shares)<-ind_codes
#View(shares)
#summary(colSums(Z)/X)

# Technical Coefficient Matrix

A<-Z %*% solve(diag(X))
saveRDS(object = A,file = "03_Lab/technical_coeff.rds")
# Leontief Matrix

L<-solve(diag(1,nrow = 435,ncol = 435)-A)

saveRDS(object = L,file = "03_Lab/Leontief.rds")