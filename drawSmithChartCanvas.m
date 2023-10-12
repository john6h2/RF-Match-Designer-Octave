 %draws an initial Smith Chart Canvas
 function drawSmithChartCanvas
   t=linspace(0,2*pi,100);
   plot(exp(i*t), 'Color','black','linewidth',1.5); axis equal;
   hold on; %!!!!!!
   plotR;
   plotX;
   plotG;
   plotB;
 endfunction
