pkg load image;

function Seq = loadImages(imgPath, imgType)
  images = dir([imgPath imgType]);
  N = length(images);
  
  if(~exist(imgPath, 'dir') || N<1)
    display('Diretorio nao encontrado ou imagens nao combinam com o formato.');
  end
  
  Seq{N,1} = [];
  
  for idx = 1:N
    Seq{idx} = imread([imgPath images(idx).name]);
  end
end

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
  
  sums = zeros(parts,1);
  interval = floor(length(dimension)/parts);
  pass = interval;
  init = 1;
  
  for i = 1:parts
    sums(i) = sum(dimension(init:pass)); 
    init = pass;
    pass += interval;
  end
  
  sums;
  threshold = 550;
  
  for i = 1:parts
    if (sums(i) > threshold)
      sums(i);
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
    if (sums(i) > threshold)
      sums(i);
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

function getCuttedLetters(str)
  #str = pwd();
  letters = loadImages(cstrcat(str, '/base/'),'*.jpg');
  parts = 50;

  cuttedImages{length(letters),1} = [];

  for idx = 1:length(letters)
    binary_image = im2bw(letters{idx}, 0.90);
    lines = sum(~binary_image');
    lines = lines';
    
    vertical_positions = getPositions(lines, parts);
    
    cols = sum(~binary_image);
    cols = cols';
    
    horizontal_positions = getPositions(cols, parts);
    
    #img_final = binary_image(vertical_positions{1}:vertical_positions{2}, horizontal_positions{1}:horizontal_positions{2});
    img_final = letters{idx}(vertical_positions{1}:vertical_positions{2}, horizontal_positions{1}:horizontal_positions{2});
    
    #imshow(img_final);
    
    #imwrite(img_final,"imagem_saida","jpeg");
    
    cuttedImages{idx} = img_final;
    
  endfor

  writeImages(cstrcat(str, '/base/'), cstrcat(str, '/base/out/'),'*.jpg', cuttedImages);

endfunction

function splitImages(str)
  cuttedImages = loadImages(cstrcat(str, '/base/out/'),'*.jpg');
  splitedImages = {};

  images = dir([cstrcat(str, '/base/out/') '*.jpg']);

  for idx = 1:length(cuttedImages)
    image = cuttedImages{idx};
    [m n] = size(image);
    
    grid = 2;
    
    step_m = floor(m/grid);
    step_n = floor(n/grid);
    
    i = 1;
    for idxM = 1:step_m-1:m
      for idxN = 1:step_n-1:n
        if(idxM + step_m <= m && idxN + step_n <= n)
          splitedImages{i,1} = image(idxM:idxM+step_m, idxN:idxN+step_n);
          
          imwrite(splitedImages{i,1}, cstrcat(cstrcat(str, '\base\out\splited\'), cstrcat(num2str(i),images(idx).name )), "jpg");
          i++;
        endif
      endfor
    endfor
    i = 0;
  endfor
endfunction

str = pwd();

#splitImages(str);

main('feature_vector_lpq', strcat(str, '\base\out\splited\'));