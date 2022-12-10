#!/usr/bin/env bash

# Use amass to discover subdomains for a domain
amass enum -d example.com

# Check if discovered subdomains are live or dead with httpx
httpx -status-code -threads 100 -o live_subdomains.txt $(cat example.com_subdomains.txt)

# Take screenshots of live subdomains with Eyewitness
eyewitness --web -f live_subdomains.txt --threads 100

# Perform a port scan of the top ports with masscan
masscan -p1-65535 -oG masscan_output.txt $(cat live_subdomains.txt)

# Perform directory bruteforcing with dirsearch and a common wordlist
cat live_subdomains.txt | xargs -I % sh -c "dirsearch -u % -e * -w /usr/share/dirsearch/wordlists/common.txt -t 100"

# Search for leaks in Github with gitleaks
gitleaks --repo-path https://github.com/example/repo --threads 100

# Extract JavaScript files from all subdomains and search for missed API keys with JSMiner
cat example.com_subdomains.txt | xargs -I % sh -c "JSMiner --extract-js % --output-dir js_files"
cat js_files/* | xargs -I % sh -c "JSMiner --search-keys %"

# Search for subdomains in the web archive with gau
gau example.com | jq '.results | .[] | .item' | xargs -I % sh -c "gau -subs %"

# Organize all output into HTML reports
# This step may require additional tools and customization to generate the reports in the desired format.
