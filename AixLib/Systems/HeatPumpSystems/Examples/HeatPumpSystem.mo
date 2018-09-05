within AixLib.Systems.HeatPumpSystems.Examples;
model HeatPumpSystem "Example for a heat pump system"
  import AixLib;

  AixLib.Systems.HeatPumpSystems.HeatPumpSystem heatPumpSystem(
    redeclare package Medium_con =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    mFlow_evaNominal=1,
    dpEva_nominal=0,
    dpCon_nominal=0,
    use_conPum=false,
    use_evaPum=false,
    GEva=1,
    GCon=1,
    redeclare package Medium_eva =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    use_comIne=false,
    comIneTime_constant=0,
    maxRunPerHou=2,
    CEva=8000,
    CCon=8000,
    scalingFactor=1,
    redeclare model PerDataHea =
        AixLib.Fluid.HeatPumps.BaseClasses.PerformanceData.LookUpTable2D (
          final dataTable=AixLib.DataBase.HeatPump.EN255.Vitocal350AWI114()),
    use_runPerHou=false,
    use_sec=true,
    use_minRunTime=true,
    use_opeEnv=true,
    minIceFac=0.5,
    minRunTime(displayUnit="min") = 1800,
    tableUpp=[-15,60; 35,60],
    tableLow=[-15,0; 35,0],
    use_minLocTime=true,
    minLocTime(displayUnit="min") = 3000,
    use_revHP=false,
    VCon=0.1,
    VEva=0.1,
    addPowerToMediumEva=false,
    addPowerToMediumCon=false,
    hys=2,
    mFlow_conNominal=20000/4180/5,
    calcQdot(mediumConc_p=4180),
    calcCOP(
      n_QHeat=1,
      lowBouPel=200),
    use_deFro=false,
    use_chiller=false,
    calcPel_deFro=0)
    annotation (Placement(transformation(extent={{4,-82},{56,-34}})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    V=40,
    m_flow_nominal=40*6/3600)
    annotation (Placement(transformation(extent={{86,34},{106,54}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/40)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{38,54},{58,74}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{38,84},{58,104}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*40*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{78,64},{98,84}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[-6*3600,0; 8*3600,4000; 18*3600,0])
                          "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-2,84},{18,104}})));
  AixLib.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_a_nominal(displayUnit="degC") = 323.15,
    dp_nominal=0,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=20000/4180/5,
    Q_flow_nominal=20000,
    T_start=293.15,
    T_b_nominal=318.15,
    TAir_nominal=293.15,
    TRad_nominal=293.15)         "Radiator"
    annotation (Placement(transformation(extent={{38,2},{18,22}})));

  AixLib.Fluid.Sources.FixedBoundary preSou(
    nPorts=2,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    T=293.15)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{-38,-32},{-18,-12}})));

  AixLib.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://AixLib/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-118,52},{-98,72}})));
  AixLib.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-78,52},{-58,72}}),
        iconTransformation(extent={{-78,52},{-58,72}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-2,54},{18,74}})));
  AixLib.Fluid.Sources.FixedBoundary sou(
    use_T=true,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    T=281.15) "Fluid source on source side"
    annotation (Placement(transformation(extent={{102,-100},{82,-80}})));

  AixLib.Fluid.Sources.FixedBoundary sin(
    use_T=true,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    T=283.15) "Fluid sink on source side"
    annotation (Placement(transformation(extent={{-48,-100},{-28,-80}})));

equation

  connect(theCon.port_b,vol. heatPort) annotation (Line(
      points={{58,64},{68,64},{68,44},{86,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port,vol. heatPort) annotation (Line(
      points={{58,94},{68,94},{68,44},{86,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port,vol. heatPort) annotation (Line(
      points={{88,64},{68,64},{68,44},{86,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1],preHea. Q_flow) annotation (Line(
      points={{19,94},{38,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rad.heatPortCon,vol. heatPort) annotation (Line(
      points={{30,19.2},{30,44},{86,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad,vol. heatPort) annotation (Line(
      points={{26,19.2},{26,44},{86,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-98,62},{-68,62}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul,TOut. T) annotation (Line(
      points={{-68,62},{-34,62},{-34,64},{-4,64}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port,theCon. port_a) annotation (Line(
      points={{18,64},{38,64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], heatPumpSystem.port_a2)
    annotation (Line(points={{82,-90},{43,-90},{43,-82}}, color={0,127,255}));
  connect(sin.ports[1], heatPumpSystem.port_b2) annotation (Line(points={{-28,-90},
          {16,-90},{16,-82},{17,-82}}, color={0,127,255}));
  connect(heatPumpSystem.port_b1, rad.port_a) annotation (Line(points={{43,-34},
          {43,0},{74,0},{74,12},{38,12}}, color={0,127,255}));
  connect(rad.port_b, preSou.ports[1]) annotation (Line(points={{18,12},{-8,12},
          {-8,-20},{-18,-20}}, color={0,127,255}));
  connect(preSou.ports[2], heatPumpSystem.port_a1)
    annotation (Line(points={{-18,-24},{17,-24},{17,-34}}, color={0,127,255}));
  connect(weaBus.TDryBul, heatPumpSystem.T_oda) annotation (Line(
      points={{-68,62},{-58,62},{-58,-42.2},{0.75,-42.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">Overview</span></h4>
<p>Simple test set-up for the HeatPumpDetailed model. The heat pump is turned on and off while the source temperature increases linearly. Outputs are the electric power consumption of the heat pump and the supply temperature. </p>
<p>Besides using the default simple table data, the user should also test tabulated data from <a href=\"modelica://AixLib.DataBase.HeatPump\">AixLib.DataBase.HeatPump</a> or polynomial functions.</p>
</html>",
      revisions="<html>
 <ul>
  <li>
  May 19, 2017, by Mirko Engelpracht:<br/>
  Added missing documentation (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/391\">issue 391</a>).
  </li>
  <li>
  October 17, 2016, by Philipp Mehrfeld:<br/>
  Implemented especially for comparison to simple heat pump model.
  </li>
 </ul>
</html>
"), __Dymola_Commands(file="Modelica://AixLib/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/HeatPump.mos" "Simulate and plot"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-120,-120},{120,120}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-38,64},{68,-2},{-38,-64},{-38,64}})}));
end HeatPumpSystem;