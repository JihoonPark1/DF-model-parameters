function y=MakePCNames(text,n)
y=cell(1,n);
for k=1:n
    y{k}=[text,num2str(k)];
end
end