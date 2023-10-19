%  [h,s,r]=Design_Stage(h,s,r,Gt,zL)
%
%   SYNOPSIS:
%       This function sets up the arguments and parameters for EVERY type
%       of design UI data is extracted from h, the structure s is called
%       s(r).Gt Target Reflection Coefficent
%       s(r).z  Current Impedance
%       s(r).sign The sign Chosen from the popup menu
%       s(r).Q, s(r).circle: optionally used for T/PI match from zL to Gt`
%       then calls the relavent design functions, and places the outputs
%       in the structue
%       s(r+1).Gt,s(r+1).z,s(r+1).out
%       s(r).out is the output, calculated jx, jb, length of line for
%       line displacement, or Z0x, the characteristic impedance of a
%       quarter wave transformer,
%       s(r+1).type records the type of element used
%       1   : Match_Series_x
%       2   : Match_Shunt_b
%       3   : Match_Quarter_Wave
%       4   : Match_Line_Displacement
%       5   : Set_Target_x was called   for zA match only
%       6   : Set_Target_b was called   for zA match only
%       s(r+1).num records the number of arguments were used in calling
%       the above functions.
%
%  SYNTAX:
%     [h,s,r]=Design_Stage(h,s,r,Gt,zL)
%  INPUT ARGUMENTS:
%       h   : The figure handle of the gui, containing data and flags
%       s   : The struct used in RF_match_designer
%       r   : the design stage # of stages = r-1
%       Gt  : The Gt entered from RF_match_designer
%       zL  : zL entered from RF_match_designer
%   OUTPUT ARGUMENTS:
%       h   : handles update, not neccesary tho
%       s   : updated output to the struct
%       r   : index r+1 if the design attemped was successfuly completed
%             not incremented if the design failed


function [h,s,r]=Design_Stage(h,s,r,Gt,zL)
%EXTRACT DATA AND FLAGS FROM h
  G_T_flag=get(h.adv_Gt_T_match_rb,"value");
  advanced=get(h.advanced_enable_checkbox, "value");
  v=get(h.Q_value_edit,"string");
    Qn=str2num(v);                    %Qn value
  circle_selectF=get(h.Circleselect,"value");   %if hit r/g circle selected
  Q_sel_F=get(h.Qselect,"value");               %if Qn w/ this .. selected

        sign_val=get(h.sign_select_popup,'Value');
        if sign_val==1  % set values 1,2 to '+','-'
          s(r).sign='+';
        elseif sign_val==2
          s(r).sign='-';
        end
    zA_match=get(h.match_2_zA_checkbox,"value"); %match zA to zL value
    %Determine which popup menu is read
        if (zA_match==0)
          menu_val = get(h.element_select_popup,'Value');
        elseif (zA_match==1)
          menu_val = get(h.z_in_element_select_popup,'Value');
        endif

%%%%%%Check if the user used the same type as last time.
        if (menu_val==s(r).type)
          btn = questdlg ("You picked the same element, Continue?", ...
                        "Verify","Yes", "No", "No");
          if (strcmp (btn, "No"))
            return;
          endif
        endif
%%%STANDARD DESIGN FROM zL TO Gt
if (zA_match==0)
    switch (menu_val) %attempt a design of user chosen type.
      case 1  %design series jx
          try
              if (Q_sel_F*advanced)  %if design for Qn is selected
                    s(r).Q=Qn;
[s(r+1).Gt, s(r+1).z, s(r+1).out] = Match_Series_x(s(r).Gt,s(r).z,s(r).sign,s(r).Q);
                    s(r+1).num=4; %record nargin
              elseif (circle_selectF*advanced) %if design for g/r circle selected
                    g_circle=real(G2y(Gt));
                    plotG(g_circle)
                    s(r).circle=g_circle;
                    s(r).Q=Qn;   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s(r+1).Gt, s(r+1).z, s(r+1).out] = Match_Series_x(s(r).Gt,s(r).z,s(r).sign,s(r).Q,s(r).circle);
                    s(r+1).num=5;
              else %design for Gt only
[s(r+1).Gt, s(r+1).z, s(r+1).out] = Match_Series_x(s(r).Gt,s(r).z,s(r).sign);
                    s(r+1).num=3;
              endif;
              s(r+1).type=1; %record series jx was done
          catch
              errordlg("No solution for this element.");
              r=r-1;
          end_try_catch
      case 2  %design shunt jb
          try
              if (Q_sel_F*advanced)  %if design for Qn is selected
                  s(r).Q=Qn;
[s(r+1).Gt, s(r+1).z, s(r+1).out] = Match_Shunt_b(s(r).Gt,s(r).z,s(r).sign,s(r).Q);
                  s(r+1).num=4;
              elseif (circle_selectF*advanced)
                  r_circle=real(G2z(Gt));
                  plotR(r_circle)
                  s(r).circle=r_circle;
                  s(r).Q=Qn;
                  s(r+1).LAST=1;
[s(r+1).Gt, s(r+1).z, s(r+1).out] = Match_Shunt_b(s(r).Gt,s(r).z,s(r).sign,s(r).Q,s(r).circle);
                  s(r+1).num=5;  %record the number of arguments
              else
                  if (s(r).type==3)&&(s(r).num==4)
                    s(r).Gt=Gt;
                  endif
[s(r+1).Gt, s(r+1).z, s(r+1).out] = Match_Shunt_b(s(r).Gt,s(r).z,s(r).sign);
                  s(r+1).num=3;  %record the number of arguments
              endif
                  s(r+1).type=2;  %record type if the design was possible
          catch
              errordlg("No solution for shunt jb of this sign, try another.");
              r=r-1;
          end_try_catch
      case 3  %design lamda/4 transformer
          try
[s(r+1).Gt, s(r+1).z, s(r+1).out] =  Match_Quarter_Wave(s(r).Gt,s(r).z,s(r).sign);
              s(r+1).type=3;
              s(r+1).num=3;
          catch
              errordlg("No solution for Quarter Wave transformer for this refl coef, z");
              r=r-1;
          end_try_catch
      case 4  %design lamda/4 transformer to hit g_circle of target Gs/GL
          try
 [s(r+1).Gt, s(r+1).z, s(r+1).out] =  Match_Quarter_Wave(s(r).Gt,s(r).z,s(r).sign,1);
           s(r+1).type=3;
           s(r+1).num=4;
          catch
            errordlg ("No solution for Quarter Wave this sign an Reflection Coefficent");
          end_try_catch

      case 5  % design matched line displacement
          try
[s(r+1).Gt,s(r+1).z, s(r+1).out] = Match_Line_Displacement(s(1).Gt,s(r).Gt);
              s(r+1).type=5;
              s(r+1).num=2;
          catch
              r=r-1;
          end_try_catch
    endswitch %Match From zL to Reflection Coefficent
%%%MATCH FROM zA TO zL
elseif (zA_match==1) %Match FROM zA to
    plotG(real(1/zL));
        switch (menu_val)
          case(1)
              [s(r+1).Gt, s(r+1).z, s(r+1).out]= Set_Target_x( zL, s(r).z, s(r).sign);
              s(r+1).type=6;
              s(r+1).num=3;
          case(2)
              [s(r+1).Gt, s(r+1).z, s(r+1).out]= Set_Target_b( zL, s(r).z, s(r).sign);
              s(r+1).type=7;
              s(r+1).num=3;
          case(3)
              [s(r+1).Gt,s(r+1).z, s(r+1).out] = Match_Line_Displacement(s(1).Gt,s(r).Gt,real(1/zL));
              s(r+1).type=4;
              s(r+1).num=3;
        endswitch
endif
   r=r+1;    %increment stage number
   %IF it's matched Notify the user
    if (zA_match)
          if (abs(zL-s(r).z)<1e-6)&&(r>1)
            helpdlg("You have successfuly matched to zL.")
          endif
    else
          if (abs(Gt-s(r).Gt)<1e-6)&&(r>1)
            helpdlg ("You have successfuly matched to target.");
          endif
    end
endfunction
