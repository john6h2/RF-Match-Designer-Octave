

  function plotQ(Q)
  TF=1/sqrt(1+Q^2);
  t3=linspace(TF,pi-TF,50);
a=sqrt(1+1/Q^2);
u=a*cos(t3); v=a*sin(t3)-1/Q;
Q_circle=u+j*v;
TF=1/sqrt(1+Q^2);
plot(Q_circle,'m','LineStyle','-','linewidth',2.0)
plot(conj(Q_circle),'m','LineStyle','-','linewidth',2.0)