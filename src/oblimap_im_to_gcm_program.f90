! File name: oblimap_im_to_gcm_program.f90
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

PROGRAM oblimap_im_to_gcm_program
  USE oblimap_configuration_module, ONLY: C, initialize_config_variables, oblimap_licence
  USE oblimap_im_to_gcm_mapping_module, ONLY: oblimap_im_to_gcm_mapping
  USE MPI
  IMPLICIT NONE

  INTEGER :: ierror
  INTEGER :: processor_id_process_dependent
  INTEGER :: number_of_processors
  INTEGER :: error_code

  ! Output: ierror
  CALL MPI_Init(ierror)

  CALL MPI_COMM_RANK(MPI_COMM_WORLD, processor_id_process_dependent, ierror)
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, number_of_processors, ierror)
  C%processor_id_process_dependent = processor_id_process_dependent
  C%number_of_processors = number_of_processors

  ! Read the configuration file and initialization of the struckt C%:
  CALL initialize_config_variables()

  IF(C%number_of_processors > C%NLON) THEN
   WRITE(UNIT=*, FMT='(A)') ' PROGRAM STOP: You are using too many processors, take less!'
   WRITE(*,*)
   WRITE(*,*)
   CALL MPI_ABORT(MPI_COMM_WORLD, error_code, ierror)
  END IF

  IF(MOD(C%NLON, C%number_of_processors) == 0) THEN
   C%max_nr_of_lines_per_partition_block = (C%NLON / C%number_of_processors)
  ELSE
   C%max_nr_of_lines_per_partition_block = (C%NLON / C%number_of_processors) + 1
  END IF
  C%psi_process_dependent = C%processor_id_process_dependent * C%max_nr_of_lines_per_partition_block + 1
  
  write(*,*) C%processor_id_process_dependent, ' C%number_of_processors  = ', C%number_of_processors    , 'NY = ', C%NLON, ' C%max_nr_of_lines_per_partition_block = ', C%max_nr_of_lines_per_partition_block, 'load unbalance = ', C%number_of_processors * C%max_nr_of_lines_per_partition_block - C%NLON
  write(*,*) C%processor_id_process_dependent, ' C%psi_process_dependent = ', C%psi_process_dependent

  ! Output: -
  CALL oblimap_licence('oblimap_im_to_gcm_program')

  ! Calling the oblimap_im_to_gcm_mapping :
  CALL oblimap_im_to_gcm_mapping()

  ! Output: ierror
  CALL MPI_Finalize(ierror)

END PROGRAM oblimap_im_to_gcm_program
