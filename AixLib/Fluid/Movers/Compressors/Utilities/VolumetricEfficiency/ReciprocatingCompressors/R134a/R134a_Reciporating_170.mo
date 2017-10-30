﻿within AixLib.Fluid.Movers.Compressors.Utilities.VolumetricEfficiency.ReciprocatingCompressors.R134a;
model R134a_Reciporating_170
  "Reciporating Compressor - R134a - 170 cm³ - Polynomial"
  extends PolynomialVolumetricEfficiency(
    final polyMod=Types.VolumetricPolynomialModels.Li2013,
    final rotSpeRef=2000/60,
    final a={1.223,-0.206,-0.017},
    final b={1,1,1},
    final c={0.779,-0.036,0});

  annotation (Documentation(revisions="<html>
<ul>
  <li>
  October 23, 2017, by Mirko Engelpracht:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/467\">issue 467</a>).
  </li>
</ul>
</html>", info="<html>
<p>
This model contains a calculation procedure for the isentropic 
efficiency presented by Li (2013).<br />
</p>
<table summary=\"Power approaches\" border=\"1\" cellspacing=\"0\" 
cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Reference</th>
<th>Formula</th> 
<th>Refrigerants</th> 
<th>Validity <code>n<sub>compressor</sub></code></th> 
<th>Validity <code>&Pi;<sub>pressure</sub></code></th> 
</tr> 
<tr>
<td>Li2013</td> 
<td><code>&eta;<sub>vol</sub> = &eta;<sub>volRef</sub> * 
(a1 + a2*(n/n<sub>ref</sub>) + a3*(n/n<sub>ref</sub>)^2)
</code></td> 
<td>R22,R134a</td> 
<td><code>30 - 120</code></td> 
<td><code>4 - 12</code></td> 
</tr> 
</table>
<h4>References</h4>
<p>
W. Li (2013): 
<a href=\"http://www.merl.com/publications/docs/TR2017-055.pdf\">
Simplified steady-state modeling for variable speed compressor</a>. 
In: <i>Applied Thermal Engineering 50(1)</i>, S. 318&ndash;326
</p>
</html>"));
end R134a_Reciporating_170;