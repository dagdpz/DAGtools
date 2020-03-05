t=1:10000;
f1=5;
f2=12;
f3=33;


[A,X]=cmorwavf(-1,1,2001,0.1,5);

B=sin(f1*2*pi*t/1000);
C=sin(f2*2*pi*t/1000);
D=sin(f3*2*pi*t/1000);

CONV_F=conv(B+C+D,A,'same');

figure

subplot(6,3,1)
plot(X,real(A))

subplot(6,3,2)
plot(X,imag(A))

subplot(6,3,3)
plot(X,abs(A))


subplot(6,1,2)
plot(t,B+C+D);


subplot(6,1,3)
plot(t,B);

subplot(6,1,4)
plot(t,CONV_F);

subplot(6,1,5)
plot(t,abs(CONV_F));

subplot(6,1,6)
plot(t,angle(CONV_F));
