%% Program to read ground reaction data contained in .csv file
function [time sample_rate data_Cop data_frs data_mrs] = lercsv(bilat)
if ~exist('caminho'); caminho = []; end;
if ~exist('arquivo1'); arquivo1 = []; end;
if (isempty(caminho) | isempty(arquivo1))
    if isempty(caminho) aux1=path; else aux1=caminho; end;
    if isempty(arquivo1) aux2='*.csv; *.CSV'; else aux2=arquivo1; end;
    try
        [arquivo1 caminho]=uigetfile([aux1 aux2],'Import CSV file');
    catch
        aux1= aux1(1:end-1);
        [arquivo1 caminho]=uigetfile(aux1,'Import CSV file (*.csv)');
    end
end

prompt = ('Type force plates sample rate:');
sample_rate1 = inputdlg(prompt);
sample_rate = str2double(sample_rate1{1});

prompt2 = ('Type first line in witch ground reaction data appears on the .csv file:');
nrow1a = inputdlg(prompt2);
nrow1 = str2double(nrow1a{1})-1;

nrow2 = nrow1;
cont = 0;

while cont == 0;
    try teste_csv = csvread([caminho arquivo1],nrow2,0,[nrow2 0 nrow2 0]);
        nrow2 = nrow2+1;
    catch
        cont = 1;
    end
end

if bilat == 1;
    
    ncolumn1 = 19;
    data_GRF = csvread([caminho arquivo1],nrow1,0,[nrow1 0 nrow2-1 ncolumn1]);
    time = size(data_GRF,1)/sample_rate;
    
    data_Cop1 = data_GRF(:,(9:11));
    
    data_Cop2 = data_GRF(:,(18:20));
    
    
    data_Cop = [data_Cop1 data_Cop2];
    data_frs1 = data_GRF(:,(3:5));
    data_frs2 = data_GRF(:,(12:14));
    data_frs = [data_frs1 data_frs2];
    data_mrs1 = data_GRF(:,(6:8));
    data_mrs2 = data_GRF(:,(15:17));
    data_mrs = [data_mrs1 data_mrs2];
    
elseif bilat ==2
    
    ncolumn1 = 10;
    data_GRF = csvread([caminho arquivo1],nrow1,0,[nrow1 0 nrow2-1 ncolumn1]);
    time = size(data_GRF,1)/sample_rate;
    data_Cop1 = data_GRF(:,(9:11));
    data_Cop2 = [];
    data_Cop = [data_Cop1 data_Cop2];
    data_frs1 = data_GRF(:,(3:5));
    data_frs2 = [];
    data_frs = [data_frs1 data_frs2];
    data_mrs1 = data_GRF(:,(6:8));
    data_mrs2 = [];
    data_mrs = [data_mrs1 data_mrs2];
    
end

end