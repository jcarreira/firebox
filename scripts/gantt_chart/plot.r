tasks <- read.csv("tasks.csv", header = T)
# day of week
tasks$day <- weekdays(strptime(tasks$date, "%Y-%m-%d"))
week      <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
tasks$day <- factor(tasks$day, levels = week)

# convert time to decimal hours
    tasks$start.ct   <- as.POSIXct(paste(tasks$date, tasks$start, sep = " "))
    tasks$end.ct     <- as.POSIXct(paste(tasks$date, tasks$end, sep = " "))
    tasks$start.hour <- as.POSIXlt(tasks$start.ct)$hour + as.POSIXlt(tasks$start.ct)$min/60 + as.POSIXlt(tasks$start.ct)$sec/3600
    tasks$end.hour   <- as.POSIXlt(tasks$end.ct)$hour + as.POSIXlt(tasks$end.ct)$min/60 + as.POSIXlt(tasks$end.ct)$sec/3600

# offset tasks if > 1 per day
    tasks$ymin <- c(rep(0, nrow(tasks)))
    t <- table(tasks$day)
    for(day in rownames(t)) {
          if(t[[day]] > 1) {
                  ss <- tasks[tasks$day == day,]
                          y  <- 0
                              for(i in as.numeric(rownames(ss))) {
                                        tasks[i,]$ymin <- y
                                                  y <- y + 1.2
                                                      }
                    }
    }


# plot
library(ggplot2)
    png(filename = "tasks.png", width = 640, height = 480)
    ggplot(tasks, aes(xmin = start.hour, xmax = end.hour, ymin = ymin, ymax = ymin + 1, fill = factor(task))) + geom_rect() + 
    facet_grid(day~.) + theme(axis.text.y = element_blank(), axis.ticks = element_blank()) + xlim(0,23) + xlab("time of day")
    dev.off()
