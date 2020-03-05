function [t,r]=DAG_polar_plot(input,stepsize_in_degrees)
stepsize_in_radiants=stepsize_in_degrees*pi/180;
bins=0+stepsize_in_radiants:stepsize_in_radiants:2*pi+stepsize_in_radiants;
[t,r]= rose(input,bins);
%h = polar(t,hist2per(r)*2);
end