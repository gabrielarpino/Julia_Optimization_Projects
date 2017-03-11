using PyPlot, GaussianProcesses

data = readcsv("JohnsonJohnson.csv")

year = convert(Array{Float64,1}, data[2:end,2])
price = convert(Array{Float64,1}, data[2:end,3])

mConst = MeanConst(mean(year))

kernel1 = SE(1.0,1.0)
kernel2 = SE(2.0,2.0)
kernel3 = SE(3.0,3.0)
kernel4 = Periodic(0.0,1.0,0.0)*SE(4.0,0.0) # Locally periodic
kernel5 = SE(4.0,4.0) + Periodic(0.0,1.0,0.0)*SE(4.0,0.0) + RQ(0.0,0.0,-1.0) + SE(-2.0,-2.0)

log_noise = 1.0

gp = GP(year,price,mConst,kernel4,log_noise)   #Fit the GP
optimize!(gp)   #Optimize hyperparameters
p1 = plot(gp)
xlabel("Year")
ylabel("Stock Price")
title("Kernel4 Optimized with Log Noise")
savefig("plot4optimizedlognoise.png")
