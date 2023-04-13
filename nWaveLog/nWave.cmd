wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder_in\[15:0\]} \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder_out\[16:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectGroup -win $_nWave1 {G2}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder_out\[16:0\]} \
{/BIST_Adder16_tb/signature\[16:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 31080.706026 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 31906.902009 -snap {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/signature\[16:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSelectGroup -win $_nWave1 {G2}
wvOpenFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16_func.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalScopeHistory -win $_nWave1 -backward
wvGetSignalClose -win $_nWave1
wvSetFileTimeRange -win $_nWave1 -time_unit 100p 0 355
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 345.674498 -snap {("G1" 5)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 108.896196 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 146.431558 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 345.019811 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 349.602617 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 346.765642 -snap {("G1" 2)}
wvCloseFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16.fsdb}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSelectGroup -win $_nWave1 {G1}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/ctrl"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/clk} \
{/BIST_Adder16_tb/finish} \
{/BIST_Adder16_tb/rst} \
{/BIST_Adder16_tb/signature\[16:0\]} \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSetPosition -win $_nWave1 {("G1" 8)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvCloseFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvTpfCloseForm -win $_nWave1
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetCursor -win $_nWave1 7089.918208 -snap {("G1" 3)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/ctrl"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/ctrl"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/misr"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/lfsr"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder/add_28"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
{/BIST_Adder16_tb/top/adder_out\[16:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvOpenFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16_func.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvSetActiveFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16.fsdb}
wvAddSignal -win $_nWave1 -group {"G1" {/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
{/BIST_Adder16_tb/top/adder_out\[16:0\]} \
}
wvSetActiveFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16_func.fsdb}
wvAddSignal -win $_nWave1 -group {"G1" {/BIST_Adder16_tb/clk} \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 348.729702 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 349.602617 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 343.492209 -snap {("G1" 9)}
wvSetCursor -win $_nWave1 354.621881 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 353.967194 -snap {("G1" 3)}
wvCloseFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvTpfCloseForm -win $_nWave1
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16_func.fsdb}
wvSelectGroup -win $_nWave1 {G1}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/clk} \
{/BIST_Adder16_tb/rst} \
{/BIST_Adder16_tb/finish} \
{/BIST_Adder16_tb/signature\[16:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetPosition -win $_nWave1 {("G2" 4)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 340.218777 -snap {("G2" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetRadix -win $_nWave1 -format UDec
wvCloseFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvTpfCloseForm -win $_nWave1
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/m110/m110061641/vlsi_testing/hw3/BIST_Adder16.fsdb}
wvSelectGroup -win $_nWave1 {G1}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectGroup -win $_nWave1 {G2}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb/top/adder"
wvGetSignalSetScope -win $_nWave1 "/BIST_Adder16_tb"
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/BIST_Adder16_tb/top/adder/A\[15:0\]} \
{/BIST_Adder16_tb/top/adder/B\[15:0\]} \
{/BIST_Adder16_tb/top/adder/sum\[15:0\]} \
{/BIST_Adder16_tb/top/adder/CO} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/BIST_Adder16_tb/clk} \
{/BIST_Adder16_tb/rst} \
{/BIST_Adder16_tb/finish} \
{/BIST_Adder16_tb/signature\[16:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetPosition -win $_nWave1 {("G2" 4)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 34941.273962 -snap {("G2" 4)}
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetRadix -win $_nWave1 -format UDec
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvExit
