%[MAGNITUDE,ANGLE]=C_2_Phasor(z)
%  Convert a complex floating point to engineering Notation MAGNITUDE/__ANGLE (in degrees)
%  SYNTAX:
%     z=phasor(MAGNITUDE,ANGLE)
%  INPUT ARGUMENTS:
%     MAGNITUDE|___ANGLE (in degrees)   : a phasor in engineering notation
%
%  OUTPUT ARGUMENTS:
%       w: a complex scalar real(w) is the magnitude imag is the phase in degrees

function w=C_2_Phasor(z)
              z1=log(z);
              w=exp(real(z1))+j*imag(z1)*180/pi;
