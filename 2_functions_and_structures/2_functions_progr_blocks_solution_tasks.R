# R Fundamentals Training
# AXA @ Madrid 21, October 2016
# Jacopo Primavera
# Class 2nd
#============================================================================================#





#============================================================================================#
# o. Setup
#============================================================================================#


dir.create("C:/Users/pc/Desktop/RFundamentalsWeek2")
setwd("C:/Users/pc/Desktop/RFundamentalsWeek2") 




#============================================================================================#
# 1. Import, overview and analyse simple data
#============================================================================================#



# read dataset "PolicyPtfSum.csv" and save its value in an object (use read.csv function)
dt <- read.csv("PolicyPtfSum.csv")

# Have an overview of the data
str(dt)
summary(dt)
# Have a look at the first 10 and last 3 rows (use head and tail) 
head(dt, n = 10)
tail(dt, 3)

# Check if there is at least one missing value
idx <- is.na(dt)
any(idx)
any(is.na(dt)) # same as above but in a single line


# Discover for which variables you have missing values
which(idx, arr.ind = TRUE)
temp <- which(idx, arr.ind = TRUE)
str(temp)
head(temp)

# Discover in which variable(s) you have missing values
table(temp[,2])

# Calculate the total exposure and average material frequency
sum(dt$exposure)    # overall exposure
sum(dt$mclaim) / sum(dt$exposure)     # overall material claim frequency 

# Calculate same indicators, but only for males
sum(  dt[ dt$Gender=="Male", "exposure" ]   )    # overall male exposure
sum( dt[dt$Gender=="Male", "mclaim"] ) / sum(  dt[dt$Gender=="Male", "exposure"]  )   # overall male material claim frequency

# Save these last two results in a vector called mystats
totexp <- sum(  dt[ dt$Gender=="Male", "exposure" ]   )    # overall male exposure
avgmfreq <- sum( dt[dt$Gender=="Male", "mclaim"] ) / sum(  dt[dt$Gender=="Male", "exposure"]  )   # overall male material claim frequency
mystat <- c(totexp, avgmfreq)
mystat


# import the full portfolio database
fulldt <- read.csv("PolicyPtf.csv")

# overview it
str(fulldt)
nrow(fulldt)
names(fulldt)
summary(fulldt)
head(fulldt)

# In the original data the columns for number of claims and cost have cryptic names:
# Numtppd --> number of material claims
# Numtpbi --> number of BI claims
# Indtppd --> Cost of material claims
# Indtpbi --> Cost of BI claims
# Change these names respectively in something more readable
# Numtppd --> mclaim
# Numtpbi --> bclaim
# Indtppd --> mcost
# Indtpbi --> bcost
names(fulldt)[17:20] <- c("mclaim", "bclaim", "mcost", "bcost")

# Create a histogram of the variable mcost
hist(fulldt$mcost)
# create a better histogram of variable mcost only for rows where there was actually at least a material claim
hist(fulldt[fulldt$mclaim>0,"mcost"])
# create an even better histogram of severity always filtering out rows without material claims
hist(fulldt[fulldt$mclaim>0,"mcost"] / fulldt[fulldt$mclaim>0,"mclaim"])
# create you final output by changing the number of bins, the title and the x-axis label
hist(fulldt[fulldt$mclaim>0,"mcost"] / fulldt[fulldt$mclaim>0,"mclaim"], nclass = 30, main = "Material severity histogram", xlab = "")
# save this plot in a variable called myhist
myhist <- hist(fulldt[fulldt$mclaim>0,"mcost"] / fulldt[fulldt$mclaim>0,"mclaim"], nclass = 30, main = "Material severity histogram", xlab = "")
# print the myhist object
myhist
# to see the histogram you will have to call the plot() function on this object
plot(myhist)






#============================================================================================#
# 2. Lists
#============================================================================================#


# Create a simple character object taking value "My analysis"
myreport <- "my analysis"
myreport2 <- c("my analysis")
myreport2 == myreport  # they are the same!

# Store the objects you have created (mystats, myhist and myreport) in a list
mylist <- list(mystat, myhist, myreport)
# give a name to each object of the list
mylist <- list(mystat = mystat, myhist = myhist, myreport = myreport)
# check the number of components in mylist with function lenght()
length(mylist)

# Play with [] operator and sublists
mylist[1]
mylist[c(1,3)]
sum(mylist[1]) # Error! you need [[]] here...

# Play with [[]] operator to extract components
mylist[[1]]
mylist[["mystat"]]
mylist$mystat
mylist$myr
mylist[["mystat"]][1]




#============================================================================================#
# 3. Grouped expressions 
#============================================================================================#





#============================================================================================#
# 4. control statements: conditional execution 
#============================================================================================#

# Conditional execution: if/else construct
# Use an if-else programming block to check whether or not your dataframe contain missing values
# trigger a warning in the first or simply print a message otherwise

if(any(is.na(fulldt))) {
  warning("Watch out missing values!")
} else {
  print("No missing values here")
}


# Use an if-else statment to create a variable taking value the number of observation in the data if data is of 
# class dataframe and missing value (NA) otherwise

y <- if(class(fulldt)=="data.frame") {
  nrow(fulldt)
} else {
  NA
}
y

# change the condition from data.frame to factor and contorl you get a NA in this case
y <- if(class(fulldt)=="factor") {
  nrow(fulldt)
} else {
  NA
}
y


# Use the vectorized version of if/else construct, ifelse() function
mclaimfg <- ifelse(fulldt$mclaim>0, 1, 0)
mean(mclaimfg)




#============================================================================================#
# 5. control statements: repetetive execution 
#============================================================================================#

# Repetitive execution: for loops
# Use a for statment to loop over the integer sequence 1:10 and print iteratively the loop variable

for(i in 1:10) {
  print(i)
}


# Not very useful, right? Let's output something a bit more useful
# Use for statement to loop over the columns of PtfPolicy and print the class of each of it

for(i in 1:ncol(fulldt)) {
  print(class(fulldt[,i]))
}

# Now store the results of previous loop in a vector

myclasses <- NULL
for(i in 1:ncol(fulldt)) {
  myclasses <- c(myclasses, class(fulldt[,i]))
}
myclasses

# or like this
myclasses <- NULL
for(i in 1:ncol(fulldt)) {
  myclasses[i] <- class(fulldt[,i])
}
myclasses

# Use a for statement to loop over all the possible values of Poldur (policy age)
# use them to subset the PtfSum data and calculate the total exposure for each of them

out <- NULL
for(i in unique(fulldt$Poldur)) {
  dtsubset <- fulldt[fulldt$Poldur==i,]
  out <- c(out, sum(dtsubset$Exposure))
}
out

mpoldur <- cbind(unique(dt$Poldur), out)
ord <- order(mpoldur[,1])
mpoldur <- mpoldur[ord,]
mpoldur
mpoldur[,2] <- round(mpoldur[,2], digits = 0)
mpoldur


# Alternative (better) ways to loop

# alternative sapply
sapply(fulldt, class)
tapply(X = fulldt$Exposure, INDEX = fulldt$Poldur, FUN = sum)
?sapply
# with dplyr
library(dplyr)
summarise(group_by(dt, Poldur), TotExposure = sum(exposure))

# with dplyr and pipeline operator
dt %>% 
  group_by(Poldur) %>%
  summarise(TotExposure = sum(exposure))

# with data.table package
library(data.table)
dtab <- as.data.table(dt)
out <- dtab[,.(TotExposure = sum(exposure)), by = Poldur]
setkey(out, Poldur)
out




#============================================================================================#
# 6. Functions
#============================================================================================#

# check the R code behind built-in functions like mean, sd, etc.
sd
mean
library(e1071)
skewness

# Write simple function called TotExpMyPtf taking no arguments and returning total exposure of policyPtf

TotExpMyPtf <- function() {
   out <- sum(fulldt$Exposure)
   return(out)
}

# call the function to see if it works
TotExpMyPtf()


# store the values returned by the function in an object named "y" and then calculate the logarhitm of it (use function log())
y <- TotExpMyPtf()
log(y)


# Generalize the function adding an argument which will be the field summed up, call it SomeTotMyPtf
SomeTotMyPtf <- function(field) sum(fulldt[,field])
SomeTotMyPtf(field = "Exposure")


# Generalize further the function
  # arguments: dataset, exposure, number of material claims, cost of material claims
  # output: vector containing material claim freqeuncy and severity

FreqAnyPtf <- function(data, expos, nmat, costmat) {
  freq <- sum(data[,nmat]) / sum(data[,expos])
  sev <- sum(data[,costmat]) / sum(data[,nmat])
  c(freq, sev)
}

FreqAnyPtf(fulldt, "Exposure", "mclaim", "mcost")


# Write a new function "FreqAnyPtfCtrl" identical to previous one but with a control structure checking that
# data is of data.frame class (use function is.data.frame)
# expos, costmat and nmat are numeric (use function is.numeric() and remember that integers are also numeric)
# test the control structure is working by providing a non-numeric variable for expos

FreqAnyPtfCtrl <- function(data, expos, nmat, costmat) {
  if(!is.data.frame(data)) stop("data must be a dataframe")
  if(!is.numeric(data[,expos])) stop("exposure must be numeric")
  if(!is.numeric(data[,nmat])) stop("nmat must be numeric")
  if(!is.numeric(data[,costmat])) stop("costmat must be numeric")
  freq <- sum(data[,nmat]) / sum(data[,expos])
  sev <- sum(data[,costmat]) / sum(data[,nmat])
  c(freq, sev)
}
FreqAnyPtfCtrl(fulldt, "Exposure", "mclaim", "mcost")
FreqAnyPtfCtrl(fulldt, "Exposure", "mclaim", "Gender") # triggering error


# Write a function "GroupedFreqAnyPtf" similar to last one but with an additinoal argument indicating a categorical variable 
# to groupy the results by (univariate analysis)
# when a value is provided check it is a factor 
# and return a matrix with the two KPIs by row and grouping variable levels by column 
# consider make the result prettier and easier to read renaming the dimension of the matrix
# when no value is provided for group argument then the same result of previous function (only totals) should be returned

GroupedFreqAnyPtf <- function(data, expos, nmat, costmat, group=NULL) {
  if(!is.data.frame(data)) stop("data must be a dataframe")
  if(!is.numeric(data[,expos])) stop("exposure must be numeric")
  if(!is.numeric(data[,nmat])) stop("nmat must be numeric")
  if(!is.numeric(data[,costmat])) stop("costmat must be numeric")
  
  if(is.null(group)) {
    freq <- sum(data[,nmat]) / sum(data[,expos])
    sev <- sum(data[,costmat]) / sum(data[,nmat])
    c(freq, sev)
  } else {
    if(!is.factor(data[,group])) stop("group must be a factor")
    freq <- tapply(X = data[,nmat], INDEX = data[,group], FUN = sum) / tapply(X = data[,expos], INDEX = data[,group], FUN = sum)
    sev <- tapply(X = data[,costmat], INDEX = data[,group], FUN = sum) / tapply(X = data[,nmat], INDEX = data[,group], FUN = sum)
    out <- rbind(freq, sev)
    dimnames(out)[[1]] <- c("Material frequency", "Material severity")
    dimnames(out)[[2]] <- levels(data[,group])
    out
  }
}

GroupedFreqAnyPtf(fulldt, "Exposure", "mclaim", "mcost")
GroupedFreqAnyPtf(fulldt, "Exposure", "mclaim", "mcost", "Gender")


# Write a simple function returning a list with the division, multiplication, addition and difference between any two numbers

mystat <- function(a, b) {
  list(div = a/b, mult = a*b, add = a+b, diff = a-b)
}

mystatvalue <- mystat(1,2)
str(mystatvalue)
mystatvalue$div







#============================================================================================#
# 7. Probability distributions & Simulation
#============================================================================================#


# Simulate 1000 random numbers from normal distribution with mean=2 and sd=1 and store them in an object called "x"
# simulate 1000 random numbers from gamma distribution with scale=750 and shape=0.8 and store it in an object called "z"

nn <- rnorm(n = 1000, mean = 2, sd = 1)
gg <- rgamma(n = 1000, scale = 750, shape = 0.8)

# Plot the histogram of x and z
# adjust the number of bins with nclass argument
# replace the absolute frequency count with the relative one
hist(nn)
hist(gg)
hist(nn, nclass = 30)
hist(gg, nclass = 50)
hist(nn, nclass = 30, probability = TRUE)
hist(gg, nclass = 50, probability = TRUE)

# Superimpose the theoretical density on the histogram of relative frequency counts
hist(nn, nclass = 30, probability = TRUE)
curve(dnorm(x, mean = 2, sd = 1), col = "red", add = TRUE)
hist(gg, nclass = 30, probability = TRUE)
curve(dgamma(x, scale = 750, shape = 0.8), col = "red", add = TRUE)

# Calculate the 95th quantile of nn and compare it with the theoretical one
quantile(x = nn, probs = 0.95)
qnorm(p = 0.95, mean = 2, sd = 1)

# Calculate the probability (relative frequency) of having values above 2000 for gg
# and compare it with the theoretical one
length(gg[gg>2000])/length(gg)
1 - pgamma(q = 2000, scale = 750, shape = 0.8)


# Use sample() function to sample randomly 4 elements from the sequence 1:10 without replacement
ss <- 1:10
sample(x = ss, size = 4)

# Sample with the following probabilities instead c(1/2, rep(1/18,9)) instead
sample(x = ss, size = 4, prob = c(1/2, rep(1/8, 9)))

# Use sample() to divide PolicyPtf dataset into a training (80%) and a test (20%) sample
idx_train <- sample(1:nrow(fulldt), size = 0.8*nrow(fulldt))
train <- fulldt[idx_train,]
test <- fulldt[-idx_train,]