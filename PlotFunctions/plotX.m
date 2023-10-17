%plotX  : Draws constant x0 circles on
%
%  SYNOPSIS:
%     When called without arguments, the function draws a set of constant x0 circles on the Smith chart called by test (at the moment)
%     if an argument is present, it will draw the constant x0 circle in magenta if ChosenX is 0
%
%
%
%  SYNTAX:
%     PlotX(ChosenX)
%  INPUT ARGUMENTS:
%     x0       : A real scalar representing normalized reactance
%
%  OUTPUT ARGUMENTS:
%     None

%     John Hawkins - (09-08-2023)

 function y=plotX(chosenX)
    t = linspace(0, 2*pi, 100);
    Gamma=exp(i*t);
      if nargin==1
          if chosenX==0  %plot a horizontal line for x=0
            t1=linspace(-1,1,10);
            plot(t1,zeros(length(t1)),'b');
          else
            t1=linspace(-pi/2,-pi/2-2*atan(chosenX),50);
            w=cos(t1)./chosenX+1+j*(sin(t1)+1)./chosenX;
            plot(w,'m','linewidth',1.5);
          endif
      endif
    if nargin==0
      %plot a few x0 circles
      x=[ -0.1 -0.3 -0.5 -0.7 -1.0  -2 -3.0 -4.0 -5.0,...
0.1,0.3,0.5,0.5,0.7,1,2,3,4,5];
      for k=1:length(x)
        t1=linspace(-pi/2,-pi/2-2*atan(x(k)),50);
        w=cos(t1)./x(k)+1+j*(sin(t1)+1)./x(k);
        plot(w,'color',[0.8500 0.3250 0.0080] ,'linewidth',0.1);
        text(cos(pi-2*atan(x(k)))-0.03,sin(pi-2*atan(x(k)))+0.03*sign(x(k)),num2str(x(k),"%02.1f"),"rotation",90,'Color','r','HorizontalAlignment','center');
      endfor

    endif
