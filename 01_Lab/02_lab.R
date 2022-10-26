##################################################
#   URP-5493: Planning & Econ Development
#   Prof: Esteban Lopez Ochoa, PhD
#   Lab 2: IO Matrices and Analysis
#################################################

#----------------------------------
#1. Set up of the IO matrices
#----------------------------------

#Creating an empty matrix of intermidiate transactions
x<-matrix(0,2,2)

#Recording values of intersectoral transactions
x[1,1]<-150
x[1,2]<-300
x[2,1]<-200
x[2,2]<-100

# Value Added (F) - (productive factor: Labor wages)
VA<-matrix(c(230,340),nrow=1,ncol=2)

#Final demand
Y<-matrix(c(130,440))

#Bulding the IO Matrix
IOM<-matrix(0,4,4)

IOM[1:2,1:2]<-x
IOM[3,1:2]<-VA
IOM[1:2,3]<-Y
IOM[4,]<-colSums(IOM) 
IOM[,4]<-rowSums(IOM)

colnames(IOM)<-c("S1","S2","Y","X")
rownames(IOM)<-c("S1","S2","V","X")

IOM

#----------------------------------
#2. Calculating the Technical Coefficient Matrix (A), 
# the Value Added Technical Coefficients (Va)  and the Leontief Inverse matrix (B)
#----------------------------------
#Technical Coefficients (A)
A<-matrix(0,2,2)
A[1,]<-x[1,]/IOM["X",1:2]
A[2,]<-x[2,]/IOM["X",1:2]

#Value added technical coefficients
Va<-F/IOM["X",1:2]


#Leontief Matrix
I<-diag(2)
B<-solve(I-A)
B


#----------------------------------
#3. Calculating the Product, Employment and Income Multipliers
#----------------------------------

#Product
O<-matrix(colSums(B),nrow=1,ncol=2)

#Income
H<-matrix(0,1,2) 
H[1,1]<-(Va[1,1]*B[1,1])+(Va[1,1]*B[2,1])
H[1,2]<-(Va[1,2]*B[1,2])+(Va[1,2]*B[2,2])


#Employment
# Number of workers in each sector
e<-matrix(c(20,32),nrow=1,ncol=2)

# Employment Tech Coeff (w=E/X)
w<-e/IOM["X",1:2]  # $ of output per worker

# Employment Multiplier

E<-matrix(0,1,2)
E[1,1]<-(w[1,1]*B[1,1])+(w[1,1]*B[2,1])
E[1,2]<-(w[1,2]*B[1,2])+(w[1,2]*B[2,2])

#----------------------------------
#4. Economic Impact Analysis of a potential investment.
#----------------------------------

#new final demand
Ystar<-matrix(c(20,0),ncol = 1,nrow = 2)

Prod.Impact <- t(O)*Ystar
Prod.Impact
#2. Economic impact on income
Income.Impact <- t(H)*Ystar
Income.Impact
#3. Economic impact on employment
Emp.Impact <- t(E)*Ystar
Emp.Impact
