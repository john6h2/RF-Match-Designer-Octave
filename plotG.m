%plotG  : Draws constant g0 circles in the Gamma Plane
%
%  SYNOPSIS:
%     When called without arguments, the function draws a set of constant
%     conductance circles. If called with and argument, it draws a circles
%     bold, and in dark blue
%
%
%
%  SYNTAX:
%     plotR(r0)
%  INPUT ARGUMENTS:
%     g0       : A real scalar representing normalized conductance
%
%  OUTPUT ARGUMENTS:
%     None, it plots to a

%     John Hawkins - (09-08-2023)



function plotG(chosenG)
  t=linspace(0,2*pi,100);
  Gamma=exp(i*t);
    if nargin==1
      two=Gamma./(chosenG+1)- chosenG/(chosenG+1);
      plot(two,'color',[0 0 0.65],'linewidth',1.5);
      text((1-chosenG)/(1+chosenG)-0.01,-0.01,num2str(chosenG,"%02.1f"),...
      "rotation",270,"Color",[0 0 1]);

    endif

    if nargin==0
      k=1;
      g=[1.0 0.1 0.3 0.5 0.7  1.5 2 3 4 10];
      G1=Gamma./(g(k)+1)- g(k)/(g(k)+1);
      plot(G1,'color', [0.086275   0.690196   0.870588],'linewidth',1.2);
    for k=2:length(g)
      two=Gamma./(g(k)+1)-g(k)/(g(k)+1);
      text((1-g(k))/(1+g(k))+0.02,-0.03,num2str(g(k),"%02.1f"),"rotation",270,"Color",'b','HorizontalAlignment','center');
      plot(two,'color',[0.3010 0.7450 0.9330]);
    endfor

    endif
