[num1,txt,raw]=xlsread('C:\Users\Yunong Liu\Dropbox\[IAQF]\Data\data_optimal.csv');
num=num1(1:7057,10:17);% filter data of returns in 28 years(1/3/1990-1/3/2018)

% ret1=num(:,1);
ret=num(:,4);
% ret3=num(:,7);

% ret=[ret1,ret2,ret3];
dates=datenum(txt(2:7058,1));



var=zeros(28,1);
year=zeros(28,1);

    n=0;
  for i=1:252:length(ret(1:end-251,1))
    n=n+1;
    R=sort(ret(i:i+251,1));
    var(n,1)=R(2);%VaR
    year(n,1)=1990+n-1;
    
    cVaR(n,1)=(R(1)+R(2))/2;%cVaR
  end

 


var_p2=var(1:end,1);

% var_p4=var(1:end,4);

cVar_p2=cVaR(1:end,1);

% cVar_p4=cVaR(1:end,4);
% port_Var=[var_p1,var_p2,var_p3];
ave_Var=mean(var_p2);
%plot VaR
figure
plot(year,var_p2,'r');
title('VaR(annual)')
legend('p2')

% port_cVar=[cVar_p1,cVar_p2,cVar_p3];
%plot cVaR
figure
plot(year,cVar_p2,'r');

title('cVaR(annual)')
legend('p2')

%Portfolio value=initial(100000)+cum_return
port_value=zeros(7057,3);
port_value(1,1)=100000;
for i=2:7057
    port_value(i,1)=port_value(i-1,1)+ret(i,1);
    
end


u=0;
maxDD=zeros(28,1);
drawdown=zeros(7056,1);
dur=zeros(7056,1);
mdur=zeros(28,1);

n=0;
u=u+1;
o=0;
for i=1:252:length(ret(1:end-251,1))%annually analysis
     o=o+1;
    for bb=i:i+251
        if bb==7056 %the newest day without drawdown
            break
       % find all drawdowns and duration in a year             
        elseif  port_value(bb,1)< port_value(bb+1,1) && port_value(bb+2,1)< port_value(bb+1,1) %find a peak(net return change from positive to negative)
          hm=port_value(bb+1,1);%set hm = the peak value
         for m=bb+2:7057
              if port_value(m,1)>hm || m==7057 %keep tracking until the port_value higher than the previous peak return
%                   drawdown(bb+1,u)=(hm-min(port_value(bb+1:m,u)))/abs(hm); %drawdown = (min value-peak value)/peak value
                  dur(bb+1,1)=m-bb-1;% duration of drawdown
                 break                  
              end
         end
        end
    end
     maxDD(o,1)=maxdrawdown(port_value(i:i+251,1));
     mdur(o,1)=max(dur(i:i+251,1));% find maximum drawdown duration   
end

data_p2=[maxDD(1:end,1),mdur(1:end,1)];


figure 
%  plot(year(6:end),maxDD(6:end,:))
plot(year,maxDD(:,1),'r')
title('maxDD of portfolio value(annual)')
legend('p2')

figure 
plot(year,mdur(:,1),'r')
title('max drawdown duration of portfolio value(annual)')
legend('p2')
aveDur=mean(mdur(1:end,1));
