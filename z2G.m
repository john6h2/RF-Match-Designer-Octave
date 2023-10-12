%  G=z2G(z)
%
%   SYNOPSIS:
%       This function calculates the Reflection Coeffient
%  SYNTAX:
%
%  INPUT ARGUMENTS:
%     z   : The normalized impedance
%  OUTPUT ARGUMENTS:
%     G   : The Reflection coefficent of the impedance
%
%     John Hawkins - (10-09-2023)
function G=z2G(z)
  G=(z-1)./(z+1);
