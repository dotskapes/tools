bta = user_param ('betakey', 'Beta', 'number')
gma = user_param ('gammakey', 'Gamma', 'number')

## ODE solver
require(odesolve)

## ODE function
f = function(time,x,p){
  with(as.list( c(x,p) ),{
    dS = - bta*S*I
    dI = + bta*S*I - gma*I
    dR =  gma*I
    return(list(c(S=dS,I=dI,R=dR)))
  })
}

## Initial Conditions
x = c(S=100,I=1,R=0)
p = c(bta,gma)

times = seq(0,80,by=0.25)

d = lsoda(x, times, f,p)
d = data.frame(d)

## Plotting outcomes
par(lwd=2)
with(d, plot(time,S,col="green", pch=18,
             ylab="Abundance", xlab="Time",
             ylim=c(0,100),type="l"))
abline(h=0,col="gray")
with(d,lines(time,I,col="red",
             type="l",pch=18))

with(d,lines(time,R,col="blue",
             type="l",pch=18))
