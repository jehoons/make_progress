# You can check the command list to make targets with following command: 
# make all --no-print-directory -nrRf Makefile
# 
# check the number of commandas to be processed with following command: 
# make all --no-print-directory -nrRf Makefile ECHO="COUNTTHIS" | grep -c "COUNTTHIS"

ifneq ($(words $(MAKECMDGOALS)),1)
.DEFAULT_GOAL = all
%:
	@$(MAKE) $@ --no-print-directory -rRf $(firstword $(MAKEFILE_LIST))
else
ifndef ECHO
T := $(shell $(MAKE) $(MAKECMDGOALS) --no-print-directory \
	-nrRf $(firstword $(MAKEFILE_LIST)) \
	ECHO="COUNTTHIS" | grep -c "COUNTTHIS")

N := x
C = $(words $N)$(eval N := x $N)
ECHO = echo "`expr "     [\`echo "scale=5;" $C '*' 100 / $T \
	| bc -l \`" : '.*\(...........\)$$'`%]"
endif

.PHONY: all clean

source=$(shell ls *.inp)
target=$(source:.inp=.step1)
summary=summary

all: $(target) $(summary)
	@$(ECHO) ALL DONE

clean:
	@rm -f $(target) $(summary) 

jobs:
	@make all --no-print-directory -nrRf Makefile

%.step1: %.inp
	@$(ECHO) PROCESSING ... $@
	@sleep 0.2
	@cp $< $@

$(summary): $(target)
	@$(ECHO) REDUCING ... $@
	@sleep 0.2
	@cat $^ > $@

endif

