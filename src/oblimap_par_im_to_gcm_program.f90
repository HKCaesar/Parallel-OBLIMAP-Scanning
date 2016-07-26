! File name: oblimap_par_im_to_gcm_program.f90
!
! Copyright (C) 2016 Thomas Reerink.
!
! This file is distributed under the terms of the
! GNU General Public License.
!
! This file is part of OBLIMAP 2.0
!
! OBLIMAP's scientific documentation and its first open source
! release (see the supplement) is published at:
! http://www.geosci-model-dev.net/3/13/2010/gmd-3-13-2010.html
!
! OBLIMAP is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! OBLIMAP is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with OBLIMAP. If not, see <http://www.gnu.org/licenses/>.
!
!
! OBLIMAP is maintained by:
!
! Thomas Reerink
! Institute for Marine and Atmospheric Research Utrecht (IMAU)
! Utrecht University
! Princetonplein 5
! 3584 CC Utrecht
! The Netherlands
!
! email: tjreerink@gmail.com
!

PROGRAM oblimap_par_im_to_gcm_program
  USE oblimap_configuration_module, ONLY: C, PAR, initialize_config_variables, oblimap_licence
  USE oblimap_im_to_gcm_mapping_module, ONLY: oblimap_im_to_gcm_mapping
  USE MPI
  IMPLICIT NONE

  INTEGER :: ierror

  ! Output: ierror
  CALL MPI_Init(ierror)

  CALL MPI_COMM_RANK(MPI_COMM_WORLD, PAR%processor_id_process_dependent, ierror)
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, PAR%number_of_processors, ierror)

  ! Read the configuration file and initialization of the struckt C%:
  CALL initialize_config_variables()
  IF(PAR%number_of_processors > C%NLON) THEN
   CALL MPI_Finalize(ierror)
   IF(PAR%processor_id_process_dependent == 0) WRITE(UNIT=*, FMT='(/2A, I4, A, I4/)') C%OBLIMAP_ERROR, ' You are using ', PAR%number_of_processors, ' processors, which is too much for the current implementated domain decomposition. Lower that number to at least: ', C%NLON
   STOP
  END IF

  IF(MOD(C%NLON, PAR%number_of_processors) == 0) THEN
   PAR%max_nr_of_lines_per_partition_block = (C%NLON / PAR%number_of_processors)
  ELSE
   PAR%max_nr_of_lines_per_partition_block = (C%NLON / PAR%number_of_processors) + 1
  END IF
  PAR%psi_process_dependent = PAR%processor_id_process_dependent * PAR%max_nr_of_lines_per_partition_block + 1

  IF(PAR%processor_id_process_dependent == 0) THEN
   ! Output: -
   CALL oblimap_licence('oblimap_gcm_to_im_program')

   WRITE(UNIT=*,FMT='(4(A, I4)/)') '  OBLIMAP-PAR runs with: number_of_processors  = ', PAR%number_of_processors , ', NLON = ', C%NLON, ', max_nr_of_lines_per_partition_block = ', PAR%max_nr_of_lines_per_partition_block, ', load unbalance = ', PAR%number_of_processors * PAR%max_nr_of_lines_per_partition_block - C%NLON
  END IF
 !WRITE(UNIT=*,FMT='(2(A, I4))') ' process id = ', PAR%processor_id_process_dependent, ' partition starting index = ', PAR%psi_process_dependent

  ! Calling the oblimap_im_to_gcm_mapping :
  CALL oblimap_im_to_gcm_mapping()

  ! Output: ierror
  CALL MPI_Finalize(ierror)

END PROGRAM oblimap_par_im_to_gcm_program
