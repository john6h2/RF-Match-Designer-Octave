% [GA, zA, x1]= Match_Shunt_b(Gtarget,zk,s,Qn,r_circle)
%
%   SYNOPSIS:
%       This function attempts to find a shunt admittance that is added to yk=1/zk to
%       intersect the Gtarget circle, or Qn or r_circle. s is the sign '+' in simple
%       cases will be a
%       series inductance, '-' a series capacitance, in some cases, both solutions
%       could be inductave x1,x2>=0 or capacitive x1,x2<=0 if Qn is present, a solution
%       that intersects the Qn=const semicircles, depending on sign. if r_circle is
%       present, it only attempts to hit the specified r_circle, making G_target
%       and Qn irrelivant.
%  SYNTAX:
%     [GA, zA, b1]=Match_Shunt_b(Gtarget,zk,s,Qn,r_circle)
%  INPUT ARGUMENTS:
%     Gtarget   : The target Reflection Coefficent
%     zk        : The impedance  you are adding jx1 (calculated is added to)
%     s         : sign in simple cases '+' is the sign of the reactive, otherwise a solution
%     Qn        : Qn, if specified without g_circle is matched to in that specifict stage, not Gtarget
%     r_circle  : when entered attempts to find a soln to hit g_circle, ignores Gtarget, Qn
%
%  OUTPUT ARGUMENTS:
%     GA        : The G(1/zk+-jb1)
%     zA        : Impedance output 1/(yk+jb1), where yk=1/zk
%     b1        : b1, the admittance calculated given the parameters entered
%
%     John Hawkins - (10-07-2023)
function [GA, zA, b1]=Match_Shunt_b(Gtarget,zk,s,Qn,r_circle)
      yk=1/zk;
      gk=real(yk);
      bk=imag(yk);
  if s=='+'
      %return and plot the addition of a shunt capacitance +jb and GA=y2G(1+jb1)
      if nargin==5
          b1=-bk +sqrt(gk/r_circle-gk^2);
          if isreal(b1)==0
              errordlg("No solution possible with these parameters.");
              return;
          endif
          ypath=linspace(yk,yk+j*b1,20);
          Gcurve=y2G(ypath);
          plot(Gcurve,'<','Color','b','linewidth',1.5);
          GA=y2G(yk+j*b1);
          plot(GA,'Color','k','*','MarkerSize',15)
      elseif nargin==4
          b1=Qn*gk-bk;
          ypath=linspace(yk,yk+j*b1,20);
          GA=y2G(yk+j*b1);
          Gcurve=y2G(ypath);
          plot(Gcurve,'<','Color','b','linewidth',1.5);
          plot(GA,'Color','k','*','MarkerSize',15)
      else %nargin==3 calculate for Gtarget
          b1=-bk+sqrt( (((1+gk)*abs(Gtarget))^2-(gk-1)^2)/(1-abs(Gtarget)^2));
          if isreal(b1)==0
              errordlg("No solution using capacitive shunt +j*b1");
              return;
          endif %error checking
          ypath=linspace(yk,yk+j*b1,20);
          Gcurve=y2G(ypath);
          plot(Gcurve,'->','Color','b');
          GA=y2G(yk+j*b1);
          plot(GA,'Color','k','*','MarkerSize',10)
      endif %nargin selection
      zA=1/(yk+j*b1);
  end %+
  if s=='-'
      if nargin==5
          b1=-bk -sqrt(gk/r_circle-gk^2);
          if isreal(b1)==0
              errordlg("No solution with the chosen constraints");
              return;
          endif %no solution check
          ypath=linspace(yk,yk+j*b1,20);
          Gcurve=y2G(ypath);
          plot(Gcurve,'<','Color','b','linewidth',1.5);
          GA=y2G(yk+j*b1);
          plot(GA,'Color','k','*','MarkerSize',10)
      elseif nargin==4
          b1=-(Qn*gk-bk);
          ypath=linspace(yk,yk+j*b1,20);
          GA=y2G(yk+j*b1);
          Gcurve=y2G(ypath);
          plot(Gcurve,'<','Color','k','linewidth',1.5);
      else %nargin==3
          b1=-bk-sqrt( (((1+gk)*abs(Gtarget))^2-(gk-1)^2)/(1-abs(Gtarget)^2));
          if isreal(b1)==0
              errordlg("No solution using inductive shunt +j*b1");
              return;
          endif
          ypath=linspace(yk,yk+j*b1,20);
          Gcurve=y2G(ypath);
          GA=y2G(yk+j*b1);
          plot(Gcurve,'->','Color','b');
          plot(GA,'Color','k','*','MarkerSize',10)
      endif %nargin selection
    zA=1/(yk+j*b1); %calculate zA for return
  end %-


