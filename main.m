% ======================================================
% SCRIPT PARA COMPUTAR LBP
% ALGORITMO DE http://www.cse.oulu.fi/MVG/Downloads/LBPMatlab
% UNIVERSIDADE OULU - MAENPPA.
% VERSAO 0.3.2
% ADAPTADO POR DIEGO BERTOLINI
% ======================================================

function [] = main(nomeArquivoEntrada, pasta)

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
                        %  Possible values for MAPPINGTYPE are
                        %       'u2'   for uniform LBP
                        %       'ri'   for rotation-invariant LBP
                        %       'riu2' for uniform rotation-invariant LBP.
                         fopen(fileName);

                         I = imread(nomeArquivo);
                         mapping=getmapping(8,'u2');
                         
                         H1 = lpq(I, 7); % Tamanho da Janela == 7 
                         
                         %Salvando em arquivo
                         %Pega o nome do arquivo.
                         nome = arquivos(i).name;
                         n = nome(2:5)
                         

                         %_Descritores
                         fprintf(fid, '%f ', H1 ); 
                         fprintf(fid, '%i', n);
                         fprintf(fid,'\n');
                         
                         %_ROTULOS
                         fprintf(fid2, '%s ', n);
                         fprintf(fid2,'\n');
                         clear I mapping H1;
                end
                
            end
            classe = classe + 1 ;
    end 
end

fclose ( fid );
fclose ( fid2 );
