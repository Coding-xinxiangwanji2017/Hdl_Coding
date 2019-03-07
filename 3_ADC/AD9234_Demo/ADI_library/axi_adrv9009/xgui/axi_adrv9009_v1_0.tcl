# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADC_DATAFORMAT_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_DATAPATH_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_DCFILTER_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_IQCORRECTION_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_OS_DATAFORMAT_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_OS_DATAPATH_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_OS_DCFILTER_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ADC_OS_IQCORRECTION_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DAC_DATAPATH_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DAC_DDS_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DAC_IQCORRECTION_DISABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ID" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADC_DATAFORMAT_DISABLE { PARAM_VALUE.ADC_DATAFORMAT_DISABLE } {
	# Procedure called to update ADC_DATAFORMAT_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_DATAFORMAT_DISABLE { PARAM_VALUE.ADC_DATAFORMAT_DISABLE } {
	# Procedure called to validate ADC_DATAFORMAT_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_DATAPATH_DISABLE { PARAM_VALUE.ADC_DATAPATH_DISABLE } {
	# Procedure called to update ADC_DATAPATH_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_DATAPATH_DISABLE { PARAM_VALUE.ADC_DATAPATH_DISABLE } {
	# Procedure called to validate ADC_DATAPATH_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_DCFILTER_DISABLE { PARAM_VALUE.ADC_DCFILTER_DISABLE } {
	# Procedure called to update ADC_DCFILTER_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_DCFILTER_DISABLE { PARAM_VALUE.ADC_DCFILTER_DISABLE } {
	# Procedure called to validate ADC_DCFILTER_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_IQCORRECTION_DISABLE { PARAM_VALUE.ADC_IQCORRECTION_DISABLE } {
	# Procedure called to update ADC_IQCORRECTION_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_IQCORRECTION_DISABLE { PARAM_VALUE.ADC_IQCORRECTION_DISABLE } {
	# Procedure called to validate ADC_IQCORRECTION_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE { PARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE } {
	# Procedure called to update ADC_OS_DATAFORMAT_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE { PARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE } {
	# Procedure called to validate ADC_OS_DATAFORMAT_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_OS_DATAPATH_DISABLE { PARAM_VALUE.ADC_OS_DATAPATH_DISABLE } {
	# Procedure called to update ADC_OS_DATAPATH_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_OS_DATAPATH_DISABLE { PARAM_VALUE.ADC_OS_DATAPATH_DISABLE } {
	# Procedure called to validate ADC_OS_DATAPATH_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_OS_DCFILTER_DISABLE { PARAM_VALUE.ADC_OS_DCFILTER_DISABLE } {
	# Procedure called to update ADC_OS_DCFILTER_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_OS_DCFILTER_DISABLE { PARAM_VALUE.ADC_OS_DCFILTER_DISABLE } {
	# Procedure called to validate ADC_OS_DCFILTER_DISABLE
	return true
}

proc update_PARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE { PARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE } {
	# Procedure called to update ADC_OS_IQCORRECTION_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE { PARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE } {
	# Procedure called to validate ADC_OS_IQCORRECTION_DISABLE
	return true
}

proc update_PARAM_VALUE.DAC_DATAPATH_DISABLE { PARAM_VALUE.DAC_DATAPATH_DISABLE } {
	# Procedure called to update DAC_DATAPATH_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DAC_DATAPATH_DISABLE { PARAM_VALUE.DAC_DATAPATH_DISABLE } {
	# Procedure called to validate DAC_DATAPATH_DISABLE
	return true
}

proc update_PARAM_VALUE.DAC_DDS_DISABLE { PARAM_VALUE.DAC_DDS_DISABLE } {
	# Procedure called to update DAC_DDS_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DAC_DDS_DISABLE { PARAM_VALUE.DAC_DDS_DISABLE } {
	# Procedure called to validate DAC_DDS_DISABLE
	return true
}

proc update_PARAM_VALUE.DAC_IQCORRECTION_DISABLE { PARAM_VALUE.DAC_IQCORRECTION_DISABLE } {
	# Procedure called to update DAC_IQCORRECTION_DISABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DAC_IQCORRECTION_DISABLE { PARAM_VALUE.DAC_IQCORRECTION_DISABLE } {
	# Procedure called to validate DAC_IQCORRECTION_DISABLE
	return true
}

proc update_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to update ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID { PARAM_VALUE.ID } {
	# Procedure called to validate ID
	return true
}


proc update_MODELPARAM_VALUE.ID { MODELPARAM_VALUE.ID PARAM_VALUE.ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID}] ${MODELPARAM_VALUE.ID}
}

proc update_MODELPARAM_VALUE.ADC_DATAPATH_DISABLE { MODELPARAM_VALUE.ADC_DATAPATH_DISABLE PARAM_VALUE.ADC_DATAPATH_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_DATAPATH_DISABLE}] ${MODELPARAM_VALUE.ADC_DATAPATH_DISABLE}
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

proc update_MODELPARAM_VALUE.ADC_OS_DATAPATH_DISABLE { MODELPARAM_VALUE.ADC_OS_DATAPATH_DISABLE PARAM_VALUE.ADC_OS_DATAPATH_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_OS_DATAPATH_DISABLE}] ${MODELPARAM_VALUE.ADC_OS_DATAPATH_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE { MODELPARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE PARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE}] ${MODELPARAM_VALUE.ADC_OS_DATAFORMAT_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_OS_DCFILTER_DISABLE { MODELPARAM_VALUE.ADC_OS_DCFILTER_DISABLE PARAM_VALUE.ADC_OS_DCFILTER_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_OS_DCFILTER_DISABLE}] ${MODELPARAM_VALUE.ADC_OS_DCFILTER_DISABLE}
}

proc update_MODELPARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE { MODELPARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE PARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE}] ${MODELPARAM_VALUE.ADC_OS_IQCORRECTION_DISABLE}
}

proc update_MODELPARAM_VALUE.DAC_DATAPATH_DISABLE { MODELPARAM_VALUE.DAC_DATAPATH_DISABLE PARAM_VALUE.DAC_DATAPATH_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DAC_DATAPATH_DISABLE}] ${MODELPARAM_VALUE.DAC_DATAPATH_DISABLE}
}

proc update_MODELPARAM_VALUE.DAC_DDS_DISABLE { MODELPARAM_VALUE.DAC_DDS_DISABLE PARAM_VALUE.DAC_DDS_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DAC_DDS_DISABLE}] ${MODELPARAM_VALUE.DAC_DDS_DISABLE}
}

proc update_MODELPARAM_VALUE.DAC_IQCORRECTION_DISABLE { MODELPARAM_VALUE.DAC_IQCORRECTION_DISABLE PARAM_VALUE.DAC_IQCORRECTION_DISABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DAC_IQCORRECTION_DISABLE}] ${MODELPARAM_VALUE.DAC_IQCORRECTION_DISABLE}
}

