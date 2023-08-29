#!/usr/bin/tclsh

proc gp4323_settings {} {
  global serialPath
  global ch1Settings
  global ch2Settings
  global ch3Settings
  global ch4Settings

  #set serialPath /dev/ttyUSB3
  set serialPath /dev/gpp4323

  array set ch1Settings {}
  set ch1Settings(OvervoltageProtection) 32.000
  set ch1Settings(OvercurrentProtection) 3.200
  set ch1Settings(Voltage) 28.000
  set ch1Settings(Current) 3.000
  
  array set ch2Settings {}
  set ch2Settings(OvervoltageProtection) 32.000
  set ch2Settings(OvercurrentProtection) 3.200
  set ch2Settings(Voltage) 28.000
  set ch2Settings(Current) 3.000
  
  array set ch3Settings {}
  set ch3Settings(OvervoltageProtection) 5.000
  set ch3Settings(OvercurrentProtection) 1.000
  set ch3Settings(Voltage) 5.000
  set ch3Settings(Current) 1.000
  
  array set ch4Settings {}
  set ch4Settings(OvervoltageProtection) 5.000
  set ch4Settings(OvercurrentProtection) 1.100
  set ch4Settings(Voltage) 5.000
  set ch4Settings(Current) 1.000
}

if {[info exists argv0] && $argv0 eq [info script]} {
  gp4323_settings
}
