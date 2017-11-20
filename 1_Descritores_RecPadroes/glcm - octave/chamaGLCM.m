% ======================================================
% SCRIPT PARA COMPUTAR GLCM DAS IMAGENS DE CARTAS
% FEVEREIRO, 04 DE 2011
% DIEGO BERTOLINI
% CHAMA FUNÇÕES GLCM DO MATLAB
% ======================================================
clear;
clc;

folder = uigetdir; 

dirListing = dir(folder);
lin  = 0;

fid = fopen('Teste_GLCM_Energia_GATOOL_Rotulos.txt','w'); % o arquivo de treinamento vai variar de 25 - 50 - 100 - 200 autores.


for d = 3:length(dirListing)
    
    if (dirListing(d).isdir == 1)
    
        fileName = fullfile(folder,dirListing(d).name); % Abre a pasta....
    
        fopen(fileName);
        
        arquivos = dir(fileName); % carrega as imagens....
        
            for i = 3 : length(arquivos) % 11começa em 3 pois os dois primeiros são: . e ..%11
                
                if (arquivos(i).isdir == 0)
                                       
                         nomeArquivo = fullfile(fileName,arquivos(i).name); 
                         fopen(fileName);
                         lin = lin + 1;   
                         
                         I = imread(nomeArquivo);
                         % Caso queira usar somente Energy, colocar
                         % parenteses,  e a linha 
                         % H1 = inf1.Energy;
                         %Energy - Dist 1
                      
                         glcm1 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 números de cinza.
                         inf1 = graycoprops(glcm1,{'energy'}); % 'contrast', 'correlation','homogeneity'});
                         H1 = inf1.Energy;
                         
%                          %Contrast - Dist 1
                         glcm2 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 números de cinza.
                         inf2 = graycoprops(glcm2,{'contrast'});
                         H2 = inf2.Contrast;
                         
                         
                         %Correlation - Dist 1
                         glcm3 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 números de cinza.
                         inf3 = graycoprops(glcm3,{'correlation'});
                         H3 = inf3.Correlation;
                         
                         
                         %Homogeneity - Dist 1 
                         glcm4 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 números de cinza.
                         inf4 = graycoprops(glcm4,{'homogeneity'});
                         H4 = inf4.Homogeneity;
                         
               

                        vetorGLCM_En_Con_Cor_Hom = [H1, H2, H3, H4];

                         fprintf(fid, '%f ', vetorGLCM_En_Con_Cor_Hom ); %k, VetorDissimilaridade(lin,k));
                         fprintf(fid, '%s ', arquivos(i).name);
                         
                         fprintf(fid,'\n');
                          
                         arquivoSaida(lin,:) = vetorGLCM_En_Con_Cor_Hom; % 5 Distâncias

                        
                         clear I glcm1 glcm2 glcm3 glcm4 inf1 inf2 inf3 inf4 H1 H2 H3 H4 vetorGLCM_En_Con_Cor_Hom
                end
                
            end
            
    end 
end 

save Teste_GLCM_Energia_GATOOL.txt arquivoSaida -ascii % NOME DO ARQUIVO DE SAÍDA SEM OS RÓTULOS.
fclose ( fid );