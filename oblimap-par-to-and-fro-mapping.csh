#! /bin/csh -f
# Thomas Reerink

if($#argv == 0 || $#argv == 1 || $#argv == 3) then

 set number_of_processes = 2
 if($#argv == 1) then
  set number_of_processes = $1
 endif

 set config_file_for_gcm_to_im = 'config-files/oblimap/ccsm-to-im/config_oblimap_ccsm_to_im_greenland'
 set config_file_for_im_to_gcm = 'config-files/oblimap/im-to-ccsm/config_oblimap_im_to_ccsm_greenland'
 if($#argv == 3) then
  set config_file_for_gcm_to_im = $2
  set config_file_for_im_to_gcm = $3
 endif


 mpirun -np ${number_of_processes} ./src/oblimap_par_gcm_to_im_program ${config_file_for_gcm_to_im}
 
#mpirun -np ${number_of_processes} ./src/oblimap_par_im_to_gcm_program ${config_file_for_im_to_gcm}
 

else
 echo ' This script runs with no argument, or with one or three OPTIONAL arguments, e.g.:'
 echo '  ./oblimap-to-and-fro-mapping.csh 2'
 echo ' Or:'
 echo '  ./oblimap-to-and-fro-mapping.csh 2 config-files/oblimap/ccsm-to-im/config_oblimap_ccsm_to_im_greenland config-files/oblimap/im-to-ccsm/config_oblimap_im_to_ccsm_greenland'
endif
