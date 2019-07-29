%% If your ground reaction data presents any offset, you could correct them here!

function data_Cop = inv_x_offset(data_Cop,bilat)

if bilat == 1
    
    % Inverting Cop data
    data_Cop(:,2)=data_Cop(:,2).*-1;
    data_Cop(:,5)=data_Cop(:,5).*-1;
    % Adding offset to x
    data_Cop(:,2)=data_Cop(:,2)+.3002;
    data_Cop(:,5)=data_Cop(:,5)+.3002;
    % Adding offset to z
    data_Cop(:,1)=data_Cop(:,1)+(.2022);
    data_Cop(:,4)=data_Cop(:,4)+(.2022);
    
elseif bilat == 2
    % Inverting Cop data
    
    data_Cop(:,2)=data_Cop(:,2).*-1;
    % Adding offset to x
    
    data_Cop(:,2)=data_Cop(:,2)+.3002;
    % Adding offset to z
    
    data_Cop(:,1)=data_Cop(:,1)+(.2022);
    

end