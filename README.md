# FRBCAT_analysis

Emily Petroff

This repository holds scripts necessary to fit for S/N, DM, and width for an FRB pulse in a specified filterbank file. The values obtained from running these scripts are used in the Swinburne FRB catalogue (http://www.astronomy.swin.edu.au/pulsar/frbcat/)

This processing pipeline has the following software requirements:
psrchive (psrchive.sourceforge.net)
destroy (https://github.com/evanocathain/destroy_gutted)
python

This repository contains three files.

1. FRBfit.csh

This is the main script to be run to do the fitting. It uses the other two files in this repository, as well as destroy, and several psrchive commands (dspsr, pdmp, pdv, pam, paz). When run on a single observation containing several beams, the script produces four files per beam: an archive file of the window around the pulse in the filterbank file (.ar), a file containing the header information for the archive (.head), an ascii file of the dedispersed timeseries around the pulse (.txt) and a plain text file with columns of DM, width, sample, and S/N (.pls). The best fit is found where S/N is maximised in the .pls file.

2. FRB.info

This file contains the relevant information about the FRB and the observation configuation neede to make the calculations in FRBfit.csh. If a best-fit DM has already been measured through other means (such as the highly optimised code using the CERN MINUIT package outlined in Thornton et al. 2013) this is taken to be the best-fit DM and hardcoded into the fitting script. Other data included in this file are the FRB name, the FRB pointing, the time in the file to start extracting archive data, the sampling time of the data, and the primary beam of the FRB detection. This file will be updated as new FRBs become available.

3. findMax.py

This simple python program takes the .pls file from the primary beam of the observation and extracts the line with the maximum S/N. The parameters at this maximum are output to a file called best_fit.txt which includes the S/N, DM, width, and sample number where the maximum is acheived. This script is called as part of FRBfit.csh and the best_fit.txt file will be generated as part of that script.
