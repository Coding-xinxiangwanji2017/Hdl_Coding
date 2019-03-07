# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADC_DATAFORMAT_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_DCFILTER_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_IODELAY_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_IQCORRECTION_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_SCALECORRECTION_ONLY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_USERPORTS_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DAC_DATAPATH_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEVICE_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IODELAY_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IO_DELAY_GROUP" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADC_DATAFORMAT_DISABLE { PARAM_VALUE.ADC_DATAFORMAT_DISABLE } {
	# Procedure called to update ADC_DATAFORMAT_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_DATAFORMAT_DISABLE { PARAM_VALUE.ADC_DATAFORMAT_DISABLE } {
	# Procedure called to validate ADC_DATAFORMAT_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_DCFILTER_DISABLE { PARAM_VALUE.ADC_DCFILTER_DISABLE } {
	# Procedure called to update ADC_DCFILTER_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_DCFILTER_DISABLE { PARAM_VALUE.ADC_DCFILTER_DISABLE } {
	# Procedure called to validate ADC_DCFILTER_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_IODELAY_ENABLE { PARAM_VALUE.ADC_IODELAY_ENABLE } {
	# Procedure called to update ADC_IODELAY_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_IODELAY_ENABLE { PARAM_VALUE.ADC_IODELAY_ENABLE } {
	# Procedure called to validate ADC_IODELAY_ENABLE
	return true
}

proc update_PARAM_VALUE.ADC_IQCORRECTION_DISABLE { PARAM_VALUE.ADC_IQCORRECTION_DISABLE } {
	# Procedure called to update ADC_IQCORRECTION_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_IQCORRECTION_DISABLE { PARAM_VALUE.ADC_IQCORRECTION_DISABLE } {
	# Procedure called to validate ADC_IQCORRECTION_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_SCALECORRECTION_ONLY { PARAM_VALUE.ADC_SCALECORRECTION_ONLY } {
	# Procedure called to update ADC_SCALECORRECTION_ONLY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_SCALECORRECTION_ONLY { PARAM_VALUE.ADC_SCALECORRECTION_ONLY } {
	# Procedure called to validate ADC_SCALECORRECTION_ONLY
	return true
}

proc update_PARAM_VALUE.ADC_USERPORTS_DISABLE { PARAM_VALUE.ADC_USERPORTS_DISABLE } {
	# Procedure called to update ADC_USERPORTS_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_USERPORTS_DISABLE { PARAM_VALUE.ADC_USERPORTS_DISABLE } {
	# Procedure called to validate ADC_USERPORTS_DISABLE
	return true
}

proc update_PARAM_VALUE.DAC_DATAPATH_DISABLE { PARAM_VALUE.DAC_DATAPATH_DISABLE } {
	# Procedure called to update DAC_DATAPATH_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DAC_DATAPATH_DISABLE { PARAM_VALUE.DAC_DATAPATH_DISABLE } {
	# Procedure called to validate DAC_DATAPATH_DISABLE
	return true
}

proc update_PARAM_VALUE.DEVICE_TYPE { PARAM_VALUE.DEVICE_TYPE } {
	# Procedure called to update DEVICE_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEVICE_TYPE { PARAM_VALUE.DEVICE_TYPE } {
	# Procedure called to validate DEVICE_TYPE
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}

proc update_PARAM_VALUE.IODELAY_ENABLE { PARAM_VALUE.IODELAY_ENABLE } {
	# Procedure called to update IODELAY_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IODELAY_ENABLE { PARAM_VALUE.IODELAY_ENABLE } {
	# Procedure called to validate IODELAY_ENABLE
	return true
}

proc update_PARAM_VALUE.IO_DELAY_GROUP { PARAM_VALUE.IO_DELAY_GROUP } {
	# Procedure called to update IO_DELAY_GROUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_DELAY_GROUP { PARAM_VALUE.IO_DELAY_GROUP } {
	# Procedure called to validate IO_DELAY_GROUP
	return true
}


proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.DEVICE_TYPE { MODELPARAM_VALUE.DEVICE_TYPE PARAM_VALUE.DEVICE_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEVICE_TYPE}] ${MODELPARAM_VALUE.DEVICE_TYPE}
}

proc update_MODELPARAM_VALUE.ADC_IODELAY_ENABLE { MODELPARAM_VALUE.ADC_IODELAY_ENABLE PARAM_VALUE.ADC_IODELAY_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_IODELAY_ENABLE}] ${MODELPARAM_VALUE.ADC_IODELAY_ENABLE}
}

proc update_MODELPARAM_VALUE.IO_DELAY_GROUP { MODELPARAM_VALUE.IO_DELAY_GROUP PARAM_VALUE.IO_DELAY_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_DELAY_GROUP}] ${MODELPARAM_VALUE.IO_DELAY_GROUP}
}

proc update_MODELPARAM_VALUE.IODELAY_ENABLE { MODELPARAM_VALUE.IODELAY_ENABLE PARAM_VALUE.IODELAY_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IODELAY_ENABLE}] ${MODELPARAM_VALUE.IODELAY_ENABLE}
}

proc update_MODELPARAM_VALUE.DAC_DATAPATH_DISABLE { MODELPARAM_VALUE.DAC_DATAPATH_DISABLE PARAM_VALUE.DAC_DATAPATH_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DAC_DATAPATH_DISABLE}] ${MODELPARAM_VALUE.DAC_DATAPATH_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_USERPORTS_DISABLE { MODELPARAM_VALUE.ADC_USERPORTS_DISABLE PARAM_VALUE.ADC_USERPORTS_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_USERPORTS_DISABLE}] ${MODELPARAM_VALUE.ADC_USERPORTS_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_DATAFORMAT_DISABLE { MODELPARAM_VALUE.ADC_DATAFORMAT_DISABLE PARAM_VALUE.ADC_DATAFORMAT_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_DATAFORMAT_DISABLE}] ${MODELPARAM_VALUE.ADC_DATAFORMAT_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_DCFILTER_DISABLE { MODELPARAM_VALUE.ADC_DCFILTER_DISABLE PARAM_VALUE.ADC_DCFILTER_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_DCFILTER_DISABLE}] ${MODELPARAM_VALUE.ADC_DCFILTER_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_IQCORRECTION_DISABLE { MODELPARAM_VALUE.ADC_IQCORRECTION_DISABLE PARAM_VALUE.ADC_IQCORRECTION_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_IQCORRECTION_DISABLE}] ${MODELPARAM_VALUE.ADC_IQCORRECTION_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_SCALECORRECTION_ONLY { MODELPARAM_VALUE.ADC_SCALECORRECTION_ONLY PARAM_VALUE.ADC_SCALECORRECTION_ONLY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_SCALECORRECTION_ONLY}] ${MODELPARAM_VALUE.ADC_SCALECORRECTION_ONLY}
}

