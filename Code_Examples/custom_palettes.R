# Custom color palettes
pal.discrete = c("#c4a113","#c1593c","#643d91","#894e7d","#477887","#688e52",
                 "#12aa91","#705f36","#8997b2","#753c2b","#3c3e44","#b3bf2d",
                 "#82b2a4","#820616","#a17fc1","#262a8e","#abb5b5","#000000",
                 "#493829","#816C5B","#A9A18C","#613318","#855723","#B99C6B",
                 "#8F3B1B","#D57500","#DBCA69","#404F24","#668D3C","#BDD09F",
                 "#4E6172","#83929F","#A3ADB8")

pal.continuous <- viridis::viridis(200,option="D")[1:180]

pl <- c("#411c70","#404F24","#D57500")
pal.diverging <- colorRampPalette(pl)

pal.discrete.cb <- pal.discrete[c(1,2,3,5,6,8)]