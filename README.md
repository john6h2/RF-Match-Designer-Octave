# RF-Match-Designer-Octave-Matlab
### Overview
An RF matching tool, featuring T or $\Pi$ &nbsp;   Q Selecting Networks in yz Smithchart.  Running RF_Match_Designer.m in Octave, (or Matlab?) will Launch a gui that will aid in the design a matching network including lumped elements, including specified Q eiter T or $\Pi$ matching networks. $\dfrac{\lambda}{4}$ Transformer design from a user entered load impedance, real or complex will be designed, to a specified $\Gamma_{target}$ should a solution exist.  
![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Screenshot_20231012_005042.png)

### User Guide
For non Q selecting matching networks, enter the load impedance, and the target reflection coefficent
![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv1.png)
 Push the Enter/Update button after entering $z_{L}$ and $\Gamma_{target}$ shown as Gs/GL, for this example, a shunt capacitance is chosen by selecting the + sign for a positive admmitance, the parrallel reactance $jx=\frac{1}{jb}$
![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv2.png)
The calculated shunt admittance is shown below the load impedance, the reflection coefficent looking into the load plus the most recent designed stage, zIN, and yIN are displayed at the lower left.  In this example the magnitude of the reflection coefficent shown as GIN matches the $\Gamma_{target} 
