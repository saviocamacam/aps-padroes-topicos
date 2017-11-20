% ======================================================
% SCRIPT PARA COMPUTAR LBP
% ALGORITMO DE http://www.cse.oulu.fi/MVG/Downloads/LBPMatlab
% UNIVERSIDADE OULU - MAENPPA.
% VERSAO 0.3.2
% ADAPTADO POR DIEGO BERTOLINI
% ======================================================

function [] = main(nomeArquivoEntrada, pasta)

pkg load statistics
pkg load image

nomeArquivo = nomeArquivoEntrada;
folder = pasta ;
dirListing = dir(pasta);
arquivo = strcat(nomeArquivo, '.txt');
rotulos = strcat(arquivo,'_ROTULOS.txt');
lin = 0;
classe = 1
fid = fopen(arquivo,'w');  
fid2 = fopen(rotulos, 'w');
for d = 3:length(dirListing)
   
    if (dirListing(d).isdir == 1)
    
        fileName = fullfile(folder,dirListing(d).name); % Abre a pasta....
    
        fopen(fileName);
        
        arquivos = dir(fileName); % carrega as imagens....
        
            for i = 3 : length(arquivos) %começa em 3 pois os dois primeiros: . e ..
                
                if (arquivos(i).isdir == 0)
                                       
                         nomeArquivo = fullfile(fileName,arquivos(i).name); 

                         fopen(fileName);

                         I = imread(nomeArquivo);
                         
                         %Salvando em arquivo
                         %Pega o nome do arquivo.
                         nome = arquivos(i).name ;
                         
                         %_Descritores
                         glcm1 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 n�meros de cinza.
                         inf1 = graycoprops(glcm1,{'energy'}); 
                         H1 = inf1.Energy;
                         
%                          %Contrast - Dist 1
                         glcm2 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 n�meros de cinza.
                         inf2 = graycoprops(glcm2,{'contrast'});
                         H2 = inf2.Contrast;
                         
                         
                         %Correlation - Dist 1
                         glcm3 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 n�meros de cinza.
                         inf3 = graycoprops(glcm3,{'correlation'});
                         H3 = inf3.Correlation;
                         
                         
                         %Homogeneity - Dist 1 
                         glcm4 = graycomatrix(I, 'NumLevels',2,'offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', false); % 2 n�meros de cinza.
                         inf4 = graycoprops(glcm4,{'homogeneity'});
                         H4 = inf4.Homogeneity;
                         
                         vetorGLCM_En_Con_Cor_Hom = [H1, H2, H3, H4];

                         
                         fprintf(fid, '%f ', vetorGLCM_En_Con_Cor_Hom ); 
                         fprintf(fid, '%i', classe);
                         fprintf(fid,'\n');
                         
                         %_ROTULOS
                         fprintf(fid2, '%s ', arquivos(i).name);
                         fprintf(fid2,'\n');
                         clear I mapping H1;
                end
                
            end
            classe = classe + 1 ;
    end 
end

fclose ( fid );
fclose ( fid2 );
