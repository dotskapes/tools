map = user_param ('mapkey', 'Map', 'point_map')
y = user_param ('ykey', 'Attribute', 'attr', 'mapkey')


library(RColorBrewer)
library(classInt)

q5 <- classIntervals(map[[y]], n=5, style="quantile")
pal <- grey.colors(4, 0.95, 0.55, 2.2)
fj5 <- classIntervals(map[[y]], n=5, style="fisher")

def.par <- par(no.readonly = TRUE)

par(mar=c(1,1,3,1)+0.1, mfrow=c(1,2))
q5Colours <- findColours(q5, pal)
plot(map, col=q5Colours, pch=19)

box()
title(main="Quantile")
legend("topleft", fill=attr(q5Colours, "palette"), legend=names(attr(q5Colours, "table")), bty="n", cex=0.8, y.intersp=0.8)
fj5Colours <- findColours(fj5, pal)
plot(map, col=fj5Colours, pch=19)
box()
title(main="Fisher-Jenks")
legend("topleft", fill=attr(fj5Colours, "palette"), legend=names(attr(fj5Colours, "table")), bty="n", cex=0.8, y.intersp=0.8)
par(def.par)
