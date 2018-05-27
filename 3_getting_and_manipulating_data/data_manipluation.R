# R Fundamentals Training
# AXA @ Madrid 21, October 2016
# Jacopo Primavera
# Class 3rd
#============================================================================================#


# two important packages for data manipualation
library(data.table)
library(dplyr)

# Example data: Iris
data("iris")

# data.table is an efficient package to perform data manipulation
# it is often convenient to convert a data.frame into a data.table to leverage the advanced data manipulation features of the package  will allow us to leverage all advanced manipulation features of the package

dt <- data.table(iris)

# the good thing is that data.frame class is not lost in this way
class(dt)
# but you will only need to be careful when calling functions expecting one class or the other


# to explore join between dataframes we make up a dataset with some info (totally fake!) on each iris species
infoIris <- data.frame(s = levels(iris$Species), discovery = c(1950, 1960, 1961), color = c("red", "yellow", "brown"))

# Are there NAs? Do we want to remove it? Or do we want to coalesce to 0?

# Removing NAs
iris <- na.omit(iris)
iris <- iris[complete.cases(iris)]

# Coalescing NAs to 0s
replaceNAs = function(DT) {
  for (j in seq_len(ncol(DT)))
    set(DT,which(is.na(DT[[j]])),j,0)
}

replaceNAs(iris)

# data table 
# DATA TABLE: WHERE, WHICH, BY

# ["Rows that...","Columns","BY="]
# Filters: First Position


## Filtering rows

# data table way
iris_setosa <- dt[Species=="setosa"]
iris_big <- dt[Petal.Width>2]
iris_big <- dt[Petal.Width>2 | Petal.Length>3]
setosaBig <- dt[Species=="setosa" & Petal.Width>0.5]
dt$Species
iris_sub <- dt[Species %in% c("setosa", "virginica")]

# dplyr way
setosa <- dt %>% filter(Species == "setosa")


## subsetting some columns?

# Data.table way
str(iris)
keep=c("Sepal.Length","Petal.Length","Species")
iris_keep <- dt[,keep,with=F]

# dplyr way by name of variables
iris_keep_dplyr <- select(dt,Sepal.Length,Petal.Length,Species)

# or using the pipeline operator
iris_keep_dplyr <- dt %>% select(Sepal.Length,Petal.Length,Species)

# or by position of variables
iris_keep_dplyr <- dt %>% select(1,3,5)



## Group by - single variable

# data frame way
table(dt$Species)

# Data.table way
dt[,.(n_per_species=length(Petal.Length)),by=Species]

# dplyr way
dt %>% group_by(Species) %>% summarise(n_per_species= length(Petal.Width))


# Group by - several variables

# Data.table way
dt[, list(n_per=length(Petal.Width), avg_per = mean(Petal.Width)),
            by=.(Species, Petal.Length)]

# dplyr way
dt %>% group_by(Species, Petal.Length) %>% summarise(n_per= length(Petal.Width))



### Binding, merging and joining.

## Binding
# tables with the same structure

# Option 1 - Same columns, row binding:
# SQL UNION (same structure in both datasets)
dt_1 <- dt
dt_total <- rbind(dt, dt_1 )

# In case we want to add new columns forour data set, se use column binding
# Option 2 - Same rows, column binding

vector <- 1:nrow(dt)
dt_total <- cbind(dt, vector)

## Joining
## base functions

# Left outer join
# to explore left_outer_join we make up a dataset with some info (totally fake!) on each iris species
infoIris <- data.frame(s = levels(iris$Species), discovery = c(1950, 1960, 1961), color = c("red", "yellow", "brown"))
names(infoIris)[1] <- "Species" # with merge functions the key variable has to have the same name on both tables
left_join_base <- merge(dt, infoIris, by = "Species", all.x = T)
left_join_base

# Inner join
# to explore inner_join we make up a dataset
flowers <- data.frame(Species = c("setosa", "virginica", "tulipan", "margherita"), n = 1:4)
inner_join <- merge(dt, flowers, by = "Species")
head(inner_join)

# Right outer join
right_join_base <- merge(dt, flowers, by = "Species", all.y = T)
right_join_base



## data table way

# Left outer join
# We need to assign a key to join as sql way before properly doing it
setkey(dt, "Species")
infoIris_dt <- data.table(infoIris)
setkey(infoIris_dt, "Species") # no need to make the names coincide here because we are setting a key
left_outer_join <- dt[infoIris_dt]

# Inner join
# We need to assign a key to join as sql way before properly doing it
flowers_dt <- data.table(flowers)
setkey(flowers_dt, "Species") # no need to make the names coincide here because we are setting a key
inner_join <- dt[flowers_dt, nomatch = 0]

# Right outer join
right_outer_join <- flowers_dt[dt]
right_outer_join



### dplyr way

# left join
left_join_dyplr <- left_join(dt, infoIris, by = "Species")

# inner join
inner_join_dplyr <- inner_join(dt, flowers, by = "Species")

# right join
right_join_dyplr <- right_join(dt, flowers, by = "Species")

# Bonus track - dplyr anti join
# Let's suppose there is one full dataset and another one subset of the first.
# A nice way to get only the data of p that it is not on q is the following:

t <- anti_join(dt, flowers, by = "Species")
t

