import numpy as np
import math as m
import argparse

parser = argparse.ArgumentParser(description="Takes the file name for the primary beam and finds the maximum.")
parser.add_argument('-f', default="01.pls")
args = parser.parse_args()

filename = args.f

data = np.loadtxt(filename, dtype={'names':('dm','width','sample','snr'), 'formats':('f4','f4','f4','f4')})

dm, snr, width, sample = data['dm'], data['snr'], data['width'], data['sample']

snr_max = max(snr)
index = snr.argmax(axis=0)
dm_best = dm[index]
w_max = width[index]
s_max = sample[index]

print "Maximum S/N of ", snr_max," occuring at dm = ", dm_best, " width = ", w_max," sample = ", s_max

newf = open("best_fit.txt","a")
newf.write("#S/N	DM	width	sample" + '\n')
newf.write(str(snr_max) + " " + str(dm_best) + " " + str(w_max) + " " + str(s_max) + '\n')
newf.close()

