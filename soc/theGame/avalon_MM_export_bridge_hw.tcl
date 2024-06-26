# TCL File Generated by Component Editor 18.1
# Tue Apr 12 11:21:14 EEST 2022
# DO NOT MODIFY


# 
# avalon_MM_export_bridge "avalon_MM_export_bridge" v1.0
#  2022.04.12.11:21:14
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module avalon_MM_export_bridge
# 
set_module_property DESCRIPTION ""
set_module_property NAME avalon_MM_export_bridge
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME avalon_MM_export_bridge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avalon_MM_export_bridge
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avalon_MM_export_bridge.vhd VHDL PATH avalon_MM_export_bridge.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL avalon_MM_export_bridge
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file avalon_MM_export_bridge.vhd VHDL PATH avalon_MM_export_bridge.vhd


# 
# parameters
# 
add_parameter addr_width NATURAL 5 ""
set_parameter_property addr_width DEFAULT_VALUE 5
set_parameter_property addr_width DISPLAY_NAME addr_width
set_parameter_property addr_width WIDTH ""
set_parameter_property addr_width TYPE NATURAL
set_parameter_property addr_width UNITS None
set_parameter_property addr_width ALLOWED_RANGES 0:2147483647
set_parameter_property addr_width DESCRIPTION ""
set_parameter_property addr_width HDL_PARAMETER true


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset i_reset reset Input 1


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk_i clk Input 1


# 
# connection point mmi
# 
add_interface mmi avalon end
set_interface_property mmi addressUnits WORDS
set_interface_property mmi associatedClock clock
set_interface_property mmi associatedReset reset
set_interface_property mmi bitsPerSymbol 8
set_interface_property mmi burstOnBurstBoundariesOnly false
set_interface_property mmi burstcountUnits WORDS
set_interface_property mmi explicitAddressSpan 0
set_interface_property mmi holdTime 0
set_interface_property mmi linewrapBursts false
set_interface_property mmi maximumPendingReadTransactions 0
set_interface_property mmi maximumPendingWriteTransactions 0
set_interface_property mmi readLatency 0
set_interface_property mmi readWaitTime 1
set_interface_property mmi setupTime 0
set_interface_property mmi timingUnits Cycles
set_interface_property mmi writeWaitTime 0
set_interface_property mmi ENABLED true
set_interface_property mmi EXPORT_OF ""
set_interface_property mmi PORT_NAME_MAP ""
set_interface_property mmi CMSIS_SVD_VARIABLES ""
set_interface_property mmi SVD_ADDRESS_GROUP ""

add_interface_port mmi i_mmi_address address Input addr_width
add_interface_port mmi i_mmi_byteenable byteenable Input 4
add_interface_port mmi i_mmi_writedata writedata Input 32
add_interface_port mmi i_mmi_write write Input 1
add_interface_port mmi i_mmi_read read Input 1
add_interface_port mmi o_mmi_readdata readdata Output 32
set_interface_assignment mmi embeddedsw.configuration.isFlash 0
set_interface_assignment mmi embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment mmi embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment mmi embeddedsw.configuration.isPrintableDevice 0


# 
# connection point mmo
# 
add_interface mmo conduit end
set_interface_property mmo associatedClock clock
set_interface_property mmo associatedReset reset
set_interface_property mmo ENABLED true
set_interface_property mmo EXPORT_OF ""
set_interface_property mmo PORT_NAME_MAP ""
set_interface_property mmo CMSIS_SVD_VARIABLES ""
set_interface_property mmo SVD_ADDRESS_GROUP ""

add_interface_port mmo o_reset new_signal Output 1
add_interface_port mmo o_mmo_address new_signal_1 Output addr_width
add_interface_port mmo o_mmo_byteenable new_signal_2 Output 4
add_interface_port mmo o_mmo_writedata new_signal_3 Output 32
add_interface_port mmo o_mmo_write new_signal_4 Output 1
add_interface_port mmo o_mmo_read new_signal_5 Output 1
add_interface_port mmo i_mmo_readdata new_signal_6 Input 32

