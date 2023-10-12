%TargetGammaPlot(Gtarget)  :
%
%  SYNOPSIS:
%     Plots the desired Gamma Gs or GL in the S plane,
%     and the constant Reflection Coefficient contour for a visualization for
%     What you need to match to.
%
%  SYNTAX:
%     TargetGammaPlot(Gtarget)
%  INPUT ARGUMENTS:
%     Gtarget: Gs or Gl probably, any desired reflection coefficent you want to match to.
%     t2pi:  a vector from 0 to 2*pi.
%  OUTPUT ARGUMENTS:
%     None

%     John Hawkins - (09-08-2023)

function TargetGammaPlot(Gtarget)
    t2pi=linspace(0,2*pi,100);
    plot(Gtarget,'Color','k','Marker','*','MarkerSize',20);
    plot(abs(Gtarget).*exp(i*t2pi),'-.','Color','k', 'linewidth', 1.5);
endfunction
