# Function to plot the results of the SWE solved on an Arakawa A-grid

function var_list = plotAgrid(phi, u, v, it)

clf

# Scaling for vectors
vscale = 6;

% x and y positions of vertices and cell centres
x = 0:size(phi,1);
y = 0:size(phi,2);
xc = 0.5:size(phi,1);
yc = 0.5:size(phi,2);

# Plot phi
pcolor(x, y, [[phi; zeros(1,length(phi))], zeros(length(phi)+1,1)])
caxis([-0.5 0.5])
colormap(whitejet(21))
set(gca, 'xgrid', 'on', 'ygrid', 'on', 'gridcolor', [0 0 0], 'xticklabel', [],
    'yticklabel', [], 'nextplot', 'add')

# Overlay velocity at u and v locations
quiver(yc, xc, v*vscale, u*vscale, 0, 'color', [0 0 0])
quiver(yc, xc, v*vscale, u*vscale, 0, 'color', [0 0 0])

title(sprintf('A-grid results for time step %g', it-1), 'fontsize', 16)
text(4, -1, 'Press return in window for next plot', 'fontsize', 12)
disp ("Click in plot window for next plot") 

waitforbuttonpress()

