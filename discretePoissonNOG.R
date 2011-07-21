
## Iterating function
f = function(x,bta,tau){
  with(as.list(x),{
    infect  = rpois(1, bta*S*I*tau)
    Spt = S - infect
    Ipt = infect
    Rpt = R + I
    time = time + tau
    return(c(time=time,S=Spt,I=Ipt,R=Rpt))
  })
}

## Initial Conditions
x = c(time=0,S=100,I=1,R=0)
## Data frame for holding all data
d = data.frame(t(x))

## Iterate while we still more or less have
## infectious individuals
while(x["I"] > 0.01 ){
  x = f(x,0.007,3)
  d = rbind(d,x)
}

## Plotting outcomes
par(lwd=2)
with(d, plot(time,S,col="green", pch=18,
             ylab="Abundance", xlab="Time",
             ylim=c(0,100),type="b"))

with(d,lines(time,I,col="red",
             type="b",pch=18))

with(d,lines(time,R,col="blue",
             type="b",pch=18))
