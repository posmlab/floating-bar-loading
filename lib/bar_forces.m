function F = bar_forces(state,force_pars,angs,locs,lengths,theta0)
%Calculates force and torque on bar
    rcm=state(1:2);
    theta=state(3);
    
    n=@(theta) [cos(theta);sin(theta)];
    motor=@(x) ones(size(x));%exp(-abs((x.^-2.89 -1)/0.75).^2.08);%Hill muscle function- x=l/l0
    
    A=locs.*n(theta0)-lengths.*n(angs);
    P=rcm+locs.*n(theta);
    a=P-A; %actuation vectors
    L=sqrt(sum(a.^2));
    ahat=a./L;
    exts=L-lengths;
    
    forces=-force_pars.*[exts(1) motor(1+exts(2)/lengths(2))...
                         exts(3) motor(1+exts(4)/lengths(4))].*ahat;
    torques=cross([locs.*n(theta);zeros(1,4)],[forces;zeros(1,4)]);
    
    net_force=sum(forces,2);
    net_torque=sum(torques(3,:),2);
    
    F=[net_force;net_torque];
end

