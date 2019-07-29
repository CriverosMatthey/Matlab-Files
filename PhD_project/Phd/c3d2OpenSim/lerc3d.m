if ~exist('caminho'); caminho = []; end;
if ~exist('arquivo'); arquivo = []; end;

if (isempty(caminho) | isempty(arquivo))
    if isempty(caminho) aux1=path; else aux1=caminho; end;
    if isempty(arquivo) aux2='*.c3d; *.C3D'; else aux2=arquivo; end;
    try
        [arquivo caminho]=uigetfile([aux1 aux2],'Import C3D file');
    catch
        aux1= aux1(1:end-1);
        [arquivo caminho]=uigetfile(aux1,'Importar C3D file (*.c3d)');
    end
end


% Upload variables
Sinal =[];
Configuracao =[];
Arquivo = arquivo;
Path    = caminho;
Trechos =[];
Trecho_Atual = [];
Resultado = [];
Legenda_Resultado = [];

Configuracao.ArquivoOriginal = Arquivo;
Configuracao.FrequenciaAmostragem = 0;
Configuracao.GanhoPositivo   = 1;
Configuracao.GanhoNegativo   = 1;
Configuracao.RuidoLinhaBase  = 0;
% Lê dados C3D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function developed by Jasper Menger, November 2005
% http://stickfigure.sourceforge.net/
% OPENC3D - Opens a C3D file, which is chosen through a file dialog box
[Markers, VideoFrameRate, AnalogSignals, AnalogFrameRate, Event, ParameterGroup, CameraInfo, ResidualError] = loadc3d([Path Arquivo]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:size(ParameterGroup,2)
    field = getfield(ParameterGroup(1,k),'name');
    if strcmp(upper(field),'POINT')
        field2 = ParameterGroup(1,k).Parameter;
        for kk = 1:size(field2,2)
            if strcmp(upper(field2(1,kk).name),'FRAMES')
                Configuracao.NFrames = field2(1,kk).data; % Número de Frames
            end
            if strcmp(upper(field2(1,kk).name),'LABELS')
                labels = field2(1,kk).data; % Nome dos marcadores
            end
            if strcmp(upper(field2(1,kk).name),'USED')
                Configuracao.NMarkers = field2(1,kk).data; % Nome dos marcadores
            end
        end
    end
end

Configuracao.FrequenciaAmostragem = VideoFrameRate; % Frequência de Amostragem
Configuracao.AnalogSignals = AnalogSignals;
Configuracao.AnalogFrameRate = AnalogFrameRate;
Configuracao.Event = Event;
Configuracao.ParameterGroup = ParameterGroup;

Sinal.Nome = {};
labelmark  = {'X', 'Y', 'Z'};
for k = 1:Configuracao.NMarkers
    for j = 1:3
        Sinal.Dado(:,(k-1)*3+j) = Markers(:,k,j);
        Sinal.Nome{end+1} = [labels{k} labelmark{j}];
    end
end
