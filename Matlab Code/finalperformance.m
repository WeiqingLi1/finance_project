% Read data 
[datam,txt1,raw] = xlsread('datam.xlsx') 

% Get percentage returns of the four portfolios

rp1 = datam(:,11)
rp2 = datam(:,13)
rp3 = datam(:,15)
rp4 = datam(:,17)

% Get the daily risk-free rate 
rf = datam(:,2)
rf = rf./100
rf1 = exp(rf/365)-1

% Calculate mean and standard deviation for percentage returns 

m = [mean(rp1), mean(rp2), mean(rp3), mean(rp4)]
stdm = [std(rp1), std(rp2), std(rp3), std(rp4)]

% Set the two rolling windows
n0 =12
n1 =62

% Calculate the standard deviation and the mean based on two rolling
% windows

[sr11, ur11]= GetRollingWindow(n0, rp1)
[sr12, ur12]= GetRollingWindow(n1, rp1)
[sr21, ur21]= GetRollingWindow(n0, rp2)
[sr22, ur22]= GetRollingWindow(n1, rp2)
[sr31, ur31]= GetRollingWindow(n0, rp3)
[sr32, ur32]= GetRollingWindow(n1, rp3)
[sr41, ur41]= GetRollingWindow(n0, rp4)
[sr42, ur42]= GetRollingWindow(n1, rp4)


sr11 = sr11'
ur11 = ur11'
sr12 = sr12'
ur12 = ur12'

sr21 = sr21'
ur21 = ur21'
sr22 = sr22'
ur22 = ur22'

sr31 = sr31'
ur31 = ur31'
sr32 = sr32'
ur32 = ur32'

sr41 = sr41'
ur41 = ur41'
sr42 = sr42'
ur42 = ur42'

% Calculate mean and standard deviation based on two rolling windows

m1 = [mean(ur11), mean(ur21), mean(ur31), mean(ur41)]
mstd1 = [mean(sr11), mean(sr21), mean(sr31), mean(sr41)]

m2 = [mean(ur12), mean(ur22), mean(ur32), mean(ur42)]
std2 = [mean(sr12), mean(sr22), mean(sr32), mean(sr42)]

% Calculate Sharpe Ratio for the four portfolios under two rolling windows

rsharpe11 = (rp1(13:end)-rf1(13:end))./sr11
rsharpe21 = (rp2(13:end)-rf1(13:end))./sr21
rsharpe31 = (rp3(13:end)-rf1(13:end))./sr31
rsharpe41 = (rp4(13:end)-rf1(13:end))./sr41

rsharpe12 = (rp1(63:end)-rf1(63:end))./sr12
rsharpe22 = (rp2(63:end)-rf1(63:end))./sr22
rsharpe32 = (rp3(63:end)-rf1(63:end))./sr32
rsharpe42 = (rp4(63:end)-rf1(63:end))./sr42

% Calculate mean of Sharpe Ratio
mrsharpe11 = mean(rsharpe11)
mrsharpe21 = mean(rsharpe21)
mrsharpe31 = mean(rsharpe31)
mrsharpe41 = mean(rsharpe41)

mrsharpe12 = mean(rsharpe12)
mrsharpe22 = mean(rsharpe22)
mrsharpe32 = mean(rsharpe32)
mrsharpe42 = mean(rsharpe42)

mrsharpe1 = [mrsharpe11, mrsharpe21, mrsharpe31, mrsharpe41]
mrsharpe2 = [mrsharpe12, mrsharpe22, mrsharpe32, mrsharpe42]

% Calculate average daily Sharpe Ratio for each year if window = 12
% window = 12
j = 1
m1 = 7056
z1 = 252
for q = 1:floor(m1/z1)
     as11(j) = mean(rsharpe11(1+z*(q-1):z*q))
     as21(j) = mean(rsharpe21(1+z*(q-1):z*q))
     as31(j) = mean(rsharpe31(1+z*(q-1):z*q))
     as41(j) = mean(rsharpe41(1+z*(q-1):z*q))
    j = j+1
end

as11 = as11'
as21 = as21'
as31 = as31'
as41 = as41'

msa1 = [mean(as11), mean(as21), mean(as31), mean(as41)]

% Plot Sharpe ratio with year
startDate1 = datenum('01-19-1990')
endDate1 = datenum('01-19-2018')
xData1 = linspace(startDate1,endDate1,28);
plot(xData1,as11,'m',xData1,as21,'r',xData1,as31,'g',xData1,as41,'c')
ylabel('Sharpe Ratio')
xlabel('Date')
title('Daily Average Sharpe Ratio Per Year (Rolling Window:12)')
legend('portfolio 1','portfolio 2','portfolio 3','portfolio 4');
set(gca,'XTick',xData1)
datetick('x','mm/dd/yyyy')

% Calculate average daily Sharpe Ratio for each year if window = 62
% window = 62
j = 1
m2 = 7006
z2 = 252
for q = 1:floor(m1/z2)
     as12(j) = mean(rsharpe12(1+z*(q-1):z*q))
     as22(j) = mean(rsharpe22(1+z*(q-1):z*q))
     as32(j) = mean(rsharpe32(1+z*(q-1):z*q))
     as42(j) = mean(rsharpe42(1+z*(q-1):z*q))
    j = j+1
end% 

as12 = as12'
as22 = as22'
as32 = as32'
as42 = as42'

msa2 = [mean(as12), mean(as22), mean(as32), mean(as42)]

% Plot Sharpe ratio with year

startDate2 = datenum('04-02-1990')
endDate2 = datenum('01-19-2018')
xData2 = linspace(startDate2,endDate2,27);
plot(xData2,as12,'m',xData2,as22,'r',xData2,as32,'g',xData2,as42,'c')
ylabel('Sharpe Ratio')
xlabel('Date')
title('Daily Average Sharpe Ratio Per Year (Rolling Window:62)')
legend('portfolio 1','portfolio 2','portfolio 3','portfolio 4');
set(gca,'XTick',xData2)
datetick('x','mm/dd/yyyy')

