function [s, u] = GetRollingWindow(x, y)

n = length(y)
j = 1
for i = 1:n-x
    s(j)=std(y(i:i+x-1),0,1)
    u(j)=mean(y(i:i+x-1))
    j = j+1
end

end

