%% If you want invert the signal of your generalized coordinate data, use this program

function  [data_coordgen_convert_inv] = invert_coordgen(data_coordgen_convert,lista_nomes_coordgen2)

[s,v] = listdlg('PromptString','Select generalized coordinates to invert',...
    'SelectionMode','multiple',...
    'ListSize', [400 300],...
    'ListString',lista_nomes_coordgen2);

    data_coordgen_convert_inv = data_coordgen_convert;

    data_coordgen_convert_inv(:,s) = data_coordgen_convert_inv(:,s).*-1;
    
end