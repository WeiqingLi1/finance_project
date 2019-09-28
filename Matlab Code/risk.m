[num1,txt,raw]=xlsread('C:\Users\Yunong Liu\Dropbox\[IAQF]\Data\data_final.csv');
num=num1(1:7057,10:17);% filter data of returns in 28 years(1/3/1990-1/3/2018)

ret1=num(:,1);
ret2=num(:,3);
ret3=num(:,5);
ret4=num(:,7);
ret=[ret1,ret2,ret3,ret4];
dates=datenum(txt(2:7058,1));


var=zeros(28,4);
year=zeros(28,1);
for j=1:4
    n=0;
  for i=1:252:length(ret(1:end-251,1))
    n=n+1;
    R=sort(ret(i:i+251,j));
    var(n,j)=R(2);%VaR
    year(n,1)=1990+n-1;
        cVaR(n,j)=(R(1)+R(2))/2;%cVaR
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
ave_Var=[mean(var_p1),mean(var_p2),mean(var_p3),mean(var_p4)];
ave_cVar=[mean(cVar_p1),mean(cVar_p2),mean(cVar_p3),mean(cVar_p4)];


port_cVar=[cVar_p1,cVar_p2,cVar_p3,cVar_p4];

port_value=zeros(7057,4);
port_value(1,:)=[100000,100000,100000,100000];
for i=2:7057
    port_value(i,1)=port_value(i-1,1)+ret(i,1);
    port_value(i,2:4)=100000+ret(i,2:4);
end

u=0;
maxDD=zeros(28,2);
drawdown=zeros(7056,2);
dur=zeros(7056,2);
mdur=zeros(28,2);
for j=1:4 
n=0;
u=u+1;
o=0;
for i=1:252:length(ret(1:end-251,1))%annually analysis
     o=o+1;
    for bb=i:i+251
        if bb==7056 %the newest day without drawdown
            break
       % find all drawdowns and duration in a year             
        elseif  port_value(bb,j)< port_value(bb+1,j) && port_value(bb+2,j)< port_value(bb+1,j) %find a peak(net return change from positive to negative)
          hm=port_value(bb+1,j);%set hm = the peak value
         for m=bb+2:7057
              if port_value(m,j)>hm || m==7057 %keep tracking until the port_value higher than the previous peak return
                  dur(bb+1,j)=m-bb-1;% duration of drawdown
                 break                  
              end
         end
        end
    end
     maxDD(o,j)=maxdrawdown(port_value(i:i+251,j));
     mdur(o,j)=max(dur(i:i+251,j));% find maximum drawdown duration   
end
end
data_p1=[maxDD(1:end,1),mdur(1:end,1)];
data_p2=[maxDD(1:end,2),mdur(1:end,2)];
data_p3=[maxDD(1:end,3),mdur(1:end,3)];
data_p4=[maxDD(1:end,4),mdur(1:end,4)];

aveMDD=[mean(maxDD(1:end,1)),mean(maxDD(1:end,2)),mean(maxDD(1:end,3)),mean(maxDD(1:end,4))];
aveDur=[mean(mdur(1:end,1)),mean(mdur(1:end,2)),mean(mdur(1:end,3)),mean(mdur(1:end,4))];
