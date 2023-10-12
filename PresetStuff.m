%     PresetStuff(h,s,r,back_F)
%
%  SYNOPSIS:
%This function enables presets for a T or PI match, for the design of a matching
%network with a given node Q
%
%
%  SYNTAX:
%     PresetStuff(h,s,r,back_F)
%  INPUT ARGUMENTS:
%     h               : The handle of the gui defined in RF_match_designer
%     s               : A structure used in RF_match_designer
%     r               : index of the stage of design r-1 stages have been designed
%     back_F          : a flag indicating GoBackOne was hit
%
%     John Hawkins - (10-06-2023)
function PresetStuff(h,s,r,back_F)
  %%EXTRACT data/flags from h
    presetsF=get(h.enable_presets_checkbox,"value");
    zA_match=get(h.match_2_zA_checkbox,"value");
    advF=get(h.advanced_enable_checkbox, "value");
    if (zA_match==0)
      set(h.advanced_enable_checkbox,"value",0);  %turn off advanced_enable_checkbox
 %     set(h.advanced_enable_checkbox,"visible","off");
    endif
  %%IF last type was jx, change to jb and vice versa. IF preset checkbox
    if (presetsF)
        if(s(r).type==1)
            set(h.element_select_popup,"value",2);
        endif
        if(s(r).type==2)
            set(h.element_select_popup,"value",1);
            set(h.adv_Gt_T_match_rb,"value",1);
        endif

    %SET Everything after the first stage to hit r/g circle,
    %Qn w/ this element would give the same results.
        if (r>1)
          set(h.Circleselect,"value",1);  %set to circle select
        endif
%IF going back set the menu values to before the previous
%design stage.
        if exist('back_F')
            if(back_F&&advF)
                if(s(r).type==1)
                    set(h.element_select_popup,"value",1);
                endif
                if(s(r).type==2)
                    set(h.element_select_popup,"value",2);
                endif
        %FOR PI/T match in the event of back, r=1 is set to Gt select
                if(r==2)
                    set(h.Gselect, "value", 1);
                endif
            endif %back_F&&advF
        endif %existance of back_F
    endif %presetsF

endfunction


