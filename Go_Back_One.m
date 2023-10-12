%  r=Go_Back_One(h,s,r,Gt,zL)
%
%   SYNOPSIS:
%       This function removes the last stage from the plot
%       and decrement's the index of stage design r. This function
%       calls Clear_Output_Table and Table_Output
%  SYNTAX:
%       r=Go_Back_One(h,s,r,Gt,zL)
%  INPUT ARGUMENTS:
%       h   : The figure handle of the gui, containing table handles
%       s   : The struct used in RF_match_designer
%       r   : the design stage # of stages = r-1
%       Gt  : The Gt entered from RF_match_designer
%       zL  : zL entered from RF_match_designer

function r=Go_Back_One(h,s,r,Gt,zL)
    Clear_Output_Table(h);
          for m=2:r-1
            switch(s(m).type)
                case (1)
                switch(s(m).num)
                    case(3)
                  %[s(m).Gt, s(m).z, s(m).out]=
                  Match_Series_x(s(m-1).Gt,s(m-1).z,s(m-1).sign);
                    case(4)
                        Match_Series_x(s(m-1).Gt,s(m-1).z,s(m-1).sign,s(m-1).Q);
                    case(5)
                      %  [s(m).Gt, s(m).z, s(m).out]=
                        Match_Series_x(s(m-1).Gt,s(m-1).z,s(m-1).sign,s(m-1).Q,s(m-1).circle);
                endswitch
                case 2
                    switch(s(m).num)
                        case(3)
                        %[s(m).Gt, s(m).z, s(m).out]=
                        Match_Shunt_b(s(m-1).Gt,s(m-1).z,s(m-1).sign);
                        case(4)
                           % [s(m).Gt, s(m).z, s(m).out]=
                            Match_Shunt_b(s(m-1).Gt,s(m-1).z,s(m-1).sign,s(m-1).Q);
                        case(5)
                            %[s(m).Gt, s(m).z, s(m).out]=
                            Match_Shunt_b(s(m-1).Gt,s(m-1).z,s(m-1).sign,s(m-1).Q,s(m-1).circle);
                    endswitch
                case 3
                    %[s(m).Gt, s(m).z, s(m).out]=
                    Match_Quarter_Wave(s(m-1).Gt,s(m-1).z,s(m-1).sign);
                case 4
                    if (s(m).num==2)
                      %[s(m).Gt, s(m).z, s(m).out]=
                      Match_Line_Displacement(Gt,s(m-1).Gt);
                    elseif (s(m).num==3)
                      %[s(m).Gt, s(m).z, s(m).out]=
                      Match_Line_Displacement(Gt,3,real(1/zL));
                    endif
                case 5
                    Set_Target_x( zL, s(m-1).z, s(m-1).sign);
                case 6
                    Set_Target_b( zL, s(m-1).z, s(m-1).sign);
            endswitch
            Table_Output(h,s,m);
          endfor
        r=r-1;   %decrement current Stage Number
endfunction
