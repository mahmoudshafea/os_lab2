# Simple Antivirus Daemon

## Overview

This project implements a simple antivirus daemon and a restore tool using Bash.

The antivirus daemon monitors a directory for changes. When a change is detected, it scans the files in the directory and checks whether they are malicious based on their file extension or file contents.

When a malicious file is detected, it is copied to the quarantine directory and then deleted from the monitored directory.

The restore tool allows quarantined files to be reviewed and either restored, permanently deleted, or left unchanged.

## Folder Hierarchy

```text
lab2/
├── Makefile Provides commands for running the antivirus and restore tools.
├── README.md Project documentation.
├── antivirusd.sh Antivirus daemon that monitors and scans the directory.
├── restore.sh Tool for reviewing and managing quarantined files.
├── test_dir/ Directory monitored by the antivirus.
└── malicious_dir/ Directory used to quarantine malicious files.
The antivirus also creates directory-info.last and directory-info.new, which are used to store directory snapshots and detect changes.

Prerequisites

The project requires Ubuntu/Linux with:
-Bash
-GNU Make
-Standard Linux utilities such as ls, grep, cp, mv, rm, find, and cmp

## Running the Antivirus:

The antivirus can be started using:

make antivirus

This runs the antivirus on test_dir, uses malicious_dir as the quarantine directory, and checks for changes every 5 seconds.

The antivirus performs an initial scan if no previous directory snapshot exists. After that, it checks the directory periodically and scans it when a change is detected.

Press Ctrl+C to stop the antivirus daemon.

##Running the Restore Tool:

The restore tool can be started using:

make restore

The tool displays the quarantined files and allows the user to:

Restore a selected file to the monitored directory.
Permanently delete a selected file.
Leave the selected file in the quarantine directory.

If there are no quarantined files, the program reports that the malicious directory is empty.

##Cleaning Generated Files:

The antivirus creates directory snapshot files named:

directory-info.last
directory-info.new

These files can be removed using:

make clean

##Flagged Extensions and Keywords:

The required flagged extensions and flagged keywords are defined in antivirusd.sh.

The flagged extensions are defined in the flagged_extensions array:

flagged_extensions=("exe" "bat" "vbs" "scr" "ps1")

The flagged keywords are defined in the flagged_keywords array:

flagged_keywords=("virus" "trojan" "malware" "worm" "ransomware")

These lists are used by the is_malicious() function to determine whether a file is malicious.

Keyword detection is case-insensitive.
