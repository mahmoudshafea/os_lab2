DIR = test_dir
MALICIOUS_DIR = malicious_dir
INTERVAL = 5

.PHONY: all setup antivirus restore clean

all: setup antivirus

setup:
	mkdir -p $(MALICIOUS_DIR)

antivirus: setup
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: setup
	./restore.sh $(DIR) $(MALICIOUS_DIR)

clean:
	rm -f directory-info.last directory-info.new
