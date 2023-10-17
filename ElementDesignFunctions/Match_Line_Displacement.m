%function [G_out,z_in, l_lambda]=Match_Line_Displacement(Gt,G_start,gcircle)
%
%  SYNOPSIS:
%      This function in the case of two argurments Gt and G_start caluculates
%      the length of the line (in wavelengths) and plots a semicircle in the
%      Gamma plane to its endpoint.  IF nargin is 3 G_start is irrelivant, it
%      calculates the length from Gt to the intersection to the g0=gcircle constant
%      conductance circle in the UHP, and the abs(Gt) circle.  The line impedance is
%      only the reference impedance;
%  SYNTAX:
%     [G_OUT, z_in, l_lambda]=Match_Line_Displacement(Gt,G_start,gcircle)
%  INPUT ARGUMENTS:
%     Gt              : The Reflection Coefficent you want to be on the same Gamma circle with
%     G_start         : The begining reflection coef, before line displacement
%     gcircle         : The constant conductance you want to intersect
%  OUTPUT ARGUMENTS:
%     G_OUT           : The Reflection Coefficent seen from the end of the displacement
%     z_in            : The input impedance
%     l_lambda        : The calculated length of the line.
%   John Hawkins - (10-07-23)

function [G_out,z_in, l_lambda]=Match_Line_Displacement(Gt,G_start,gcircle)
        %if there are 3 arguments G_start is ignored match to the intersection
        %of the constant Gt circle and the g0=gcircle circle in the UHP
        if nargin==3
ELen=arg(Gt)-acos((1-abs(Gt)^2-gcircle*(1+abs(Gt)^2))/(2*gcircle*abs(Gt)));
            ELen=mod(ELen,2*pi); % elecrical length greater than zero
            G_out=Gt*exp(-j*ELen);
            z_in=G2z(G_out);
            l_lambda=ELen/(4*pi);
            tA=linspace(0,-ELen,20);
            plot(Gt.*exp(i*tA),'Color','g','>'); %plot the path in the ref coef plane
          %determine length to get to the gcircle
        elseif nargin==2
              %make sure its close enough on the const G circle
            if (abs(Gt)^2-abs(G_start)^2)>1e-5
                errordlg("Cannot Be Matched with a line displacement.");
                return;
            endif
            %check that its not the same point on the circle
            if abs(arg(Gt)-arg(G_start))<1e-5
                errordlg("You aren't designing anything.");
                return;
            endif;
            alpha=mod(arg(Gt),2*pi);  %target angle
            beta=mod(arg(G_start),2*pi); %begining angle
            ELen=mod(beta-alpha,2*pi);    %elecrical length is mod 2*pi
            G_out=G_start*exp(-j*ELen);   %calculate G_out, shoud be Gt
            z_in=G2z(G_out);              %calculate the impedance looking into the stage
            l_lambda=ELen/(4*pi);         %calculate length in wavelengths
            tA=linspace(0,-ELen,20);
            plot(G_start.*exp(i*tA),'Color','g','>');  %plot in the G plane
        endif
