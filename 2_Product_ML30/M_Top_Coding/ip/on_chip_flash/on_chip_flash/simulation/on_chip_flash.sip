set_global_assignment -entity "on_chip_flash" -library "lib_on_chip_flash" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "on_chip_flash" -library "lib_on_chip_flash" -name IP_TOOL_VERSION "17.1"
set_global_assignment -entity "on_chip_flash" -library "lib_on_chip_flash" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_on_chip_flash" -name SPD_FILE [file join $::quartus(sip_path) "../on_chip_flash.spd"]
set_global_assignment -library "lib_on_chip_flash" -name MISC_FILE [file join $::quartus(sip_path) "../../on_chip_flash.qsys"]

set_global_assignment -library "lib_on_chip_flash" -name MISC_FILE [file join $::quartus(sip_path) "on_chip_flash.vhd"]
set_global_assignment -library "lib_on_chip_flash" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_util.v"]
set_global_assignment -library "lib_on_chip_flash" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash.v"]
set_global_assignment -library "lib_on_chip_flash" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_data_controller.v"]
set_global_assignment -library "lib_on_chip_flash" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_csr_controller.v"]
