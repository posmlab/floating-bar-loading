alpha=0.1;
fp=[10e3 10 10e3 10].*[1 alpha 1 alpha];
angs=deg2rad([90 90 90 90]);
locs=[-5 -3 5 3]*1e-3;
N=4;
xwindow=linspace(-5e-3,5e-3,N);
ywindow=linspace(-5e-3,0e-3,N);
thwindow=deg2rad(linspace(-10,0,N));
sols=cell(N,N,N);
x0=[0;0;0];
figure(1);
hold on;
for ix=1:N
    x0(1)=xwindow(ix);
    for iy=1:N
        x0(2)=ywindow(iy);
        for ith=1:N
            x0(3)=thwindow(ith);
            [~,sols{ix,iy,ith}]=odeeq(angs,locs,fp,x0);
            S=sols{ix,iy,ith}.y;
            E=sols{ix,iy,ith}.ye;
            figure(1)
            plot3(S(1,:),S(2,:),S(3,:));
            scatter3(S(1,end),S(2,end),S(3,end),'ko');
            figure(2)
            proj=null([1 1 0])'*S;
            plot(proj(1,:),proj(2,:));
            hold on;
            [~,res(:,ix*N^2+iy*N+ith)]=deval(sols{ix,iy,ith},sols{ix,iy,ith}.x(end));
        end
    end
end
figure(1);
xlabel('x')
ylabel('y')
zlabel('\theta')