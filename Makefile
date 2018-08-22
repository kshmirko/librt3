#!/usr/bin/make

#main building variables
DSRC    = src
DOBJ    = build/obj/
DMOD    = build/mod/
DEXE    = build/
LIBS    =
FC      = gfortran
OPTSC   = -c -J build/mod
OPTSL   = -static -O3 -lcrt -J build/mod
VPATH   = $(DSRC) $(DOBJ) $(DMOD)
MKDIRS  = $(DOBJ) $(DMOD) $(DEXE)
LCEXES  = $(shell echo $(EXES) | tr '[:upper:]' '[:lower:]')
EXESPO  = $(addsuffix .o,$(LCEXES))
EXESOBJ = $(addprefix $(DOBJ),$(EXESPO))

#auxiliary variables
COTEXT  = "Compiling $(<F)"
LITEXT  = "Assembling $@"

#building rules
$(DEXE)DUMP: $(MKDIRS) $(DOBJ)dump.o \
	$(DOBJ)dump.o \
	$(DOBJ)radutil3.o \
	$(DOBJ)radtran3.o \
	$(DOBJ)radscat3.o \
	$(DOBJ)rt2subs.o \
	$(DOBJ)radintg3.o \
	$(DOBJ)radmat.o
	@rm -f $(filter-out $(DOBJ)dump.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) DUMP

#compiling rules
$(DOBJ)dump.o: src/dump.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)radutil3.o: src/radutil3.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)radtran3.o: src/radtran3.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)radscat3.o: src/radscat3.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)rt2subs.o: src/rt2subs.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)radintg3.o: src/radintg3.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)radmat.o: src/radmat.f
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

#phony auxiliary rules
.PHONY : $(MKDIRS)
$(MKDIRS):
	@mkdir -p $@
.PHONY : cleanobj
cleanobj:
	@echo deleting objects
	@rm -fr $(DOBJ)
.PHONY : cleanmod
cleanmod:
	@echo deleting mods
	@rm -fr $(DMOD)
.PHONY : cleanexe
cleanexe:
	@echo deleting exes
	@rm -f $(addprefix $(DEXE),$(EXES))
.PHONY : clean
clean: cleanobj cleanmod
.PHONY : cleanall
cleanall: clean cleanexe
