within AixLib.Fluid.Movers.Compressors.Utilities.IsentropicEfficiency.Generic;
model Poly_GeneralLiterature
  "Generic overall isentropic efficiency based on literature review for 
  various compressors"
  extends PolynomialIsentropicEfficiency(
    final polyMod=Types.IsentropicPolynomialModels.Engelpracht2017,
    final a={0.624648650065473, 1.942405219838358e-04,
             -3.318894570488234e-08, -0.002032592168203},
    final b={1,1,1,1});

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
This model contains a calculation procedure for the isentropic efficiency
presented by Engelpracht (2017). However, this approach is just fitted
to various experimental data obtained by a literature review and, 
therefore, to use with caution.<br />
</p>
<table summary=\"Polynomial approaches\" border=\"1\" cellspacing=\"0\" 
cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Reference</th>
<th>Formula</th> 
<th>Refrigerants</th> 
<th>Validity <code>n<sub>compressor</sub></code></th> 
<th>Validity <code>&Pi;<sub>pressure</sub></code></th> 
</tr> 
<tr>
<td>Engelpracht2017</td> 
<td><code>&eta;<sub>ise</sub> = a1 + a2*n + 
a3*n^3 + a5*&pi;^2 </code></td> 
<td>Generic model</td> 
<td><code>0 - 120</code></td> 
<td><code>1 - 10</code></td> 
</tr> 
</table>
<h4>References</h4>
<p>
Engelpracht, Mirko (2017): Development of modular and scalable simulation
models for heat pumps and chillers considering various refrigerants.
<i>Master Thesis</i>
</p>
</html>"));
end Poly_GeneralLiterature;
