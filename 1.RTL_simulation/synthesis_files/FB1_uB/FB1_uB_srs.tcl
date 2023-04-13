#-- Synopsys, Inc.
#-- Version 201809 
#-- Tcl File /home/course/csr530603/final_project/1.RTL_simulation/synthesis_files/FB1_uB/FB1_uB_srs.tcl
#-- Written on Thu Apr 13 10:34:05 2023
 
set DATABASE_NAME {FB1_uB_srs}
set DESIGN_NAME {FB1_uB}
set TOP_MODULE {TraceBuildLib.FB1_uB}
set TECH {HAPS-100}
set INCLUDE_PATH_FROM_TOP {$LIB/board;\
	/home/course/csr530603/final_project/1.RTL_simulation} 
set LIB_PATH_FROM_TOP {}
set HDL_DEFINE_FROM_TOP {}
set HDL_PARAM_FROM_TOP {}
set SRC_LIST {src_srs.txt}
set CDC_LIST {cdc_files.txt}
set FDC_LIST {fdc_files.txt}
set MAP_STATE_NAME m0
set RTL_INPUT_FORMAT srs

######################################
# Template '/usr/cadtool/csr5306/synopsys/protocomp/R-2020.12-SP1-1/lib/protocompiler/sysgen_template.tcl' follows:
# $LIB/protocompiler/sysgen_template.tcl
# This is a template to be used for synthesis of FPGAs in multi-FPGA projects.
# Please refer to the "ProtoCompiler User Guide" for detailed information
# on usage and customization of the flow for synthesis and place and route.

# system_generate will define the following Tcl variables at the top of this script:
#   $DATABASE_NAME : this is FPGA specific
#   $TOP_MODULE : this is FPGA specific
#   $TECH : technology for this FPGA, e.g. "HAPS-80"
#   $INCLUDE_PATH_FROM_TOP: any include path used in the top level compile
#   $LIB_PATH_FROM_TOP: any library path used in the top level compile
#   $HDL_DEFINE_FROM_TOP: any library path used in the top level compile
#   $HDL_PARAM_FROM_TOP: any hdl_param in the top level compile
#   $SRC_LIST: filelist of source files
#   $CDC_LIST: filelist of cdc files from top level compile
#   $FDC_LIST: constraint files for this FPGA passed from top level
#   $MAP_STATE_NAME: Name of the map state that is system_generate assumes. Set by system_generate.
#   $RTL_INPUT_FORMAT: "hdl" or "srs"

# Everything else can be customized by modifying a copy of this template and
#   passing it to system generate via:
#   system_generate ... -synthesis_template <pathtotemplate>

# The following procedure sets default values for TCL variables used by this script.
#   You can change these TCL variables from the launch protocompiler command.
#   Example:
#     launch protocompiler -tclcmd {set ENABLE_PAR 1; set ENABLE_BACKANNOTATE 1} -script fpga_script
proc set_if_unset {var val} {
	upvar $var v
	if {! [ info exists v]} { set v $val } elseif { "$v" != "$val" } { puts "Note: '$var' has been overridden to '$v'" }
}

proc init_read_recipe { } {
  if { ![ file exists ./parff.recipe] }  {
    exec rsync -azvpL $::LIB/protocompiler/parff.recipe ./
  }
  exec rm -Rf success.recipe
  set recipeFile "parff.recipe"

  set fp [open "$recipeFile" r]
  set file_data [read $fp]
  close $fp
  global StratEnd
  set data [split $file_data "\n"]
  set StratStart 0
  set StratEnd 1
  array set bigList ""
  foreach line $data {
    if { [regexp "^#" $line] } {
    } else {
       if { $StratEnd && ![regexp "\{" $line] } {
           # We got a strategy
           set SindBadStratName [string trim [lindex [split $line :] 0]]
           if { $SindBadStratName == "" } {
               continue
           }
           # Default values are below
           set DistributedSynthesis 0 
           set SynthesisStrategy "fast"
           set PARMode "default"
           set MPFMode "None"
           set opt_design_flags "NA"
           set place_design_flags "NA"
           set route_design_flags "NA"
           set sll_optimize "NA"
       } elseif { $StratStart && ![regexp "\}" $line] } {
         lassign [split $line :] name value
         set name [string trim $name]
         set $name $value
       } elseif { [regexp "\{" $line] } {
           set StratStart 1
           set StratEnd 0
       } elseif { [regexp "\}" $line] } {
         set StratStart 0
         set StratEnd 1
       } 
       # So first time around this will create the default strategy
       # If there are things inside then it will help populate the new values
       if { $StratEnd == 1} {
         set bigList($SindBadStratName) [list\
            $DistributedSynthesis $SynthesisStrategy $PARMode $MPFMode $opt_design_flags\
            $place_design_flags $route_design_flags $sll_optimize]
       }
    }
  }
  return [array get bigList]
}

proc hVivado_edit_srsfile {strats srsFilePath Tech} {
    set tech $Tech
    set srsFile $srsFilePath
    set synthDir [file dirname $srsFile]
    set noStrats [llength $strats]

    exec sed -i "s?set_if_unset VIVADO_DIR ./vivado_\${RTL_INPUT_FORMAT}?PLACEHOLDER?g" $srsFile
    set noStrats [llength $strats]
    for {set i 1} {$i <= $noStrats} {incr i} {
       exec sed -i "s?PLACEHOLDER$?set_if_unset VIVADO$i\_DIR ./vivado$i\_\${RTL_INPUT_FORMAT}\\nPLACEHOLDER?g" $srsFile
    }
    exec sed -i "s?PLACEHOLDER$??g" $srsFile
    exec sed -i "s?set_if_unset RUN_VIVADO_SCRIPT     \"\$VIVADO_DIR/run_vivado_haps.tcl\"?PLACEHOLDER?g" $srsFile
    for {set i 1} {$i <= $noStrats} {incr i} {
       exec sed -i "s?PLACEHOLDER$?set_if_unset RUN_VIVADO_SCRIPT$i     \"\$VIVADO$i\_DIR/run_vivado_haps.tcl\"\\nPLACEHOLDER?g" $srsFile
    }
    exec sed -i "s?PLACEHOLDER$??g" $srsFile
    exec sed -i "s?set export_vivado_args \"export vivado -path \$VIVADO_DIR\"?PLACEHOLDER1?g" $srsFile
    exec sed -i "s?if { \"\$VIVADO_VERILOG_FLOW\" } { lappend export_vivado_args -format verilog }?PLACEHOLDER2?g" $srsFile
    exec sed -i "s?if { \"\$VIVADO_OPTION_FILE\" != \"\" } { lappend export_vivado_args -vivado_option_file \${VIVADO_OPTION_FILE} }?PLACEHOLDER3?g" $srsFile
    exec sed -i "s?eval \$export_vivado_args?PLACEHOLDER4?g" $srsFile
    for {set i 1} {$i <= $noStrats} {incr i} {
       exec sed -i "s?PLACEHOLDER1$?set export_vivado_args$i \"export vivado -path \$VIVADO$i\_DIR\"\\n        PLACEHOLDER1?g" $srsFile
       exec sed -i "s?PLACEHOLDER2$?if { \"\$VIVADO_VERILOG_FLOW\" } { lappend export_vivado_args$i -format verilog }\\n        PLACEHOLDER2?g" $srsFile
       exec sed -i "s?PLACEHOLDER3$?if { \"\$VIVADO_OPTION_FILE\" != \"\" } { lappend export_vivado_args$i -vivado_option_file \${VIVADO_OPTION_FILE} }\\n        PLACEHOLDER3?g" $srsFile
       exec sed -i "s?PLACEHOLDER4$?eval \$export_vivado_args$i\\n        PLACEHOLDER4?g" $srsFile
    }
    exec sed -i "s?PLACEHOLDER1$??g" $srsFile
    exec sed -i "s?PLACEHOLDER2$??g" $srsFile
    exec sed -i "s?PLACEHOLDER3$??g" $srsFile
    exec sed -i "s?PLACEHOLDER4$??g" $srsFile
    exec sed -i "s?if \{ \$ENABLE_PAR || \$ENABLE_PAR_EXPLORER \} \{?PLACEHOLDER\\n  if \{ \$ENABLE_PAR || \$ENABLE_PAR_EXPLORER \} \{?g" $srsFile
    for {set i 1} {$i <= $noStrats} {incr i} {
       exec sed -i "s?PLACEHOLDER$?set fpga_env_file$i \"\$\VIVADO$i\_DIR/vivado_pc_env.tcl\"\\n  set fpga_flag_file$i \"\$VIVADO$i\_DIR/vivado_pc_flags.tcl\"\\n  set fpga_proc_file$i \"\$\VIVADO$i\_DIR/vivado_pc_procs.tcl\"\\nPLACEHOLDER?g" $srsFile
    }
    for {set i 0} {$i < $noStrats} {incr i} {
       lassign [lindex $strats $i] SindBadStratName DistributedSynthesis SynthesisStrategy \
                                   PARMode MPFMode opt_design_flags place_design_flags \
                                   route_design_flags sll_optimize
       set j [expr $i+1];
       set outfile1 [open "recipe$j.txt" w+]
       puts $outfile1 "$SindBadStratName:"
       puts $outfile1 "{"
       foreach var { DistributedSynthesis SynthesisStrategy PARMode  MPFMode\
                     opt_design_flags place_design_flags route_design_flags \
                     sll_optimize } {
           puts $outfile1 "$var:[set $var]"
       }
       puts $outfile1 "}"
       close $outfile1
       exec mv recipe$j.txt $synthDir/

       if { ( ("$place_design_flags" != "NA") || ("$route_design_flags" != "NA") || ("$sll_optimize" != "NA") ) } {
           exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/fast_turn_around/s//custom_run/g\" \$fpga_flag_file$j \\nPLACEHOLDER?g" $srsFile
       }
       if { $MPFMode == "Single" } {
           exec sed -i "s?PLACEHOLDER$?exec echo \"set SingleMachineMPF 1\" >>\$fpga_env_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif { $MPFMode == "Multi" } {
           exec sed -i "s?PLACEHOLDER$?exec echo \"set MultiMachineMPF 1\" >>\$fpga_env_file$j \\nPLACEHOLDER?g" $srsFile
       }

       if {"$PARMode" != "NA"} {
         if { [regexp {Emulation} $PARMode] } {
           exec sed -i "s?PLACEHOLDER$?exec echo \"set EmulationMode 1\" >> \$fpga_env_file$j \\nPLACEHOLDER?g" $srsFile 
         } else {
           exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/fast_turn_around/s//$PARMode/g\" \$fpga_flag_file$j \\nPLACEHOLDER?g" $srsFile
         }
       }
       if {"$opt_design_flags" != "NA"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_opt_design_flags/s//$opt_design_flags/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "timing_qor"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_opt_design_flags/s//-directive Explore/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "fast_turn_around"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_opt_design_flags/s//-directive RuntimeOptimized/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "default"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_opt_design_flags/s///g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } else {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_opt_design_flags/s///g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       }
       if {"$place_design_flags" != "NA"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_place_design_flags/s//$place_design_flags/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "timing_qor"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_place_design_flags/s//-directive Explore/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "fast_turn_around"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_place_design_flags/s//-directive RuntimeOptimized/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "default"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_place_design_flags/s///g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } else {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_place_design_flags/s///g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       }
       if {"$route_design_flags" != "NA"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_route_design_flags/s//$route_design_flags/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "timing_qor"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_route_design_flags/s//-directive Explore/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "fast_turn_around"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_route_design_flags/s//-directive RuntimeOptimized/g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } elseif {"$PARMode" == "default"} {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_route_design_flags/s///g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       } else {
         exec sed -i "s?PLACEHOLDER$?exec sed -i \"0,/custom_route_design_flags/s///g\" \$fpga_proc_file$j \\nPLACEHOLDER?g" $srsFile
       }
       if {"$sll_optimize" != "NA" && ${tech} != "HAPS-80"} {
           exec sed -i "s?PLACEHOLDER$?exec echo \"set SllOptVivadoEnable $sll_optimize\" >> \$fpga_env_file$j \\nPLACEHOLDER?g" $srsFile
       }
    }
    exec sed -i "s?PLACEHOLDER$??g" $srsFile
    exec sed -i "s?set id \\\[launch vivado -bg -run_dir \$VIVADO_DIR -script \$RUN_VIVADO_SCRIPT]?NEWPLACEHOLDER?g" $srsFile
    for {set i 1} {$i <= $noStrats} {incr i} {
       exec sed -i "s?NEWPLACEHOLDER$?set j$i \[launch vivado -bg -run_dir \$VIVADO$i\_DIR -script \$RUN_VIVADO_SCRIPT$i]\\n        NEWPLACEHOLDER?g" $srsFile
       if {"$i" == "1"} {
         set tmp "\$j1"
         set jw $tmp
        } else {
         set tmp "\$j$i"
         append jw { } $tmp
        }
    }
    exec sed -i "s?        NEWPLACEHOLDER??g" $srsFile
    exec sed -i "s?NEWPLACEHOLDER$??g" $srsFile
    exec sed -i "s?monitor_fpga_complexity \$id \$VIVADO_DIR??g" $srsFile
    exec sed -i "s?import vivado \$VIVADO_DIR??g" $srsFile
    exec sed -i "s?database apply_state -backannotate?#database apply_state -backannotate?g" $srsFile
}

proc generate_recipe_dirs { arrayName synthIgnore} {
  upvar $arrayName bigList
  set FastSynthStrats ""
  set AdvSynthStrats ""
  set RoutSynthStrats ""
  set BaseSynthStrats ""
  set noStrats 0
  foreach { SindBadStratName Strategy }  [array get bigList] { 
     incr noStrats
     set synthMode [lindex $Strategy 1]
     if { $synthMode == $synthIgnore } {
         puts "Ignoring Recipe $SindBadStratName as original failed with $synthMode"
         continue
     }
     if {"$synthMode" == "fast"} {
       lappend FastSynthStrats [list $SindBadStratName {*}$Strategy]
     } elseif {"$synthMode" == "advanced"} {
       lappend AdvSynthStrats [list $SindBadStratName {*}$Strategy]
     } elseif {"$synthMode" == "routability"} {
       lappend RoutSynthStrats [list $SindBadStratName {*}$Strategy]
     } elseif {"$synthMode" == "base"} {
       lappend BaseSynthStrats [list $SindBadStratName {*}$Strategy]
     }
  }
  if {$noStrats <= 0} {
    puts "Total No of Recipes are equal to 0, please review recipe File" 
    exit
  }
  if {[llength $FastSynthStrats] > 0} {
    #puts "$FastSynthStrats are Fast Synthesis Strategies with [llength $FastSynthStrats] strategies\n"
  }
  if {[llength $AdvSynthStrats] > 0} {
    #puts "$AdvSynthStrats are Advanced Synthesis Strategies with [llength $AdvSynthStrats] strategies\n"
  }
  if {[llength $RoutSynthStrats] > 0} {
    #puts "$RoutSynthStrats are Routability Synthesis Strategies with [llength $RoutSynthStrats] strategies\n"
  }
  if {[llength $BaseSynthStrats] > 0} {
    #puts "$BaseSynthStrats are Base Synthesis Strategies with [llength $BaseSynthStrats] strategies\n"
  }
  set fpgadir $::DESIGN_NAME
  set cmd "launch protocompiler"
  if {[llength $FastSynthStrats] > 0} {
    set mode fast
    create_one_parff_dir $fpgadir $mode $FastSynthStrats $::TECH cmd
  }
  if {[llength $AdvSynthStrats] > 0} {
    set mode advanced
    create_one_parff_dir $fpgadir $mode $AdvSynthStrats $::TECH cmd
  }
  if {[llength $RoutSynthStrats] > 0} {
    set mode routability
    create_one_parff_dir $fpgadir $mode $RoutSynthStrats $::TECH cmd
  }
  if {[llength $BaseSynthStrats] > 0} {
    set mode base
    create_one_parff_dir $fpgadir $mode $BaseSynthStrats $::TECH cmd
  }
  return $cmd
}

proc create_one_parff_dir { fpgadir mode strats TECH cmdString} {
    upvar $cmdString cmd
    exec rm -Rf ${fpgadir}_${mode}
    if { [ file exists ${fpgadir}_haps_timing.fdc ] }  {
      exec rsync -azvpL ${fpgadir}_haps_timing.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists srs_cons_var.fdc ] }  {
      exec rsync -azvpL srs_cons_var.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists syn_dics_$fpgadir\.fdc ] }  {
      exec rsync -azvpL syn_dics_$fpgadir\.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists tdm_cons_var.fdc ] }  {
      exec rsync -azvpL tdm_cons_var.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists timing.fdc ] }  {
      exec rsync -azvpL timing.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists hdl_cons_var.fdc ] }  {
      exec rsync -azvpL hdl_cons_var.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists HAPS80.fdc ] }  {
      exec rsync -azvpL HAPS80.fdc ${fpgadir}_${mode}/
    }
    if { [ file exists HAPS100.fdc ] }  {
      exec rsync -azvpL HAPS100.fdc ${fpgadir}_${mode}/
    }
    exec rsync -azvpL cdc_files.txt fdc_files.txt options.tcl src_srs.txt ${fpgadir}_attr.fdc ${fpgadir}_iostd.fdc ${fpgadir}_pinloc.fdc ${fpgadir}_srs $fpgadir\.srs ${fpgadir}_srs.html ${fpgadir}_srs.tcl ${fpgadir}_timing.fdc  ${fpgadir}_${mode}
    exec sed -i "s?set_if_unset ENABLE_PAR            0?set_if_unset ENABLE_PAR            1?g" ${fpgadir}_${mode}/${fpgadir}_srs.tcl 
    exec sed -i "s?set_if_unset SYNTH_PAR_EXPLORER            0?set SYNTH_PAR_EXPLORER            0?g" ${fpgadir}_${mode}/${fpgadir}_srs.tcl
    exec echo "option set synthesis_strategy ${mode}" >> ${fpgadir}_${mode}/options.tcl
    exec sed -i "s?../common_files/?../../common_files/?g" ${fpgadir}_${mode}/fdc_files.txt
    exec touch ${fpgadir}_${mode}/.parff
    append cmd " -tclcmd \"source ../smart_param_settings.tcl\" -run_dir ./${fpgadir}_${mode} -script {./${fpgadir}_${mode}/${fpgadir}_srs.tcl}"
    hVivado_edit_srsfile $strats ${fpgadir}_${mode}/${fpgadir}_srs.tcl $TECH
}

proc monitor_fpga_complexity { main_id vivadodir } {
    set isComplex 0
    global DesignName
    set skipCurrentSynthesis 0
    while { !$isComplex } {
        after 10000 ; # poll every 10 seconds
        set run_state [job query $main_id -run_state]
        if { [info exists ::env(PC_ENABLE_SMART_SPO)] && $::env(PC_ENABLE_SMART_SPO) == 1  } {
            if { [info exists ::env(PC_SPO_COMPLEXITY_PREDICTOR)] } {
                # Use the custom complexity predictor
                if { [$::env(PC_SPO_COMPLEXITY_PREDICTOR) $vivadodir] == 1 } {
                    set isComplex 1
                }
            } else {
                #Use a custom timer
                if { ![info exists spo_counter] } {
                    if { [info exists ::env(PC_SPO_COMPLEXITY_TIME)] } {
                        set timed_parff $::env(PC_SPO_COMPLEXITY_TIME)
                    } else {
                        set timed_parff 10
                    }
                    set spo_counter [expr ($timed_parff * 60) / 10]
                }
                if { $run_state == "running" } {
                    incr spo_counter -1
                    if { $spo_counter == 0 } {
                        set isComplex 1
                    }
                }
            } 
            if { $run_state != "running" } {
                # Job is either finished or cancelled
                # Need to check for job failure
                if { [file exists .mainOK] != 1} {
                    # Job failed, launch parff
                    set isComplex 1
                    set skipCurrentSynthesis 1
                }
                # Exit the While loop
                break
            }
        } else {
            # If SMART_SPO is not enabled, find the terminating condition for the loop
            if { $run_state != "running" } {
                break
            }
        }
    }
    if { $isComplex } {
        puts "========================================================"
        puts "Detected COMPLEX FPGA, Launching PARFF for ${::DESIGN_NAME}."
        puts "========================================================"
        #Now need to launch parff
        array set bigList [init_read_recipe]
        set currentStrategy {}
        if { $skipCurrentSynthesis == 1 } {
            set currentStrategy [option_get synthesis_strategy]
        }
        set cmd [generate_recipe_dirs bigList $currentStrategy]
        set ::SYNTH_PAR_EXPLORER 1
        # Clear the tracking files
        exec rm -Rf .Success .ready .mainOK
        exec rm -Rf ./recipe.txt
        append cmd " -bg"
        # Launch the background jobs
        set pc_job [{*}$cmd]

        #Start next loop to keep monitoring the new jobs
        set done 0
        while { !$done } {
            # Now this loop runs for both jobs and checks if .ready is present
            set main_state [job query $main_id -run_state]
            if { $main_state == "running" && [file exists .Success] == 0 }  {
                # wait for 10 sec before querying again
                after 10000
            } else {
                # First Check the main State, Then check the ancilarry processes
                if { $main_state != "running" } {
                    # Check if other runs completed already
                    if { [file exists .Success] == 0 } {
                        set ret_code [job query $main_id -return_code]
                        if { $ret_code == 0  && [file exists .mainOK] == 1 } {
                            # Success, Terminate the remaining jobs
                            exec touch .Success .ready
                            job kill $pc_job
                            set done 1
                        }
                    }
                } elseif { [file exists .ready] } {
                    # If ready then set done
                    if { $main_state == "running" } {
                        # Terminate the main job
                        job kill $main_id
                    }
                    # We are done
                    set done 1
                } elseif { [file exists .Success] } {
                    # If success then Wait
                    if {$main_state == "running" } {
                        # Terminate the main job
                        job kill $main_id
                    }
                    # We are not done and have to wait for child processes to complete
                    after 10000
                }
            }
        }
    }
}

set_if_unset SYNTH_PAR_EXPLORER            0
# new variables needed for the flow
set_if_unset ENABLE_PARFF_FLOW               0
set_if_unset VIVADO_ENABLE_FAST_TAT_MODE     0
set_if_unset VIVADO_POST_LINK_OPTION_FILES   ""
# note: not all combinations of enables are valid:
set_if_unset ENABLE_INCR_FLOW      0
set_if_unset ENABLE_PRE_INSTRUMENT 0
set_if_unset ENABLE_COMPILE        1
set_if_unset ENABLE_PRE_MAP        1
set_if_unset ENABLE_MAP            1
set_if_unset ENABLE_EXPORT_VIVADO  1
set_if_unset ENABLE_PAR            0
set_if_unset ENABLE_PAR_EXPLORER   0
set_if_unset PAR_EXPLORER_SCRIPT   ""
set_if_unset ENABLE_BACKANNOTATE   0
set_if_unset VIVADO_OPTION_FILE    ""
set_if_unset VIVADO_VERILOG_FLOW 0
set_if_unset USER_RTL_IDC ""
set_if_unset USER_NETLIST_IDC ""
set_if_unset COMPILE_NLE ""
set_if_unset MAX_PARALLEL_JOBS ""

if {$MAX_PARALLEL_JOBS !=""} {
      option set max_parallel_jobs $MAX_PARALLEL_JOBS
}

if { $SYNTH_PAR_EXPLORER } {
  array set bigList [init_read_recipe]
  set cmd [generate_recipe_dirs bigList {}]

  exec rm -Rf .Success .ready .mainOK
  exec rm -Rf ./recipe.txt
  puts "\n$cmd is Command to be passed for PC-HAPS tcl console\n"
  exec rm -Rf ./launch_parff.tcl
  exec touch ./launch_parff.tcl
  exec echo "$cmd" >> ./launch_parff.tcl
  source ./launch_parff.tcl
  if { $ENABLE_BACKANNOTATE } {
    set back_annotation 1
    set done 0
  } else {
    set back_annotation 0
    set done 1
  } 
  while {$done == 0} {
    if { ([file exists ./.ready]) } {
      database apply_state -backannotate
      set done 1
    } else { 
      after 60000;
    }
  }        
} else {

# MAP_STATE_NAME is assumed by system_generate, so if you change MAP_STATE,
# or use STATE_SUFFIX then update the system_generate state with:
# database apply_state -link_state ...
  if { [info exists STATE_SUFFIX] } {
	set_if_unset MAP_STATE m${STATE_SUFFIX}
  } else {
	set_if_unset MAP_STATE ${MAP_STATE_NAME}
  }
  set_if_unset STATE_SUFFIX "0"
  set_if_unset PRE_INSTRUMENT_STATE p${STATE_SUFFIX}
  set_if_unset COMPILE_STATE c${STATE_SUFFIX}
  set_if_unset PRE_MAP_STATE pm${STATE_SUFFIX}
  set_if_unset PAR_EXPLORER_STATE pe${STATE_SUFFIX}
  set_if_unset VIVADO_DIR ./vivado_${RTL_INPUT_FORMAT}
  set_if_unset RUN_VIVADO_SCRIPT     "$VIVADO_DIR/run_vivado_haps.tcl"
# post-map verilog is enabled if $env(VM_NETLIST_DIR) is set
# set these paths to IDC files if you are doing single-FPGA debug, and if using RTL_IDC, ENABLE PRE_INSTRUMENT above
# recommendation: use environment variable to point to a common scripts directory. For example:
#   set USER_RTL_IDC "$env(project_scripts_dir)/mb1_uA.idc"
  if { $ENABLE_INCR_FLOW } {
	  cd src_hdl
	  source uchaps.tcl
	  cd ..
  } else {
	  database load $DATABASE_NAME
	  database apply_state -technology $TECH
  }
  source options.tcl
  if { "$VIVADO_VERILOG_FLOW" } { 
		option set write_verilog 1
		option set result_format vm	
  }

  if { $ENABLE_PRE_INSTRUMENT || $ENABLE_COMPILE } {
	if { $ENABLE_PRE_INSTRUMENT } {
		set ccmd pre_instrument
		set cstate ${PRE_INSTRUMENT_STATE}
	   } else {
		set ccmd compile
		set cstate ${COMPILE_STATE}
	}
	if { $ENABLE_INCR_FLOW } {
		set compile_args "run $ccmd -out $cstate -cdclist $CDC_LIST"
	} else {
		set compile_args "run $ccmd -srclist $SRC_LIST -out $cstate -cdclist $CDC_LIST"
	}
	# lappend ensures Tcl quoting works correctly when there are special characters
	lappend compile_args -top_module $TOP_MODULE
	if { "$INCLUDE_PATH_FROM_TOP" != "" } { lappend compile_args -include_path ${INCLUDE_PATH_FROM_TOP} }
	if { "$LIB_PATH_FROM_TOP" != "" } { lappend compile_args -library_path ${LIB_PATH_FROM_TOP} }
	if { "$HDL_DEFINE_FROM_TOP" != "" } { lappend compile_args -hdl_define ${HDL_DEFINE_FROM_TOP} }
	if { "$HDL_PARAM_FROM_TOP" != "" } { lappend compile_args -hdl_param ${HDL_PARAM_FROM_TOP} }
	if { "$COMPILE_NLE" != "" } { lappend compile_args -nle ${COMPILE_NLE} }
	if { $ENABLE_INCR_FLOW } { lappend compile_args  -ucdb src_hdl/ucdb -src src_hdl/srs_dir/Non_Modified.srs}
	# this will run either "compile" or "pre_instrument" (if debugging a single-fpga):
	eval $compile_args

	if { $ENABLE_PRE_INSTRUMENT && $ENABLE_COMPILE } {
		set idc_compile_args "run compile -out ${COMPILE_STATE}"
		if { "$USER_RTL_IDC" != "" } { lappend idc_compile_args -idc ${USER_RTL_IDC} }
		# if pre_instrument was done, then run compile does not need the args again:
		eval $idc_compile_args
	}
  }
  database set_state ${COMPILE_STATE}

  if { $ENABLE_PRE_MAP } {
	set pre_map_args "run pre_map -fdclist $FDC_LIST -out ${PRE_MAP_STATE}"
	if { "$USER_NETLIST_IDC" != "" } { lappend pre_map_args -idc ${USER_NETLIST_IDC} }
	eval $pre_map_args
  }
  database set_state ${PRE_MAP_STATE}

  if { $ENABLE_MAP } {
	run map -out $MAP_STATE
  }
  database set_state $MAP_STATE

# simulation netlists:
  if { [array names env VM_NETLIST_DIR] != "" } {
	export netlist -format verilog -path $env(VM_NETLIST_DIR)
  }

  if { $ENABLE_EXPORT_VIVADO } {
	set export_vivado_args "export vivado -path $VIVADO_DIR"
	if { "$VIVADO_VERILOG_FLOW" } { lappend export_vivado_args -format verilog }
	if { "$VIVADO_OPTION_FILE" != "" } { lappend export_vivado_args -vivado_option_file ${VIVADO_OPTION_FILE} }
	# export vivado:
	eval $export_vivado_args
  }

  if { $ENABLE_PAR || $ENABLE_PAR_EXPLORER } {
	if { $ENABLE_PAR_EXPLORER } {
		set par_explorer_args "run par_explorer -out ${PAR_EXPLORER_STATE}"
		if { "$PAR_EXPLORER_SCRIPT" != "" } { lappend par_explorer_args -script ${PAR_EXPLORER_SCRIPT} }
		# run par_explorer:
		eval $par_explorer_args
	} else {
		set id [launch vivado -bg -run_dir $VIVADO_DIR -script $RUN_VIVADO_SCRIPT]
        monitor_fpga_complexity $id $VIVADO_DIR
		import vivado $VIVADO_DIR
	}
  }

  if { $ENABLE_BACKANNOTATE } {
	database apply_state -backannotate
  }
}
########################################
# Job management for bg jobs
########################################
if { [file exists .parff] == 1 } {
    set wait_for_jobs 1
    while { $wait_for_jobs } {
        set jobs [job list]
        if { [llength $jobs] > 0 } {
            # Only if ready is existing then stop all other jobs
            if { [file exists ../.ready] } {
                foreach j $jobs {
                    set job_name [job query $j -job_name]
                    if { $job_name == "launch_vivado" } {
                        puts "Terminating job $j"
                        job kill $j
                    }
                }
                set wait_for_jobs 0
            }
        } else {
            set wait_for_jobs 0
        }
        if { ${wait_for_jobs} == 1 } {
            after 5000
        }
    }
}

# Version information: $Header: //vg/synplicity/ui202012pcp4/misc/protocompiler/sysgen_template.tcl#7 $
