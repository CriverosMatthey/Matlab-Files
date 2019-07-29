%% Routine to convert travectories axes from motion capture system to OpenSim axes pattern

function  data_trajetorias_convert = convert_traj_axes(data_trajetorias,var)

if var == 1;

lista1 = {'VICON';'BTS';'OTHERS'};

    [s1,v1] = listdlg('PromptString','Select motion capture system used to perform convertion',...
        'SelectionMode','single',...
        'ListSize', [400 300],...
        'ListString',lista1);
    
    if s1(1) == 2;
        
        data_trajetorias_convert = data_trajetorias;
        
    elseif s1(1) == 1;
        
        % Pay attention to these convertion
        
        for kk = 3:3:size(data_trajetorias,2);
            
            var_aux = data_trajetorias(:,kk-2);
            
            var_aux2 = data_trajetorias(:,kk-1);
            
            var_aux3 = data_trajetorias(:,kk);
                   
            data_trajetorias (:,kk-2) = -var_aux2; %% old "Y" turns "X"
                    
            data_trajetorias (:,kk-1) = var_aux3; %% old "Z" turns "Y"
            
            data_trajetorias (:,kk) = -var_aux; %% old "X" turns "Z"            
        end
        

        
    elseif s1(1) == 3;
        
        msgbox('Look for how motion capture system axes are deffined to perform convertion')
        
    end
    
    
    data_trajetorias_convert = data_trajetorias;
    
elseif var == 2;
    
    lista1 = {'VICON';'BTS';'OTHERS'};

    [s1,v1] = listdlg('PromptString','Select system used to calculate the joint angles',...
        'SelectionMode','single',...
        'ListSize', [400 300],...
        'ListString',lista1);
    
    if s1(1) == 2;
        
        data_trajetorias_convert = data_trajetorias;
        
    elseif s1(1) == 1;
        
        for kk = 3:3:size(data_trajetorias,2);
            
            var_aux = data_trajetorias(:,kk-2);
            
            var_aux2 = data_trajetorias(:,kk-1);
            
            var_aux3 = data_trajetorias(:,kk);
                   
            data_trajetorias (:,kk-2) = -var_aux2; %% O antigo eixo "Y" virou "X"
                    
            data_trajetorias (:,kk-1) = var_aux3; %% O antigo eixo "Z" virou "Y"
            
            data_trajetorias (:,kk) = -var_aux; %% O antigo eixo "X" virou "Z"
            
        end
        

        
    elseif s1(1) == 3;
        
        msgbox('Look for how motion capture system axes are deffined to perform convertion')
        
    end
    
    
    data_trajetorias_convert = data_trajetorias;
    
    
elseif var == 3;
    
    lista1 = {'AMTI';'BTS';'BERTEC';'OTHERS'};

    [s1,v1] = listdlg('PromptString','Select system used to record ground reaction data',...
        'SelectionMode','single',...
        'ListSize', [400 300],...
        'ListString',lista1);
    
    if s1(1) == 2;
        
        data_trajetorias_convert = data_trajetorias;
        
    elseif s1(1) == 1;
        
        for kk = 3:3:size(data_trajetorias,2);
            
            var_aux = data_trajetorias(:,kk-2);
            
            var_aux2 = data_trajetorias(:,kk-1);
            
            var_aux3 = data_trajetorias(:,kk);
                   
            data_trajetorias (:,kk-2) = var_aux2;
                    
            data_trajetorias (:,kk-1) = -var_aux3;
            
            data_trajetorias (:,kk) = -var_aux;
            
        end
        
    elseif s1(1) == 3;
        
        msgbox('Look for how Bertec system axes are deffined to perform convertion')
        
    elseif s1(1) == 4;
        
        msgbox('Look for how system axes are deffined to perform convertion')
        
    end
    
    
    data_trajetorias_convert = data_trajetorias;
    
end