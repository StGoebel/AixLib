within AixLib.Fluid.DistrictHeatingCooling.Supplies.OpenLoop;
model SourceMFlow
  "Simple supply node model with prescribed mass flow rate"
  extends BaseClasses.Supplies.OpenLoop.PartialSupplyLessInputs;

  parameter Modelica.SIunits.AbsolutePressure pReturn
    "Fixed return pressure";


  Sources.MassFlowSource_T         source(          redeclare package Medium =
        Medium,
    use_m_flow_in=true,
    use_T_in=false,
    T=6 + 273.15,
    nPorts=1)
    "Ideal fluid source with prescribed temperature and pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,0})));

  Sources.FixedBoundary sink(redeclare package Medium = Medium,
    p=pReturn,
    nPorts=1)
    "Ideal sink for return from the network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={18,0})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_input(unit="W")
    "Prescribed heat flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,104}), iconTransformation(extent={{-10,50},{30,90}})));
  Modelica.Blocks.Math.Gain gain(k=1/(cp_default*6))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,52})));

protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

equation
  connect(gain.y, source.m_flow_in)
    annotation (Line(points={{0,41},{0,-8},{-20,-8}},
                                                   color={0,0,127}));
  connect(Q_flow_input, gain.u)
    annotation (Line(points={{0,104},{0,64}}, color={0,0,127}));
  connect(senT_return.port_b, source.ports[1])
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(sink.ports[1], senT_supply.port_a)
    annotation (Line(points={{28,0},{40,0}}, color={0,127,255}));
  annotation (Icon(graphics={Ellipse(
          extent={{-78,40},{2,-40}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>
March 17, 2018, by Marcus Fuchs:<br/>
Implemented for <a href=\"https://github.com/RWTH-EBC/AixLib/issues/402\">issue 403</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model is a quick draft of a supply model with prescribed mass flow rate
calculated from a heat flow rate input. This can be used in place of a demand
node to represent a supply with prescribed mass flow rate. 

We needed this for a quick prototype, but the model will likely be replaced 
by a better one soon.
</p>
</html>"));
end SourceMFlow;