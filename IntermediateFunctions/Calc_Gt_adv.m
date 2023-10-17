%  [s,Gt_adv]=Calc_Gt_adv(h,s,r,Gt,zL)
%
%   SYNOPSIS:
%       This function calculates the reflection coefficent, for a T
%       or PI match, x3 added series to zL, or b3 added shunt to yL
%       to meet rt=G2z(Gt) and determines the second element in the
%       matching network has a node Q equal to the Qn specified. s(1).Gt
%       is modified.
%  SYNTAX:
%     [s, Gt_adv] = Calc_Gt_adv(h,s,r,Gt,zL)
%   INPUT ARGUMENTS:
%       h   : The figure handle of the gui, containing table handles
%       s   : The struct used in RF_match_designer
%       r   : the design stage # of stages = r-1
%       Gt  : The Gt entered from UI
%       zL  : zL entered from the UI
%   OUTPUT ARGUMENTS:
%       s       : The struct used in RF_match_designer, neccessary to update
%       Gt_adv  : The calculated Reflection Coeffient

function [s,Gt_adv]=Calc_Gt_adv(h,s,r,Gt,zL)
  %EXTRACT DATA AND FLAGS FROM h
    G_T_flag=get(h.adv_Gt_T_match_rb,"value");
    resetGt=get(h.adv_Gt_reset_rb,"value");
    menu_val=get(h.element_select_popup,"value");
    advanced=get(h.advanced_enable_checkbox, "value");
        v=get(h.Q_value_edit,"string");
          Qn=str2num(v);

  if (advanced*G_T_flag) %design Gt for T TT match checkbox hit
      if isempty(Qn)
          errordlg("You have to enter Qn");
          return;
      endif
        if (menu_val==1)
              rL=real(s(1).z);
              xL=imag(s(1).z);
              rt=real(G2z(Gt));
              x3=-xL+sqrt(rt*rL*(1+Qn^2)-rL^2);
              Gt_adv=z2G(zL+j*x3);
              plotG(real((zL+j*x3)^-1));
              Plot_Circle(0,Gt_adv);
        endif %menu_val=1
        if (menu_val==2)
              gL=real(1/s(1).z);
              bL=imag(1/s(1).z);
              gt=real(G2y(s(1).Gt));
              b3=-bL+sqrt(gt*gL*(1+Qn^2)-gL^2);
              Gt_adv=y2G(1/zL+j*b3);
              plotR(real((1/zL+j*b3)^-1))
              Plot_Circle(0,Gt_adv);
        endif %menu_val=2
  else
         Gt_adv=[];  %if advanced is turned off destroy Gt_adv
  endif
        if exist('Gt_adv')
          s(r).Gt=Gt_adv;
        else  %L/4 Tx or Line Displacement was selected
          errordlg('Choose series or shunt');
          return;
        end
        if (resetGt*advanced)
            s(r).Gt=Gt;
            Plot_Circle(0,Gt)
        endif
endfunction
