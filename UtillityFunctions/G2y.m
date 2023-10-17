%get imput admittance from reflection coefficient
function y=G2y(G)
  y=(1-G)./(1+G);