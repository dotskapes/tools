beta = user_param ('betakey', 'Beta value', 'number')

                                        #S, I, and R are the initial *totals* of susceptible, infected, and recovered individuals
                                        #All parameters must be positive, and S(0)+I(0) ≤ 1
                                        #Derivative-solving library

library(deSolve)

sir<-function(time, state, parameters)          #Solve SIR equations
  {
    with(as.list(c(state, parameters)), {
      dS <- - (beta*S*I)
      dI <- (beta*S*I) - (gamma*I)
      dR <- (gamma*I)
      return(list(c(dS, dI, dR)))
    })}

parms<- c(beta= beta,                          # transmission rate  (Ro=beta/gamma)
          gamma= 0.14286)             # recovery rate

yini<-  c(S=1-.000001,                  # initial proportion susceptible
          I=.000001,                            # initial proportion infected
          R=0)                                  # initial proportion recovered

times<- seq(0,100,by=1)             #time sequence to use

out <- as.data.frame(ode(func = sir, y=yini, parms = parms, times=times))
out

                                        #Plot values and add legend
graph.colors = c(rgb(0,1,0), rgb(1,0,0), rgb(0,0,1))
matplot(times, out[,-1], lty=1, type = "l", xlab ="Time", ylab = "% of Individuals", main ="SIR Model Freq", bty = "l", lwd=1, col =graph.colors)
legend(par("usr")[1],par("usr")[3],c("Susceptible", "Infected", "Recovered"), pch=1, col=graph.colors, xjust=0, yjust=2)
