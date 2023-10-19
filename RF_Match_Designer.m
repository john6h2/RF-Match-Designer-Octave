%% (10-07-23 John Hawkins <john6h2@gmail.com>
%% Demo which has the aim to show all available GUI elements.
%% Useful since Octave 4.0

close all
clear h
clear -g

graphics_toolkit qt


h.ax = axes ("position", [0.05 0.42 0.5 0.5]);


function h=update_plot (obj, init = false)
  set(gca,'xticklabel',{[]});
  set(gca,'yticklabel',{[]});
  h = guidata (obj);
  updateF = false;
global  G_mag;          % USER entered Reflection Coefficent magnitude
global  G_angle;        % USER entered Reflection Coefficent angle
global  zL;             % USER entered Normalized Load Impedance
global  Gt;             % Reflection Coefficent
global  design_F=0;     % flag beginning a design
global  menu_val=1;     % value from the popupmenu, initialized to add jx
%struct used to store data
global  s = struct ("Gt",77,"z",0,"type",0,"out",0,"Q",0,"sign",0, "num",0);
global  r=1;            % index for design stage r-1 stages have been designed
global  sign_val=1;     % default to '+'
global  qflag=0;        % plot Qn checkbox was selected
global  Qn;             % value of Qn
global  advF=0;         % flag if advanced checkbox is selected
global  Gt_adv;         % Gt_adv value placed in s(r).Gt if there
global  redraw_F=0;     % redraw flag
global  resetGt;        % resetGt is selected
global  z_in;           % input impedance after currently designed stage
global  y_in;           % input admittance after currently designed stage
global  G_in;           % reflection coefficent after stage designed
global  zA_match_F=0;   % flag if match from zA to zL checkbox
global  zA;             % USER entered zA value
global  showgr;         % flag when show gr checkbox
global  G_T_flag=0;     % flag for advanced PI/T match
global  back_F=0;       % flag set to 1 by Go Back One pushbutton

addpath(genpath(pwd))   %%%%  addpath TO ACCESS FILES IN SUBDIRECTORIES%%%%%%
  switch (gcbo)
    case{h.Gt_magnitue_edit}
                v = get (gcbo, "string");
                G_mag=str2num(v);
    case{h.Gt_angle_edit}
                v=get(gcbo,"string");
                G_angle=str2num(v);
    case {h.zL_value_edit}
                v=get(gcbo,"string");
                try
                    zL=str2num(v);
                    s(1).z=zL;
                catch
                    errordlg("Syntax Error");
                end_try_catch
                if isempty(zL);
                    errordlg("Check Syntax, Impedance not entered.");
                endif
    case {h.Q_enable_checkbox}
          updateF=1;
          qflag=get(h.Q_enable_checkbox,"value");
    case {h.Q_value_edit}
          v=get(gcbo,"string");
          Qn=str2num(v);
    case {h.go_back_one_pushbutton}
          if r==1
              errordlg("You haven't designed anything yet");
          else
              back_F=1;
          end

    case {h.match_2_zA_checkbox}  %hide the Gs/Gl edit
          zA_match_F=get(h.match_2_zA_checkbox,"value");
          if (zA_match_F==1)
              set(h.Gtarget_label,"visible","off");
              set(h.Gt_angle_label,"visible","off");
              set(h.Gt_magnitue_label,"visible","off");
              set(h.Gt_angle_edit,"visible","off");
              set(h.Gt_magnitue_edit,"visible","off");
              set(h.zA_label,"visible","on");
              set(h.zA_value_edit, "visible", "on");
              set(h.zL_value_edit, "string","");
              set(h.advanced_enable_checkbox, "visible","off");
          elseif(zA_match_F==0)
              set(h.Gtarget_label,"visible","on");
              set(h.Gt_angle_label,"visible","on");
              set(h.Gt_magnitue_label,"visible","on");
              set(h.Gt_angle_edit,"visible","on");
              set(h.Gt_magnitue_edit,"visible","on");
              set(h.zA_label,"visible","off");
              set(h.zA_value_edit, "visible", "off");
              set(h.advanced_enable_checkbox, "visible","on");
          endif
    case {h.zA_value_edit}
          v=get(gcbo,"string");
          try
              zA=str2num(v);
              s(1).z=zA;
              Gt=z2G(zA+1e-6+j*1e-6);
              s(1).Gt=Gt;
          catch
              errordlg("Syntax Error");
          end_try_catch
    case {h.update_pushbutton}
            updateF=1;
    case {h.design_pushbutton}
            design_F=1;
            updateF=1;
            redraw_F=1;
    case {h.sign_select_popup}
            sign_val=get(h.sign_select_popup,'Value');
    case {h.advanced_enable_checkbox}
        advF=get(h.advanced_enable_checkbox, "value");
            if (advF==1)  %make advanced inputs visible
                set (h.advanced_bg, "visible" , "on");
                set (h.adv_Gt_reset_rb, "visible", "on");
                set (h.adv_Gt_T_match_rb, "visible", "on");
                set (h.Gt_select_bg, "visible", "on");
                set (h.enable_presets_checkbox,"visible","on");
                set (h.enable_presets_lable, "visible", "on" );
                set (h.enable_presets_checkbox,"value",1);
                set (h.Gselect, "value", 1);
                set (h.adv_Gt_T_match_rb,"value",1);
                G_T_flag=1;
            elseif (advF==0)  %make advanced inputs invisible
                set (h.enable_presets_checkbox,"value",0);
                set (h.advanced_bg, "visible" , "off");
                set (h.adv_Gt_reset_rb, "visible", "off");
                set (h.adv_Gt_T_match_rb, "visible", "off");
                set (h.enable_presets_checkbox,"visible","off");
                set (h.enable_presets_lable, "visible", "off" );
                set (h.Gt_select_bg, "visible", "off");
                set (h.adv_Gt_reset_rb,"value",1);
            endif
    case {h.show_const_gr_checkbox}
            updateF=1;
            showgr=get(h.show_const_gr_checkbox,"value");
    case {h.adv_Gt_reset_rb}
            resetGt=get(h.adv_Gt_reset_rb,"value");
    case {h.adv_Gt_T_match_rb}
            G_T_flag=get(h.adv_Gt_T_match_rb,"value");
    case {h.redraw_pushbutton}
            redraw_F=1;
endswitch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (init)
      G_T_flag=0;
    endif
 if (init||back_F||updateF||redraw_F||design_F||advF)
      hold off;
      drawSmithChartCanvas;           %SET UP Initial background
      set(gca,'xticklabel',{[]});     %take tick lables off
      set(gca,'yticklabel',{[]});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PLOT Q %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if (qflag)  %%plot Q when selected
          if ~isempty(Qn)
              plotQ(Qn);
          endif
      endif
%%%%%%%%%%%%%%%%%%%%% MATCH FROM zL to Gt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if (zA_match_F==0)
            zA=[];                  %destroy zA if design is for GL/GS
            set(h.zA_value_edit,"string","");
            set(h.z_in_element_select_popup, "visible", "off");
            set(h.element_select_popup,"visible","on");
            try
                s(1).z=zL;
            catch
                errordlg("enter zL");
            end_try_catch
%%%%%%%%%%%%%%%  MATCH FROM zA to zL  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      elseif (zA_match_F==1)  %Set Up For Match FROM zA to zL
            G_mag=[];    %destroy Gt if design is for zA
            G_angle=[];
            set(h.advanced_enable_checkbox,"value",0)
            set(h.Gt_magnitue_edit,"string","");
            set(h.Gt_angle_edit, "string","");
            set(h.z_in_element_select_popup, "visible", "on");
            set(h.element_select_popup,"visible","off");
            if (~isempty(zA))     %plot zA when its there
                s(1).z=zA+1e-6+j*1e-6;
                Gt=z2G(zA);
                s(1).Gt=Gt;
                if abs(Gt)<1e-3;
                    plot(0,0,'Color','k','x','MarkerSize',10);
                else
                    TargetGammaPlot(Gt);
                endif
            endif
      endif %zA to Gt or zL to Gt
%%%%%%%%%%%%SHOW CONSTANT Resistance Conductance Circles %%%%%%%%%%%%%%%%%%%%%%%
      if (showgr)     %plot const g,r circles when box is checked
          if (zA_match_F)
              if ~isempty(zA)
                  plotG(real(1/zL));
              endif
          else
              if ~(isempty(Gt))
                  plotR(real(G2z(Gt)));
                  plotG(real(G2y(Gt)));
              endif
          end
      endif
%%%%% PLOT zL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if ~isempty(zL)     %plot zL when it's there
          plot(z2G(zL)+1e-6+1e-6*j,'Color',[0 0 0],'.','MarkerSize',12);
          v=sprintf("zL=%.2f+j%.2f",real(zL),imag(zL));
          set(h.output_label,"string",v);
      endif
%%%%% PLOT Gt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if ~isempty(G_mag*G_angle) %plot target Gt when its there
                Gt=Phasor_2_C(G_mag,G_angle+eps);
                if isempty(s(r).Gt)||(r==1)
                    s(1).Gt=Gt;
                endif
                TargetGammaPlot(Gt);
      endif
%%%%%GO BACK ONE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if (back_F) %go back one code
            PresetStuff(h,s,r,back_F);
            r=Go_Back_One(h,s,r,Gt,zL);
            back_F=0;
      endif
%%%% REDRAW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if (redraw_F)
            ReDraw(s,r,Gt,zL);
      endif
%%%%CALCULATE Gt_adv    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %     if ~isempty(G
      if (advF*G_T_flag)
          [s,Gt_adv]=Calc_Gt_adv(h,s,r,Gt,zL);
          Plot_Circle(0,Gt_adv);
          updateF=1;
      endif
%%%DESIGN A STAGE%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if (design_F) %% DESIGN A STAGE
          design_F=0;
          [h,s,r]=Design_Stage(h,s,r,Gt,zL);
          Table_Output(h,s,r,zL);
          PresetStuff(h,s,r);
      endif

 endif %of checked flags

       if ~isempty(zL)  %Once zL is entered
          z_in=s(r).z;  %Get the Current imput impedance to display
          y_in=1/s(r).z; %get the Current imput admittance to display
          G_in= C_2_Phasor(z2G(s(r).z)); %Get Current Input Reflection Coefficent
          if (advF*G_T_flag)
            G_targ=C_2_Phasor(Gt_adv);  %set G_targ to display as a phasor
          else
            G_targ=C_2_Phasor(s(r).Gt);   %display as a phasor
          end;
          a=real(G_targ);
          b=imag(G_targ);
          if (imag(z_in)>=0)
            set (h.advanced_current_z_label, "string", sprintf("zIN= %.2f +j%.2f",real(z_in),imag(z_in)));
          else
            set (h.advanced_current_z_label, "string", sprintf("zIN= %.2f -j%.2f",real(z_in),-imag(z_in)));
          endif
          if (imag(y_in)>=0)
            set (h.advanced_current_y_label,"string", sprintf("yIN= %.2f + %.2fj",real(y_in),imag(y_in)));
          else
            set (h.advanced_current_y_label,"string", sprintf("yIN= %.2f - %.2fj",real(y_in),-imag(y_in)));
          endif
          set (h.advanced_current_G_label,"string", sprintf("GIN= %.3f /_ %.1f",real(G_in),imag(G_in)));
%          set (h.advanced_current_Gt_label,"string", sprintf("Gt= %.3f /_ %.1f",a,b));
       endif

endfunction

%%%UPPER RIGHT G Z LABELS/CONTROLS%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.zA_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "zIN=", "visible", "off",
                                "horizontalalignment", "center",
                                "position", [0.75 0.85 0.05 0.05]);
h.zA_value_edit = uicontrol ("style", "edit",
                                "units", "normalized", "visible", "off",
                                "string", "",
                                "position", [0.80 0.85 0.20 0.05],
                                "callback",@update_plot);
h.match_2_zA_checkbox = uicontrol ("style", "checkbox",
                                "units", "normalized",
                                "string", "match zIN to zL",
                                "callback", @update_plot,
                                "position", [0.75 0.65 0.25 0.05]);
h.Gtarget_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Enter Gs/GL",
                                "horizontalalignment", "left",
                                "position", [0.70 0.95 0.35 0.05]);
h.Gt_magnitue_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Magnitude",
                                "horizontalalignment", "left",
                                "position", [0.70 0.90 0.20 0.05]);
h.Gt_magnitue_edit = uicontrol ("style", "edit",
                                "units", "normalized",
                                "string", "0.",
                                "position", [0.70 0.85 0.14 0.05],
                                "callback",@update_plot);
h.Gt_angle_label = uicontrol    ("style", "text",
                                "units", "normalized",
                                "string", "ANGLE(deg)",
                                "horizontalalignment", "left",
                                "position", [0.85 0.90 0.20 0.05]);
h.Gt_angle_edit = uicontrol ("style", "edit", "units", "normalized",
                                             "string", "","callback", @update_plot,
                                             "position", [0.85 0.85 0.14 0.05]);
h.Q_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Q=",
                                "horizontalalignment", "center",
                                "position", [0.55 0.75 0.05 0.05]);
h.Q_value_edit =    uicontrol ("style", "edit",
                                "units", "normalized",
                                "string", "","horizontalalignment", "center",
                                "position", [0.60 0.75 0.05 0.05],
                                "callback",@update_plot);
h.Q_enable_checkbox = uicontrol ("style", "checkbox",
                                "units", "normalized",
                                "string", "plot Qn ",
                                "callback", @update_plot,
                                "position", [0.55 0.80 0.15 0.05]);

h.zL_value_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "zL=",
                                "horizontalalignment", "center",
                                "position", [0.70 0.78 0.10 0.05]);

h.zL_value_edit = uicontrol ("style", "edit", "units", "normalized",
                                "string", "","horizontalalignment",
                                "center", "position", [0.80 0.78 0.20 0.05],
                                "callback",@update_plot);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.update_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Enter/Update",
                                "callback", @update_plot,
                                "position", [0.60 0.65 0.15 0.09]);
h.redraw_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Redraw",
                                "callback", @update_plot,
                                "position", [0.60 0.40 0.15 0.09]);

h.show_const_gr_checkbox = uicontrol ("style", "checkbox",
                                      "units", "normalized",
                                      "string", "show g/r circle's",
                                      "callback", @update_plot,
                                      "position", [0.55 0.55 0.25 0.05]);


%%%%%%%%%%END UPPER RIGHT CONTROLS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.update_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Enter/Update",
                                "callback", @update_plot,
                                "position", [0.6 0.65 0.15 0.09]);
h.design_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Design",
                                "callback", @update_plot,
                                "position", [0.50 0.35 0.10 0.07]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%right Center
h.go_back_one_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Go Back One",
                                "callback", @update_plot,
                                "position", [0.70 0.25 0.20 0.09]);


%%%%OUTPUT TEXT BOXES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.output_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "",
                                "horizontalalignment", "center",
                                "position", [0.00 0.35 0.20 0.05]);
h.output1_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "",
                                "horizontalalignment", "center",
                                "position", [0.00 0.30 0.20 0.05]);
h.output2_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "",
                                "horizontalalignment", "center",
                                "position", [0.00 0.25 0.20 0.05]);
h.output3_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "",
                                "horizontalalignment", "center",
                                "position", [0.00 0.20 0.20 0.05]);
h.output4_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "",
                                "horizontalalignment", "center",
                                "position", [0.00 0.15 0.20 0.05]);
h.output5_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "",
                                "horizontalalignment", "center",
                                "position", [0.00 0.10 0.20 0.05]);

%%%%%%%% LOWER LEFT%%%%%%%% MATCH DESIGN CONTROLS
h.element_select_label = uicontrol  ("style", "text","units",
                                    "normalized","string", "Match Element",
                                    "horizontalalignment", "left",
                                    "position", [0.30 0.35 0.18 0.05]);

h.z_in_element_select_popup = uicontrol  ("visible", "off","style", "popupmenu",
                                          "units", "normalized", "string",
              {"Series Reactance jx", "Shunt Admitance jb","Line Displacement"},
                                          "callback", @update_plot,
                                          "position", [0.30 0.30 0.25 0.05]);
h.element_select_popup = uicontrol  ("style", "popupmenu", "units",
                                      "normalized","string", ...
 {"Series Reactance jx", "Shunt Admitance jb", "Wave/4 Tx", "L/4 to g", "Line displacement"},
                                      "callback", @update_plot,
                                      "position", [0.30 0.30 0.25 0.05]);

h.sign_select_label = uicontrol ("style", "text", "units", "normalized",
                                  "string", "sign", "horizontalalignment", "left",
                                  "position", [0.20 0.35 0.06 0.05]);

h.sign_select_popup = uicontrol ("style", "popupmenu", "units", "normalized",
                                  "string", {"+","-"}, "callback", @update_plot,
                                  "position", [0.20 0.30 0.06 0.05]);
%%%%%% BEGIN ADVANCED CONTROLS
h.enable_presets_checkbox = uicontrol ("visible", "off", "style", "checkbox",
                                        "units", "normalized","string",
                                        "Enable Presets","horizontalalignment",
                                        "center", "position", [0.00 0.05 0.20 0.05]);
h.enable_presets_lable = uicontrol ("visible", "off", "style", "text",
                                    "units", "normalized", "string",
                                    "for T or PI match", "horizontalalignment",
                                    "center", "position", [0.00 0.00 0.20 0.05]);

h.advanced_enable_checkbox = uicontrol ("style", "checkbox", "units",
                                        "normalized", "string", "advanced design ",
                                        "callback", @update_plot,
                                        "position", [0.20 0.25 0.15 0.05]);
%%%%%%RADIO BUTTON GROUP START
h.advanced_bg = uibuttongroup ("position", [ 0.20 0 0.25 0.25], "visible", "off");
h.Gselect = uicontrol (h.advanced_bg, "style", "radiobutton", "string", "Gt select",
                                  "units","normalized", "Position", [0.0 0.66 1 0.33]);
h.Qselect = uicontrol (h.advanced_bg, "style", "radiobutton", "string",
                                      "Qn w/ this ele", "units", "normalized",
                                      "Position", [ 0.0 0.33 1 0.33]);
h.Circleselect = uicontrol (h.advanced_bg, "style", "radiobutton", "string",
                                            "hit r/g circle", "units",
                                            "normalized", "Position", [ 0.0 0.00 1 0.33]);
%%%%%%%%%ADVANCED RADIO BUTTON GROUP END
h.Gt_select_bg = uibuttongroup ("position", [ 0.40 0.15 0.28 0.10], "visible", "off");
h.adv_Gt_T_match_rb = uicontrol (h.Gt_select_bg,"style", "radiobutton",
                                "units", "normalized", "visible", "on",
                                "string", "set Gt for T/PI match ",
                                "callback", @update_plot,
                                "position", [0.0 0.50 1 0.50]);

h.adv_Gt_reset_rb = uicontrol (h.Gt_select_bg,  "style", "radiobutton", "units",
                                                "normalized", "visible", "on",
                                                "string", "set to Gs/Gl ","callback",
                                              @update_plot, "position", [0 0 1 0.50]);

%% DISPLAY CURRENT IMPEDANCE ADMITTANCE
h.advanced_current_z_label = uicontrol ("style", "text", "units", "normalized",
                                        "string", "zIN=", "horizontalalignment",
                                        "left", "position", [0.45 0.10 0.20 0.05]);
h.advanced_current_y_label = uicontrol ("style", "text", "units", "normalized",
                                        "string", "yIN=", "horizontalalignment",
                                        "left", "position", [0.65 0.10 0.20 0.05]);
h.advanced_current_G_label = uicontrol ("style", "text", "units", "normalized",
                                        "string", "GammaIN=", "horizontalalignment",
                                        "left", "position", [0.65 0.05 0.20 0.05]);
%h.advanced_current_Gt_label = uicontrol ("style", "text", "units", "normalized",
%                                          "string", "Gtarget=", "horizontalalignment",
%                                          "left", "position", [0.45 0.05 0.20 0.05]);
%%%%%%%%%%%%%%%%%%%%%%%%%END OF LAYOUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
    guidata (gcf, h)
    h=update_plot (gcf, true);

