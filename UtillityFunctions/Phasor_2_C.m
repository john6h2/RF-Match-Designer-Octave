%z=Phasor2_C(MAGNITUDE,ANGLE)
%  A glorified degrees to radians converter, a helpful book keeping function
%  SYNTAX:
%     z=phasor(MAGNITUDE,ANGLE)
%  INPUT ARGUMENTS:
%     MAGNITUDE|___ANGLE (in degrees)       : a phasor in engineering notation
%
%  OUTPUT ARGUMENTS:
%       z:   a complex scalar

function z=Phasor_2_C(MAGNITUDE,ANGLE)
          z=MAGNITUDE*exp(i*ANGLE*pi/180);
