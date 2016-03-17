#!/i3c/alisa/rom5161/python/Python-2.7.6/python

###################################################################
# Code by : Raunaq Malhotra
# Basic template for evaluating k-mers as erroneous or true 
# using a given classification model 
# Based on template from Gael Varoquax Andreas Muller
###################################################################

import sys
import numpy as np
from sklearn.externals import joblib
# for reading two files simultaneously 
from itertools import izip
import ntpath 
import time


def main():
	# load the testing file and the model 
	start_time = time.time()
	if(len(sys.argv)<2):
		print "USAGE: python PredictErrorCorrection1.py modelfile kmerfile outputfile\n"
		sys.exit()	 
	modelfile = sys.argv[1]
	print modelfile
	model = joblib.load(modelfile)
	modelname = ntpath.basename(modelfile)
	print modelname, " is the classifier"
	kmerfile = sys.argv[2]
	writefilename = sys.argv[3]
	# Processing line by line 
	process_line_by_line(kmerfile,model,modelname,writefilename)
	# Processing in blocks 
	print "Results computed for all the data points"
	print("===== %s seconds =====" % (time.time() - start_time))
	
def process_line_by_line(kmerfile,model,modelname,writefilename):
	if writefilename == "":
		writefilename = filename.replace(".txt",".")+modelname.replace(".pkl","")+".pred"+".txt"
	fwrite = open(writefilename,'w')
	(tp, tn, fp, fn) = [0] * 4
	with  open(kmerfile) as kmers:
		for kmerdata in kmers:
			kmer = kmerdata.split()
			if(int(kmer[1]) > 2 ):
				y_test = 0 # unknown in this case
				X_test = kmer[1:]
				y_pred = model.predict(X_test)
				if y_pred == 1:
					fwrite.write(kmer[0]+"\n")
				temp = y_pred+y_test
				if temp == 2 :
					tp +=1
				elif temp == 0 :
					tn +=1
				elif temp == 1 and y_pred ==1:
					fp +=1
				else: 
					fn +=1
	fwrite.write("#True Positive %d \n" % tp)
	fwrite.write("#True Negative %d \n" % tn)
	fwrite.write("#False Positive %d \n" % fp)
	fwrite.write("#False Negative %d \n" % fn)
			# np.savetxt(fwrite,y_pred,fmt='%d',delimiter=",",newline=",")

	
def process_in_blocks(filename,model,nblocks=10):
	file_pointer = open(filename)
	nblocks = 10
	for c_number in range(nblocks):
		print "Processing ", c_number, " block "
		for line in file_block(file_pointer,nblocks,c_number):
			data = np.fromstring(line,dtype=np.int32,sep=' ')
			y_test = data[0]
			X_test = data[1:]
			y_pred = model.predict(X_test)
			print y_pred, y_test
	

def file_length(fname):
	with open(fname) as f:
		for i, l in enumerate(f):
			pass
	return i+1

def file_block(fp, number_of_blocks, block):
	'''
	A generator that splits a file into blocks and iterates
	over the lines of one of the blocks
	Source:https://xor0110.wordpress.com/2013/04/13/how-to-read-a-chunk-of-lines-from-a-file-in-python/ 
	'''
	
	assert 0 <= block and block < number_of_blocks
	assert 0 < number_of_blocks
	fp.seek(0,2)
	file_size = fp.tell()
	# Ensure that these are whole numbers ??
	ini = file_size * block / number_of_blocks
	end = file_size * (1+block) / number_of_blocks
	
	if ini <=0:
		fp.seek(0)
	else: 
		fp.seek(ini-1)
		fp.readline()
	while fp.tell() < end: 
		yield fp.readline()

if __name__=="__main__":
    main()
