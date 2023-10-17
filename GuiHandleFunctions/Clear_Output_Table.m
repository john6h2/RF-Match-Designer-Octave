%  Clear_Output_Table(h)
%
%  SYNOPSIS:
%       This function clears the table output.
%  SYNTAX:
%       Clear_Output_Table(h)
%  INPUT ARGUMENTS:
%       h   : The figure handle of the gui, containing table handles

function  Clear_Output_Table(h)
            set (h.output1_label, "string","");
            set(h.output2_label, "string", "");
            set(h.output3_label, "string", "");
            set(h.output4_label, "string", "");
            set(h.output5_label, "string" ,"");
endfunction
