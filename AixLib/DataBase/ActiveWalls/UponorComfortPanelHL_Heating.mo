within AixLib.DataBase.ActiveWalls;
record UponorComfortPanelHL_Heating
  "Ceiling heating from Uponor Comfort panel HL"

extends ActiveWallBaseDataDefinition(
    Temp_nom=Modelica.SIunits.Conversions.from_degC({40,30,20}),
    q_dot_nom=100,
    k_isolation=0.38,
    VolumeWaterPerMeter=0.03848,
    Spacing=0.10,
    eps=0.9,
    C_ActivatedElement=1000,
    c_top_ratio=0.99,
    PressureDropExponent=1.8895,
    PressureDropCoefficient=32.981);
    annotation (Documentation(revisions="<html>
<p><ul>
<li><i>February 13, 2014&nbsp;</i> by Ana Constantin:<br/>Implemented.</li>
</ul></p>
</html>",
      info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>Record for celing heating system from Uponor Comfort panel HL.</p>
<p>Defines heat exchange properties and storage capacity of the active part of the wall.</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://EBC/Images/stars5.png\"/> </p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>Record is used with <a href=\"EBC.HVAC.Components.ActiveWalls.Panelheating_1D_Dis\">EBC.HVAC.Components.ActiveWalls.Panelheating_1D_Dis</a></p>
<p>Source:</p>
<p><ul>
<li>Product: Comfort Panel HL</li>
<li>Manufacturer: Uponor</li>
<li>Borschure: Geb&auml;udetechnik / TECHNISCHER GESAMTKATALOG 2013/14 / Uponor Kassettendeckensystzem Comfort Panel HL</li>
<li>c_top_ratio: guess value 99&percnt; goes towards the room</li>
<li>C_Floorheating: guess value (it shouldn&apos;t be too small, but the storage is minimal)</li>
<li>k_isolation: guess value according to the the PE-X material</li>
</ul></p>
</html>"));

end UponorComfortPanelHL_Heating;
