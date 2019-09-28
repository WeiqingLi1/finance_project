[num1,txt,raw]=xlsread('C:\Users\Yunong Liu\Dropbox\[IAQF]\Data\data.csv');
num=num1(1:7056,9:12);% filter data of returns in 28 years(1/3/1990-1/3/2018)
dates=datenum(txt(2:7057,1));%convert dates to date number

%calculate VaR & CVaR
var=zeros(112,4);
year=zeros(112,1);
for j=1:4
    n=0;
  for i=1:63:length(num(1:end-62,1))
    n=n+1;
    R=sort(num(i:i+62,j));
    var(n,j)=R(3);%95th VaR
    year(n,1)=dates(i,1);
   %Calculate CVaR
    cVaR(n,j)=mean(R(1)+R(2)+R(3));
  end
end

var_p1=var(1:end,1);
var_p2=var(1:end,2);
var_p3=var(1:end,3);
var_p4=var(1:end,4);

cVar_p1=cVaR(1:end,1);
cVar_p2=cVaR(1:end,2);
cVar_p3=cVaR(1:end,3);
cVar_p4=cVaR(1:end,4);
port_Var=[var_p1,var_p2,var_p3,var_p4];
%plot VaR
figure
plot(year,port_Var);
datetick('x','yyyy-mm','keeplimits')
title('VaR(3-month)')
legend('p1','p2','p3','p4')

port_cVar=[cVar_p1,cVar_p2,cVar_p3,cVar_p4];
%plot cVaR
figure
plot(year,port_cVar);
datetick('x','yyyy-mm','keeplimits')
title('cVaR(3-month)')
legend('p1','p2','p3','p4')



%Portfolio value=initial(100000)+cum_return
port_value=100000+num1(1:end,13:16);


% calculate max drawdown and durarion
u=0;
maxDD=zeros(112,4);
drawdown=zeros(7056,4);
dur=zeros(7056,4);
mdur=zeros(112,4);
for j=1:4 
n=0;
u=u+1;
o=0;
for i=1:63:length(num(1:end-62,1))%3-monthly analysis
    o=o+1;
    for bb=i:i+62
        if bb==7056 %the newest day without drawdown
            break
       % find all drawdowns in 3 month             
        elseif  num(bb,j)>0 && num(bb+1,j)<0 %find a peak(net return change from positive to negative)
          hm=port_value(bb,u);%set hm = the peak value
         for m=bb+1:i+62
              if port_value(m,u)>hm || m==7056 %keep tracking until the port_value higher than the previous peak return
                 drawdown(bb,u)=(min(port_value(bb:m,u))-hm)/abs(hm); %drawdown = (min value-peak value)/peak value
                 dur(bb,u)=m-bb;% duration of drawdown= (index of min-index of peak(1))
                 break                  
              end
         end
        end
    end
     maxDD(o,u)=min(drawdown(i:bb,u));%maxDD is Max drawdown(negtive, so should be min), I is the index 
     mdur(o,u)=max(dur(i:bb,u));% find maximum drawdown duration  
    
end
end
data_p1=[maxDD(1:end,1),mdur(1:end,1)];
data_p2=[maxDD(1:end,2),mdur(1:end,2)];
data_p3=[maxDD(1:end,3),mdur(1:end,3)];
data_p4=[maxDD(1:end,4),mdur(1:end,4)];

figure 
plot(year(13:end,1),maxDD(13:end,:))
datetick('x','yyyy-mm','keeplimits')
title('maxDD of portfolio value(3-month)')
legend('p1','p2','p3','p4')
figure 
plot(year,mdur)
datetick('x','yyyy-mm','keeplimits')
title('max drawdown duration of portfolio value(3-month)')
legend('p1','p2','p3','p4')
% average maximum drawdown duration
aveDur=[mean(mdur(1:end,1)),mean(mdur(1:end,2)),mean(mdur(1:end,3)),mean(mdur(1:end,4))];