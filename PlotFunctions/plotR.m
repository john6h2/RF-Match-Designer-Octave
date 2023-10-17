%plotR  : Draws constant r0 circles in the Gamma Plane
%
%  SYNOPSIS:
%     When called without arguments, the function draws a set of
%     constant r0 circles in the Smith chart.  If an argument is
%     present, it plots that specific value in bold dark red.
%
%
%
%
%  SYNTAX:
%     plotR(r0)
%  INPUT ARGUMENTS:
%     r0       : A real scalar representing normalized resistance
%
%  OUTPUT ARGUMENTS:
%     None

%     John Hawkins - (09-08-2023)



function plotR(chosenR)
    t = linspace(0, 2*pi, 100);
    Gamma=exp(i*t);

  if nargin==1
    Rcir=Gamma./(chosenR+1)+chosenR/(chosenR+1);
    plot(Rcir,'Color',[0.7569 0 0],'linewidth',1.5);
    text((chosenR-1)/(chosenR+1)-0.01,0.01,num2str(chosenR,"%02.1f"),"rotation",90);
  endif
  if nargin==0
      r=[1.0 0.1, 0.3 0.5 0.7 1.5 2 3 4 5 10];
      k=1;
      R1=Gamma./(r(k)+1)+r(k)/(r(k)+1);
      text((r(k)-1)/(r(k)+1)-0.01,0.01,num2str(r(k),"%02.1f"),"rotation",90);
      plot(R1,'r','linewidth',1.0);
  for k=2:length(r)
    two=Gamma./(r(k)+1)+r(k)/(r(k)+1);
    text((r(k)-1)/(r(k)+1)-0.02,0.03,num2str(r(k),"%02.1f"),"rotation",90,"Color",'red','HorizontalAlignment','center');
    plot(two,'color', [1 0.5000 0],'linewidth',0.5);
  end
  endif
