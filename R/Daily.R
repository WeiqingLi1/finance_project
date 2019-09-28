# Previous Day position's next day Value

#portfolio 1

t$port1_daily[1] = NA

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  if (t$signal[i]== 1)
    t$port1_daily[i+1] = t$Close[i+1]
  else
    t$port1_daily[i+1] = -t$Close[i+1]
}

#portfolio 2

t$port2_daily[1] = NA

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  if (t$signal[i]== 1)
    aa <- GBSOption("c",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  else
    aa <- GBSOption("p",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))

  t$port2_daily[i+1] = aa@price  
}

#portfolio 3

t$port3_daily[1] = NA

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  aa1 <- GBSOption("c",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  aa2 <- GBSOption("p",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))

  t$port3_daily[i+1] = aa1@price+aa2@price  
}

#portfolio 4

t$port4_daily[1] = NA

count=0   #count days passed

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  
  if (as.numeric(difftime(t$Date[i+1],t$Date[i])) == 1)   #workday
    count = count+1
  else                                             # not workday
    count = count+as.numeric(difftime(t$Date[i+1],t$Date[i])) 
  
  if (count <= 89){
    Remaina = 90 - count}         # today buy remain
  if (count >= 90){       # expired already, adjuste to 90 days passed
    Remaina = 0                # yesterday buy today remain
    count = 0}                   # after expired, rebalance
  
  aa1 <- GBSOption("c",t$Close[i+1],t$Close[i],(Remaina/365),(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  aa2 <- GBSOption("p",t$Close[i+1],t$Close[i],(Remaina/365),(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))

  t$port4_daily[i+1] = aa1@price+aa2@price 
}

#Dump first day NA return

t <- t[-1,] 

setwd("F:/Dropbox/[IAQF]/R")
write_csv(t,"../data/Daily.csv")









### Cashflow

#portfolio 1

t$port1_daily[1] = NA

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  if (t$signal[i]== 1)
    aa = t$Close[i]
  else
    aa = -t$Close[i]
  
  if (t$signal[i+1]== 1)
    bb = -t$Close[i+1]
  else
    bb = t$Close[i+1] 
  
  t$port1_daily[i+1] = aa + bb
}


#portfolio 2

t$port2_daily[1] = NA

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  if (t$signal[i]== 1)
    aa <- GBSOption("c",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  else
    aa <- GBSOption("p",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))

  if (t$signal[i+1]== 1)
    bb <- GBSOption("c",t$Close[i+1],t$Close[i+1],0.246575342,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  else
    bb <- GBSOption("p",t$Close[i+1],t$Close[i+1],0.246575342,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100)) 
  
  t$port2_daily[i+1] = aa@price - bb@price  
}

#portfolio 3

t$port3_daily[1] = NA

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){
  aa1 <- GBSOption("c",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  aa2 <- GBSOption("p",t$Close[i+1],t$Close[i],0.243835616,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  bb1 <- GBSOption("c",t$Close[i+1],t$Close[i+1],0.246575342,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  bb2 <- GBSOption("p",t$Close[i+1],t$Close[i+1],0.246575342,(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  
  t$port3_daily[i+1] = aa1@price+aa2@price-bb1@price-bb2@price   
}

#portfolio 4

t$port4_daily[1] = NA

count=0   #count days passed

for (i in seq_along(t$Close[1:(length(t$Close)-1)])){

  if (as.numeric(difftime(t$Date[i+1],t$Date[i])) == 1)   #workday
    count = count+1
  else                                             # not workday
    count = count+as.numeric(difftime(t$Date[i+1],t$Date[i])) 
  
  if (count <= 89){
    Remainb = 90 - count         # today buy remain
    Remaina = Remainb}          # yesterday buy today remain
  if (count >= 90){       # expired already, adjuste to 90 days passed
    Remainb = 90               # today's remain
    Remaina = 0                # yesterday buy today remain
    count = 0}                   # after expired, rebalance
  
  aa1 <- GBSOption("c",t$Close[i+1],t$Close[i],(Remaina/365),(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  aa2 <- GBSOption("p",t$Close[i+1],t$Close[i],(Remaina/365),(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  bb1 <- GBSOption("c",t$Close[i+1],t$Close[i+1],(Remainb/365),(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))
  bb2 <- GBSOption("p",t$Close[i+1],t$Close[i+1],(Remainb/365),(t$Free_rate[i+1]/100),0,(t$VIX[i+1]/100))

  t$port4_daily[i+1] = aa1@price+aa2@price-bb1@price-bb2@price 
}

#Dump first day NA return

t <- t[-1,] 

setwd("F:/Dropbox/[IAQF]/R")
write_csv(t,"../data/Daily.csv")




cc1 <- GBSOption("c",1000,999,0.01,0.05,0,0.2)
cc1@price

cc2 <- GBSOption("c",1000,999,0.1,0.05,0,0.2)
cc2@price

aa1@price
aa2@price
bb1@price
bb2@price













