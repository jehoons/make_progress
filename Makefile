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
ECHO = echo "`expr "   [\`expr $C '*' 100 / $T\`" : '.*\(....\)$$'`%]"
endif

.PHONY: all clean

source=$(shell ls *.inp)
target=$(source:.inp=.step1)
summary=summary

all: $(target) $(summary)
	@$(ECHO) All done

clean:
	@rm -f $(target) $(summary) 

%.step1: %.inp
	@$(ECHO) Processing ... $@
	@sleep 0.1
	@cp $< $@

$(summary): $(target)
	@$(ECHO) Reducing ... $@
	@sleep 0.1
	@cat $^ > $@

#target: a.c b.c c.c
#	@$(ECHO) Linking $@
#	@sleep 0.1
#	@touch $@

#%.c:
#	@$(ECHO) Compiling $@
#	@sleep 0.1
#	@touch $@

endif
