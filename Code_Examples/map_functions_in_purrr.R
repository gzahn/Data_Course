# using the purrr package and "map" functions
# map functions allow you to perform a similar action on a series of objects, elements, etc.
# can be like a replacement for 'for-loops'

library(tidyverse) # purrr comes packaged along with the tidyverse suite


# map() ####
# map is great at working with lists, and can perform some function on all elements of a list

# list refresher: ####
# lists can contain anything. You can mix characters, numerics, logicals, even data.frames!
mylist <- list(Obj1=1:10, # element 1 (named "Obj1") is a vector of the numbers 1-10
     Obj2=c("a","b","c"), # element 2 is a character vector of just a, b, and c
     Obj3=data.frame(Var1=rep(c("a","b"),each=5), # element 3 is a data frame with 3 columns defined here
                     Var2=rnorm(10),
                     Var3=letters[1:10]))
mylist

mylist[[1]] # extract elements from lists using double-brackets
mylist[1] # extract element, but returned as list
# make sure you can see the difference in those two!

length(mylist[[1]])
length(mylist[1]) # WTF!?



mylist[[1]][1] # get first element inside of the first element of a list
mylist[1][1] # why DOESN'T this give you the same thing?
mylist[1][[1]][1] # and why DOES this give the same thing?

mylist[["Obj3"]] # can use names of elements, if they have names
mylist[["Obj3"]][,"Var2"] # access "Var2" from inside "Obj3" in the list "mylist"

map(iris,is.factor) # map, by itself wants to return a list
map_lgl(iris,is.factor) # map_lgl forces "map" to return a "logical" type vector
map_dbl(iris,is.factor) # map_lgl forces "map" to return a "double" type vector (numeric)

# other variants are available such as map_if() which only applies the function to an element if it passes a test
l <- list(Var1=1:10,Var2=letters,Var3=1:100)
l
l %>% map(mean) # get NA for element 2, since it's a character vector and "mean" is meaningless
l %>% map_if(is.numeric,mean) # map_if() allows us to only apply mean() to elements that make sense


sentences # built-in character vector

# split it into a list, each element containing the sentence, but subdivided by word within that element
list_sentences <- str_split(sentences," ")
list_sentences


firstwords <- map_chr(list_sentences,1) # this shorthand function pulls the first item from each list element ("_chr" means it returns a character vector instead of another list)
firstwords

firstwords <- as.data.frame(table(firstwords)) # make a table of first-word counts
firstwords

firstwords %>% filter(Freq > 2) %>% # remove low-count words
  arrange(desc(Freq)) %>% # rearrange, mist-used at top
  mutate(firstwords = factor(firstwords,levels = firstwords)) %>% # re-code the factor levels to match this new order
    ggplot(aes(x=firstwords,y=Freq)) + geom_col() # simple bar chart of counts


# last-words is going to be tougher!
map_dbl(list_sentences,length) # the lengths of each sentence can vary, so we can't use the shorthand from line 28
summary(map_dbl(list_sentences,length))
map(list_sentences,9) # only some sentences have, say, 9 words...


# So, we can use "anonymous functions" inside of a map operation
# Anonymous functions are functions that is created and used, but never assigned to a variable.

# here's an example:
function(x){x+1}
nums <- 1:10
map_dbl(nums,function(x){x+1})

# look, I get that that's the exact same as doing:
nums + 1

# but it's more flexible.... for example we can use tail(x,1) to get the last element of any vector
tail(1:10,2) # last 2 elements of that vector
list(num=1:26,chr=letters) # a list, two elements, each element is it's own vector
tail(list(num=1:26,chr=letters),1) # last element of that list (which happens to be a character vector of length=26)


# performs the function on each element IN the list instead of "on" the list as a whole!
# But with map() functions, we can apply tail(x,1) to each internal element of a list
map_chr(list_sentences,function(x){tail(x,1)})  # anonymous function to pull last word, no matter length of sentence


lastwords <- map_chr(list_sentences,function(x){tail(x,1)}) %>%  
  str_remove("\\.") # have to use regex to escape-out the '.'

lastwords <- as.data.frame(table(lastwords))
lastwords %>% filter(Freq > 2) %>%
  arrange(desc(Freq)) %>%
  mutate(lastwords = factor(lastwords,levels = lastwords)) %>%
  ggplot(aes(x=lastwords,y=Freq)) + geom_col()



# try to figure out what the following line of code is doing...
map(list_sentences,function(x){str_trunc(string=x,width=3,ellipsis = "")})


  


# modify() ####

# modify_if() is another very handy tool from the purrr package:
str(iris)

# if a condition is matched, it will perform the designated function there, if not, it will ignore
iris %>%
  modify_if(is.factor, as.character) %>%
  str()

# Modify at specified depth (for more complex, nested lists...i.e., lists of lists)
l1 <- list(
  obj1 = list(
    prop1 = list(param1 = 1:2, param2 = 3:4),
    prop2 = list(param1 = 5:6, param2 = 7:8)
  ),
  obj2 = list(
    prop1 = list(param1 = 9:10, param2 = 11:12),
    prop2 = list(param1 = 12:14, param2 = 15:17)
  )
)
l1
length(l1)

# In the above list, "obj" is level 1, "prop" is level 2 and "param"
# is level 3. To apply sum() on all params, we map it at depth 3:
l1 %>% modify_depth(3, sum) %>% str()

# modify() lets us pluck the elements prop1/param2 in obj1 and obj2:
l1 %>% modify(c("prop1", "param2"))

list(l1[["obj1"]][[1]][2], l1[["obj2"]][[1]][2]) # the long, ugly way of doing the same thing (that dumps obj names, incidentally)




# reduce() ####
# reduce() is an operation that combines the elements of a vector into a single value by applying a function that takes two inputs.
?reduce
1:3 %>% reduce(sum)
1:10 %>% reduce(sum) # same as: 1+2+3+4+5+6+7+8+9+10



# make a few dataframe objects with similar columns
x <- data.frame(Var1=1:26,Var2=letters,Obj="a",Var3=rnorm(26,3))
y <- data.frame(Var1=27:52,Var2=letters,Obj="b",Var3=rnorm(26,5))
z <- data.frame(Var1=27:52,Var2=LETTERS,Obj="c",Var3=rnorm(26,7))


get("x") # "get()" can access objects by their names, programmatically
x # same output... but accessed differently

df_list <- c("x","y","z") # if we know the names of the objects, we can work on them all at once
df_list

str(map(df_list,get)) # we can apply the "get()" function on all at once, returning a list where each main element contains a dataframe
all_dfs <- map(df_list,get)
all_dfs # take a look at our new list


# reduce lets us pick a function to "condense" all the items in a list into one object!
joined_dfs <- reduce(all_dfs,full_join) # here, we use full_join() to join them all at once into a single dataframe
joined_dfs
# If you had dozens or hundreds of files, it would take ages to load them all and join them together without map() and reduce()


# reduce lets us use any function we can to reduce list objects:
str(all_dfs)
all_dfs %>% modify("Var3") %>% # pull out the numeric column of interest
  map(mean) %>% # apply mean() to each list element
  reduce(min) # find the minimum mean value of Var3 in each of those dataframes


l2 <- list(A=1:10,B=21:30,C=41:50)
l2means <- map(l2,mean)
  reduce(l2means,mean)

all_dfs %>% modify("Var3")

