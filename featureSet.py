import sys
from collections import defaultdict

#print sys.argv[1]

def kmer(a,n):
    l=len(a)
    b=[]
    for i in range(0,l-n+1):
        b.append(a[i:n+i])
    return b

i35 = sys.argv[1]
i23 = sys.argv[2]
i13 = sys.argv[3]
out = sys.argv[4]
out1 = out+'temp.txt'
o = open(out1,'w+')
'''
with open(i35) as f:
    content = f.readline()
    content= content.split()
    print content[0], content[1]

'''
with open(i23) as f:
    content23 = f.readlines()
#dict23={}
dict23 = defaultdict(lambda: 0, key=0)
for i in content23:
    i = i.strip('\n')
    a = i.split()
    dict23[a[0]]=a[1]

#print dict23
n=len(a[0])
print n
with open(i35) as f:
    for line in f:
        line= line.strip('\n')
        line=line.split()
        #print line
        b = kmer(line[0],n)
        #list set was for removing duplicates
        #b=list(set(b))
        temp = line[0]+' '+line[1]+' '
        for i in b:
            if dict23[i]!=0:
                temp = temp + dict23[i] + ' '
        temp = temp + '\n'
        o.write(temp)
    
dict23={}
o.close()
o = open(out,'w+')
with open(i13) as f:
    content13 = f.readlines()
#dict23={}
dict13 = defaultdict(lambda: 0, key=0)
for i in content13:
    i = i.strip('\n')
    a = i.split()
    dict13[a[0]]=a[1]


n=len(a[0])
print n
with open(out1) as f:
    for line in f:
        line= line.strip('\n')
        line1=line.split()
        #print line
        b = kmer(line1[0],n)
        #list set was for removing duplicates
        #b=list(set(b))
        temp = line
        for i in b:
            if dict13[i]!=0:
                temp = temp + dict13[i] + ' '
        temp = temp + '\n'
        o.write(temp)
o.close()
os.remove(out1)
'''
Changes - provide options for all three kmer files, threshold,

If the 35mer count is less then threshold then it need not be included in the output file
If the count is greater than threshold 2, don't store it
t1= 1
t2 = 30 default value

variable names

-o output option, otherwise output name
kmer files compulsory

'''
