# NTDS Auto

**One-click NTDS.dit parsing & NTLM cracking automation script for Kali Linux**

## Features
- Parses raw NTDS.dit dump
- Extracts username + NTLM hashes
- Automatically runs hashcat with `rockyou.txt`
- Matches cracked passwords to usernames
- Produces `final_creds.txt` ready for reporting
- Safe to re-run; handles already-cracked hashes

## Requirements
- Kali Linux
- hashcat installed
- rockyou.txt wordlist (`/usr/share/wordlists/rockyou.txt`)

## Usage
1. Place `ntds.txt` in the project folder.
2. Run:
```bash
./ntds_auto.sh
