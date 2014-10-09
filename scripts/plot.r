# Create Line Chart

# convert factor to numeric for convenience 

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 3) {
	stop ("Rscript plot.r Num Input Output file required")
}	

data <- read.csv(args[2], header=TRUE, sep=",")

#Orange$Tree <- as.numeric(Orange$Tree) 
#    ntrees <- max(Orange$Tree)

# get the range for the x and y axis 

#print (data)

#xrange <- range(data)

#summary(data)

#print ("Data$usr")
#print(data$usr)

# Do conversions here
used_mem <- as.numeric(as.character(data$used))
usr_cpu <- as.numeric(as.character(data$usr))
sys_cpu <- as.numeric(as.character(data$sys))
data_read <- as.numeric(as.character(data$read))
data_write <- as.numeric(as.character(data$writ))
data_recv <- as.numeric(as.character(data$recv))
data_send <- as.numeric(as.character(data$send))

#print(data$used)
#print (used_mem)
#print (data$used/1024/1024)

xvalues = seq(from = 1, to = length(data$usr), by=1)
#print (xvalues)

#attach(data)

pdf(args[3])

par(mfrow=c(3,3))
plot(data.frame(xvalues, usr_cpu), type="l", xlab="Time (sec)", ylab="User CPU Usage (%)", main="User CPU usage", ylim=c(0,100))
plot(data.frame(xvalues, sys_cpu), type="l", xlab="Time (sec)", ylab="Sys CPU Usage (%)", main="System CPU usage", ylim=c(0,100))
plot(data.frame(xvalues, used_mem/1024/1024), type="l", xlab="Time (sec)", ylab="Memory used (Mb)", main="Memory used")
plot(data.frame(xvalues, data_read/1024/1024), type="l", xlab="Time (sec)", ylab="Read (Mb/s)", main="Data read from disk")
plot(data.frame(xvalues, data_write/1024/1024), type="l", xlab="Time (sec)", ylab="Write (Mb/s)", main="Data written to disk")
plot(data.frame(xvalues, data_recv/1024/1024), type="l", xlab="Time (sec)", ylab="Data received (Mb/s)", main="Data received over network")
plot(data.frame(xvalues, data_send/1024/1024), type="l", xlab="Time (sec)", ylab="Data sent (Mb/s)", main="Data sent over network")
mtext(paste("Node ",args[1]), side=3, line=-1.5, outer=TRUE)

#stop("stop")
##    xrange <- range(Orange$age) 
##    yrange <- range(Orange$circumference) 
#
## set up the plot 
#    plot(xrange, yrange, type="n", xlab="Time (sec)",
#                ylab="CPU Usage (%)" ) 
##colors <- rainbow(ntrees) 
#    colors <- rainbow(
#    linetype <- c(1:ntrees) 
#    plotchar <- seq(18  ,18+ntrees,1)
#
## add lines 
#    for (i in 1:ntrees) { 
#          tree <- subset(Orange, Tree==i) 
#                lines(tree$age, tree$circumference, type="b", lwd=1.5,
#                            lty=linetype[i], col=colors[i], pch=plotchar[i]) 
#    } 
#
## add a title and subtitle 
#title("Tree Growth", "example of line plot")
#
## add a legend 
#legend(xrange[1], yrange[2], 1:ntrees, cex=0.8, col=colors,
#            pch=plotchar, lty=linetype, title="Tree")
