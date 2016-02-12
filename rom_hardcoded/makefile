#change these parameters 
PROJECT = rom2
TB_TOP = rom2_tb
TB_TOP_OPT = rom2_tb_opt


all: $(PROJECT)

$(PROJECT): 
	vcom -64 -f rtl.cfg
	vlog -64 -f tb.cfg
	vopt -64 $(TB_TOP) +acc=mpr -o $(TB_TOP_OPT) 
	vsim -64 -l simulation.log -do sim.do -c $(TB_TOP_OPT)
	vsim -view waveform.wlf
	
clean:
	rm -rf work
	rm *.log
	rm *.key
	rm -rf *.shm	
