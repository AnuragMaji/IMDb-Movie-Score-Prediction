movie<- read.csv("movie_metadata.csv", header = TRUE)
str(movie)

library(ggplot2)
ggplot(movie, aes(x = gross, y = imdb_score))+ 
  geom_point(alpha = 1/10) + geom_smooth()
#Scatter plot with gross profit on the x axis and IMDB score on the y axis. 
#As shown, there is a very slight positive correlation between gross profit and score. 
#Many films do not have much gross profit despite being rated well! We shall
#see this effect later during analysis as well.

ggplot(movie, aes(x =factor(title_year), y = imdb_score)) + 
  geom_boxplot() + scale_x_discrete(breaks = pretty(movie$title_year,n=10))
#Box plots with IMDB ratings by year. There are alot more higher 
#rated films towards the beginning of the 20th century. 
#An explanation for this is because many older films which were 
#not so good were probably not rated

#We create a sub dataset called 'temporary' 
#where we store data from rows which do not have 
#any missing values and only numerical columns

columns <- c()
for(i in 1:dim(movie)[2])
{
  if(is.numeric(movie[,i])|| is.integer(movie[,i]))
  {
    columns[i]=T
  }
  else
  {
    columns[i]=F
  }
}

temporary <- na.omit(movie[,columns])

#then we divide 'temp' into two parts - train and test data set

set.seed(2)
train <- sample(dim(temporary)[1],dim(temporary)[1]*0.95)
temp_train <- temporary[train,]
temp_test <- temporary[-train,]

#Test for correlation of IMDb score with other numerical parameters
correlation <- c()
for(i in 1:dim(temporary)[2])
{
  correlation[i] <- cor(temporary[,i],temporary[,'imdb_score'])
}

correlation

#Fit a linear regression model
lmfit = lm(imdb_score~num_voted_users+duration+num_critic_for_reviews,data=temp_train)
summary(lmfit)

#The R square value in this case is 0.28, which is very low. It suggests 
#that only 28 % of the variability in data is exlained by the factors,
#namely duration , number of user votes and num_critic_for reviews.
# In the presence of more useful information,
#this value of R square can be improved.
#Addition of another factor, the num_critic_for_reviews which seems to have a 
#relatively higher correlation seems that it could be benificial, 
#but it does not add much value since the adjusted 
#R square value only increases by very little.

#Another factor to note is that being a commercially successfull movie 
#does not mean a higher IMDb rating since the correlation between 
#the two factors is just 0.21

#Since the overall R squared value seems to be very poor, we can conclude that 
#linear reression with the factors provided does not provide us a valid result
pred <- predict(lmfit,temp_test)
mean((temp_test$imdb_score-pred)^2)
#Forming the prdictor variable and the MSE for prediction, which comes out to be
#  0.7014

#Now we use recurisive partitioning and regression trees
library(rpart)

set.seed(3)
m.rpart <- rpart(imdb_score~.,data=temp_train)
m.rpart


p.rpart <- predict(m.rpart,temp_test)
cor(p.rpart,temp_test$imdb_score)

#The correlation seems to be good. 
#Now we compare the MSE's for trees and for linear regression

mean((p.rpart-temp_test$imdb_score)^2)
mean((temp_test$imdb_score-pred)^2)

#We can see that the tree reduces the MSE 
#by some amount when compared to the Linear Model

