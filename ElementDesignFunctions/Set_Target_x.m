% [GA, zA, x1]= Set_Target_x(zL,zA,sign)
%
%   SYNOPSIS:
%       This function calculates a series jx reactance to meet a
%       constant g circle as a process of matching to zL it plots the
%       addition of the series reactance in the S plane. Not an extensive
%       function.
%  SYNTAX:
%     [GA, zA, x1]= Set_Target_x(zL,zA,sign)
%  INPUT ARGUMENTS:
%     zL        : The desired Load impedance
%     zA        : The impedance  you are adding jx1 (calculated is added to)
%     s         : sign '+' is iductive, '-' is capacitive
%  OUTPUT ARGUMENTS:
%     GA        : The G(zk+-jx1)
%     zA        : zA+j*x1
%     x1        : x1, the calculated reactance

%     John Hawkins - (10-11-2023)

function [G_out , z_out, x1]= Set_Target_x( zL, zA, sign)
        rA=real(zA);
        xA=imag(zA);
        g=real(1/zL);
        if sign=='+'
            x1=-xA + sqrt(rA/g-rA^2);
        elseif sign=='-'
            x1=-xA -sqrt(rA/g - rA^2);
        end
        zpath=linspace(zA,zA+j*x1,20);
        Gcurve=z2G(zpath);
        plot(Gcurve,'Color','r','>');
        z_out=zA+j*x1;
        G_out=z2G(z_out);
endfunction
