% [GA, zA, x1]= Match_Series_x(Gtarget,zk,s,Qn,g_circle)
%
%   SYNOPSIS:
%       This function attempts to find a series reactance that is added to zk to
%       intersect the Gtarget circle. s is the sign '+' in simple cases will be a
%       series inductance, '-' a series capacitance, in some cases, both solutions
%       could be inductave x1,x2>=0 or capacitive x1,x2<=0 if Qn is present, a solution
%       that intersects the Qn=const semicircles, depending on sign. if g_circle is
%       present, it only attempts to hit the specified g_circle, making G_target
%       and Qn irrelivant.
%  SYNTAX:
%     [GA, zA, x1]=Match_Series_x(Gtarget,zk,s,Qn,g_circle)
%  INPUT ARGUMENTS:
%     Gtarget   : The target Reflection Coefficent
%     zk        : The impedance  you are adding jx1 (calculated is added to)
%     s         : sign in simple cases '+' is the sign of the reactive, otherwise a solution
%     Qn        : Qn, if specified without g_circle is matched to in that specifict stage, not Gtarget
%   g_circle    : when entered attempts to find a soln to hit g_circle, ignores Gtarget, Qn

%  OUTPUT ARGUMENTS:
%     GA        : The G(zk+-jx1)
%     zA        : Impedance zk+-jx1
%     x1        : x1, the reactance calculated given the parameters entered

%     John Hawkins - (10-07-2023)

function [GA,zA,x1]=Match_Series_x(Gtarget,zk,s,Qn,g_circle)
    rk=real(zk);
    xk=imag(zk);

if s=='+'
      if nargin==5
          x1=-xk+sqrt(rk/g_circle-rk^2);
          if isreal(x1)==0
            errordlg("No + solution using series j*x1");
          return;
          endif
          zpath=linspace(zk,zk+j*x1,20);
          Gcurve=z2G(zpath);
          plot(Gcurve,'<','Color','r','linewidth',1.5);
      elseif nargin==4
          x1=Qn*rk-xk;
          zpath=linspace(zk,zk+j*x1,20);
          GA=z2G(zk+j*x1);
          Gcurve=z2G(zpath);
          plot(Gcurve,'<','Color','r','linewidth',1.5);
          plot(GA,'Color','k','*','MarkerSize',10);

      else %nargin=3
          %Plot the addition of a series inductance +jx1 and GA=z2G(zk+jx1)
          x1=-xk+sqrt( (((1+rk)*abs(Gtarget))^2-(rk-1)^2)/(1-abs(Gtarget)^2));
          if isreal(x1)==0
            errordlg("No + solution using series j*x1 to the target Refl Coeff");
            return;
          endif
          zpath=linspace(zk,zk+j*x1,20);
          Gcurve=z2G(zpath);
          plot(Gcurve,'<','Color','r');
          GA=z2G(zk+j*x1);
          plot(GA,'Color','k','*','MarkerSize',10)
endif %+
    zA=zk+j*x1;
    GA=z2G(zk+j*x1);

elseif s=='-'
        if nargin==5
            x1=-xk-sqrt(rk/g_circle-rk^2);
            if isreal(x1)==0
              errordlg("No + solution using series j*x1");
              return;
            endif
            zpath=linspace(zk,zk+j*x1,20);
            Gcurve=z2G(zpath);
            plot(Gcurve,'<','Color','r','linewidth',1.5);
            GA=z2G(zk+j*x1);
            plot(GA,'Color','k','*','MarkerSize',10);
        elseif nargin==4
            x1=xk-Qn*rk;
            zpath=linspace(zk,zk+j*x1,20);
            Gcurve=z2G(zpath);
            plot(Gcurve,'<','Color','r','linewidth',1.5);
            GA=z2G(zk+j*x1);
            plot(GA,'Color','k','*','MarkerSize',10)
        else %nargin==3
            %add series capacitance -j*x1 in many cases
            x1=-xk-sqrt( (((1+rk)*abs(Gtarget))^2-(rk-1)^2)/(1-abs(Gtarget)^2));
            if isreal(x1)==0
              errordlg("No solution using capacitive series reactance -j*x");
              return;
            endif
            zpath=linspace(zk,zk+j*x1,20);
            Gcurve=z2G(zpath);
            GA=z2G(zk+j*x1);
            plot(Gcurve,'-<','Color','r');
            plot(GA,'Color','k','*','MarkerSize',10)
        endif %nargin
          zA=zk+j*x1;
          GA=z2G(zk+j*x1);
endif %-

endfunction
