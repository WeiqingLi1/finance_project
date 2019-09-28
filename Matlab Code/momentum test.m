[dataf,txt,raw] = xlsread('dataf.xlsx') % read absolute return (eg.p2-p1) data
[dataff,txt,raw] = xlsread('dataff.xlsx') % read the risk-free rate data

% read daily portfolio absolute return
rp1 = dataf(:,1)
rp2 = dataf(:,2)
rp3 = dataf(:,3)
rp4 = dataf(:,4)


% Calculate the monthly dollar return of portfolio 1,2,3,4

j = 1
m1 = 7068
z = 21
for q = 1:floor(m1/21)
     mrp1(j) = sum(rp1(1+z*(q-1):z*q))
     mrp2(j) = sum(rp2(1+z*(q-1):z*q))
     mrp3(j) = sum(rp3(1+z*(q-1):z*q))
     mrp4(j) = sum(rp4(1+z*(q-1):z*q))
    j = j+1
end

mrp1 = mrp1'
mrp2 = mrp2'
mrp3 = mrp3'
mrp4 = mrp4'

r1 = regARIMA(60,0,0) %Establishing AR(60)model
r2 = regARIMA(10,0,0) %Establishing AR(10)model

% Using AR(60) model to estimate rho and t-statistic

[EstMdm1,logLm1,infom1] = estimate(r1,mrp1)

[EstMdm2,logLm2,infom2] = estimate(r1,mrp2)

[EstMdm3,logLm3,infom3] = estimate(r1,mrp3)

[EstMdm4,logLm4,infom4] = estimate(r1,mrp4)

% Using AR(10) model to estimate rho and t-statistic
[EstMdm5,logLm5,infom5] = estimate(r2,mrp1)

[EstMdm6,logLm6,infom6] = estimate(r2,mrp2)

[EstMdm7,logLm7,infom7] = estimate(r2,mrp3)

[EstMdm8,logLm8,infom8] = estimate(r2,mrp4)






