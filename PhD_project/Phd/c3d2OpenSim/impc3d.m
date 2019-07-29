%function erro = impc3d(modo, caminho, arquivo);
%
% Abre arquivos texto do DAS.
%
% MODO: 'DIALOGO' quando  as perguntas  sao  respondidas pelo usuario
%       e as mensagens de erro sao exibidas na tela
%       'SILENCIOSO' (default) quando as  perguntas  sao  respondidas
%       com os parametros de chamada da funcao e as mensagens de erro
%       e alertas nao devem ser exibidas na tela
%
% CAMINHO: Diretorio do arquivo que deve ser lido
%
% ARQUIVO: Nome do arquivo que deve ser lido
%
% ERRO: 0 se nao houve erro
%       1 se houve erro (a variavel "lasterr" contem a mensagem de erro)
%       2 o usuario cancelou a operacao
%
% exemplo: impc3d('SILENCIOSO','D:\meusEXPERIMENTOS\','dados1');
% exemplo: impc3d('DIALOGO','D:\meusEXPERIMENTOS\',[]);
%
% Deselvolvida por Gustavo Leporace em 29/03/2012

function erro =  impc3d(modo, caminho, arquivo, formato)
try
    global Sinal Arquivo Path Configuracao Trechos
    global Trecho_Atual Resultado Legenda_Resultado Opcoes
    
    % cria todas as variaveis caso elas nao existam
    if ~exist('modo'); modo = 'DIALOGO'; end;
    if ~exist('caminho'); caminho = []; end;
    if ~exist('arquivo'); arquivo = []; end;
    
    % se esta no modo silencioso e nao recebeu
    % caminho ou arquivo retorna da funcao com
    % um codigo de erro
    if strcmp(upper(modo),'SILENCIOSO')
        if (isempty(caminho) | isempty(arquivo))
            error('Caminho ou Arquivo inexistente.');
        end
    end
    
    % se estava no modo dialogo e nao recebeu
    % caminho ou arquivo retorna da funcao com
    % um codigo de warning
    if strcmp(upper(modo),'DIALOGO')
        if (isempty(caminho) | isempty(arquivo))
            if isempty(caminho) aux1=Path; else aux1=caminho; end;
            if isempty(arquivo) aux2='*.c3d; *.C3D'; else aux2=arquivo; end;
            try
                [arquivo caminho]=uigetfile([aux1 aux2],'Importar Arquivo C3D');
            catch
                aux1= aux1(1:end-1);
                [arquivo caminho]=uigetfile(aux1,'Importar Arquivo C3D (*.c3d)');
            end
            % se a operacao foi cancelada retorna da funcao
            if ischar(arquivo)==0
                erro = 2;
                return;
            end
        end
    end
    
    % Atualiza variaveis
    Sinal =[];
    Configuracao =[];
    Arquivo = arquivo;
    Path    = caminho;
    Trechos =[];
    Trecho_Atual = [];
    Resultado = [];
    Legenda_Resultado = [];
    
    mouse('AMPULHETA');
    FiG = gcf;
    
    % prepara variavesis de configuracao do Mecanica
    Configuracao.ArquivoOriginal = Arquivo;
    Configuracao.FrequenciaAmostragem = 0;
    Configuracao.GanhoPositivo   = 1;
    Configuracao.GanhoNegativo   = 1;
    Configuracao.RuidoLinhaBase  = 0;
    % Lê dados C3D
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Função abaixo foi desenvolvida por Jasper Menger, November 2005
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
    
%     temp = find(Sinal.Dado == 0);
%     Sinal.Dado(temp) = NaN;
%     
%     for k = 1:size(Sinal.Dado,2)
%         temp = find(~isnan(Sinal.Dado(:,k)));
%         naonan_ini(k) = temp(1);
%         naonan_fim(k) = temp(end);
%     end
%     
%     naonan_ini2 = max(naonan_ini);
%     naonan_fim2 = min(naonan_fim);
%     
%     Sinal.Dado = Sinal.Dado(naonan_ini2:naonan_fim2,:);

  
    % Mostra dados na tela
    mecanica('arquivo');
    % se for um arquivo de ate sinais desenha os sinais
    if length(Sinal.Nome)>2
        erro = versinal('SILENCIOSO', 'JUNTO');
    else
        erro = versinal('SILENCIOSO', 'SEPARADOS');
    end;
    if erro error(lasterr); end;
    
    %Salva comando no arquivo de MACRO
    if isfield(Opcoes,'FIDMacro') & strcmp(upper(modo),'DIALOGO')
        FID = Opcoes.FIDMacro;
        fprintf(FID,'  %% importa sinal no formato C3D \n');
        fprintf(FID,'  %% erro = impc3d(modo, caminho, arquivo) \n');
        fprintf(FID,'  erro = impc3d(''DIALOGO''); \n');
        fprintf(FID,'  if     (erro==1) error(lasterr); \n');
        fprintf(FID,'  elseif (erro==2) return;  end; \n\n');
    end
    
    %Coloca o mouse na forma padrao
    figure(FiG);
    mouse('PADRAO');
    
    erro = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % se ocorreu algum erro salta para estas linhas
    % caso contrario termina a execucao normalmente
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch
    erro = 1;
    lasterr(['Erro em IMPC3D: ' lasterr]);
    try
        mouse('PADRAO');
    catch
        erro = 1;
    end;
    
    if  strcmp(upper(modo),'DIALOGO')
        h = errordlg(lasterr,'Importar C3D','modal');
        waitfor(h);
    else
        disp([10 '*****' 10 lasterr 10 '*****' 10]);
    end;
end;
