clc
clear all

data=[0.1 0.2 0.3;0.3 0.2 0.1;0.6 0.4 0.8;0.9 0.2 0.4];

wij=[0.1;-0.1;0.2];
wjk=[0.2 -0.5 0.1];

itermax=100;

for iter=1:itermax
    for sample=1:size(data,1)
        oj=data(sample,:)*wij;
        ok=oj*wjk;
        
        delwjk=zeros(1,size(wjk,2));
        for k=1:size(wjk,2)
            delwjk(1,k)=0.1*(data(sample,k)-ok(k))*oj/size(wjk,2);        
        end
        wjk=wjk+delwjk;

        delwij=zeros(size(wjk,2),1);

        count=0;
        for k=1:size(wjk,2)
            count=count+(data(sample,k)-ok(k))*wjk(k);     
        end
        delwij=0.1*data(sample,:)'*count/size(wjk,2);
        wij=wij+delwij;       

    end
    
    if(max(delwij)<0.0001 && max(delwjk)<0.0001)
        break
    end
    
end


reduced_features=zeros(size(data,1),1);
for sample=1:size(data,1)
    reduced_features(sample,:)=data(sample,:)*wij;
end
reduced_features

