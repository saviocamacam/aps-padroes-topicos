pkg load image;

function Seq = loadImages(imgPath, imgType)
  images = dir([imgPath imgType]);
  N = length(images);
  
  if(~exist(imgPath, 'dir') || N<1)
    display('Diretorio nao encontrado ou imagens nao combinam com o formato.');
  end
 
  Seq{N,1} = [];


  for idx = 1:N 
    Seq{idx} = images(idx).name;
   endfor
  #{
  for idx = 1:N
    Seq{idx} = imread([imgPath images(idx).name]);
  end
  #}

endfunction

function Seq = writeImages(imgSourcePath, imgDestinationPath, imgType, finalImage)
  images = dir([imgSourcePath imgType]);
  N = length(images);
  
  if(~exist(imgSourcePath, 'dir') || N<1)
    display('Diretorio nao encontrado ou imagens nao combinam com o formato.');
  end
  
  for idx = 1:N
    imwrite(finalImage{idx}, [imgDestinationPath images(idx).name], "jpg");
  end
end


function positions = getPositions(dimension, slice)
  positions{2,1} = [];
  parts = slice;
  
  means = zeros(parts,1);
  interval = floor(length(dimension)/parts);
  pass = interval;
  init = 1;
  
  for i = 1:parts
    means(i) = sum(dimension(init:pass)); 
    init = pass;
    pass += interval;
  end
  
  means;
  
  for i = 1:parts
    if (means(i) > 100)
      means(i);
      i;
      if(i == 1)
        positions{1} = 1;
      else
        positions{1} = interval * (i-1);
      end
      
      break;
    endif
  end
  
  for i = parts:-1:1
    if (means(i) > 100)
      means(i);
      i;
      if(i == slice)
        positions{2} = length(dimension);
      else
        positions{2} = interval * (i+1);
      end
      
      break;
    endif
  end
end

str = pwd();
letters = loadImages(cstrcat(str, '/base/'),'*.jpg');
parts = 100;

#cuttedImages{length(letters),1} = [];


for idx = 1:length(letters)
  binary_image = im2bw(imread(strcat(str, '/base/', letters{idx})), 0.90);
  lines = sum(~binary_image');
  lines = lines';
  
  vertical_positions = getPositions(lines, 100);
  
  cols = sum(~binary_image);
  cols = cols';
  
  horizontal_positions = getPositions(cols, 100);
  
  img_final = binary_image(vertical_positions{1}:vertical_positions{2}, horizontal_positions{1}:horizontal_positions{2});
  
  #imshow(img_final);
  
  #imwrite(img_final,"imagem_saida","jpeg");
  
 # cuttedImages{idx} = img_final
 
 imwrite(img_final, strcat(str, '/out/', letters{idx}), 'jpg');


  
end
#}
#writeImages(cstrcat(str, '/base/'), cstrcat(str, '/base/out/'),'*.jpg', cuttedImages);
