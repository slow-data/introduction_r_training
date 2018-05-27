# R Fundamentals Training
# @AXA EMEA Region, Madrid (13, October 2016)
# Lecturer: Jacopo Primavera
# Audience: Actuarial, Risk Management, IT, Underwriting


# Week 1 - Agenda
#============================================================================================#
        # 1. R & your system 
        # 2. R atomic objects 
        # 3. Basic operators 
        # 4. Vectors
        # 5. Useful functions by class of object
        # 6. Vectorization + recycling
        # 7. Subsetting vectors (the [] operator)
        # 8. Coercion 
        # 9. Missing values and reserved words
        # 10. Matrices
        # 11. Factors
        # 12. Data frames  


# Notes
#============================================================================================#
        # Everything to the right of the pound symbol is ignored by R (i.e. it's a comment)
        # R is case sensitive!
        # Press CTRL+Enter to run programs on RStudio
        # To pull up documentation for a function run help(namefunction) or ?namefunction
        # Rremember that in R you cannot use back slash (\) to indicate paths
      




##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################







#============================================================================================#
# 1. R system view, workspace, console and basic operations 
#============================================================================================#



## R system view
# --------------------------------------------------------------------   


# Once R is installed it is able to communicate with your computer, so to "view" your system

# for example you can create a folder somewhere in your computer directly from R with function dir.create()

# Give it a try by creating a folder called "RFundamentalsWeek1" (place it in your local C:/ rather than in the shared servers, to speed up operations)

dir.create("C:/Users/AX30164/Desktop/RFundamentalsWeek1")	    # I chose to place it on desktop

# Now set this folder as your working directory with function setwd(). Working directory is the place which by default R communicate with (save and load file, etc.) 

setwd("C:/Users/AX30164/Desktop/RFundamentalsWeek1") 

# Check if this was correctly set with function getwd()
getwd()

# Check what is inside your working directory (should be empty now...)
dir()

# now copy paste the file "PolicyPtfSum.csv" (you should have received it by email in the past days) into this folder and check again 
dir()

# In RStudio you can manage the communication with your system (set working directory, load files, etc.) by using the Menu here above (Session > Set Working Directory > ...)

     


## Workspace and object creation/remove
# --------------------------------------------------------------------   


# The workspace is the collection of all objects you create during an R session

# list all objects in your workspace
ls()

# create an object in the workspace called "x" having value 1
# The assignment operator ( '<-' ) assigns a value (1) to a symbol (x). This procedure is commonly referred as to create an object
x <- 1

# now we should see x in the workspace
ls()

# create other objects
y <- 99
msg <- "Hello"

# replacement. In R objects values are easily replaced by assigning them new values
y <- 100

# remove x from the workspace
rm(list="x")

# remove all objects from workspace
rm(list=ls())



## Printing
# --------------------------------------------------------------------   

# explicit printing (print function)
x <- 1
print(x)        
msg <- "Hello"
print(msg)

# auto-print
x
msg





#============================================================================================#
# 2. R atomic objects --> single values with simplest, most basic format 
#============================================================================================#


"Hola"    # character, any string within quotes
3.14       # numeric, any real number
4L      # integer, any integer number
TRUE    # logical, TRUE or FALSE reserved words

# with function class() you can check the class of the object
class("Hola")
class(3.14)
class(TRUE)
class(4L)
class(1+0i)

# integer vs numeric. Any number in R is numeric by default. Suffix "L" explicitly tell R we want an integer
class(4)
class(4L)





#============================================================================================#
# 3. Basic operators 
#============================================================================================#


# arithmetic operators
# --------------------------------------------------------------------   

3 + 4
3 - 4
3 * 4
3 / 4
abs(3 - 4)
3^4   # or 3**4
sqrt(4)


# logical operators
# --------------------------------------------------------------------   

3 == 4
"a" == "a"
3 > 4
3 <= 4
3 != 4
"hello" != "Hello"
4 >= 3 & 3==3
4 < 3 | 3==3





#============================================================================================#
# 4. Vectors --> atomic objects extended
#============================================================================================#


# Vectors collects a set of atomic objects of same class (so we will talk about integer vectors, logical vectors, etc.)

# c() function
# --------------------------------------------------------------------   

c("Hola", "Ciao", "Hello", "Bonjour")
c(0.99, 2.4, 1.4, 5.9)
c(1L, 2L, 3L, 4L)
c(TRUE, TRUE, FALSE, TRUE)

# check the class
class(c("Hola", "Ciao", "Hello", "Bonjour"))
class(c(0.99, 2.4, 1.4, 5.9))
class(c(1L, 2L, 3L, 4L))
class(c(TRUE, TRUE, FALSE, TRUE))


# other ways to create vectors: sequence function and colon operator
# --------------------------------------------------------------------   

# all these sentences create the same result

seq(from = 1, to = 4, by = 1)
seq(from=1, to=4)     # by=1 is default
seq(1, 4)      # arguments in R can be matched by position
1:4       # common operations in R have shortcuts


# rep function

rep(x = 1, times = 4)
rep(1, 4)
rep(c(1,2), times = 2)
rep(c(1,2), each = 2)


# combine vectors (in R you can easily nest functions)

c(x, 1, 9, 0.99, 88, c(2, 3, 1))


# arithmetic and logical operators seen before work on vectors and matrices as well as scalars (we say that these operators are vectorized)
# --------------------------------------------------------------------   

c(1, 2, 3, 4) + c(5, 6, 7, 8)
c(1, 2, 3, 4) - c(5, 6, 7, 8)
c(1, 2, 3, 4) * c(5, 6, 7, 8)
c(1, 2, 3, 4) / c(5, 6, 7, 8)
c(1, 2, 3, 4) ** c(5, 6, 7, 8)
sqrt(c(1, 2, 3, 4))

c(1, 2, 3, 4) == c(5, 6, 7, 8)  
c(1, 2, 3, 4) != c(5, 6, 7, 8)  
c(1, 2, 3, 4) > c(5, 6, 7, 8) 

# most functions in R are vectorized




#============================================================================================#
# 5. Useful functions by class of object 
#============================================================================================#



# numerical objects
# --------------------------------------------------------------------   

mynum <- c(3.14, 6, 8.99, 10.21, 10)
length(mynum)
sum(mynum)
mean(mynum)
sd(mynum)   # standard deviation
median(mynum)

# logical objects
# --------------------------------------------------------------------   

mylogic <- c(F, T, F, rep(T, 3))
length(mylogic)
sum(mylogic)  # the underlying structure of logical values in R is TRUE=1 and FALSE=0
which(mylogic)  # give the TRUE indices of a logical oobject
mylogic
any(mylogic)  # is at least one of the values TRUE?
all(mylogic)  # are all of the values TRUE?

# character objects
# --------------------------------------------------------------------   

mychar <- c("201510", "201511", "201512", "201601", "201602", "201603")
substr(x = mychar, start = 1, stop = 4)
nchar("Hello")    # number of characters in a string
paste("Welcome", "to R training", sep = "/")    # concatenate character vectors 
paste("This is week", 1, sep=": ")   # a useful feature of paste is that it converts automatically all arguments to character
gsub(pattern = "20", replacement = "", x = mychar)  # find and replace 






#============================================================================================#
# 6. Vectorization + recycling
#============================================================================================#

# same length vectors (simple element-by-element)
# --------------------------------------------------------------------   

c(1, 2, 3, 4) + c(5, 6, 7, 8)


# different length vectors and lengths multiples one another (element-by-element with recycling)
# --------------------------------------------------------------------   

c(1, 2) + c(5, 6, 7, 8)
c(1, 2, 1, 2) + c(5, 6, 7, 8)


# different length vectors and lengths not multiples one another (element-by-element with recycling and warning)
# --------------------------------------------------------------------   

c(1, 2, 3) + c(5, 6, 7, 8)
r <- c(1, 2, 3, 1) + c(5, 6, 7, 8)
r




#============================================================================================#
# 7. Subsetting vectors (the [] operator)
#============================================================================================#


# [logical index] 
# --------------------------------------------------------------------   

x <- 1:10
x >= 5
idx <- x >= 5
x[idx]  
x[x < 7]


# [positive integers index]
# --------------------------------------------------------------------   

x[1]    # 1st element
x[c(1,5)]   # 1st and 5th element


# [negative integers vector] 
# --------------------------------------------------------------------   

x[-1]   # all but the 1st
x[-c(1,10)]   # all but the 1st and the 10th





#============================================================================================#
# 8. Coercion, force an object to belong to a class 
#============================================================================================#


## implicit coercion 
# --------------------------------------------------------------------   

c(1.7, "a")   
class(c(1.7, "a"))  # numeric vs CHARACTER 

c(TRUE, 2) 
c(FALSE, 2) 
class(c(TRUE, 2))   # logical vs NUMERICAL

c("a", TRUE)
class(c("a", TRUE))   # CHARACTER vs logical

# to decide the prevailing class R uses a principle of least common denominator
# for example logcial values TRUE and FALSE have a logical character representation, but the viceversa is not true


## explicit coercion (the as.* functions)
# --------------------------------------------------------------------   

x <- c(0, 1, 2, 3, 4, 5, 6)
class(x)

as.character(x)
as.logical(x)   # when asked to coerce numerical to logical R converts 0s into FALSEs and all values above or equals to 1 into TRUEs


as.numeric(c("a", "b", "c"))  # non-sensical coercion result in NAs
as.logical(c("a", "b", "c"))  # non-sensical coercion result in NAs

  




#============================================================================================#
# 9. Missing values and reserved words
#============================================================================================#


# NA is a reserved word in R indicating a missing value
# reserved words have special meaning and cannot be used as identifier (variable name, function name, etc.)
# --------------------------------------------------------------------   

NA <- 1   # error !

x <- c(7, 2, NA, 8, 3)
class(x)
is.na(x)

# operations with NAs usually return NAs
# --------------------------------------------------------------------   

4 + NA
4 - NA
4/NA
4 * NA
sqrt(NA)

# ...with some exceptions
1^NA
NA^0


help(reserved)    # a list of R's reserved words


# NULL, represents the null object  
# --------------------------------------------------------------------   

x <- NULL   # useful to initialize objects that will be filled later, among others usages

# Inf, -Inf, NaN
1/0
-1/0
0/0



# NaN is also a NA, viceversa is not true
# --------------------------------------------------------------------   

sum(is.na(c(1, 2, NA, NaN)))
sum(is.nan(c(1, 2, NA, NaN)))






#============================================================================================#
# 10. Matrices --> vectors with a dimension attribute  
#============================================================================================#


# matrix can be seen as a vector with dimension attribute
# --------------------------------------------------------------------   

x <- 1:6
dim(x)    # the dimension of an object
dim(x) <- c(2, 3)   # i am imposing a 2x3 dimesion (standing for 2 rows and 3 columns) to this vector
x
class(x)


# create a matrix with function matrix()
# --------------------------------------------------------------------   

m <- matrix(data = 1:6, nrow = 2, ncol = 3)
m
class(m)
dim(m)



# Create a matrix by binding columns or rows
# --------------------------------------------------------------------   

x <- 1:3
y <- 10:12
cbind(x,y)
rbind(x,y)


# Subsetting matrices using (i,j)-style index
# --------------------------------------------------------------------   

m[1,2]  # one single element
m[1,]   # one full row
m[,3]   # one full column
m[,-1]  # all columns but one







#============================================================================================#
# 11. Factors, positive integer vectors with labels 
#============================================================================================#


# factors can be seen as integer vectors with a label dimension
# --------------------------------------------------------------------   

f <- factor( c("female", "male", "male", "male", "female", "male", "female") )
f
levels(f)   # check the levels of the factor
as.integer(f)   # see the underlying integer representation of factors (first level is assigned to integer 1, second level to integer 2, and so on)


# if you run a GLM with a factor variable as predictor then the first level will be taken as base level

levels(f) <- c("male", "female")    # change default position (alphabetical)


# ordered factors, an extension of factors
----------------------------------------------------------
# by default factors are not ordered, but you can ask for an explicit order (when there is a natural one)

f2 <- factor( c("low", "medium", "low", "high", "low", "medium") )
f2_ord <- factor( c("low", "medium", "low", "high", "low", "medium"), ordered = TRUE)
f2
f2_ord
levels(f2_ord) <- c("low", "medium", "high")   # change default order (alphabetically)

# ordering factors that have a natural order is a practical advantage because many R functions recognize and treat ordered factors differently 


# exploring factors
# --------------------------------------------------------------------   
table(f)        # frequency counts of each combination of factor levels 
table(f2)
table(f2_ord)






#============================================================================================#
# 12. Data frames --> list of vectors of same length but not necessarily same class  
#============================================================================================#


# data frame is the R default representation for tabular data (excel data for example)
# It is a key object for pricing actuaries since pricing database are also read as data frames in R


# data frames can be created with the function data.frame() but let's read some real data


# -------------------------------------------------- Let's play with some real insurance data

# if you haven't done so yet, copy the dataset PolicyPtfSum.csv into your working directory

dt <- read.csv("C:/Users/AX30164/Desktop/RFundamentalsWeek1/PolicyPtfSum.csv")
dir()
dt <- read.csv("PolicyPtfSum.csv")


# since we copied the file in our working directory there's no need to specify the full path and read.csv("PolicyPtfSum.csv") would have worked same way

str(dt)   # returns a compact summary of R objects
summary(dt)   # given its class each column is summarized in few statistics
names(dt)


# "PolicyPtfSum" is an anonymized summarized policy portfolio for year 2010. 
# Dataset contains  policies for third party bodily and material claims. 

# Gender --> gender of the driver of the car
# Category_Car --> category of the car
# Occupation --> occupation of the driver
# Occupation_na --> occupation of the driver with missing values included
# Age --> age of the driver
# Poldur --> Age of the insurance contract
# exposure --> Sum of Exposure
# mclaim --> Sum of number of third party material claims
# bclaim --> Sum of number of third party bodily injury claims
# mcost --> Sum of Total cost of third party material claims
# bcost --> Sum of Total cost of third party bodily injury claims

# By default R reads strings as factors. 
# numbers with decimal places are read as numerical
# numbers without decimal places are read as integers
# variables containing exclusively the strings TRUE or FALSE are read as logical


# Subset data.frames
# --------------------------------------------------------------------   

# the [i,j] notation used for matrix is valid for data.frames too
dt[1,1]
dt[1,]
dt[,1]

# data frames can be very large so there is a handy function to visualize only a certain number of observation on top or bottom
head(dt, n = 20)
head(dt)
tail(dt, n = 5)

# Dollar operator (get advantage of auto-completion of RStudio, after typing the dollar press tab)

dt$Occupation
class(dt$Age)
class(dt$mcost)



# Operations with data.frames
# --------------------------------------------------------------------   

sum(dt$exposure)    # overall exposure
sum(dt$mclaim) / sum(dt$exposure)     # overall material claim frequency 
sum(dt$mcost) / sum(dt$mclaim)    # overall material claim average cost


# Only for males

sum(  dt[ dt$Gender=="Male", "exposure" ]   )    # overall male exposure
sum( dt[dt$Gender=="Male", "mclaim"] ) / sum(  dt[dt$Gender=="Male", "exposure"]  )   # overall male material claim frequency


# When you start to filter and making more complex calculation with a dataframe the syntax becomes rapidly twisted

# with() and subset() functions can help make your syntax more readable
# --------------------------------------------------------------------   

with(dt, sum(mclaim)/sum(exposure))   # evaluate R expression in an environment constructed from data
subset(dt, Gender=="Male")

head(subset(dt, Gender=="Male"))    # returns subsets of vectors, matrices or dataframes which meet conditions

with( subset(dt, Gender=="Male"), sum(mclaim)/sum(exposure) ) # this looks more readable to me than previous one


# Subset data frames to remove missing values
# --------------------------------------------------------------------   

nas <- is.na(dt)
head(nas)
sum(nas)    # we know there are 1631 missing values but we don't know where
good <- complete.cases(dt)    # return a logical vector indicating which cases are complete (i.e. have no missing values)
length(good)
head(good)
dt_no_missing <- dt[good,]    # filter original dataframe to obtain only complete records


# use paste to create a new variable (for exampple to test an interaction)
# --------------------------------------------------------------------   

dt$Gender_X_CatCar <- with(dt, paste(Gender, Category_Car, sep="_"))
head(dt$Gender_X_CatCar)    # we notice levels are not printed
class(dt$Gender_X_CatCar)   # indeed the variable is character, not factor
dt$Gender_X_CatCar <- as.factor(dt$Gender_X_CatCar)   # coerce it to factor
head(dt$Gender_X_CatCar)
table(dt$Gender_X_CatCar)


# create a logical indicator for records with at least a material claim
# --------------------------------------------------------------------   

mclaimfg <- with(dt, ifelse(mclaim>0, TRUE, FALSE))

head( with(dt[mclaimfg,], mcost/mclaim) )
head( round(with(dt[mclaimfg,], mcost/mclaim), digits = 1 ) )



# V-Cramer indicator (association index from 0 to 1)
# --------------------------------------------------------------------   

# install.packages("vcd") if you haven't done so
# At the time of my research I could not find a built-in function in R calculating V-Cramer so I went to the Internet and found this (https://stat.ethz.ch/pipermail/r-help/2014-February/371349.html)
# more on how to build your own functions next week...

catcor <- function(x, type=c("cramer", "phi", "contingency")) { 
  require(vcd) 
  nc <- ncol(x) 
  v <- expand.grid(1:nc, 1:nc) 
  type <- match.arg(type) 
  res <- matrix(mapply(function(i1, i2) assocstats(table(x[,i1], 
                                                         x[,i2]))[[type]], v[,1], v[,2]), nc, nc) 
  rownames(res) <- colnames(res) <- colnames(x) 
  res 
} 


# for now let's just enjoy this function (on the shoulder of the giants...)

catcor(x = dt[,c("Gender", "Category_Car", "Occupation")], type = "cramer")


# ---------------------------------------------------------------- See you next class!