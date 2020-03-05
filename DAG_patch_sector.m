function DAG_patch_sector(center,r1,r2,phi1,phi2,stepsize,col)


x = [r1*cos([phi1, phi1:stepsize:phi2, phi2]) r2*cos([phi2, phi2:-stepsize:phi1, phi1])] + center(1);
y = [r1*sin([phi1, phi1:stepsize:phi2, phi2]) r2*sin([phi2, phi2:-stepsize:phi1, phi1])] + center(2);

patch(x,y,col,'facecolor',col,'edgecolor',col);

end