%  Table_Output(s,h,r,Gt,zL)
%
%   SYNOPSIS:
%       This function writes the last successfully designed stage
%       index r, and outputs writes to the figure labels in the
%       RF_match_designer gui.
%  SYNTAX:
%     Table_Output(h,s,r,Gt,zL)
%  INPUT ARGUMENTS:
%     h   : The figure handle of the gui, containing table handles
%     s   : The struct used in RF_match_designer
%     r   : the design stage # of stages = r-1
%     Gt  : The Gt entered from RF_match_designer
%     zL  : zL entered from RF_match_designer
%  OUTPUT ARGUMENTS:
%     none
function  Table_Output(h,s,r,zL)
  %set up which string
  switch(s(r).type)
    case(1)
      v=sprintf("series jx=%.3f", s(r).out);
    case(2)
      v=sprintf ("shunt jb=%.3f", s(r).out);
    case(3)
      v=sprintf( "l/4, Z0x=%.2f",s(r).out);
    case(4)
      v=sprintf("line of l=%.3f",s(r).out);
    case (5)
      v=sprintf("series l=%.3f", s(r).out);
    case (6)
      v=sprintf ("shunt jx=%.3f", s(r).out);
    case(7)
      v=sprintf ("shunt jb=%.3f", s(r).out);
  endswitch



      switch(r)
        case (1)
              if ~isempty(zL)
                v=sprintf("zL=%.2f+j%.2f",zL);
                set(h.output_label,"string",v);
              endif
        case (2)
            set (h.output1_label, "string",v);
        case(3)
            set(h.output2_label, "string", v);
        case(4)
            set(h.output3_label, "string", v);
        case(5)
            set(h.output4_label, "string", v);
        case(6)
            set(h.output5_label, "string" , v);
     endswitch


