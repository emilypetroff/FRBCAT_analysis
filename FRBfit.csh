#!/bin/csh

if ( $#argv != 1 ) then
	echo "Usage: csh FRBfit.csh <FRB_name>"
	exit 1
endif

set FRB = $1
set pointing 	= `grep $FRB FRB.info | awk '{print $2}'`
set dm 		= `grep $FRB FRB.info | awk '{print $3}'`
set dm_best 	= `grep $FRB FRB.info | awk '{print $4}'`
set t_frb 	= `grep $FRB FRB.info | awk '{print $5}'`
set tsamp 	= `grep $FRB FRB.info | awk '{print $6}'`
set prim_beam	= `grep $FRB FRB.info | awk '{print $7}'`
set read_time 	= 2.0  # Read out 2 seconds around FRB in fil file
set data_dir	= /lustre/projects/p002_swin/epetroff/FRB_data/$FRB/fil_files # Insert data directory here
set destroy 	=  # Path name to location of destroy on network
set nsamps 	= `echo $read_time $tsamp | awk '{print $1/$2}'` # number of samples in the extracted archive

echo $FRB
if ( ! -d /$FRB ) mkdir $FRB
cd $FRB

# Create the archive files for each beam around the time of the FRB
foreach beam ( 01 02 03 04 05 06 07 08 09 10 11 12 13 )

	dspsr -cepoch start -S $t_frb -T $read_time -c $read_time -b $nsamps -D $dm -t 12 -O $beam $data_dir/$beam/${pointing}.fil
	if ( `echo $tsamp | awk '{if ($1 > 0.0001) print 1}'` == 1 ) then #because thanks for nothing cshell
		echo "zapping AFB bad channels"
		paz -z "5 6 7 8 25 26 27 94 95" ${beam}.ar -m
	else
		echo "zapping BPSR bad channels"
		paz -Z "0 150" -Z "335 338" -Z "181 183" ${beam}.ar -m
	endif

	psredit ${beam}.ar > ${beam}.head
end

# Correct the DM in each archive file if need be
if ( $dm_best == 0 ) then
	if ( -e pdmp.per ) rm pdmp.per
	pdmp -mb 1024 -g /null ${prim_beam}.ar
	set dm = `awk '{print $4}' pdmp.per`
	echo "Applying a DM correction. New DM is " $dm
	pam -d $dm *.ar -m 
endif

# Produce an ASCII timeseries and search with destroy
foreach beam ( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
	pdv -t -j "D, F" ${beam}.ar | awk 'NR!=1{print $4}' > ${beam}.txt

	$destroy -ascii -dm $dm -n $nsamps -box 2 -nsmax 10 ${beam}.txt
	mv pulses.pls ${beam}.pls

end

python ../findMax.py -f ${prim_beam}.pls
cd ..
