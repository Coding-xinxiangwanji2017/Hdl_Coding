function [ output_data ] = func_echo_split( trigger_edge )
%FUNC_ECHO_SPLIT Summary of this function goes here
%   Detailed explanation goes here

echo_pair = [1, 8; 
             2, 7; 
             3, 6; 
             4, 5] ; 
         
[row col] = size(trigger_edge); 

data = trigger_edge; 

id_echo = 1; 
frameID_echo_start = 1; 

% % check first row
% if (data(1,2)~= 1)
%     fprintf('Incomplete Trigger_edge data ...\n');
%     fprintf('The Trigger-Edge Time sequence does not start from 1 ...\n') ;
%     output_data = 0 ; 
%     return;
% end

ind_echo_start = 1; 
for k = 1:1:row
    if trigger_edge(k, 2) ~= 0
        trigger_edge(k, 4) = id_echo;
    end
    
    if data(k,2) == (9-frameID_echo_start)
        id_echo = id_echo + 1; 
        if k<row
            frameID_echo_start = data(k+1, 2); 
            ind_echo_start = k+1; 
        else break; 
        end
    end     
end


% check last-echo integrity
if trigger_edge(ind_echo_start, 2) ~= 9 - trigger_edge(row,2) 
    trigger_edge(ind_echo_start:row, :) = 0 ; 
end

output_data = sortrows(trigger_edge) ; 

end

