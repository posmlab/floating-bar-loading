function [y,sol] = odeeq(angs,locs,fp,x0)
%Equilibrates the bar by integrating the overdamped equations of motion
%forward until equilibrium is reached or time reaches some large value
    theta0=deg2rad(-0);
    lengths=[50,50,50,50]*1e-3;
    T=1/(fp(1)+fp(3));
    
    odefun=@(t,x) bar_forces(x,fp,angs,locs,lengths,theta0).*[1;1;1e3];%Multiply by large number bc rotation has a different timescale
    opts=odeset('Events',@eventfun);
    sol=ode45(odefun,[0,150*T],x0,opts);
    y=sol.y(:,end);
    function c=constraint(state)
        exts=spring_exts(state,angs,locs,lengths,theta0);
        c=exts([1,3]);
    end
    function [value,isTerminal,direction]=eventfun(t,y)
        value=[(sum(abs(odefun(t,y))'<1e-6)==3)-0.5;...
               sum((spring_exts(y,angs,locs,lengths,theta0).*[1 0 1 0])<0)-1.5];
        isTerminal=[1;0];
        direction=[0;0];
    end
end

