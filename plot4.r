# When loading the dataset into R, please consider the following:
#         
#         The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. Make sure your computer has enough memory (most modern computers should be fine).
# 
# We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
# 
# You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
# 
# Note that in this dataset missing values are coded as ?.


# Data starts from 16 Dec 2006 17:24 hours. Lines to skip = no of minutes to 1/2/2007 00:00 hours
# so minutes on Dec 16 = 37+6*60 = 397
# Lines from 17 Dec to 1 Feb = mintues in = 15+31 = 46 days. 
# total minutes = 397 + (46*24*60) = 66637 min or lines to skip
# No of lines to read (same as no of minutes) for two days = 2*24*60 = 2880

# reading the required data subset
data<-read.csv2("household_power_consumption.txt", header=FALSE, comment.char = "",colClasses = "character",skip=66637, nrows=2880)

# conversion to Date format
data[,1] <- as.Date(data[,1],"%d/%m/%Y") 

# adding the header
colnames(data) <- read.csv2("household_power_consumption.txt",comment.char = "", header=FALSE, colClasses = "character", nrows=1)

# converting the datatypes to numeric
data[,3]<- as.numeric(data[,3]) 
data[,4]<- as.numeric(data[,4])
data[,5]<- as.numeric(data[,5])
data[,6]<- as.numeric(data[,6])
data[,7]<- as.numeric(data[,7])
data[,8]<- as.numeric(data[,8])
data[,9]<- as.numeric(data[,9])

# combining Date and Time to convert to POSIXlt format data
data$combine <- paste(data[,1],data[,2])
data$combine <- strptime(data$combine, format="%Y-%m-%d %H:%M:%S")

# plotting the plot4.png
png(filename = "plot4.png", width = 480, height=480, units = "px")
par(mfrow=c(2,2))
with(data, 
     {
             plot(combine, Global_active_power, xlab="", ylab="Global Active Power", type="l")
             
             plot(combine, Voltage, ylab="Voltage", xlab="datetime", type="l")
             
             plot(combine,Sub_metering_1, type="n", xlab = "", ylab = "Energy sub metering")
             lines(data$combine, data$Sub_metering_1, type="l", col="Black")
             lines(data$combine, data$Sub_metering_2, type="l", col="Red")
             lines(data$combine, data$Sub_metering_3, type="l", col="Blue")
             legend("topright", pch="-",  col=c("Black","Red","Blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n")
             
             plot(combine, Global_reactive_power, ylab="Global_reactive_power", xlab="datetime", type="l", ylim=c(0.0,0.5))
     }
)
dev.off()

