%[G_OUT,z_in, Z0x] =Match_Quarter_Wave(G_target,s,zk)
%
%  SYNOPSIS:
%     This function attemps a quarterWave match from input impedance zk to somewhere on the target
%     reflection coefficient circle, in one of two paths depending on the sign s '+' or '-',  It will
%     plot the contour on the Smith Chart Canvas if a match is possible, otherwise it returns an error.
%     if zk is ommited, it will quarterWave match from the default zk=1;
%
%
%
%  SYNTAX:
%     [G_OUT, z_in, Z0x]=Match_Quarter_Wave(G_target,zk,s)
%  INPUT ARGUMENTS:
%     G_target       : The Reflection Coefficent you want to be on the same Gamma circle with
%     s= sign        : sign '+' correspods to leftward path to the G_target circle '-' rightward
%     zk             : load impedance, real or compex if left off it defalts to 1
%  OUTPUT ARGUMENTS:
%     G_OUT           : The Reflection Coefficent seen from the end of the quarter Wave transformer
%     z_in            : The input impedance
%     Z0x            :  The Characteristic Impedance in Ohm of the line.

%     John Hawkins - (09-08-2023)
%function [G_OUT,z_in, Z0x] =Match_Quarter_Wave(G_target,s,zk)
function [G_OUT,z_in, Z0x] =Match_Quarter_Wave(G_target,zk,s)
      yk=1/zk;
      if nargin==2;
        yk=1;
      endif
        gk=real(yk);


          if s== '+'
              a= gk*(1+abs(G_target)^2)/(abs(yk)^2*(1-abs(G_target)^2));
              m=a+sqrt(a^2-1/abs(yk)^2);
              if ~(isreal(m))  %check if the solution was possible
                error("No solution with quarterWave match.");
              endif
              y_curve=linspace(yk,m*yk,20);
              z_in=1/(m*yk);
              G_curve=y2G(y_curve);
              if isreal(G_curve)  %put zeros in the y position for real contour
                plot(G_curve,zeros(length(G_curve)),'<','Color','k');
              else
                plot(G_curve,'>','Color','k');
            endif
      endif
      if s== '-'
            a= gk*(1+abs(G_target)^2)/(abs(yk)^2*(1-abs(G_target)^2));
            m=a-sqrt(a^2-1/abs(yk)^2);
            if ~(isreal(m))
              error("No solution with quarterWave match.");
            endif
            y_curve=linspace(yk,m*yk,20);
            z_in=1/(m*yk);
            G_curve=y2G(y_curve);
            if isreal(G_curve)
              plot(G_curve,zeros(length(G_curve)),'>','Color','k');
            else
              plot(G_curve,'>','Color','k');
            endif
      endif
            G_OUT=G_curve(20);
            Z0x=50*sqrt(m);



