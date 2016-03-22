from matplotlib import pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np


# Script used to generate timing plot for different error correction methods
timings = np.array([12,15,3,3,10,67,62])
IDs = ['Quake','Bless','Musket','BFC','Seecer','BayesHammer','MultiRes']
sns.barplot(x=IDs,y=timings)
sns.axlabel('Algorithms','Timings(in minutes)')
sns.plt.title("Comparison of timings for error correction algorithms")


