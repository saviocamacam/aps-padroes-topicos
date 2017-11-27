import cv2
import os
import re
import sys

points = 8
radius = 2
#from picamera import PiCamera
from scipy.stats import itemfreq # para histograma
import numpy as np
from skimage.feature import local_binary_pattern
from skimage.viewer import ImageViewer

#pega a lista de arquivos dentro do diretorio
arquivos = []
for root, dirs,files in os.walk("./"+sys.argv[1], topdown=True):
    for name in files:
      #  print(os.path.join(root, name))
        arquivos.append((name,name[0:re.search("\.",name).start()]))
arquivos.sort()
f = open('features.txt', 'ab+')
l = open('labels.txt', 'a+')
#itera cada arquivo, encontra faces e extrai as caracteristicas
while (len(arquivos) is not 0):
    a = arquivos.pop()
    #print (a)
    frame = cv2.imread("./"+sys.argv[1]+"/" + a[0])
    #print("./"+sys.argv[1]+"/" + a[0])
    labelFile = a[1].split("_")[0]
    gray = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
    mat = None

    #extrai o LBP
    lbp = local_binary_pattern(gray, points,radius, method="nri_uniform")
    #print(lbp)
#        cv2.imshow("lbp", lbp)
    mat = lbp

    #calcula o histograma normalizado
    x = itemfreq(lbp)
    hist = x[:, 1]/sum(x[:, 1])
    mat = hist
#        cv2.imshow("Reconhecimento de faces", frame)


    #print (type(mat))
        #pergunta se deseja salvar ou nao a imagem
       # if input("Salvar s/n") == 's':

    if len(mat) == 59:
        l.write("{0}\n".format(labelFile))
        np.savetxt(f, mat[None], delimiter=' ', footer="")#fmt='%10.5f', footer="")
    else:
        print("PAUUUUUU -------------" + labelFile + "\n\n")
f.close()
l.close()
