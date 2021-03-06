within AixLib.Fluid.Sources;
model MassFlowSource_h
  "Ideal flow source that produces a prescribed mass flow with prescribed specific enthalpy, composition and trace substances"
  extends AixLib.Fluid.Sources.BaseClasses.PartialSource_m_flow;
  extends AixLib.Fluid.Sources.BaseClasses.PartialSource_h;
  extends AixLib.Fluid.Sources.BaseClasses.PartialSource_Xi_C;
  annotation (defaultComponentName="boundary",
    Documentation(info="<html>
<p>
Models an ideal flow source, with prescribed values of flow rate, specific enthalpy, composition and trace substances:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Prescribed specific enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>
If <code>use_m_flow_in</code> is false (default option),
the <code>m_flow</code> parameter
is used as boundary pressure, and the <code>m_flow_in</code>
input connector is disabled; if <code>use_m_flow_in</code>
is true, then the <code>m_flow</code> parameter is ignored,
and the value provided by the input connector is used instead.
</p>
<p>
The same applies to the specific enthalpy <i>h</i>, composition <i>X<sub>i</sub></i> or <i>X</i> and trace substances <i>C</i>.
</p>
<h4>Options</h4>
<p>
Instead of using <code>Xi_in</code> (the <i>independent</i> composition fractions),
the advanced tab provides an option for setting all
composition fractions using <code>X_in</code>.
<code>use_X_in</code> and <code>use_Xi_in</code> cannot be used
at the same time.
</p>
<p>
Parameter <code>verifyInputs</code> can be set to <code>true</code>
to enable a check that verifies the validity of the used specific enthalpy
and pressures.
This removes the corresponding overhead from the model, which is
a substantial part of the overhead of this model.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>
for more information.
</p>
<p>
Note, that boundary specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Made <code>medium</code> conditional and refactored inputs.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
when it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
Implemenation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end MassFlowSource_h;
