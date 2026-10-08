#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Usage: $0 dir malicious_dir interval-secs"
	exit 1
fi
dir="$1"
malicious_dir="$2"
interval_secs="$3"
if [ ! -d dir ]; then
	echo "Source directory not found"
	exit 1
fi
if [ ! -d malicious_dir ]; then
	mkdir -p "malicious_dir"
fi

snapshot_last="directory-info.last"
snapshot_new="directory-info.new"

flagged_extensions=("exe" "bat" "vbs" "scr" "ps1")
flagged_keywords=("virus" "trojan" "malware" "worm" "ransomware")

is_malicious(){
	local file="$1"
	local filename
	local extension

	filename=$(basename "$file")

	for extension in  "${flagged_extensions[@]}"; do
		if [[filename==*."$extension"]]; then
			return 0
		fi
	done

	for keyword in "${flagged_keywords[@]}"; do
		if grep -qi "$file" "$keyword" 2>dev/null; then
			return 0
		fi
	done
	return 1
}
scan_directory() {
    local file
    local filename

    for file in "$dir"/*; do
        [ -f "$file" ] || continue

        if is_malicious "$file"; then
            filename=$(basename "$file")

            echo "$file is malicious and it is DELETED"

            cp -- "$file" "$malicious_dir/$filename"
            rm -- "$file"
        fi
    done
}

if [ ! -f "$snapshot_last" ]; then
    scan_directory
    ls -l "$dir" > "$snapshot_last"
fi

while true; do
    sleep "$interval"

    ls -l "$dir" > "$snapshot_new"

    if ! cmp -s "$snapshot_last" "$snapshot_new"; then
        scan_directory
        cp "$snapshot_new" "$Snapshot_last"
    fi
done
