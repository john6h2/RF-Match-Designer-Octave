%get reflection coefficient from imput impedance
function z=G2z(G)
  z=(1+G)./(1-G+eps+j*eps);
