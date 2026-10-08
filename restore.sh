#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: $0 fir malicious_dir"
	return 1
fi

dir="$1"
malicious_dir="$2"

if [ ! -d "$dir" ]; then
	echo "Error: source directory does not exist"
	return 1
fi

if [ ! -d "$malicious_dir" ]; then
	echo "Error: malicious directory does not exist"
	return 1
fi

while true; do
	mapfile -t files < <( find "$malicious_dir" -maxdepth 1 -type f -printf "%f\n" | sort)
	if [ "${#files[@]}" -eq 0 ]; then
		echo "malicious directory is empty"
		exit 0
	fi
    echo
    read -rp "Choose a file number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] ||
       [ "$choice" -lt 1 ] ||
       [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid choice."
        continue
    fi

    index=$((choice - 1))
    filename="${files[$index]}"
    filepath="$malicious_dir/$filename"

    echo
    echo "Selected: $filename"
    echo "1. Restore this file"
    echo "2. Permanently delete this file"
    echo "3. Leave this file as-is"

    read -rp "Choose an option: " option

    case "$option" in
        1)
            mv -- "$filepath" "$dir/$filename"
            echo "Restored $filename to $dir."
            ;;

        2)
            rm -- "$filepath"
            echo "$filename permanently deleted."
            ;;

        3)
            ;;

        *)
            echo "Invalid option."
            ;;
    esac
done
