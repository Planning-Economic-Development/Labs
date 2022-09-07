##################################################
#   URP-5493: Planning & Econ Development
#   Prof: Esteban Lopez Ochoa, PhD
#   Lab 1: Measures of Regional Economic Activity
#################################################


#-------- Part 0: Loading and Manipulating Data ----

# Website to explore the data: https://www.bea.gov 

# website to download the raw data: https://apps.bea.gov/regional/downloadzip.cfm



#loading the data
library(data.table)
gdp_tx<-fread("01_Lab/CAGDP2_TX_2001_2020.csv")

#cleaning the data


# Can we create a bar plot that shows where does Bexar's GDP falls within Texas?
library(ggplot2)
options(scipen = 999)
gdp_tx[,gdp_2020:=as.numeric(`2020`)]
summary(gdp_tx$gdp_2020)


ggplot(data = gdp_tx[Description=="All industry total" & GeoName!="Texas" & gdp_2020> 2348820,],aes(y=reorder(GeoName,gdp_2020),x=gdp_2020))+
  geom_bar(stat = 'identity')

# Can we create a bar plot for Bexar's GDP by industry




#---------------------------
# Primacy Index
#---------------------------
# Description: 
#   Measures what is the economic sector of a region r that has
# 	the highest share in the total of the economic activity of that
#	region.
# Formula:
#   P_rs=max(x_sr/X_r)
#		X_r	: Total economic Activity of a region r
#		x_sr	: Economic Activity of sector s at region r		 




#---------------------------
# Location Quotient
#---------------------------
# Description: 
#   Measures the relative specialization of an economic sector of a 
# 	region r.
# Formula:
#	S_sr=
#   Q_rs=∑(x_sr/X_r)/(x_sR/X_SR)
#		x_sr	: Economic Activity of sector s at region r		 
#		X_r	: Total economic Activity of a region r
#		x_sR	: Economic Activity of sector s in all regions (reference)		 
#		X_SR	: Total economic Activity in all sectors and all regions



#---------------------------
# Market Potential
#---------------------------
# Description: 
#   Measures the accessibility of a spatial unit (r) to the rest of
#   markets in an area of analysis. It weights to the economic activity
#   of region r with respect to the distance of r to the rest of the regions
#   in the area of analysis R-ri={r1,..-ri.,R}
# Formula:
#   MP_ri=∑_j(P_rj/D_rirj)
#		D_rirj: Distance between region ri and rj
#		P_ri	: Economic Activity at rj		 






