% Solve the 2D linearised SWEs using an Arakawa C-grid
% dphi/dt = -Phi(du/dx + dv/dy)
% du/dt = fv - dphi/dx
% dv/dt = -fu - dphi/dy

% constants
Phi = 1;
f = 1;

% Setup grid
dx = 0.1;
x = 0:dx:1;
dy = 0.1;
y = 0:dy:1;

% setup timestepping
dt = 0.05;
nt = 9;
% gravity wave Courant number
Cogw = sqrt(Phi)*dt/dx;
fprintf (stderr, "Gravity wave Courant number = %g\n", Cogw);

% Assign prognostic variables
u = zeros(length(x)+1, length(y)+1);
v = zeros(length(x)+1, length(y)+1);
phi = zeros(length(x), length(y));

% setup initial conditions - checkerboard phi
%for i = 2:2:length(x); for j = 2:2:length(y);
%    phi(i,j) = 1;
%endfor; endfor
%for i = 1:2:length(x); for j = 1:2:length(y);
%    phi(i,j) = 1;
%endfor; endfor

% setup initial conditions - phi bump
for i = 1:length(x); for j = 1:length(y);
    if (x(i) > 0.45 && x(i) < 0.55 && y(j) > 0.45 && y(j) < 0.55)
        phi(i,j) = 0.5; % - sqrt((x(i)-0.5)^2 + (y(j)-0.5)^2);
    endif
endfor; endfor
plotBgrid(phi, u, v, 1);

% Loop through time steps, evolve the flow and plot
maxCo = 0;
for it = 1:nt
    % Loop through the interior of the grid
    for i = 2:length(x)-1; for j = 2:length(y)-1;
        u(i,j) = u(i,j) + dt*(f*v(i,j) - ...
               0.5*(phi(i,j)-phi(i-1,j)+phi(i,j-1)-phi(i-1,j-1))/dx);
        Co = abs(u(i,j))*dt/dx;
        if (Co > maxCo) maxCo = Co; endif
    endfor; endfor
    for i = 2:length(x)-1; for j = 2:length(y)-1;
        v(i,j) = v(i,j) + dt*(-f*u(i,j) - ...
               0.5*(phi(i,j)-phi(i,j-1)+phi(i-1,j)-phi(i-1,j-1))/dy);
        Co = abs(v(i,j))*dt/dx;
        if (Co > maxCo) maxCo = Co; endif
    endfor; endfor
    for i = 1:length(x); for j = 1:length(y);
        phi(i,j) = phi(i,j) - 0.5*dt*Phi*...
            ((u(i+1,j)-u(i,j)+u(i+1,j+1)-u(i,j+1))/dx...
             + (v(i,j+1)-v(i,j)+v(i+1,j+1)-v(i+1,j))/dy);
    endfor; endfor

    plotBgrid(phi, u, v, it+1);

    fprintf (stderr, "Time = %g, max Courant number = %g\n", it*dt, maxCo);
%    fprintf (stderr, "Press return to continue...\n");
%    pause
endfor

