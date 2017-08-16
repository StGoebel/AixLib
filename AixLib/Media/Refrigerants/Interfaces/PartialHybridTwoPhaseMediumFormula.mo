within AixLib.Media.Refrigerants.Interfaces;
partial package PartialHybridTwoPhaseMediumFormula
  "Base class for two phase medium using a hybrid approach without records"
  extends Modelica.Media.Interfaces.PartialTwoPhaseMedium;

  redeclare record extends ThermodynamicState "Thermodynamic state"
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
    SpecificEnthalpy h "Enthalpy";
  end ThermodynamicState;
  /*The record "ThermodynamicState" contains the input arguments
    of all the function and is defined together with the used
    type definitions in PartialMedium. The record most often contains two of the
    variables "p, T, d, h" (e.g., medium.T)
  */

  /*Provide records thats contain the coefficients for the smooth transition
    between different regions.
  */
  replaceable record SmoothTransition
    "Record that contains ranges to calculate a smooth transition between
    different regions"
    SpecificEnthalpy T_ph = 10;
    SpecificEntropy T_ps = 10;
    AbsolutePressure d_pT = 10;
    SpecificEnthalpy d_ph = 10;
    Real d_ps(unit="J/(Pa.K.kg)") =  50/(30e5-0.5e5);
    Real h_ps(unit="J/(Pa.K.kg)") = 100/(30e5-0.5e5);
    AbsolutePressure d_derh_p = 0.2;
  end SmoothTransition;
  /*Provide Helmholtz equations of state (EoS). These EoS must be fitted to
    different refrigerants and the explicit formulas have to be 
    provided within the template.
  */
  replaceable partial function alpha_0
  "Dimensionless Helmholtz energy (Ideal gas contribution alpha_0)"
    input Real delta "Temperature";
    input Real tau "Density";
    output Real alpha_0 = 0 "Dimensionless ideal gas Helmholz energy";
    annotation(Inline=false,
          LateInline=true);
  end alpha_0;

  replaceable partial function alpha_r
  "Dimensionless Helmholtz energy (Residual part alpha_r)"
      input Real delta "Temperature";
      input Real tau "Density";
      output Real alpha_r = 0 "Dimensionless residual Helmholz energy";
    annotation(Inline=false,
          LateInline=true);
  end alpha_r;

  replaceable partial function tau_d_alpha_0_d_tau
  "Short form for tau*(dalpha_0/dtau)@delta=const"
    input Real tau "Density";
    output Real tau_d_alpha_0_d_tau = 0 "Tau*(dalpha_0/dtau)@delta=const";
    annotation(Inline=false,
          LateInline=true);
  end tau_d_alpha_0_d_tau;

  replaceable partial function tau2_d2_alpha_0_d_tau2
  "Short form for tau*tau*(ddalpha_0/(dtau*dtau))@delta=const"
      input Real tau "Density";
      output Real tau2_d2_alpha_0_d_tau2 = 0
      "Tau*tau*(ddalpha_0/(dtau*dtau))@delta=const";
    annotation(Inline=false,
          LateInline=true);
  end tau2_d2_alpha_0_d_tau2;

  replaceable partial function tau_d_alpha_r_d_tau
  "Short form for tau*(dalpha_r/dtau)@delta=const"
    input Real delta "Temperature";
    input Real tau "Density";
    output Real tau_d_alpha_r_d_tau = 0 "Tau*(dalpha_r/dtau)@delta=const";
    annotation(Inline=false,
          LateInline=true);
  end tau_d_alpha_r_d_tau;

  replaceable partial function tau2_d2_alpha_r_d_tau2
  "Short form for tau*tau*(ddalpha_r/(dtau*dtau))@delta=const"
      input Real delta "Temperature";
      input Real tau "Density";
      output Real tau2_d2_alpha_r_d_tau2 = 0
      "Tau*tau*(ddalpha_r/(dtau*dtau))@delta=const";
    annotation(Inline=false,
          LateInline=true);
  end tau2_d2_alpha_r_d_tau2;

  replaceable partial function delta_d_alpha_r_d_delta
  "Short form for delta*(dalpha_r/(ddelta))@tau=const"
    input Real delta "Temperature";
    input Real tau "Density";
    output Real delta_d_alpha_r_d_delta = 0
      "Delta*(dalpha_r/(ddelta))@tau=const";
    annotation(Inline=false,
          LateInline=true);
  end delta_d_alpha_r_d_delta;

  replaceable partial function delta2_d2_alpha_r_d_delta2
  "Short form for delta*delta(ddalpha_r/(ddelta*delta))@tau=const"
    input Real delta "Temperature";
    input Real tau "Density";
    output Real delta2_d2_alpha_r_d_delta2 = 0
    "Delta*delta(ddalpha_r/(ddelta*delta))@tau=const";
    annotation(Inline=false,
          LateInline=true);
  end delta2_d2_alpha_r_d_delta2;

  replaceable partial function tau_delta_d2_alpha_r_d_tau_d_delta
  "Short form for tau*delta*(ddalpha_r/(dtau*ddelta))"
    input Real delta "Temperature";
    input Real tau "Density";
    output Real tau_delta_d2_alpha_r_d_tau_d_delta = 0
    "Tau*delta*(ddalpha_r/(dtau*ddelta))";
    annotation(Inline=false,
          LateInline=true);
  end tau_delta_d2_alpha_r_d_tau_d_delta;
  /*Provide functions that set the actual state depending on the given input
    parameters. Additionally, state functions for the two-phase region 
    are needed.  
    Just change these functions if needed.
  */
  redeclare function extends setDewState
  "Return thermodynamic state of refrigerant  on the dew line"
  algorithm
    state := ThermodynamicState(
       phase = phase,
       T = sat.Tsat,
       d = dewDensity(sat),
       p = saturationPressure(sat.Tsat),
       h = dewEnthalpy(sat));
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end setDewState;

  redeclare function extends setBubbleState
  "Return thermodynamic state of refrigerant on the bubble line"
  algorithm
    state := ThermodynamicState(
       phase = phase,
       T = sat.Tsat,
       d = bubbleDensity(sat),
       p = saturationPressure(sat.Tsat),
       h = bubbleEnthalpy(sat));
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end setBubbleState;

  redeclare function extends setState_dTX
  "Return thermodynamic state of refrigerant as function of d and T"
  algorithm
    state := ThermodynamicState(
      d = d,
      T = T,
      p = pressure_dT(d=d,T=T,phase=phase),
      h = specificEnthalpy_dT(d=d,T=T,phase=phase),
      phase = phase);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end setState_dTX;

  redeclare function extends setState_pTX
  "Return thermodynamic state of refrigerant as function of p and T"
  algorithm
    state := ThermodynamicState(
      d = density_pT(p=p,T=T,phase=phase),
      p = p,
      T = T,
      h = specificEnthalpy_pT(p=p,T=T,phase=phase),
      phase = phase);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end setState_pTX;

  redeclare function extends setState_phX
  "Return thermodynamic state of refrigerant as function of p and h"
  algorithm
    state:= ThermodynamicState(
      d = density_ph(p=p,h=h,phase=phase),
      p = p,
      T = temperature_ph(p=p,h=h,phase=phase),
      h = h,
      phase = phase);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end setState_phX;

  redeclare function extends setState_psX
  "Return thermodynamic state of refrigerant as function of p and s"
  algorithm
    state := ThermodynamicState(
      d = density_ps(p=p,s=s,phase=phase),
      p = p,
      T = temperature_ps(p=p,s=s,phase=phase),
      h = specificEnthalpy_ps(p=p,s=s,phase=phase),
      phase = phase);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end setState_psX;
  /*Provide functions to calculate thermodynamic properties using the EoS.
    Just change these functions if needed.
  */
  redeclare function extends pressure
  "Pressure of refrigerant"
  algorithm
    p := state.p;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end pressure;

  redeclare function extends temperature
  "Temperature of refrigerant"
  algorithm
    T := state.T;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end temperature;

  redeclare function extends density
  "Density of refrigerant"
  algorithm
    d := state.d;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end density;

  redeclare function extends specificEnthalpy
  "Specific enthalpy of refrigerant"
  algorithm
    h := state.h;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
  "Specific internal energy of refrigerant"
  algorithm
    u := specificEnthalpy(state)  - pressure(state)/state.d;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificInternalEnergy;

  redeclare function extends specificGibbsEnergy
  "Specific Gibbs energy of refrigerant"
  algorithm
    g := specificEnthalpy(state) - state.T*specificEntropy(state);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
  "Specific Helmholtz energy of refrigerant"
  algorithm
    f := specificEnthalpy(state) - pressure(state)/state.d -
      state.T*specificEntropy(state);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificHelmholtzEnergy;

  redeclare function extends specificEntropy
  "Specific entropy of refrigerant"
  protected
    SpecificEntropy sl;
    SpecificEntropy sv;
    SaturationProperties sat = setSat_T(state.T);

    Real d_crit = fluidConstants[1].criticalMolarVolume*MM;
    Real MM = fluidConstants[1].molarMass;
    Real R = Modelica.Constants.R/MM;
    Real tau = fluidConstants[1].criticalTemperature/state.T;
    Real delta;
    Real deltaL;
    Real deltaG;
    Real quality;

    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      delta := state.d/d_crit;
      s := R*(tau_d_alpha_0_d_tau(tau) + tau_d_alpha_r_d_tau(delta, tau) -
        alpha_0(delta, tau) - alpha_r(delta, tau));
    elseif state.phase==2 or phase_dT==2 then
      deltaL := bubbleDensity(sat)/d_crit;
      deltaG := dewDensity(sat)/d_crit;
      quality := (bubbleDensity(sat)/state.d - 1)/(bubbleDensity(sat)/dewDensity(
        sat) - 1);
      sl := R*(tau_d_alpha_0_d_tau(tau) + tau_d_alpha_r_d_tau(deltaL, tau) -
        alpha_0(deltaL, tau) - alpha_r(deltaL, tau));
      sv := R*(tau_d_alpha_0_d_tau(tau) + tau_d_alpha_r_d_tau(deltaG, tau) -
        alpha_0(deltaG, tau) - alpha_r(deltaG, tau));
       s := sl + quality*(sv-sl);
    end if;
    annotation(Inline=false,
          LateInline=true);
  end specificEntropy;

  redeclare function extends specificHeatCapacityCp
  "Specific heat capacity at constant pressure of refrigerant"
  protected
    SpecificHeatCapacity cpl;
    SpecificHeatCapacity cpv;
    SaturationProperties sat = setSat_T(state.T);

    Real d_crit = fluidConstants[1].criticalMolarVolume*MM;
    Real MM = fluidConstants[1].molarMass;
    Real R = Modelica.Constants.R/MM;
    Real tau = fluidConstants[1].criticalTemperature/state.T;
    Real delta;
    Real deltaL;
    Real deltaG;
    Real quality;

    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      delta :=state.d/d_crit;
      cp := specificHeatCapacityCv(state) + R*((1 +
        delta_d_alpha_r_d_delta(delta, tau) -
        tau_delta_d2_alpha_r_d_tau_d_delta(delta, tau))^2)/(1 + 2*
        delta_d_alpha_r_d_delta(delta, tau) +
        delta2_d2_alpha_r_d_delta2(delta, tau));
    elseif state.phase==2 or phase_dT==2 then
      cp := Modelica.Constants.inf;
      deltaL :=bubbleDensity(sat)/d_crit;
      deltaG :=dewDensity(sat)/d_crit;
        quality := (bubbleDensity(sat)/state.d - 1)/(bubbleDensity(sat)/dewDensity(
         sat) - 1);
      cpl := specificHeatCapacityCv(setBubbleState(sat)) + R*((1 +
         delta_d_alpha_r_d_delta(deltaL, tau) -
         tau_delta_d2_alpha_r_d_tau_d_delta(deltaL, tau))^2)/(1 + 2*
         delta_d_alpha_r_d_delta(deltaL, tau) +
         delta2_d2_alpha_r_d_delta2(deltaL, tau));
      cpv := specificHeatCapacityCv(setDewState(sat)) + R*((1 +
         delta_d_alpha_r_d_delta(deltaG, tau) -
         tau_delta_d2_alpha_r_d_tau_d_delta(deltaG, tau))^2)/(1 + 2*
         delta_d_alpha_r_d_delta(deltaG, tau) +
         delta2_d2_alpha_r_d_delta2(deltaG, tau));
      cp := cpl + quality*(cpv-cpl);
    end if;
    annotation(Inline=false,
          LateInline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Specific heat capacity at constant volume of refrigerant"
  protected
    SpecificHeatCapacity cvl;
    SpecificHeatCapacity cvv;
    SaturationProperties sat = setSat_T(state.T);

    Real d_crit = fluidConstants[1].criticalMolarVolume*MM;
    Real MM = fluidConstants[1].molarMass;
    Real R = Modelica.Constants.R/MM;
    Real tau = fluidConstants[1].criticalTemperature/state.T;
    Real delta;
    Real deltaL;
    Real deltaG;
    Real quality;

    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
       dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
       then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      delta :=state.d/d_crit;
      cv := -R*(tau2_d2_alpha_0_d_tau2(tau) +
        tau2_d2_alpha_r_d_tau2(delta, tau));
    elseif state.phase==2 or phase_dT==2 then
      deltaL :=bubbleDensity(sat)/d_crit;
      deltaG :=dewDensity(sat)/d_crit;
      quality := (bubbleDensity(sat)/state.d - 1)/(bubbleDensity(sat)/dewDensity(
        sat) - 1);
      cvl := -R*(tau2_d2_alpha_0_d_tau2(tau) +
        tau2_d2_alpha_r_d_tau2(deltaL, tau));
      cvv := -R*(tau2_d2_alpha_0_d_tau2(tau) +
        tau2_d2_alpha_r_d_tau2(deltaG, tau));
      cv := cvl + quality*(cvv-cvl);
    end if;
    annotation(Inline=false,
          LateInline=true);
  end specificHeatCapacityCv;

  redeclare function extends velocityOfSound
    "Velocity of sound of refrigerant"
  protected
    VelocityOfSound aL;
    VelocityOfSound aG;
    SaturationProperties sat = setSat_T(state.T);

    Real d_crit = fluidConstants[1].criticalMolarVolume*MM;
    Real MM = fluidConstants[1].molarMass;
    Real R = Modelica.Constants.R/MM;
    Real tau = fluidConstants[1].criticalTemperature/state.T;
    Real delta;
    Real deltaL;
    Real deltaG;
    Real quality;

    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      delta :=state.d/d_crit;
      a := (R*state.T*(1+2*delta_d_alpha_r_d_delta(delta,tau)+
        delta2_d2_alpha_r_d_delta2(delta,tau)-(1+
        delta_d_alpha_r_d_delta(delta,tau)-
        tau_delta_d2_alpha_r_d_tau_d_delta(delta,tau))^2/(
        tau2_d2_alpha_0_d_tau2(tau)+tau2_d2_alpha_r_d_tau2(delta,tau))))^0.5;
    elseif state.phase==2 or phase_dT==2 then
      deltaL :=bubbleDensity(sat)/d_crit;
      deltaG :=dewDensity(sat)/d_crit;
      quality := (bubbleDensity(sat)/state.d - 1)/(bubbleDensity(sat)/dewDensity(
        sat) - 1);
      aG := (R*state.T*(1+2*delta_d_alpha_r_d_delta(deltaL,tau)+
        delta2_d2_alpha_r_d_delta2(deltaL,tau)-(1+
        delta_d_alpha_r_d_delta(deltaL,tau)-
        tau_delta_d2_alpha_r_d_tau_d_delta(deltaL,tau))^2/(
        tau2_d2_alpha_0_d_tau2(tau)+tau2_d2_alpha_r_d_tau2(deltaL,tau))))^0.5;
      aL := (R*state.T*(1+2*delta_d_alpha_r_d_delta(deltaG,tau)+
        delta2_d2_alpha_r_d_delta2(deltaG,tau)-(1+
        delta_d_alpha_r_d_delta(deltaG,tau)-
        tau_delta_d2_alpha_r_d_tau_d_delta(deltaG,tau))^2/(
        tau2_d2_alpha_0_d_tau2(tau)+tau2_d2_alpha_r_d_tau2(deltaG,tau))))^0.5;
      a:=aL + quality*(aG-aL);
    end if;
    annotation(Inline=false,
          LateInline=true);
  end velocityOfSound;

  redeclare function extends isobaricExpansionCoefficient
  "Isobaric expansion coefficient beta of refrigerant"
  protected
    SaturationProperties sat = setSat_T(state.T);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      beta := 1/state.d * pressure_derT_d(state)/pressure_derd_T(state);
    elseif state.phase==2 or phase_dT==2 then
     beta := Modelica.Constants.small;
    end if;
    annotation(Inline=false,
          LateInline=true);
  end isobaricExpansionCoefficient;

  redeclare function extends isothermalCompressibility
  "Isothermal compressibility factor of refrigerant"
  protected
    SaturationProperties sat = setSat_T(state.T);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      kappa := 1/state.d/pressure_derd_T(state);
    elseif state.phase==2 or phase_dT==2 then
      kappa := Modelica.Constants.inf;
    end if;
    annotation(Inline=false,
          LateInline=true);
  end isothermalCompressibility;

  replaceable function isothermalThrottlingCoefficient
  "Isothermal throttling coefficient of refrigerant"
    input ThermodynamicState state "Thermodynamic state";
    output Real delta_T(unit="J/(Pa.kg)") "Isothermal throttling coefficient";

  protected
    SaturationProperties sat = setSat_T(state.T);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
     if state.phase==1 or phase_dT==1 then
       delta_T := specificEnthalpy_derd_T(state)/pressure_derd_T(state);
     elseif state.phase==2 or phase_dT==2 then
       delta_T := Modelica.Constants.inf;
     end if;
    annotation(Inline=false,
          LateInline=true);
  end isothermalThrottlingCoefficient;

  replaceable function jouleThomsonCoefficient
  "Joule-Thomson coefficient of refrigerant"
    input ThermodynamicState state "Thermodynamic state";
    output Real my(unit="K/Pa") "Isothermal throttling coefficient";

  protected
    SaturationProperties sat = setSat_T(state.T);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and state.d >
      dewDensity(sat)) and state.T < fluidConstants[1].criticalTemperature)
      then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      my := 1 / (pressure_derT_d(state) - pressure_derd_T(state) *
        specificEnthalpy_derT_d(state)/specificEnthalpy_derd_T(state));
    elseif state.phase==2 or phase_dT==2 then
      my := temperature_derp_h(setState_pT(sat.psat,sat.Tsat));
    end if;
    annotation(Inline=false,
          LateInline=true);
  end jouleThomsonCoefficient;
  /*Provide functions to calculate thermodynamic properties depending on the
    independent variables. Moreover, these functions may depend on the Helmholtz
    EoS. Just change these functions if needed.
  */
  redeclare replaceable function pressure_dT
  "Computes pressure as a function of density and temperature"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase "2 for two-phase, 1 for one-phase, 0 if not known";
    output AbsolutePressure p "Pressure";

  protected
    SaturationProperties sat = setSat_T(T);
    Real phase_dT = if not ((d < bubbleDensity(sat) and d > dewDensity(sat))
      and T < fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if phase_dT == 1 or phase == 1 then
      p := d*Modelica.Constants.R/fluidConstants[1].molarMass*T*
        (1+delta_d_alpha_r_d_delta(delta = d/(
        fluidConstants[1].criticalMolarVolume*fluidConstants[1].molarMass),
        tau = fluidConstants[1].criticalTemperature/T));
    elseif phase_dT == 2 or phase == 2 then
      p := saturationPressure(T);
    end if;
  annotation(derivative(noDerivative=phase)=pressure_dT_der,
          inverse(d=density_pT(p=p,T=T,phase=phase)),
          Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end pressure_dT;

  redeclare replaceable function density_ph
  "Computes density as a function of pressure and enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";

  protected
    SmoothTransition st;

    SpecificEnthalpy dh = st.d_ph;
    SaturationProperties sat;
    SpecificEnthalpy h_dew;
    SpecificEnthalpy h_bubble;

  algorithm
    sat := setSat_p(p=p);
    h_dew := dewEnthalpy(sat);
    h_bubble := bubbleEnthalpy(sat);

    if h<h_bubble-dh or h>h_dew+dh then
      d := density_pT(p=p,T=temperature_ph(p=p,h=h));
    else
      if h<h_bubble then
        d := bubbleDensity(sat)*(1 - (h_bubble - h)/dh) + density_pT(
          p=p,T=temperature_ph(p=p,h=h))*(h_bubble - h)/dh;
      elseif h>h_dew then
        d := dewDensity(sat)*(1 - (h - h_dew)/dh) + density_pT(
          p=p,T=temperature_ph(p=p,h=h))*(h - h_dew)/dh;
      else
        d := 1/((1-(h-h_bubble)/(h_dew-h_bubble))/bubbleDensity(sat) +
          ((h-h_bubble)/(h_dew-h_bubble))/dewDensity(sat));
      end if;
    end if;
    annotation(derivative(noDerivative=phase)=density_ph_der,
          Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end density_ph;

  redeclare replaceable function density_ps
  "Computes density as a function of pressure and entropy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Temperature";

  protected
    SmoothTransition st;

    SpecificEntropy ds = p*st.d_ps;
    SaturationProperties sat;
    SpecificEntropy s_dew;
    SpecificEntropy s_bubble;

  algorithm
    sat := setSat_p(p=p);
    s_dew := dewEntropy(sat);
    s_bubble := bubbleEntropy(sat);

    if s<s_bubble-ds or s>s_dew+ds then
      d:=density_pT(p=p,T=temperature_ps(p=p,s=s,phase=phase));
    else
      if s<s_bubble then
        d:=bubbleDensity(sat)*(1 - (s_bubble - s)/ds) + density_pT(
          p=p,T=temperature_ps(p=p,s=s,phase=phase),phase=phase)*
          (s_bubble - s)/ds;
      elseif s>s_dew then
        d:=dewDensity(sat)*(1 - (s - s_dew)/ds) + density_pT(
          p=p,T=temperature_ps(p=p,s=s,phase=phase),phase=phase)*
          (s - s_dew)/ds;
      else
        d:=1/((1-(s-s_bubble)/(s_dew-s_bubble))/bubbleDensity(sat) +
          ((s-s_bubble)/(s_dew-s_bubble))/dewDensity(sat));
      end if;
    end if;
    annotation(Inline=false,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end density_ps;

  redeclare function specificEnthalpy_pT
  "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";

  algorithm
    h := specificEnthalpy_dT(density_pT(p,T,phase),T,phase);
    annotation(inverse(T=temperature_ph(p=p,h=h,phase=phase)),
          Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy_pT;

  redeclare function specificEnthalpy_dT
    "Computes specific enthalpy as a function of density and temperature"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";

  protected
    Real hl=0;
    Real hv=0;

    Real d_crit = fluidConstants[1].criticalMolarVolume*MM;
    Real MM = fluidConstants[1].molarMass;
    Real R = Modelica.Constants.R/MM;
    Real tau = fluidConstants[1].criticalTemperature/T;
    Real delta;
    Real dewDelta;
    Real bubbleDelta;
    Real quality;

    SaturationProperties sat = setSat_T(T);
    Real phase_dT = if not ((d < bubbleDensity(sat) and d > dewDensity(sat))
      and T < fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if phase_dT == 1 or phase == 1 then
      delta := d/d_crit;
      h := R*T*(tau_d_alpha_0_d_tau(tau) + tau_d_alpha_r_d_tau(delta, tau) +
        delta_d_alpha_r_d_delta(delta, tau) + 1);
    elseif phase_dT == 2 or phase == 2 then
      dewDelta := dewDensity(sat)/d_crit;
      bubbleDelta := bubbleDensity(sat)/d_crit;
      quality := if phase==2 or phase_dT==2 then (bubbleDensity(sat)/d - 1)/
        (bubbleDensity(sat)/dewDensity(sat) - 1) else 1;
      hl := R*T*(tau_d_alpha_0_d_tau(tau) +
        tau_d_alpha_r_d_tau(bubbleDelta, tau) + delta_d_alpha_r_d_delta(
        bubbleDelta, tau) + 1);
      hv := R*T*(tau_d_alpha_0_d_tau(tau) + tau_d_alpha_r_d_tau(dewDelta, tau) +
        delta_d_alpha_r_d_delta(dewDelta, tau) + 1);
      h := hl + quality*(hv-hl);
    end if;
    annotation(derivative(noDerivative=phase)=specificEnthalpy_dT_der,
          Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy_dT;

  redeclare replaceable function specificEnthalpy_ps
  "Computes specific enthalpy as a function of pressure and entropy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";

  protected
    SmoothTransition st;

    SpecificEntropy ds = p*st.h_ps;
    SaturationProperties sat;
    SpecificEntropy s_dew;
    SpecificEntropy s_bubble;
    SpecificEnthalpy h_dew;
    SpecificEnthalpy h_bubble;

  algorithm
    sat := setSat_p(p=p);
    s_dew := dewEntropy(sat);
    s_bubble := bubbleEntropy(sat);

    if s<s_bubble-ds or s>s_dew+ds then
      h := specificEnthalpy_pT(p=p,T=temperature_ps(
        p=p,s=s,phase=phase),phase=phase);
    else
      h_dew := dewEnthalpy(sat);
      h_bubble := bubbleEnthalpy(sat);
      if s<s_bubble then
        h := h_bubble*(1 - (s_bubble - s)/ds) + specificEnthalpy_pT(
          p=p,T=temperature_ps(p=p,s=s,phase=phase),phase=phase)*
          (s_bubble - s)/ds;
      elseif s>s_dew then
        h := h_dew*(1 - (s - s_dew)/ds) + specificEnthalpy_pT(
          p=p,T=temperature_ps(p=p,s=s,phase=phase),phase=phase)*
          (s - s_dew)/ds;
      else
        h := h_bubble+(s-s_bubble)/(s_dew-s_bubble)*(h_dew-h_bubble);
      end if;
    end if;
    annotation(Inline=false,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy_ps;
  /*Provide functions partial derivatives. These functions may depend on the
    Helmholtz EoS and are needed to calculate thermodynamic properties.  
    Just change these functions if needed.
  */
  replaceable function pressure_dT_der
  "Calculates time derivative of pressure_dT"
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    input Real der_d "Time derivative of density";
    input Real der_T "Time derivative of temperature";
    output Real der_p "Time derivative of pressure";

  protected
    ThermodynamicState state = setState_dTX(d=d,T=T,phase=phase);

  algorithm
    der_p := der_d*pressure_derd_T(state=state) + der_T*
      pressure_derT_d(state=state);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end pressure_dT_der;

  replaceable function pressure_derd_T
    "Calculates pressure derivative (dp/dd)@T=const"
    input ThermodynamicState state "Thermodynamic state";
    output Real dpdT "Pressure derivative (dp/dd)@T=const";

  protected
    Real delta = state.d/(fluidConstants[1].criticalMolarVolume*
      fluidConstants[1].molarMass);
    Real tau = fluidConstants[1].criticalTemperature/state.T;

    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
      state.d > dewDensity(sat)) and state.T <
      fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      dpdT := Modelica.Constants.R/fluidConstants[1].molarMass*
        state.T*(1 + 2*delta_d_alpha_r_d_delta(delta=delta,tau=tau) +
        delta2_d2_alpha_r_d_delta2(delta=delta,tau=tau));
    elseif state.phase==2 or phase_dT==2 then
      dpdT := Modelica.Constants.small;
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end pressure_derd_T;

  replaceable function pressure_derT_d
    "Calculates pressure derivative (dp/dT)@d=const"
    input ThermodynamicState state "Thermodynamic state";
    output Real dpTd "Pressure derivative (dp/dT)@d=const";

  protected
    Real delta = state.d/(fluidConstants[1].criticalMolarVolume*
      fluidConstants[1].molarMass);
    Real tau = fluidConstants[1].criticalTemperature/state.T;

    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
      state.d > dewDensity(sat)) and state.T <
      fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      dpTd:=Modelica.Constants.R/fluidConstants[1].molarMass*state.d*
        (1 + delta_d_alpha_r_d_delta(delta=delta,tau=tau) -
        tau_delta_d2_alpha_r_d_tau_d_delta(delta=delta,tau=tau));
    elseif state.phase==2 or phase_dT==2 then
      dpTd := Modelica.Constants.inf;
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end pressure_derT_d;

  replaceable function temperature_ph_der
  "Calculates time derivative of temperature_ph"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    input Real der_p "Time derivative of pressure";
    input Real der_h "Time derivative of specific enthalpy";
    output Real der_T "Time derivative of density";

  protected
    ThermodynamicState state = setState_phX(p=p,h=h,phase=phase);

  algorithm
    der_T := der_p*temperature_derp_h(state=state) +
      der_h*temperature_derh_p(state=state);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end temperature_ph_der;

  replaceable function temperature_derh_p
    "Calculates temperature derivative (dT/dh)@p=const"
    input ThermodynamicState state "Thermodynamic state";
    output Real dThp "Temperature derivative (dT/dh)@p=const";

  protected
    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
        state.d > dewDensity(sat)) and state.T <
        fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      dThp := 1 / (specificEnthalpy_derT_d(state) -
        specificEnthalpy_derd_T(state)*pressure_derT_d(state)/
        pressure_derd_T(state));
    elseif state.phase==2 or phase_dT==2 then
      dThp:=Modelica.Constants.small;
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end temperature_derh_p;

  replaceable function temperature_derp_h
    "Calculates temperature derivative (dT/dp)@h=const"
    input ThermodynamicState state "Thermodynamic state";
    output Real dTph "Temperature derivative (dT/dp)@h=const";

  protected
    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
      state.d > dewDensity(sat)) and state.T <
      fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      dTph := 1 / (pressure_derT_d(state) - pressure_derd_T(state)*
        specificEnthalpy_derT_d(state)/specificEnthalpy_derd_T(state));
    elseif state.phase==2 or phase_dT==2 then
      dTph := Modelica.Constants.small;
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end temperature_derp_h;

  replaceable function density_ph_der
    "Calculates time derivative of density_ph"
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific Enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    input Real der_p "Time derivative of pressure";
    input Real der_h "Time derivative of specific enthalpy";
    output Real der_d "Time derivative of density";

  protected
    ThermodynamicState state = setState_phX(p=p,h=h,phase=phase);

  algorithm
    der_d := der_p*density_derp_h(state=state) +
    der_h*density_derh_p(state=state);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end density_ph_der;

  redeclare replaceable function extends density_derh_p
    "Calculates density derivative (dd/dh)@p=const"

  protected
    SmoothTransition st;

    AbsolutePressure dp = st.d_derh_p;

    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
      state.d > dewDensity(sat)) and state.T <
      fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      ddhp := 1 / (specificEnthalpy_derd_T(state) -
        specificEnthalpy_derT_d(state)*pressure_derd_T(state)/
        pressure_derT_d(state));
    elseif state.phase==2 or phase_dT==2 then
      ddhp:=-(state.d^2)/state.T*(saturationTemperature(state.p+dp/2)-
        saturationTemperature(state.p-dp/2))/dp;
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end density_derh_p;

  redeclare function extends density_derp_h
    "Calculates density derivative (dd/dp)@h=const"

  algorithm
    ddph := 1 / (pressure_derd_T(state) - pressure_derT_d(state)*
      specificEnthalpy_derd_T(state)/specificEnthalpy_derT_d(state));
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end density_derp_h;

  redeclare function extends dBubbleDensity_dPressure
    "Calculates bubble point density derivative"

  protected
    ThermodynamicState state_l = setBubbleState(sat);
    ThermodynamicState state_v = setDewState(sat);

    Real ddpT = 1 / pressure_derd_T(state_l);
    Real ddTp = -pressure_derT_d(state_l) / pressure_derd_T(state_l);
    Real dTp = (1/state_v.d - 1/state_l.d)/(specificEntropy(state_v) -
      specificEntropy(state_l));

  algorithm
    ddldp := ddpT + ddTp*dTp;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end dBubbleDensity_dPressure;

  redeclare function extends dDewDensity_dPressure
    "Calculates dew point density derivative"

  protected
    ThermodynamicState state_l = setBubbleState(sat);
    ThermodynamicState state_v = setDewState(sat);

    Real ddpT = 1/pressure_derd_T(state_v);
    Real ddTp = -pressure_derT_d(state_v)/pressure_derd_T(state_v);
    Real dTp = (1/state_v.d - 1/state_l.d)/(specificEntropy(state_v) -
      specificEntropy(state_l));

  algorithm
    ddvdp := ddpT + ddTp*dTp;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end dDewDensity_dPressure;

  replaceable function specificEnthalpy_dT_der
    "Calculates time derivative of specificEnthalpy_dT"
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Real der_d "Time derivative of density";
    input Real der_T "Time derivative of temperature";
    output Real der_h "Time derivative of specific enthalpy";

  protected
    ThermodynamicState state = setState_dT(d=d,T=T,phase=phase);

  algorithm
    der_h := der_d*specificEnthalpy_derd_T(state=state) +
      der_T*specificEnthalpy_derT_d(state=state);
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy_dT_der;

  replaceable function specificEnthalpy_derT_d
  "Calculates enthalpy derivative (dh/dT)@d=const"
    input ThermodynamicState state "Thermodynamic state";
    output Real dhTd "Enthalpy derivative (dh/dT)@d=const";

  protected
    Real delta = state.d/(fluidConstants[1].criticalMolarVolume*
      fluidConstants[1].molarMass);
    Real tau = fluidConstants[1].criticalTemperature/state.T;

    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
      state.d > dewDensity(sat)) and state.T <
      fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      dhTd := Modelica.Constants.R/fluidConstants[1].molarMass*
        (1 - tau2_d2_alpha_0_d_tau2(tau=tau) - tau2_d2_alpha_r_d_tau2(
        delta=delta, tau=tau) + delta_d_alpha_r_d_delta(
        delta=delta,tau=tau) - tau_delta_d2_alpha_r_d_tau_d_delta(
        delta=delta, tau=tau));
    elseif state.phase==2 or phase_dT==2 then
      dhTd:=Modelica.Constants.inf;
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy_derT_d;

  replaceable function specificEnthalpy_derd_T
  "Calculates enthalpy derivative (dh/dd)@T=const"
    input ThermodynamicState state "Thermodynamic state";
    output Real dhdT "Enthalpy derivative (dh/dd)@T=const";

  protected
    Real delta = state.d/(fluidConstants[1].criticalMolarVolume*
      fluidConstants[1].molarMass);
    Real tau = fluidConstants[1].criticalTemperature/state.T;

    SaturationProperties sat = setSat_p(state.p);
    Real phase_dT = if not ((state.d < bubbleDensity(sat) and
      state.d > dewDensity(sat)) and state.T <
      fluidConstants[1].criticalTemperature) then 1 else 2;

  algorithm
    if state.phase==1 or phase_dT==1 then
      dhdT := Modelica.Constants.R/fluidConstants[1].molarMass*
        state.T/state.d*(0 + tau_delta_d2_alpha_r_d_tau_d_delta(
        delta=delta,tau=tau) + delta_d_alpha_r_d_delta(delta=delta,tau=tau) +
        delta2_d2_alpha_r_d_delta2(delta=delta,tau=tau));
    elseif state.phase==2 or phase_dT==2 then
      dhdT := -1/state.d^2*(bubbleEnthalpy(sat)-dewEnthalpy(sat))/
        (1/bubbleDensity(sat)-1/dewDensity(sat));
    end if;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end specificEnthalpy_derd_T;

  redeclare function extends dBubbleEnthalpy_dPressure
  "Calculates bubble point enthalpy derivative"

  protected
    ThermodynamicState state_l = setBubbleState(sat);
    ThermodynamicState state_v = setDewState(sat);
    Real dhpT = specificEnthalpy_derd_T(state_l)/pressure_derd_T(state_l);
    Real dhTp = specificEnthalpy_derT_d(state_l) - specificEnthalpy_derd_T(
      state_l)*pressure_derT_d(state_l)/pressure_derd_T(state_l);
    Real dTp = (1/state_v.d - 1/state_l.d)/
      (specificEntropy(state_v) - specificEntropy(state_l));

  algorithm
    dhldp := dhpT + dhTp*dTp;
    annotation(Inline=true,
          LateInline=true,
          Evaluate=true,
          efficient=true);
  end dBubbleEnthalpy_dPressure;

  redeclare function extends dDewEnthalpy_dPressure
  "Calculates dew point enthalpy derivative"

  protected
    ThermodynamicState state_l = setBubbleState(sat);
    ThermodynamicState state_v = setDewState(sat);
    Real dhpT = specificEnthalpy_derd_T(state_v)/pressure_derd_T(state_v);
    Real dhTp = specificEnthalpy_derT_d(state_v) - specificEnthalpy_derd_T(
      state_v)*pressure_derT_d(state_v)/pressure_derd_T(state_v);
    Real dTp=(1.0/state_v.d - 1.0/state_l.d)/
      (specificEntropy(state_v) - specificEntropy(state_l));

  algorithm
    dhvdp := dhpT + dhTp*dTp;
    annotation(Inline=true,
    LateInline=true,
          Evaluate=true,
          efficient=true);
  end dDewEnthalpy_dPressure;
  annotation (Documentation(revisions="<html>
<ul>
  <li>
  June 6, 2017, by Mirko Engelpracht:<br/>
  First implementation (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/408\">issue 408</a>).
  </li>
</ul>
</html>", info="<html>
<p>This package provides the implementation of a refrigerant modelling approach using a hybrid approach. The hybrid approach is developed by Sangi et al. and consists of both the Helmholtz equation of state and fitted formula for thermodynamic state properties at bubble or dew line (e.g. p<sub>sat</sub> or h<sub>l,sat</sub>) and thermodynamic state properties depending on two independent state properties (e.g. T_ph or T_ps). In the following, the basic formulas of the hybrid approach are given.</p>
<p><b>The Helmholtz equation of state</b></p>
<p>The Helmholtz equation of state (EoS) allows the accurate description of fluids&apos; thermodynamic behaviour and uses the Helmholtz energy as fundamental thermodynamic relation with temperature and density as independent variables. Furthermore, the EoS allows determining all thermodynamic state properties from its partial derivatives and its<b> general formula</b> is given below:</p>
<p align=\"center\"><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Helmholtz_EoS.png\"/></p>
<p>As it can be seen, the general formula of the EoS can be divided in two part: The <b>ideal gas part (left summand) </b>and the <b>residual part (right summand)</b>. Both parts&apos; formulas are given below:</p>
<p align=\"center\"><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Helmholtz_IdealGasPart.png\"/></p>
<p align=\"center\"><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Helmholtz_ResidualPart.png\"/></p>
<p><br>Both, the ideal gas part and the residual part can be divided in three subparts (i.e. the summations) that contain different coefficients (e.g. nL, l<sub>i</sub>, p<sub>i</sub> or e<sub>i</sub>). These coefficients are fitting coefficients and must be obtained during a fitting procedure. While the fitting procedure, the general formula of the EoS is fitted to external data (e.g. NIST Refprop 9.1) and the fitting coefficients are determined. Finally, the formulas obtained during the fitting procedure are implemented in an explicit form.</p>
<p>For further information of <b>the EoS and its partial derivatives</b>, please read the paper &QUOT;<a href=\"http://www.ep.liu.se/ecp/076/006/ecp12076006.pdf\">HelmholtzMedia - A fluid properties library</a>&QUOT; by Thorade and Saadat as well as the paper &QUOT;<a href=\"http://gfzpublic.gfz-potsdam.de/pubman/item/escidoc:247373:5/component/escidoc:306833/247373.pdf\">Partial derivatives of thermodynamic state properties for dynamic simulation</a>&QUOT; by Thorade and Saadat.</p>
<p><b>Fitted formulas</b></p>
<p>Fitted formulas allow to reduce the overall computing time of the refrigerant model. Therefore, both thermodynamic state properties at bubble and dew line and thermodynamic state properties depending on two independent state properties are expresses as fitted formulas. The fitted formulas&apos; approaches implemented in this package are developed by Sangi et al. within their &QUOT;Fast_Propane&QUOT; model and given below:<br></p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"80%\"><tr>
<td valign=\"middle\"><p><i>Saturation pressure</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/SaturationPressure.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Saturation temperature</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/SaturationTemperature.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Bubble density</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/BubbleDensity.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Dew density</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/DewDensity.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Bubble Enthalpy</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/BubbleEnthalpy.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Dew Enthalpy</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/DewEnthalpy.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Bubble Entropy</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/BubbleEntropy.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Dew Entropy</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/DewEntropy.png\"/></p></td>
</tr>
</table>
<br>
<table cellspacing=\"0\" cellpadding=\"3\" border=\"1\" width=\"80%\"><tr>
<td rowspan=\"2\" valign=\"middle\"><p><i>Temperature_ph</i></p></td>
<td valign=\"middle\"><p>First Input</p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Temperature_ph_Input1.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p>Second Input</p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Temperature_ph_Input2.png\"/></p></td>
</tr>
<tr>
<td rowspan=\"2\" valign=\"middle\"><p><i>Temperature_ps</i></p></td>
<td valign=\"middle\"><p>First Input</p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Temperature_ps_Input1.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p>Second Input</p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Temperature_ps_Input2.png\"/></p></td>
</tr>
<tr>
<td rowspan=\"2\" valign=\"middle\"><p><i>Density_pT</i></p></td>
<td valign=\"middle\"><p>First Input</p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Density_pT_Input1.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p>Second Input</p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/Density_pT_Input2.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>Functional approach</i></p></td>
<td colspan=\"2\" valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/StateProperties_Approach.png\"/></p></td>
</tr>
</table>
<p>As it can be seen, the fitted formulas consist basically of the coefficients e<sub>i</sub>, c<sub>i</sub> as well as of the parameters Mean<sub>i</sub> and Std<sub>i</sub>. These coefficients are the fitting coefficients and must be obtained during a fitting procedure. While the fitting procedure, the formulas presented above are fitted to external data (e.g. NIST Refprop 9.1) and the fitting coefficients are determined. Finally, the formulas obtained during the fitting procedure are implemented in an explicit form.</p>
<p>For further information of <b>the hybrid approach</b>, please read the paper &QUOT;<a href=\"http://dx.doi.org/10.3384/ecp14096\">A Medium Model for the Refrigerant Propane for Fast and Accurate Dynamic Simulations</a>&QUOT; by Sangi et al..</p>
<p><b>Smooth transition</b></p>
<p>To ensure a smooth transition between different regions (e.g. from supercooled region to two-phase region) and, therefore, to avoid discontinuities as far as possible, Sangi et al. implemented functions for a smooth transition between the regions. An example (i.e. specificEnthalpy_ps) of these functions is given below:<br></p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"80%\"><tr>
<td valign=\"middle\"><p><i>From supercooled region to bubble line and vice versa</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/SupercooledToTwoPhase.png\"/></p></td>
<tr>
<td valign=\"middle\"><p><i>From dew line to superheated region and vice versa</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/TwoPhaseToSuperheated.png\"/></p></td>
</tr>
<tr>
<td valign=\"middle\"><p><i>From bubble or dew line to two-phase region and vice versa</i></p></td>
<td valign=\"middle\"><p><img src=\"modelica://AixLib/Resources/Images/Media/Refrigerants/Interfaces/SaturationToTwoPhase.png\"/></p></td>
</tr>
</table>
<p><b>Assumptions and limitations</b></p>
<p>Three limitations are known for this package:</p>
<ol>
<li>The modelling approach implemented in this package is a hybrid approach and, therefore, is based on the Helmholtz equation of state as well as on fitted formula. Hence, the refrigerant model is just valid within the valid range of the fitted formula.</li>
<li>It may be possible to have discontinuities when moving from one region to another (e.g. from supercooled region to two-phase region). However, functions are implemented to reach a smooth transition between the regions and to avoid these discontinuities as far as possible. (Sangi et al., 2014)</li>
<li>Not all time derivatives are implemented. So far, the following time derivatives are implemented: pressure_dT_der, temperature_ph_der, density_ph_der and specificEnthalpy_dT_der.</li>
</ol>
<p><b>Typical use and important parameters</b></p>
<p>The refrigerant models provided in this package are typically used for heat pumps and refrigerating machines. However, it is just a partial package and, hence, it must be completed before usage. In order to allow an easy completion of the package, a template is provided in <a href=\"modelica://AixLib.Media.Refrigerants.Interfaces.TemplateHybridTwoPhaseMediumFormula\">AixLib.Media.Refrigerants.Interfaces.TemplateHybridTwoPhaseMediumFormula</a>.</p>
<p><b>References</b> </p>
<p>Thorade, Matthis; Saadat, Ali (2012): <a href=\"http://www.ep.liu.se/ecp/076/006/ecp12076006.pdf\">HelmholtzMedia - A fluid properties library</a>. In: <i>Proceedings of the 9th International Modelica Conference</i>; September 3-5; 2012; Munich; Germany. Link&ouml;ping University Electronic Press, S. 63&ndash;70.</p>
<p>Thorade, Matthis; Saadat, Ali (2013): <a href=\"http://gfzpublic.gfz-potsdam.de/pubman/item/escidoc:247373:5/component/escidoc:306833/247373.pdf\">Partial derivatives of thermodynamic state properties for dynamic simulation</a>. In:<i> Environmental earth sciences 70 (8)</i>, S. 3497&ndash;3503.</p>
<p>Sangi, Roozbeh; Jahangiri, Pooyan; Klasing, Freerk; Streblow, Rita; M&uuml;ller, Dirk (2014): <a href=\"http://dx.doi.org/10.3384/ecp14096\">A Medium Model for the Refrigerant Propane for Fast and Accurate Dynamic Simulations</a>. In: <i>The 10th International Modelica Conference</i>. Lund, Sweden, March 10-12, 2014: Link&ouml;ping University Electronic Press (Link&ouml;ping Electronic Conference Proceedings), S. 1271&ndash;1275</p>
<p>Klasing,Freerk: A New Design for Direct Exchange Geothermal Heat Pumps - Modeling, Simulation and Exergy Analysis. <i>Master thesis</i></p>
</html>"));
end PartialHybridTwoPhaseMediumFormula;
