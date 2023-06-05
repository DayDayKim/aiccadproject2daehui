#############################################################################
##        Copyright (c) 1988 - 2020 Synopsys, Inc. All rights reserved.     #
##                                                                          #
##  This Synopsys TestMAX product and all associated documentation are      #
##  proprietary to Synopsys, Inc. and may only be used pursuant to the      #
##  terms and conditions of a written license agreement with Synopsys, Inc. #
##  All other use, reproduction, modification, or distribution of the       #
##  Synopsys Testmax product or associated documentation is                 #
##  strictly prohibited.                                                    #
##                                                                          #
#############################################################################
##                                                                          #
##  Version    : R-2020.09                                                  #
##  Created on : Fri Jul 31 17:32:30 IST 2020                               #
##                                                                          #
#############################################################################
#!/bin/csh -f

# User need to configure the appropriate .csh settings 
#source /data2/.cshrc

# User need to configure the appropriate grid command 
# source <your cshrc settings>

# User need to configure the appropriate tools settings 
 # Please ensure you add the tool binaries to the PATH 

# configure licenes
#setenv SNPSLMD_LICENSE_FILE <License server>

#setenv PATH .:$PATH
export PATH=.:$PATH

############################
# configure iLane variable 
############################
# --------------------------------------------------------------
# sim = false 	// disable all simulation tasks to speed up run-time
# sim = 0delay	// only enable zero-delay-sim	
# sim = sdf	// enable both zero-delay-sim & sdf-annotated-sim  ; NOT AVAILABLE
# --------------------------------------------------------------
#setenv 	sim			0delay;
export sim=0delay;
# --------------------------------------------------------------
# synthesis = dc 	// synthesis with dc env. 
# synthesis = fc 	// synthesis with fc env.  
# --------------------------------------------------------------
#setenv	syn			dc;
#setenv	syn			fc;
export syn=dc;
# --------------------------------------------------------------
# validation = exhaustive // Runs all patterns 
# validation = fast       
# --------------------------------------------------------------
#setenv  validation            exhaustive;
#setenv  validation             fast;
export validation=fast;

# netlist flow enablement :
# only one core will be managed with netlist instead of RTL
#setenv  netlist_flow            no;	 # Disables Netlist Flow (Default)
#setenv  netlist_flow            yes;    # Enables Netlist Flow 
export netlist_flow=yes;	 # Disables Netlist Flow (Default)

# Encryption is a LCA feature, please contact local Synopsys Support Engineer for more details
#setenv encryption 		no;	# Disables Encryption (Default)
#setenv encryption 		yes;	# Enables Encryption
export encryption=no;	# Disables Encryption (Default)

# defining pattern and interval numbers  (don't specify less than 10 patterns)
#setenv patterns   		150;
#setenv intervals  		3;
export patterns=150;
export intervals=3;

# Enabling TestMAX FuSa(core0/1) to calculate the SPFM on the RTL,RTL + DFTIP and DFT inserted Netlist 
#setenv fusa_enable		no;     # Disables FuSa (Default)
#setenv fusa_enable		yes;	# Enables FuSa
export fusa_enable=no;     # Disables FuSa (Default)

# Enable TestMAX Diagnosis flow
#setenv diag                     yes;	# Enables Diagnosis (Default)
#setenv diag                     no;    # Disables Diagnosis 
export diag=yes;	# Enables Diagnosis (Default)

# Enable DFTMAX/DFTMAX Ultra Compression Selection
#setenv  Compr			streaming;  # DFTMAX Ultra (Default)
#setenv Compr			scan;	    # DFTMAX
export Compr=streaming;  # DFTMAX Ultra (Default)

# Enable Shared Wrapper 
#setenv share_wrapper_en         no;	# Disables Shared Wrapper (Default)
#setenv share_wrapper_en        yes;	# Enables Shared Wrapper
export share_wrapper_en=no;	# Disables Shared Wrapper (Default)

# Libraries
#setenv ILANE_LIB_PATH "/data2/incendio/2021_CAD/TESTCASE/iLane_Rev5.0_libs"
export ILANE_LIB_PATH="/data3/Class/AICCAD/2023_1/2023_1_aiccad03/iLane_Rev5.0_libs"


export VCS_HOME="/data1/synopsys/vcs/vcs_2020.03/vcs/Q-2020.03-SP2-8"

