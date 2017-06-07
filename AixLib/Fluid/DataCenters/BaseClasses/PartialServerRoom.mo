within AixLib.Fluid.DataCenters.BaseClasses;
partial model PartialServerRoom
  extends AixLib.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.SIunits.Temperature T_start=295.15
    "Initial temperature for all components" annotation(Dialog(tab="Advanced",group="Initialization"));

  parameter Modelica.SIunits.ThermalResistance RExtRem=0.0427487
    "Resistor Rest outer wall"
    annotation(Dialog(tab="Outer walls"));
  parameter Modelica.SIunits.ThermalResistance RExt=0.004366
    "Resistor 1 outer wall"
    annotation(Dialog(tab="Outer walls"));
  parameter Modelica.SIunits.HeatCapacity CExt=1557570 "Capacity 1 outer wall"
    annotation(Dialog(tab="Outer walls"));
  parameter Modelica.SIunits.Area AExt=238.5 "Outer wall area"
    annotation(Dialog(tab="Outer walls"));

  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExt=2.7
    "Outer wall's coefficient of heat transfer (inner side)"
    annotation(Dialog(tab="Outer walls"));

  parameter Modelica.SIunits.Temperature Tmax = 313.15
    "Maximum allowable temperature in the room before a shutdown signal";
  parameter Modelica.Media.Interfaces.Types.MassFraction X_start[Medium.nX]=
      Medium.X_default "Start value of mass fractions m_i/m" annotation(Dialog(tab="Advanced",group="Initialization"));

  ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall outerwall(
    port_b(T(
        nominal=293.15,
        min=278.15,
        max=323.15)),
    n=1,
    RExtRem=RExtRem,
    T_start=T_start,
    RExt={RExt},
    CExt={CExt})
    annotation (Placement(transformation(extent={{-68,40},{-50,60}})));

  AixLib.Utilities.HeatTransfer.HeatConv heatConvOuterwall(
                  A=AExt, alpha=alphaExt)
    annotation (Placement(transformation(extent={{-24,40},{-44,60}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a equalAirTemp  annotation (Placement(transformation(extent={{-110,70},{-70,110}}),
                   iconTransformation(extent={{-120,80},{-100,100}})));

  Modelica.Blocks.Interfaces.BooleanOutput emergencyStop
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput T_room
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=Tmax)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,70})));
  Modelica.Fluid.Vessels.ClosedVolume volumeInlet(
    redeclare package Medium = Medium,
    use_portsData=false,
    nPorts=1,
    each X_start=X_start,
    V=56.25,
    T_start=T_start) "Volume of the false floor or liquid dispenser"
    annotation (Placement(transformation(extent={{-10,-80},{10,-100}})));
  Modelica.Fluid.Vessels.ClosedVolume volumeRoom(
    redeclare package Medium = Medium,
    use_portsData=false,
    use_HeatTransfer=true,
    each X_start=X_start,
    nPorts=1,
    V=55,
    T_start=T_start)
              annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
equation
    connect(equalAirTemp, outerwall.port_a) annotation (Line(
        points={{-90,90},{-80,90},{-80,49.0909},{-68,49.0909}},
        color={191,0,0}));
    connect(outerwall.port_b, heatConvOuterwall.port_b) annotation (Line(
        points={{-50,49.0909},{-46.5,49.0909},{-46.5,50},{-44,50}},
        color={191,0,0}));

  connect(greaterThreshold.u, T_room)
    annotation (Line(points={{80,58},{80,50},{110,50}}, color={0,0,127}));
  connect(greaterThreshold.y, emergencyStop) annotation (Line(points={{80,81},{80,
          81},{80,90},{110,90}}, color={255,0,255}));
  connect(volumeRoom.heatPort, heatConvOuterwall.port_a) annotation (Line(
        points={{-10,80},{-16,80},{-16,50},{-24,50}}, color={191,0,0}));
  connect(port_a, volumeInlet.ports[1]) annotation (Line(points={{-100,0},{-100,
          0},{-100,-80},{0,-80}}, color={0,127,255}));

  connect(temperature.port_b, port_b) annotation (Line(points={{50,40},{100,40},
          {100,0},{100,0}},
                          color={0,127,255}));
  connect(temperature.T, T_room)
    annotation (Line(points={{40,51},{40,50},{110,50}}, color={0,0,127}));
  connect(volumeRoom.ports[1], temperature.port_a) annotation (Line(points={{0,70},{
          2,70},{2,40},{30,40}},      color={0,127,255}));
    annotation (
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}}),
         graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-92,92},{92,-92}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,60},{-36,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,60},{-14,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,60},{8,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,60},{30,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,60},{52,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-16},{-36,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,-16},{-14,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,-16},{8,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,-16},{30,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,-16},{52,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>ReducedOrderModel is a simple component to compute the air temperature, heating load, etc. for a thermal zone. The zone is simplified to one outer wall, one inner wall and one air node. It is build out of standard components and <a href=\"AixLib.Building.LowOrder.BaseClasses.SimpleOuterWall\">SimpleOuterWall</a> and <a href=\"AixLib.Building.LowOrder.BaseClasses.SimpleInnerWall\">SimpleInnerWall</a>. </p>
<p>The partial class contains following components: </p>
<ul>
<li>inner and outer walls</li>
<li>windows</li>
<li>convective heat transfer of the walls and windows</li>
<li>influence of air temperature caused by infiltration</li>
<li>connectors for internal gains (conv. and rad.) </li>
</ul>
<h4>Main equations</h4>
<p>The concept is described in VDI 6007. All equations can be found in VDI 6007. All outer walls and inner walls (including the windows) are merged together to one wall respectively. The inner walls are used as heat storages only, there is no heat transfer out of the zone (adiabate). This assumption is valid as long as the walls are in the zone or touch zones with a similar temperature. All walls, which touch other thermal zones are put together in the outer walls, which have an heat transfer with <a href=\"AixLib.Building.LowOrder.BaseClasses.EqAirTemp\">EqAirTemp</a>.</p>
<h4>Assumption and limitations</h4>
<p>The simplifications are based on the VDI 6007, which describes the thermal behaviour of a thermal zone with the equations for an electric circuit, hence they are equal. The heat transfer is described with resistances and the heat storage with capacitances. </p>
<h4>Typical use and important parameters</h4>
<p>The resolution of the model is very rough (only one air node), so the model is primarly thought for computing the air temperature of the room and with that, the heating and cooling load. It is more a heat load generator than a full building model. It is thought mainly for city district simulations, in which a lot of buildings has to be taken into account and the specific cirumstances in one building can be neglected.</p>
<p>Inputs: The model needs the outdoor air temperature and the Infiltration/VentilationRate for the Ventilation, the equivalent outdoor temperature (see <a href=\"AixLib.Building.LowOrder.BaseClasses.EqAirTemp.partialEqAirTemp\">EqAirTemp</a>) for the heat conductance through the outer walls and the solar radiation through the windows. There are two ports, one thermal, one star, for inner loads, heating etc. . </p>
<p>Parameters: Inner walls: R and C for the heat conductance and storage in the wall, A, alpha and epsilon for the heat transfer. Outer walls: Similar to inner walls, but with two R&apos;s, as there is also a conductance through the walls. Windows: g, A, epsilon and a splitfac. Please see VDI 6007 for computing the R&apos;s and C&apos;s</p>
<h4>Options</h4>
<ul>
<li>Only outer walls are considered</li>
<li>Outer and inner walls are considered </li>
<li>Outer and inner walls as well as windows are considered </li>
</ul>
<h4>Validation</h4>
<p>The model is verified with the VDI 6007, see <a href=\"AixLib.Building.LowOrder.Validation.VDI6007\">Validation.VDI6007</a>. A validation with the use of the standard ASHRAE 140 is in progress </p>
<h4>Implementation</h4>
<h4>References</h4>
<ul>
<li>German Association of Engineers: Guideline VDI 6007-1, March 2012: Calculation of transient thermal response of rooms and buildings - Modelling of rooms.</li>
<li>Lauster, M.; Teichmann, J.; Fuchs, M.; Streblow, R.; Mueller, D. (2014): Low order thermal network models for dynamic simulations of buildings on city district scale. In: Building and Environment 73, p. 223&ndash;231. DOI: 10.1016/j.buildenv.2013.12.016.</li>
</ul>
</html>", revisions="<html>
<ul>
<li><i>June 2015,&nbsp;</i> by Moritz Lauster:<br>Changed name solar radiation input from u1 to solRad_in.</li>
</ul>
<ul>
<li><i>October 2014,&nbsp;</i> by Peter Remmen:<br>Implemented.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end PartialServerRoom;
