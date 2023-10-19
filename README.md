# RF-Match-Designer-Octave-Matlab
### Overview
<p>
An RF matching tool, featuring T or $\Pi$ &nbsp;   Q Selecting Networks in yz Smithchart.  Running RF_Match_Designer.m in Octave, (or Matlab?) will Launch a gui that will aid in the design a matching network including lumped elements, including specified Q eiter T or $\Pi$ matching networks. $\dfrac{\lambda}{4}$ Transformer design from a user entered load impedance, real or complex will be designed, to a specified $\Gamma_{target}$ should a solution exist.  </p>

![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Screenshot_20231012_005042.png)

### User Guide

<p> In <b>all</b> cases a dialog box will confirm you have matched, in advanced mode depending on the location of the current $z_{IN}$ both choices of sign may result in two positive solutions for reactance jx or jb, or both negative.  Sometimes the complex conjugate of the reflection coefficent will be solved for.  If that happens, use the Go Back One pushbutton, and choose the other sign.</p> 

For non Q selecting matching networks, enter the load impedance, and the target reflection coefficent
![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv1.png)
 <p> <b>Push the Enter/Update button after entering </b>$z_{L}$ and $\Gamma_{target}$   shown as Gs/GL, for this example, a shunt capacitance is chosen by selecting the + sign for a positive admmitance, the parrallel reactance $jx=\frac{1}{jb}$ </p>
 
![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv2.png)
<p>
The calculated shunt admittance is shown below the load impedance, the reflection coefficent looking into the load plus the most recent designed stage, zIN, and yIN are displayed at the lower left.  In this example the magnitude of the reflection coefficent shown as |GIN|=  $|\Gamma_{target}|$  the Magnitude of Gs/GL. 
A line displacement is neccessary now, a movement along the circle, to get to the target. </p>

![Alt](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv3.png)
<p>The sketch, illustrates the output table, the output parameters listed in the table correspond to elements from zL to the targeted reflection coefficent.</p>
<p> A shunt admittance, line displacement is one way to match.  The match may also be achieved with a $\frac{\lambda}{4}$ and a line displacement  Hit the Go Back One Pushbutton twice to start over.  You can see if a $\frac{\lambda}{4}$ match exists by selecting the Wave/4 in the popup menu, and hitting design.  At the moment a 50 $\Omega$ line is assumed. </p>  

![](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv4.png)

<p>As in the last example, a line displacement will achive a match</p>

![](https://github.com/john6h2/RF-Match-Designer-Octave/blob/main/Docs/images/nonadv5.png)
