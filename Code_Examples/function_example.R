
fully_anti_join = function(x,y,name){
  anti = anti_join(x,y, by= name)
  anti2 = anti_join(y,x, by= name)
  full_join(anti,anti2)
}
