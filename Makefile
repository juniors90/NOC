WEEKS := \
	week01-network-fundamentals \
	week02-tcp-ip-subnetting \
	week03-linux-networking \
	week04-dns-dhcp \
	week05-routing \
	week06-switching \
	week07-wireshark \
	week08-troubleshooting \
	week09-monitoring \
	week10-snmp \
	week11-services-servers \
	week12-python-networking \
	week13-network-automation \
	week14-databases-logs \
	week15-noc-incident-simulation \
	week16-final-noc-project

.PHONY: setup clean

setup:
	@for week in $(WEEKS); do \
		mkdir -p $$week/docs $$week/lab; \
		touch $$week/README.md; \
	done
	@touch README.md .gitignore
	@echo "NOC project structure created."

clean:
	@for week in $(WEEKS); do \
		rm -rf $$week; \
	done
	@echo "NOC project structure removed."