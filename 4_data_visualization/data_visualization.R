# R Fundamentals Training
# AXA @ Madrid 15, December 2016
# Jacopo Primavera

# Data visualization
#============================================================================================#



##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################


# setup working directory
dir.create("C:/Users/AX30164/Desktop/RFundamentalsWeek5") # put the path you prefer
setwd("C:/Users/AX30164/Desktop/RFundamentalsWeek5") # use same path used above

# load packages
library(dplyr)
library(MASS)
library(rworldmap)
library(ggplot2)



#------------------------------------------------------------------------
#-------------------------- EXPLORE DATA PROPERTIES
#------------------------------------------------------------------------


# Let's simulate some data
x <- rnorm(100)
y <- x + rnorm(100, mean=0.2, sd=2)
df <- data.frame(lab = LETTERS[1:7], g = rgamma(7, shape = 100))


# plot() is a generic function for plotting R objects
plot(x) # if you provide just a vector of numbers default is to plot them on y axis against an index on x axis
plot(x, y) # if you provide just a vector of numbers default is to plot them on y axis against an index on x axis
plot(df)

# Now let's play with some insurance data
# read the data (copy the data PolicyPtf.csv in the working directory first)
dt <- read.csv("PolicyPtf.csv")

# first thing you want to do is probably to have an idea of what kind of data you have
str(dt)
summary(dt)

# prepare data for barplots
dt_poldur <- dt %>% group_by(Poldur) %>% summarise(Expos=sum(Exposure))
dt_car <- dt %>% group_by(Category_Car) %>% summarise(Expos=sum(Exposure))

# barplots
plot(dt_poldur) 
plot(dt_car) 

# we could use also barplot function
barplot(dt_poldur$Expos, names.arg = dt_poldur$Poldur)

# histograms
hist(dt$Age)
hist(dt$Age, nclass = 30) # to smooth more by increasing number of bins

# boxplots
boxplot(dt$Value_Car)





#------------------------------------------------------------------------
#---------------------- find patterns in data
#------------------------------------------------------------------------


## multiple boxplots (you can use the formula statement ~)
boxplot(dt$Age ~ dt$Category_Car, col="salmon2")

# splitting screen to accomodate multiple plots
parOriginal <- par(no.readonly = TRUE) # save a copy of original graphical parameters
par(mfrow=c(2,2), mar=c(4,4,2,1)) # par can be used to set or query graphical parameters
# mfrow set the split of the graphical window
# mar sets the margin on the fours sides of the plot

hist(dt[dt$Category_Car=="Small","Age"], nclass = 30, probability = TRUE, col="palegreen1")
hist(dt[dt$Category_Car=="Medium","Age"], nclass = 30, probability = TRUE, col="palegreen1")
hist(dt[dt$Category_Car=="Large","Age"], nclass = 30, probability = TRUE, col="palegreen1")
# if you don't like to leave one box emppty you may add the full distribution...
hist(dt$Age, nclass = 30, probability = TRUE, col="khaki")

## scatterplot
par(parOriginal) # set default graphical parameters

# let's simulate two normal populations, one with means 2 and 4 
x_a <- rnorm(50, 2)
x_b <- rnorm(50, 4)
x <- c(x_a, x_b)

# let's simulate another two normal populations respectively correlated with previous ones
y_a <- x_a + rnorm(50, 0.2, 0.5)
y_b <- x_b + rnorm(50, 0.2, 1)
y <- c(y_a, y_b)

# create variable to label the two populations
l <- c(rep("A", 50), rep("B", 50))
df <- data.frame(x=x, y=y, l=l)

# scatterplot 2-d
plot(df$x, df$y)

# add a third dimension with colour
with(df, plot(x, y, col = l))


# spatial analysis
newmap <- getMap(resolution = "coarse")  
class(newmap)
plot(newmap)


# add some attribute at country-level
# load a R workspace containing a simple dataset with profitability KPIs for countries in EMEA-LATAM region
load("emealatam_data.RData")
new
# 'new' database contains for some country in the EMEALATAM Region profitability indicators with view revised budget 2016 (view of June)
# let's join these KPIs by country to the internal map of rworldmap package
new2 <- joinCountryData2Map(new, joinCode = "NAME", nameJoinColumn = "name")

# function mapCountryData in rworldmap Draw a map of country-level data, allowing countries to be coloured
mapCountryData(new2, nameColumnToPlot="eaxa_net_cr_rb_pl_cl_nhe") # EAXA CR PL+CL w/o Health






#------------------------------------------------------------------------
#  ------------------ communicate results
#------------------------------------------------------------------------



## Graphical parameters and annotations

hist(dt$Age, 
     nclass = 30, # number of bins
     probability = TRUE, 
     col="wheat", # color of bars
     border = "black", # color of border of bars
     xlab = "Age", # label of x axis
     ylab = "", # label of y axis
     ylim = c(0, 0.03),
     main = "Policyholder's age probability density distribution" # title
     ) 

fit <- fitdistr(dt$Age, "normal")
curve(dnorm(x, mean = fit$estimate["mean"], sd = fit$estimate["sd"]), add=T, col = "red") # not so normal...

# legends can be added
legend("topright", # position of legend box
       bty = "n", # box type = none
       legend = c("Observed", "theoretical normal"), # text to be displayed
       col = c("wheat", "red"), # colors
       lty = c(1,1), # line type 
       lwd = c(10, 1) # line width
       )


# ggplot2

windowsFonts(Times=windowsFont("TT Times New Roman")) # translate font names for ggplot

# build ggplot layer by layer...
gg1 <-ggplot(dt, aes(x = Age, group = Category_Car, fill = Category_Car)) + # set Age on x-axis, group and fill (with color) according to the values of category_car
  geom_density(alpha = .4) + # transform age data into a density distribution summary 
  xlab("Policyholder's age") + # set x-axis label
  ylab("") + # set y-axis label
  ggtitle("Age distributions by car category") + # set plot title
  guides(fill=guide_legend("Car category")) + # color legend according to values of category car
  theme(plot.title = element_text(hjust = 0, vjust=5, size = 18, family = "Times"), # set position, size and font for title
        axis.text.x = element_text(size = 14, family = "Times"), # set size and font for x axis label
        axis.text.y = element_text(size = 14, family = "Times"), # set size and font for y axis label
        panel.background = element_rect(fill = "white") # set background color
        )
     
# plot a ggplot object
gg1



# colors
colors() # for a list of all colors known by R

# a vector of valid colors
mapCountryData(new2, nameColumnToPlot="eaxa_net_cr_rb_pl_cl_nhe",
               colourPalette = c("red","white","blue", "green", "purple", "orange", "grey")) # not so nice, right?

# let's use palettes built with RColorBrewer
display.brewer.all(n=NULL, type="all") # diverging, sequential, qualitative
display.brewer.all(n=NULL, type="seq") # we are interested in sequential palettes in this case

# using output from RColorBrewer as palette for map
mapCountryData(new2, nameColumnToPlot="eaxa_net_cr_rb_pl_cl_nhe",
               colourPalette = brewer.pal(7, "Purples"))



# Graphic devices

pdf(file = "myplot.pdf")
gg1
dev.off()

png(file = "myplot.PNG")
gg1
dev.off()




