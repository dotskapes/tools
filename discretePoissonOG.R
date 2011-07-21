Logout
Maps



Sync Geoserver











mancio
br_precip
Development Tools
Tools








precip
test
sir compartment model
sir_22
discretePoissonOG
discreteNOG
sirODE
discreteOG
discretePoissonNOG
sirODE_user
aggregate
discretePoissonNOG_userparams
Results








Analyses








Main
News
Map
Info
Find
Analyze

Select Tool
Tool: discretePoissonOG
Description: undefined
Set Parameters



Save Analysis






Submit Tool



Results
R Result





Save




Overview
View Code
Fork


## Iterating function
f = function(x,bta,gma,dt){
  with(as.list(x),{
    infect  = rpois(1, bta*dt*S*I)
    recover = rpois(1, gma*I*dt)

    Sp = S - infect
    Ip = I + infect - recover
    Rp = R + recover
    time = time + dt
    return(c(time=time,S=Sp,I=Ip,R=Rp))
  })
}

## Initial Conditions
x = c(time=0,S=100,I=1,R=0)
## Data frame for holding all data
d = data.frame(t(x))

## Iterate while we still more or less have
## infectious individuals
while(x["I"] > 0.01 ){
  x = f(x,0.003,1/7,0.1)
  d = rbind(d,x)
}

## Plotting outcomes
par(lwd=2)
with(d, plot(time,S,col="green", pch=18,
             ylab="Abundance", xlab="Time",
             ylim=c(-50,150),type="b"))
abline(h=0,col="gray")
with(d,lines(time,I,col="red",
             type="b",pch=18))

with(d,lines(time,R,col="blue",
             type="b",pch=18))

