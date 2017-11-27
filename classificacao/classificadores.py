import sys
import numpy as np
from sklearn.neighbors import KNeighborsClassifier
from sklearn import svm
from sklearn.svm import LinearSVC
from sklearn.multiclass import OneVsOneClassifier
from sklearn.metrics import confusion_matrix
# classificador gradiente
from sklearn.ensemble import GradientBoostingClassifier
# classificador floresta
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import time
import operator

sys.argv[1]
#sys.argv[2]
#f = open('pred.txt', 'a+')

train_features = np.loadtxt(sys.argv[1] + "/features_train.txt")
train_labels = np.loadtxt(sys.argv[1] + "/labels_train.txt", dtype=np.str)

test_features = np.loadtxt(sys.argv[1] + "/features_test.txt")
test_labels = np.loadtxt(sys.argv[1] + "/labels_test.txt", dtype=np.str)

#label = set(test_labels)

#print("{} classes".format(len(label)))

predict = {}

#train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size=0.2, random_state=1234)
'''
print(len(test_labels))

print ("SVM")
clf = OneVsOneClassifier(LinearSVC(multi_class='ovr'))
#clf = OneVsOneClassifier(svm.SVC(kernel="rbf"))
clf.fit(train_features, train_labels)
#svm.SVC(C=1.0, cache_size=200, class_weight=None, coef0=0.0, decision_function_shape=None, degree=3, gamma='auto', kernel='rbf', max_iter=-1, probability=False, random_state=None, shriking=True, tol=0.001, verbose=False)
print("Taxa de acerto SVM: {}".format(clf.score(test_features, test_labels)))


print("")
print(confusion_matrix(test_labels,clf.predict(test_features)))

#np.savetxt(f, clf.predict_proba(test_features), delimiter=' ', footer="")
#np.savetxt(f, clf.predict_proba(train_features), delimiter=',', footer="")
#f.write("\n")
'''
print ("Random Forest tree")
# what is n_estimators?
clf = RandomForestClassifier(n_estimators=300)
clf.fit(train_features, train_labels)

print("Taxa de acerto: {}".format(clf.score(test_features, test_labels)))
print("")
print(confusion_matrix(test_labels,clf.predict(test_features)))

for idx, p in enumerate(clf.predict(test_features)):
    try:
        predict[test_labels[idx]][p] += 1
    except:
        try:
            predict[test_labels[idx]][p] = 1
        except:
            predict[test_labels[idx]] = {p:1}

true = 0
false = 0
for key in predict:
    l = list(predict[key].items())
    l.sort(key=operator.itemgetter(1))
    l.reverse()
    print(key,l[0], key==l[0][0])
    if key==l[0][0]:
        true += 1
    else:
        false += 1
    
print(true, false)

print ("Gradient")
clf = GradientBoostingClassifier(n_estimators=100, learning_rate=0.1)
clf.fit(train_features, train_labels)
print("Taxa de acerto: {}".format(clf.score(test_features, test_labels)))
print("")
print(confusion_matrix(test_labels,clf.predict(test_features)))

print()

parametros = {"n_neighbors":[]}
def generate(init, fnl):
    ret = []
    for i in range(init,fnl+1):
        ret.append(i)
    return ret

for i in range(1,15,2):#[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]:
    print ("N = {}".format(i))
    neigh = KNeighborsClassifier(n_neighbors = i)
    neigh.fit(train_features, train_labels)
    aux_orb = neigh.predict_proba(test_features)
    tempo_inicial = time.time()
    print("Taxa de acerto KNN: {}".format(neigh.score(test_features, test_labels)))
    print(time.time() - tempo_inicial)
    print(confusion_matrix(test_labels,neigh.predict(test_features)))


#f.close()
