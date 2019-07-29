%% This program read .c3d file, allow select what kind of files write and the variables inside each one
% The following programs are needed: lerc3d.m (Gustavo Leporace), loadc3d.m (Jasper Menger)
% Created by: Felipe Costa Alvim - nov/2014;
% To record .trc file of marker trajectories you will need: .c3d file from
% a motion capture system with marker trajectories saved inside it.
% To record a .mot file of generalized coordinates you will need: .c3d file
% form a motion capture system with joint angles saved inside it.
% To record a .mot file of ground reaction forces you will need: .csv file
% with forces, moments and CoP saved inside it. The data contained in this
% file must be of all force plates collected.
%

%% Inform the files to be writen

lista_arquivos = {'.trc (marker trajectories)';
    '.mot (generalized coordinates)'
    '.mot (ground reaction forces)'};
[s,v] = listdlg('PromptString','Select the files to be writen:',...
    'SelectionMode','multiple',...
    'ListSize', [400 300],...
    'ListString',lista_arquivos);

%% Read .c3d file

if ismember(1,s) == 1 || ismember(2,s) == 1;  
    lerc3d
    lista = Sinal.Nome;
    cont1 = 0;
    for k = 1:3:length(lista);
        cont1 = cont1+1;
        var_aux1 = lista{k};
        var_aux1(length(var_aux1)) = [];
        lista_nova {cont1} = var_aux1;
    end   
end

 %% Select variables to put in .trc file (select only markers trajectories)

if ismember(1,s) == 1
    prompt = ('Type the name of .trc file to be saved:');
    filename = inputdlg(prompt);
    [s1,v1] = listdlg('PromptString','Select variables to put in .trc file (select only markers trajectories):',...
        'SelectionMode','multiple',...
        'ListSize', [400 300],...
        'ListString',lista_nova);
    % mounting data and names matrix to be writen on .trc file of markes trajectories
    lista_nomes_trajetorias = lista_nova(s1);  % matrix with data names to be saved
    % header data to the .trc file of marker trajectories data
    % mounting names matrix of columns (XN YN ZN) to be saved  
    for kk = 1:length(lista_nomes_trajetorias);
        for kkk = 1:3;
            if kkk ==1
                var_head{kkk} = ['X' num2str(kk)];
            elseif kkk==2
                var_head{kkk} = ['Y' num2str(kk)];
            else
                var_head{kkk} = ['Z' num2str(kk)];
            end
        end
        var_head_comp (:,kk) = var_head;
    end
    var_head_comp = var_head_comp(:)';
    % Select data
    for k1 = 1:length(s1);
        nomes_trajetorias = {[lista_nova{s1(k1)} 'X'] [lista_nova{s1(k1)} 'Y'] [lista_nova{s1(k1)} 'Z']};
        nomes_trajetorias1 (:,k1) = nomes_trajetorias;
    end
    nomes_trajetorias1 = nomes_trajetorias1(:);
    cont2 = 0;
    for k2 = 1:length(nomes_trajetorias1)
        for k3 = 1:length(lista)
            comp1 = strcmp (nomes_trajetorias1(k2),lista(k3));
            if comp1 == 1;
                cont2 = cont2+1;
                data_trajetorias(:,cont2) = Sinal.Dado(:,k3);  %% matrix with dataset to be saved
            end
        end
    end
    data_trajetorias_convert = convert_traj_axes(data_trajetorias,1);
    % writing .trc file
    novo_trc={'PathFileType',	'4',	'(X/Y/Z)',	[filename{1} '.trc'],[],[],[],[];...
        'DataRate',	'CameraRate',	'NumFrame',	'NumMarker',	'Units',	'OrigDataRate',	'OrigDataStartFrame','OrigNumFrames';...
        num2str(Configuracao.FrequenciaAmostragem)	,num2str(Configuracao.FrequenciaAmostragem)	,num2str(size(Sinal.Dado,1))	,num2str(length(lista_nomes_trajetorias))	,'mm'	,num2str(Configuracao.FrequenciaAmostragem)	,'1' ,num2str(size(Sinal.Dado,1)) };
    novo_trc{4,1}='Frame#';
    novo_trc{4,2}='Time';
    for kk5 = 1:Configuracao.NFrames;
        novo_trc{kk5+5,1} = num2str(kk5);
    end
    for kk1 = 1:length(lista_nomes_trajetorias);
        novo_trc{4,kk1+2}= lista_nomes_trajetorias{kk1};
    end
    for kk2 = 1:length(var_head_comp);
        novo_trc{5,kk2+2}= var_head_comp{kk2};
    end
    for kk3 = 1:size(data_trajetorias_convert,1)
        for kk4 = 1:size(data_trajetorias_convert,2)
            novo_trc{kk3+5,kk4+2} = num2str(data_trajetorias_convert(kk3,kk4));
        end
    end
    per = 1/Configuracao.FrequenciaAmostragem;
    time=per:per:(Configuracao.NFrames/Configuracao.FrequenciaAmostragem);
    for kk6=1:length(time)
        novo_trc{kk6+5,2} = num2str(time(kk6));
    end
    FILE=fopen([filename{1} '.trc'],'w');
    for i=1:size(novo_trc,1)
        for j=1:size(novo_trc,2)
            if j>1 && size(novo_trc{i,j},1)~=0
                fprintf(FILE,'\t');
            end
            if (i==4 || i==5)&& ( size(novo_trc{i,j},1)==0 ) && j>1
                fprintf(FILE,'\t');
            end
            if ischar(novo_trc{i,j})
                fprintf(FILE,novo_trc{i,j});
            end
        end
        fprintf(FILE,'\n');
    end
    fclose(FILE);
end

%% Select interest variables to the .mot file (of generalized coordinates)

if ismember(2,s) == 1;
    prompt = ('Type .mot filename of generalized coordinates to be writen:');
    filename2 = inputdlg(prompt);
    [s2,v2] = listdlg('PromptString','Select variables to the .mot file of generalized coordinates:',...
        'SelectionMode','multiple',...
        'ListSize', [400 300],...
        'ListString',lista_nova);
    % Mounting data and names matrix to be writen on .mot files of genderalized coordinates
    lista_nomes_coordgen = lista_nova(s2);  %% matrix with columns names to be writen
    for k1 = 1:length(s2);
        nomes_coordgen = {[lista_nova{s2(k1)} 'X'] [lista_nova{s2(k1)} 'Y'] [lista_nova{s2(k1)} 'Z']};
        nomes_coordgen1 (:,k1) = nomes_coordgen;
    end
    lista_nomes_coordgen1 = nomes_coordgen1(:);
    cont2 = 0;
    for k2 = 1:length(lista_nomes_coordgen1)
        for k3 = 1:length(lista)
            comp2 = strcmp (lista_nomes_coordgen1(k2),lista(k3));
            if comp2 == 1;
                cont2 = cont2+1;
                data_coordgen(:,cont2) = Sinal.Dado(:,k3);  %% matrix with dataset to be wrinten
            end
        end
    end
    
    data_coordgen_convert = convert_traj_axes(data_coordgen,2);
    lista_nomes_coordgen2 = adapta_nomes_coordgen (lista_nomes_coordgen1);
     lista_invert = {'YES';
        'NO'};
    [invert,v5] = listdlg('PromptString','Would you like to invert some joint angles?',...
        'SelectionMode','single',...
        'ListSize', [400 300],...
        'ListString',lista_invert);
    if invert == 1
    data_coordgen_convert_inv = invert_coordgen(data_coordgen_convert,lista_nomes_coordgen2);
    else
    end
    % Writing .mot file of generalized coordinates
    novo_coordgen={[filename2{1} '.mot'];...
        'version=1';...
        ['nRows=' num2str(Configuracao.NFrames)];...
        ['nColumns=' num2str(length(lista_nomes_coordgen2)+1)];...
        'inDegrees=yes';...
        'endheader';
        'time';};
    for k10 = 1:length(lista_nomes_coordgen2);
        novo_coordgen{7,k10+1} = lista_nomes_coordgen2{k10};
    end
    per = 1/Configuracao.FrequenciaAmostragem;
    time=per:per:(Configuracao.NFrames/Configuracao.FrequenciaAmostragem);
    for kk11=1:length(time)
        novo_coordgen{kk11+7,1} = num2str(time(kk11));
    end
    
    FILE2=fopen([filename2{1} '.mot'],'w');
    for i=1:size(novo_coordgen,1)
        for j=1:size(novo_coordgen,2)
            if j>1 && size(novo_coordgen{i,j},1)~=0
                fprintf(FILE2,'\t');
            end
            if (i==4 || i==5)&& ( size(novo_coordgen{i,j},1)==0 ) && j>1
                fprintf(FILE2,'\t');
            end
            if ischar(novo_coordgen{i,j})
                fprintf(FILE2,novo_coordgen{i,j});
            end
        end
        fprintf(FILE2,'\n');
    end
    fclose(FILE2);
end

%% Select interest variables to the .mot file of ground reaction forces

if ismember(3,s) == 1;
    lista_frs = {'YES';
        'NO'};
    [bilat,v4] = listdlg('PromptString','Exist kinetic data for both lower limbs?',...
        'SelectionMode','single',...
        'ListSize', [400 300],...
        'ListString',lista_frs);
    [time1, sample_rate, data_Cop, data_frs, data_mrs] = lercsv1(bilat);
    prompt = ('Type filename of .mot (ground reaction forces) to be writen:');
    filename3 = inputdlg(prompt);
    if bilat(1) ==1 %% Yes, exits GRF data for both lower limbs
        novo_frs={[filename3{1} '.mot'];...
            ['nRows=' num2str(sample_rate*time1)];...
            'nColumns=19';...
            'endheader'};
        novo_frs(5,(1:19)) = {'time','ground_force_vx','ground_force_vy','ground_force_vz','ground_force_px','ground_force_py','ground_force_pz','1_ground_force_vx','1_ground_force_vy','1_ground_force_vz','1_ground_force_px','1_ground_force_py','1_ground_force_pz','ground_torque_x','ground_torque_y','ground_torque_z','1_ground_torque_x','1_ground_torque_y','1_ground_torque_z'};
    elseif bilat(1) == 2 %% No, exits GRF data for only only one lower limbs
        novo_frs={[filename3{1} '.mot'];...
            ['nRows=' num2str(sample_rate*time1)];...
            'nColumns=10';...
            'endheader'};
        novo_frs(5,(1:10)) = {'time','ground_force_vx','ground_force_vy','ground_force_vz','ground_force_px','ground_force_py','ground_force_pz','ground_torque_x','ground_torque_y','ground_torque_z'};
    end

    if bilat == 1
        data_Cop_2 = data_Cop(:,(1:3));
        data_Cop_1 = data_Cop(:,(4:6));
        data_frs_2 = data_frs(:,(1:3));
        data_frs_1 = data_frs(:,(4:6));
        data_mrs_2 = data_mrs(:,(1:3));
        data_mrs_1 = data_mrs(:,(4:6));
        data_frs1 = [data_frs_1 data_Cop_1 data_frs_2 data_Cop_2 data_mrs_1 data_mrs_2];
    elseif bilat == 2
        data_Cop_2 = data_Cop;
        data_Cop_1 = [];
        data_frs_2 = data_frs;
        data_frs_1 = [];
        data_mrs_2 = data_mrs;
        data_mrs_1 = [];
        data_frs1 = [data_frs_1 data_Cop_1 data_frs_2 data_Cop_2 data_mrs_1 data_mrs_2];
    end
    data_frs_convert = convert_traj_axes(data_frs1,3);
    for kkk1 = 1:size(data_frs_convert,1);
        for kkk2 = 1:size (data_frs_convert,2);
            if isnan(data_frs_convert(kkk1,kkk2))==1;
                data_frs_convert(kkk1,kkk2) = 0;
            end
            novo_frs{kkk1+5,kkk2+1} = num2str(data_frs_convert(kkk1,kkk2));
        end
    end
    per1 = 1/sample_rate;
    time2=per1:per1:time1;
    for kk11=1:length(time2)
        novo_frs{kk11+5,1} = num2str(time2(kk11));
    end
    FILE3=fopen([filename3{1} '.mot'],'w');
    for i=1:size(novo_frs,1)
        for j=1:size(novo_frs,2)
            if j>1 && size(novo_frs{i,j},1)~=0
                fprintf(FILE3,'\t');
            end
            if (i==4 || i==5)&& ( size(novo_frs{i,j},1)==0 ) && j>1
                fprintf(FILE3,'\t');
            end
            if ischar(novo_frs{i,j})
                fprintf(FILE3,novo_frs{i,j});
            end
        end
        fprintf(FILE3,'\n');
    end
    fclose(FILE3);
end
msgbox('Files recorded succefully!')
clc;
clear all;