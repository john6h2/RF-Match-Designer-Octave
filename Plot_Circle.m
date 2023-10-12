%   Plot_Circle(z0,R)
%
%   SYNOPSIS:
%       This function is no big deal, it's useful in plotting a circle where R is
%       complex, and you want to plot the absolute value of R, useful when plotting
%       a reflection coefficent magnitude.
%     John Hawkins - (10-07-2023)

function Plot_Circle(z0,R)
      t=linspace(0,2*pi,100);
      z=z0+abs(R)*exp(i*t);
      plot(z,'k')
endfunction
