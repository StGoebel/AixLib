within AixLib.Utilities.Sources.HeaterCooler;
partial model partialHeaterCoolerPI
  extends AixLib.Utilities.Sources.HeaterCooler.partialHeaterCooler;
  parameter Real h_heater = 0 "upper limit controller output of the heater" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Real l_heater = 0 "lower limit controller output of the heater" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Real KR_heater = 1000 "Gain of the heating controller" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Modelica.SIunits.Time TN_heater = 1
    "Time constant of the heating controller" annotation(Dialog(tab = "Heater", group = "Controller",enable=not recOrSep));
  parameter Real h_cooler = 0 "upper limit controller output of the cooler"
                                                                           annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Real l_cooler = 0 "lower limit controller output of the cooler"          annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Real KR_cooler = 1000 "Gain of the cooling controller"
                                                                  annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Modelica.SIunits.Time TN_cooler = 1
    "Time constant of the cooling controller" annotation(Dialog(tab = "Cooler", group = "Controller",enable=not recOrSep));
  parameter Boolean recOrSep = false "Use record or seperate parameters" annotation(choices(choice =  false
        "Seperate",choice = true "Record",radioButtons = true));
  parameter AixLib.DataBase.Buildings.ZoneBaseRecord zoneParam annotation(choicesAllMatching=true,Dialog(enable=recOrSep));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Cooling annotation(Placement(transformation(extent={{26,-23},
            {6,-2}})));
  Control.PITemp pITempCool(
    RangeSwitch=false,
    h=if not recOrSep then h_cooler else zoneParam.h_cooler,
    l=if not recOrSep then l_cooler else zoneParam.l_cooler,
    KR=if not recOrSep then KR_cooler else zoneParam.KR_cooler,
    TN=if not recOrSep then TN_cooler else zoneParam.TN_cooler)
    "PI control for cooler"
    annotation (Placement(transformation(extent={{-20,-10},{0,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Heating annotation(Placement(transformation(extent={{26,22},
            {6,2}})));
  Control.PITemp pITempHeat(
    RangeSwitch=false,
    h=if not recOrSep then h_heater else zoneParam.h_heater,
    l=if not recOrSep then l_heater else zoneParam.l_heater,
    KR=if not recOrSep then KR_heater else zoneParam.KR_heater,
    TN=if not recOrSep then TN_heater else zoneParam.TN_heater)
    "PI control for heater" annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Interfaces.RealOutput HeatingPower "Power for heating"
    annotation (Placement(transformation(extent={{80,20},{120,60}}),
        iconTransformation(extent={{80,20},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput CoolingPower "Power for cooling"
    annotation (Placement(transformation(extent={{80,-26},{120,14}}),
        iconTransformation(extent={{80,-26},{120,14}})));
equation
  connect(Heating.port, heatCoolRoom) annotation (Line(
        points={{6,12},{2,12},{2,-40},{90,-40}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(pITempHeat.Therm1, heatCoolRoom) annotation (Line(
        points={{-16,11},{-16,-40},{90,-40}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(pITempCool.y, Cooling.Q_flow) annotation (Line(
        points={{-1,-20},{26,-20},{26,-12.5}},
        color={0,0,127},
        smooth=Smooth.None));
  connect(Cooling.port, heatCoolRoom) annotation (Line(
        points={{6,-12.5},{2.4,-12.5},{2.4,-40},{90,-40}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(pITempCool.Therm1, heatCoolRoom) annotation (Line(
        points={{-16,-11},{-16,-40},{90,-40}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(Heating.Q_flow, pITempHeat.y) annotation (Line(points={{26,12},{26,20},{-1,20}}, color={0,0,127}));
  connect(Heating.Q_flow, HeatingPower)
    annotation (Line(points={{26,12},{26,40},{100,40}}, color={0,0,127}));
  connect(Cooling.Q_flow, CoolingPower) annotation (Line(points={{26,-12.5},{56,
          -12.5},{56,-6},{100,-6}}, color={0,0,127}));
  annotation (Documentation(info = "<html>
 <h4><span style=\"color:#008000\">Overview</span></h4>
 <p>This is the base class of an ideal heater and/or cooler. It is used in full ideal heater/cooler models as an extension. It extends another base class and adds some basic elements.</p>
 </html>", revisions="<html>
 <ul>
 <li><i>October, 2015&nbsp;</i> by Moritz Lauster:<br/>Adapted to Annex60 and restructuring, implementing new functionalities</li>
 </ul>
 <ul>
 <li><i>June, 2014&nbsp;</i> by Moritz Lauster:<br/>Added some basic documentation</li>
 </ul>
 </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end partialHeaterCoolerPI;
