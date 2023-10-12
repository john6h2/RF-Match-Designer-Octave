% [GA, zA, x1]= Set_Target_b(zL,zA,sign)
%
%   SYNOPSIS:
%       This function calculates a series jb reactance to get to zL
%       it plots the addition of the shunt admittance in the S plane.
%       Not an extensive function.
%  SYNTAX:
%     [GA, zA, x1]= Set_Target_x(zL,zA,sign)
%  INPUT ARGUMENTS:
%     zL        : The desired Load impedance
%     zA        : The impedance  you are adding jx1 (calculated is added to)
%     s         : sign '+' is capacitive, '-' is inductive ADMITANCE
%  OUTPUT ARGUMENTS:
%     GA        : The G(zA+jb1)
%     zA        : (yA+j*b1)^-1
%     b1        : b1, the calculated reactance
%     John Hawkins - (10-11-2023)


function [G_out , z_out, b1]= Set_Target_b( zL, zA, sign)
           rL=real(zL);
           yA=1/zA;
           gA=real(yA);
           bA=imag(yA);
            if sign=='+'
              b1=-bA+sqrt(gA/rL-gA^2);
            elseif sign=='-'
              b1=-bA-sqrt(gA/rL-gA^2);
            endif
        ypath=linspace(yA,yA+j*b1,20);
        Gcurve=y2G(ypath);
        plot(Gcurve,'Color','b','>');
        y_out=yA+j*b1;
        z_out=1/y_out;
        G_out=y2G(y_out);

