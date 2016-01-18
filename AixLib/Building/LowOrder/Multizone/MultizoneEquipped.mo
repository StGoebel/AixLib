within AixLib.Building.LowOrder.Multizone;
model MultizoneEquipped
  "Multizone with basic heat supply system, air handling unit, an arbitrary number of thermal zones (vectorized), and ventilation"
  extends AixLib.Building.LowOrder.Multizone.partialMultizone;
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAirAHUAvg
    "Averaged air temperature of the zones which are supplied by the AHU" annotation (Placement(transformation(extent={{16,-28},
            {8,-20}})));
  BaseClasses.ThermSplitter splitterThermPercentAir(dimension=buildingParam.numZones,
      splitFactor=AixLib.Building.LowOrder.BaseClasses.ZoneFactorsZero(buildingParam.numZones, zoneParam)) annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={26,-24})));
  Modelica.Blocks.Interfaces.RealInput AHU[4]
    "Input for AHU Conditions [1]: Desired Air Temperature in K [2]: Desired minimal relative humidity [3]: Desired maximal relative humidity [4]: Schedule Desired Ventilation Flow"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,-16}), iconTransformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={43,-93})));
  Utilities.Sources.HeaterCooler.HeaterCoolerPI heaterCooler[buildingParam.numZones](
    zoneParam=zoneParam,
    each recOrSep=true,
    each staOrDyn=true) "Heater Cooler with PI control"
    annotation (Placement(transformation(extent={{-32,-64},{-6,-38}})));
  Modelica.Blocks.Interfaces.RealInput TSetHeater[buildingParam.numZones](
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Set point for heater"
                           annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=270,
        origin={-20,-100}), iconTransformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-94,6})));
  HVAC.AirHandlingUnit.AHU AirHandlingUnit(
    BPF_DeHu=buildingParam.BPF_DeHu,
    HRS=buildingParam.HRS,
    efficiencyHRS_enabled=buildingParam.efficiencyHRS_enabled,
    efficiencyHRS_disabled=buildingParam.efficiencyHRS_disabled,
    heating=buildingParam.heatingAHU,
    cooling=buildingParam.coolingAHU,
    dehumidification=buildingParam.dehumidificationAHU,
    humidification=buildingParam.humidificationAHU) "Air Handling Unit"
    annotation (Placement(transformation(extent={{-54,-24},{22,46}})));
  BaseClasses.AirFlowRate airFlowRate(
    zoneParam=zoneParam,
    dimension=buildingParam.numZones,
    withProfile=true) annotation (Placement(transformation(extent={{-72,6},{-60,22}})));
  Modelica.Blocks.Interfaces.RealInput TSetCooler[buildingParam.numZones](
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Set point for cooler"
                           annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=270,
        origin={-48,-100}), iconTransformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-94,-22})));
  Modelica.Blocks.Interfaces.RealOutput Pel(
   final quantity="Power",
   final unit="W") "The consumed electrical power supplied from the mains"
                                                            annotation (
      Placement(transformation(extent={{94,6},{114,26}}), iconTransformation(
          extent={{100,12},{114,26}})));
  Modelica.Blocks.Interfaces.RealOutput HeatingPowerAHU(
   final quantity="HeatFlowRate",
   final unit="W") "The absorbed heating power supplied from a heating circuit"
                                                                 annotation (Placement(transformation(extent={{94,-14},{114,6}}),
        iconTransformation(extent={{100,-8},{114,6}})));
  Modelica.Blocks.Interfaces.RealOutput CoolingPowerAHU(
   final quantity="HeatFlowRate",
   final unit="W") "The absorbed cooling power supplied from a cooling circuit"
                                                                 annotation (Placement(transformation(extent={{94,-32},{114,-12}}),
        iconTransformation(extent={{100,-26},{114,-12}})));
  Modelica.Blocks.Interfaces.RealOutput HeatingPowerHeater[size(
    heaterCooler, 1)](
   final quantity="HeatFlowRate",
   final unit="W") "Power for heating" annotation (Placement(
        transformation(extent={{90,-54},{110,-34}}), iconTransformation(extent={{100,-52},
            {114,-38}})));
  Modelica.Blocks.Interfaces.RealOutput CoolingPowerCooler[size(
    heaterCooler, 1)](
   final quantity="HeatFlowRate",
   final unit="W") "Power for cooling" annotation (Placement(
        transformation(extent={{94,-76},{114,-56}}), iconTransformation(extent={{100,-70},
            {114,-56}})));
  BaseClasses.Split splitterVolumeFlowVentilation(nout=buildingParam.numZones,
      coefficients=AixLib.Building.LowOrder.BaseClasses.ZoneFactorsZero(
        buildingParam.numZones, zoneParam))
    "splits the volume flow rate from the AHU into parts for each zone (weighted with VAir/VAirTot)"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={48,24})));
  Modelica.Blocks.Routing.Replicator replicatorTemperatureVentilation(nout=
        buildingParam.numZones)
    "replicates scalar temperature of AHU into a vector[numZones] of identical temperatures"
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={23,39})));
  Modelica.Blocks.Math.Gain conversion(k=3600/buildingParam.Vair)
    "converts m3/s into 1/h" annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={48,10})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=1, uMax=1000)
    annotation (Placement(transformation(extent={{0,-28},{-8,-20}})));
equation
  for i in 1:buildingParam.numZones loop
    connect(internalGains[(i*3)-2], airFlowRate.relOccupation[i]) annotation (Line(
      points={{76,-100},{74,-100},{74,-34},{-76,-34},{-76,10.8},{-72,10.8}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;
  connect(AHU[1], replicatorTemperatureVentilation.u) annotation (Line(
      points={{-100,-1},{-100,-8},{23,-8},{23,33}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(splitterThermPercentAir.signalOutput, zone.internalGainsConv) annotation (Line(
      points={{30,-24},{60,-24},{60,43.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirAHUAvg.port, splitterThermPercentAir.signalInput) annotation (
      Line(
      points={{16,-24},{22,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(AirHandlingUnit.T_outdoorAir, weather[1]) annotation (Line(
      points={{-49.44,9.44444},{-56,9.44444},{-56,115}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weather[2], AirHandlingUnit.X_outdoorAir) annotation (Line(
      points={{-56,105},{-56,5.55556},{-49.44,5.55556}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AHU[1], AirHandlingUnit.T_supplyAir) annotation (Line(
      points={{-100,-1},{-100,-2},{20,-2},{20,11},{15.92,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airFlowRate.airFlowRateOutput, AirHandlingUnit.Vflow_in) annotation (
      Line(
      points={{-60,14},{-58,14},{-58,11.7778},{-52.48,11.7778}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AHU[4], airFlowRate.profile) annotation (Line(
      points={{-100,-31},{-100,18},{-72,18},{-72,17.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AHU[2], AirHandlingUnit.phi_supplyAir[1]) annotation (Line(
      points={{-100,-11},{-100,-2},{18,-2},{18,6},{15.92,6},{15.92,7.88889}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AHU[3], AirHandlingUnit.phi_supplyAir[2]) annotation (Line(
      points={{-100,-21},{-100,-2},{18,-2},{18,6},{15.92,6},{15.92,6.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetCooler, heaterCooler.setPointCool) annotation (Line(points={{-48,-100},
          {-48,-66},{-22.12,-66},{-22.12,-60.36}}, color={0,0,127}));
  connect(TSetHeater, heaterCooler.setPointHeat) annotation (Line(points={{-20,-100},
          {-22,-100},{-22,-68},{-16.14,-68},{-16.14,-60.36}}, color={0,0,127}));
  connect(heaterCooler.heatCoolRoom, zone.internalGainsConv) annotation (Line(
        points={{-7.3,-56.2},{26,-56.2},{26,-48},{60,-48},{60,43.4}},
                                                  color={191,0,0}));
  connect(AirHandlingUnit.Pel, Pel) annotation (Line(points={{7.94,2.05556},{8,
          2.05556},{8,2},{56,2},{80,2},{80,16},{104,16}},
                                                 color={0,0,127}));
  connect(AirHandlingUnit.QflowH, HeatingPowerAHU) annotation (Line(points={{-0.42,
          2.05556},{-0.42,-6},{80,-6},{80,-4},{104,-4}}, color={0,0,127}));
  connect(AirHandlingUnit.QflowC, CoolingPowerAHU) annotation (Line(points={{-17.14,
          2.05556},{-17.14,-32},{90,-32},{90,-32},{90,-22},{104,-22}},
                                                              color={0,0,127}));
  connect(heaterCooler.HeatingPower, HeatingPowerHeater) annotation (Line(
        points={{-6,-45.8},{38,-45.8},{38,-44},{100,-44}}, color={0,0,127}));
  connect(heaterCooler.CoolingPower, CoolingPowerCooler) annotation (Line(
        points={{-6,-51.78},{12,-51.78},{12,-52},{36,-52},{36,-66},{104,-66}},
        color={0,0,127}));
  connect(splitterVolumeFlowVentilation.y, zone.ventilationRate) annotation (
      Line(
      points={{48,30.6},{48,43},{52,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicatorTemperatureVentilation.y, zone.ventilationTemperature)
    annotation (Line(points={{23,44.5},{23,47.2},{45,47.2}}, color={0,0,127}));
  connect(conversion.y, splitterVolumeFlowVentilation.u)
    annotation (Line(points={{48,14.4},{48,14.4},{48,16.8}}, color={0,0,127}));
  connect(conversion.u, AirHandlingUnit.Vflow_out) annotation (Line(points={{48,5.2},
          {48,4},{28,4},{28,28},{-60,28},{-60,21.8889},{-52.48,21.8889}},
        color={0,0,127}));
  connect(AirHandlingUnit.phi_supply, AirHandlingUnit.phi_extractAir)
    annotation (Line(points={{15.92,16.4444},{20,16.4444},{20,21.8889},{15.92,
          21.8889}},
        color={0,0,127}));
  connect(TAirAHUAvg.T, limiter.u)
    annotation (Line(points={{8,-24},{4,-24},{0.8,-24}}, color={0,0,127}));
  connect(limiter.y, AirHandlingUnit.T_extractAir) annotation (Line(points={{-8.4,
          -24},{-12,-24},{-12,-14},{26,-14},{26,25.7778},{15.92,25.7778}},
        color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics={
        Rectangle(
          extent={{-66,30},{32,-36}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={212,221,253}),
        Rectangle(
          extent={{-66,-38},{32,-70}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,-8},{-20,-22}},
          lineColor={0,0,255},
          fillColor={212,221,253},
          fillPattern=FillPattern.Solid,
          textString="Air Conditioning"),
        Text(
          extent={{-64,-48},{-36,-58}},
          lineColor={0,0,255},
          fillColor={212,221,253},
          fillPattern=FillPattern.Solid,
          textString="Heating
Cooling")}),
    Documentation(revisions="<html>
<ul>
<li><i>June 22, 2015&nbsp;</i> by Moritz Lauster:<br>Changed building physics to AixLib</li>
<li><i>April 25, 2014&nbsp;</i> by Ole Odendahl:<br>Implemented</li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is a multizone model with a variable number of thermal zones. It adds heater/cooler devices and an air handling unit. Outputs are the thermal demands of the zone heating as well as thermal and electrical demand of the air handling unit. This model is pre-configured and ready-to-use. The<a href=\"AixLib.Building.LowOrder.Multizone.partialMultizone\"> partial class</a> has a replaceable<a href=\"AixLib.Building.LowOrder.ThermalZone\"> thermal zone</a> model, due to the functionalities, <a href=\"AixLib.Building.LowOrder.ThermalZone.ThermalZoneEquipped\">ThermalZoneEquipped</a> is the most suitable recommendation.</span></p>
</html>"));
end MultizoneEquipped;
