#!/usr/bin/tclsh

proc connect {serialPath} {
  set fid [open $serialPath rb+]
  fconfigure $fid -mode 115200,n,8,1 -blocking 1 -translation {lf lf} -buffering line
  return $fid
}

proc idn? {fid} {
  puts $fid {*IDN?}
  return [gets $fid]
}

proc iset {fid ch amp} {
  puts $fid "ISET${ch}:${amp}"
}

proc iset? {fid ch} {
  puts $fid "ISET${ch}?"
  return [gets $fid]
}

proc vset? {fid ch} {
  puts $fid "VSET${ch}?"
  return [gets $fid]
}

proc vset {fid ch volt} {
  puts $fid "VSET${ch}:${volt}"
}

proc vout? {fid ch} {
  puts $fid "VOUT${ch}?"
  return [gets $fid]
}

proc iout? {fid ch} {
  puts $fid "IOUT${ch}?"
  return [gets $fid]
}

proc off {fid ch} {
  puts $fid ":OUTPut${ch}:State OFF"
}

proc on {fid ch} {
  puts $fid ":OUTPut${ch}:State ON"
}

proc onoff? {fid ch} {
  puts $fid ":OUTPut${ch}:State?"
  return [gets $fid]
}

proc ovp? {fid ch} {
  puts $fid ":OUTPut${ch}:OVP?"
  return [gets $fid]
}

proc ovp {fid ch volt} {
  puts $fid ":OUTPut${ch}:OVP ${volt}"
}

proc ovponoff? {fid ch} {
  puts $fid ":OUTPut${ch}:OVP:STATe?"
  return [gets $fid]
}

proc ovpon {fid ch} {
  puts $fid ":OUTPut${ch}:OVP:STATe ON"
}

proc ovpoff {fid ch} {
  puts $fid ":OUTPut${ch}:OVP:STATe OFF"
}

proc ocpon {fid ch} {
  puts $fid ":OUTPut${ch}:OCP:STATe ON"
}

proc ocpoff {fid ch} {
  puts $fid ":OUTPut${ch}:OCP:STATe OFF"
}

proc ocponoff? {fid ch} {
  puts $fid ":OUTPut${ch}:OCP:STATe?"
  return [gets $fid]
}

proc ocp? {fid ch} {
  puts $fid ":OUTPut${ch}:OCP?"
  return [gets $fid]
}

proc ocp {fid ch amp} {
  puts $fid ":OUTPut${ch}:OCP ${amp}"
}

proc status {fid ch} {
  puts "[idn? $fid]"
  puts "---------------------------- CHANNEL ${ch} ----------------------------"
  puts "Channel ${ch} ON/OFF?              : [onoff? $fid $ch]"
  puts ""
  puts "Overvoltage protection ON/OFF? : [ovponoff? $fid $ch]"
  puts "Overvoltage protection SET?    : [ovp? $fid $ch]"
  puts ""
  puts "Overcurrent protection ON/OFF? : [ocponoff? $fid $ch]"
  puts "Overcurrent protection SET?    : [ocp? $fid $ch]"
  puts ""
  puts "Voltage SET?                   : [vset? $fid $ch]"
  puts "Current SET?                   : [iset? $fid $ch]"
  puts ""
  puts "Voltage MEAS?                  : [vout? $fid $ch]"
  puts "Current MEAS?                  : [iout? $fid $ch]"
  puts "---------------------------- CHANNEL ${ch} ----------------------------"
}

proc chon {fid ch chSettings} {
  upvar $chSettings localChSettings

  off $fid $ch
  if {"OFF"!=[onoff? $fid $ch]} {
    puts "Channel ${ch} ON/OFF? !!! FAILED !!!"
    return
  }

  ovp $fid $ch $localChSettings(OvervoltageProtection)
  if {[ovp? $fid $ch]!=$localChSettings(OvervoltageProtection)} {
    puts "Overcurrent protection SET? !!! FAILED !!!"
    return
  }

  ovpon $fid $ch
  if {"ON"!=[ovponoff? $fid $ch]} {
    puts "Overvoltage protection ON/OFF? !!! FAILED !!!"
    return
  }

  ocp $fid $ch $localChSettings(OvercurrentProtection)
  if {[ocp? $fid $ch]!=$localChSettings(OvercurrentProtection)} {
    puts "Overcurrent protection SET? !!! FAILED !!!"
    return
  }

  ocpon $fid $ch
  if {"ON"!=[ocponoff? $fid $ch]} {
    puts "Overcurrent protection ON/OFF? !!! FAILED !!!"
    return
  }

  vset $fid $ch $localChSettings(Voltage)
  if {[vset? $fid $ch]!=$localChSettings(Voltage)} {
    puts "Voltage SET? !!! FAILED !!!"
    return
  }

  iset $fid $ch $localChSettings(Current)
  if {[iset? $fid $ch]!=$localChSettings(Current)} {
    puts "Current SET? !!! FAILED !!!"
    return
  }
}

if {[info exists argv0] && $argv0 eq [info script]} {
  gp4323_settings
  set fid [connect $serialPath]

  if {"ch1"==[lindex $argv 0]} {
    if {"on"==[lindex $argv 1]} {
      chon $fid 1 ch1Settings
      status $fid 1
    } elseif {"off"==[lindex $argv 1]} {
      off $fid 1
      status $fid 1
    } elseif {"status"==[lindex $argv 1]} {
      status $fid 1
    }
  } elseif {"ch2"==[lindex $argv 0]} {
    if {"on"==[lindex $argv 1]} {
      chon $fid 2 ch2Settings
      status $fid 2
    } elseif {"off"==[lindex $argv 1]} {
      off $fid 2
      status $fid 2
    } elseif {"status"==[lindex $argv 1]} {
      status $fid 2
    }
  } elseif {"ch3"==[lindex $argv 0]} {
    if {"on"==[lindex $argv 1]} {
      chon $fid 3 ch3Settings
      status $fid 3
    } elseif {"off"==[lindex $argv 1]} {
      off $fid 3
      status $fid 3
    } elseif {"status"==[lindex $argv 1]} {
      status $fid 3
    }
  } elseif {"ch4"==[lindex $argv 0]} {
    if {"on"==[lindex $argv 1]} {
      chon $fid 4 ch4Settings
      status $fid 4
    } elseif {"off"==[lindex $argv 1]} {
      off $fid 4
      status $fid 4
    } elseif {"status"==[lindex $argv 1]} {
      status $fid 4
    }
  }
}
