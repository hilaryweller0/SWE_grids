# Function to plot the results of the SWE solved on an Arakawa C-grid

function var_list = plotCgrid(phi, u, v, it)

clf

# Scaling for vectors
vscale = 6;

% x and y positions of different grids
x = 0:size(phi,1);
y = 0:size(phi,2);
xu = x;
yu = 0.5:size(phi,2);
xv = 0.5:size(phi,1);
yv = y;

% create matrices for v at u and u at v

vu = zeros(size(u));
uv = zeros(size(v));

for i = 2:size(v,1)-1; for j = 1:size(u,2)-1;
    vu(i,j) = 0.25*(v(i-1,j) + v(i,j) + v(i-1,j+1) + v(i,j+1));
endfor; endfor

for i = 1:size(v,1)-1; for j = 2:size(u,2)-1;
    uv(i,j) = 0.25*(u(i,j-1) + u(i+1,j-1) + u(i,j) + u(i+1,j));
endfor; endfor

# Plot phi
pcolor(x, y, [[phi; zeros(1,length(phi))], zeros(length(phi)+1,1)])
caxis([-0.5 0.5])
colormap(whitejet(21))
set(gca, 'xgrid', 'on', 'ygrid', 'on', 'gridcolor', [0 0 0], 'xticklabel', [],
    'yticklabel', [], 'nextplot', 'add')

# Overlay velocity at u and v locations
quiver(yu, xu, vu*vscale, u*vscale, 0, 'color', [0 0 0])
quiver(yv, xv, v*vscale, uv*vscale, 0, 'color', [0 0 0])

title(sprintf('C-grid results for time step %g', it-1), 'fontsize', 16)
text(4, -1, 'Press return in window for next plot', 'fontsize', 12)
disp ("Click in plot window for next plot") 

waitforbuttonpress()

