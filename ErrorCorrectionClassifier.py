#!/i3c/alisa/rom5161/python/Python-2.7.6/python

###################################################################
# Code source : Gael Varoquax 
# 				Andreas Muller
# Code modifications by : Raunaq Malhotra
# Basic template for training classification of k-mers as 
# erroneous or true using multiple classification algorithms
###################################################################
import sys
import numpy as np
from sklearn.metrics import confusion_matrix
from sklearn.cross_validation import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.lda import LDA
from sklearn.qda import QDA
from sklearn.externals import joblib

names = [ #"NearestNeighbor", 
		#"LinearSVM",
		#"RBFSVM",
		"DecisionTree",
		"RandomForest",
		"AdaBoost",
		#"NaiveBayes",
		#"LDA",
		#"QDA"]
	]	
classifiers = [
		#KNeighborsClassifier(5),
		#SVC(kernel="linear", C=0.025),
		#SVC(gamma=2, C=1),
		DecisionTreeClassifier(max_features="sqrt"),
		RandomForestClassifier(n_estimators=20,max_features="sqrt"),
		AdaBoostClassifier(),
		#GaussianNB(),
		#LDA(),
		#QDA()]
		]

data = np.loadtxt(sys.argv[1],dtype=np.int32)
# load the data
#print data.shape
y=data[:,0]
#X=data[:,1:]
#X=data[:,1:14]
dRange=[1]+range(int(sys.argv[3]),int(sys.argv[4]))
print dRange
X=data[:,dRange]
#print X.shape

#Generate train/test datasets
X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=0.3) 


# Iterate over classifiers
for name, clf in zip(names, classifiers):
	clf.fit(X_train,y_train)
	score = clf.score(X_test,y_test)
	y_pred = clf.predict(X_test)
	cm = confusion_matrix(y_test,y_pred)
	#dump_name = "./"+sys.argv[2]+"/"+name+".pkl"
	#print dump_name, " is the name of the classifier storage" 
	#joblib.dump(clf,dump_name)
	print "For classifier ",name,", the score is ", score
	print "Confusion matrix is ", cm
