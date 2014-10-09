
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 3) {
	stop ("Rscript plot.r Num Input Output file required")
}	

data <- read.csv(args[2], header=TRUE, sep=",")

# Do conversions here
used_mem <- as.numeric(as.character(data$used))
usr_cpu <- as.numeric(as.character(data$usr))
sys_cpu <- as.numeric(as.character(data$sys))
data_read <- as.numeric(as.character(data$read))
data_write <- as.numeric(as.character(data$writ))
data_recv <- as.numeric(as.character(data$recv))
data_send <- as.numeric(as.character(data$send))

xvalues = seq(from = 1, to = length(data$usr), by=1)

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
