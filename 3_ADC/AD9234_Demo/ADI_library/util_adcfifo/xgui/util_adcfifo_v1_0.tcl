# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADC_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEVICE_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DMA_ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DMA_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DMA_READY_ENABLE" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADC_DATA_WIDTH { PARAM_VALUE.ADC_DATA_WIDTH } {
	# Procedure called to update ADC_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_DATA_WIDTH { PARAM_VALUE.ADC_DATA_WIDTH } {
	# Procedure called to validate ADC_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DEVICE_TYPE { PARAM_VALUE.DEVICE_TYPE } {
	# Procedure called to update DEVICE_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEVICE_TYPE { PARAM_VALUE.DEVICE_TYPE } {
	# Procedure called to validate DEVICE_TYPE
	return true
}

proc update_PARAM_VALUE.DMA_ADDRESS_WIDTH { PARAM_VALUE.DMA_ADDRESS_WIDTH } {
	# Procedure called to update DMA_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DMA_ADDRESS_WIDTH { PARAM_VALUE.DMA_ADDRESS_WIDTH } {
	# Procedure called to validate DMA_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.DMA_DATA_WIDTH { PARAM_VALUE.DMA_DATA_WIDTH } {
	# Procedure called to update DMA_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DMA_DATA_WIDTH { PARAM_VALUE.DMA_DATA_WIDTH } {
	# Procedure called to validate DMA_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DMA_READY_ENABLE { PARAM_VALUE.DMA_READY_ENABLE } {
	# Procedure called to update DMA_READY_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DMA_READY_ENABLE { PARAM_VALUE.DMA_READY_ENABLE } {
	# Procedure called to validate DMA_READY_ENABLE
	return true
}


proc update_MODELPARAM_VALUE.DEVICE_TYPE { MODELPARAM_VALUE.DEVICE_TYPE PARAM_VALUE.DEVICE_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEVICE_TYPE}] ${MODELPARAM_VALUE.DEVICE_TYPE}
}

proc update_MODELPARAM_VALUE.ADC_DATA_WIDTH { MODELPARAM_VALUE.ADC_DATA_WIDTH PARAM_VALUE.ADC_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_DATA_WIDTH}] ${MODELPARAM_VALUE.ADC_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DMA_DATA_WIDTH { MODELPARAM_VALUE.DMA_DATA_WIDTH PARAM_VALUE.DMA_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DMA_DATA_WIDTH}] ${MODELPARAM_VALUE.DMA_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DMA_READY_ENABLE { MODELPARAM_VALUE.DMA_READY_ENABLE PARAM_VALUE.DMA_READY_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DMA_READY_ENABLE}] ${MODELPARAM_VALUE.DMA_READY_ENABLE}
}

proc update_MODELPARAM_VALUE.DMA_ADDRESS_WIDTH { MODELPARAM_VALUE.DMA_ADDRESS_WIDTH PARAM_VALUE.DMA_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DMA_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.DMA_ADDRESS_WIDTH}
}

