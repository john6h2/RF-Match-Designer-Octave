%plotB  : Draws constant b0 circles on
%
%  SYNOPSIS:
%     When called without arguments, the function draws a set of constant x0 circles on the Smith chart called by test (at the moment)
%     if an argument is present, it will draw the constant x0 circle in magenta
%
%
%
%  SYNTAX:
%     plotB(b0)
%  INPUT ARGUMENTS:
%     b0       : A real scalar representing normalized admittance
%
%  OUTPUT ARGUMENTS:
%     None

%     John Hawkins - (09-08-2023)

function plotB(chosenB)
  if nargin==1
    if chosenB==0  %plot a horizontal line for b=0
      t1=linspace(-1,1,10);
      plot(t1,zeros(length(t1)),'b','linewidth',2);
    else
      t1=linspace(pi/2,pi/2-2*atan(chosenB),30);
      w=cos(t1)./chosenB-1+j*(sin(t1)-1)./chosenB;
      plot(w,'g','linewidth',1.6);
      text(cos(-2*atan(chosenB))+0.03,sin(-2*atan(chosenB))-0.04*sign(chosenB),num2str(chosenB,"%02.1f"),"rotation",90,"Color",'g','HorizontalAlignment','center');
    endif
  endif
  if nargin==0
       t1=linspace(-1,1,10);   %plot b=0
      plot(t1,zeros(length(t1)),'b');
    %plot a few constant b0 circles
    b=[-0.1 -0.3 -0.5 -1.0 -5.0 0.1 0.3 0.5 1 3 5];
  for k=1:length(b)
      t1=linspace(pi/2,pi/2-2*atan(b(k)),30);
      w=cos(t1)./b(k)-1+j*(sin(t1)-1)./b(k);
      plot(w,'color',[0.3010 0.7450 0.9330]);
      text(cos(-2*atan(b(k)))+0.03,sin(-2*atan(b(k)))-0.03*sign(b(k)),num2str(b(k),"%02.1f"),"rotation",90,"Color",'blue','HorizontalAlignment','center');
  end
  endif
