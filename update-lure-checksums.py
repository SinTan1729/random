#!/bin/env python3

# This is a script to update checksums for sources in lure build scripts
# This is a crude analog for updpkgsums for PKGBUILD files
# The script assumed that matching sources* and checksums* lines are already there

import os
import re
import subprocess
import time

# Check if the build script exists
if not os.path.isfile("lure.sh"):
    print("Couldn't find a lure.sh file in the current directory.")
    exit(1)

with open("lure.sh", "r") as script_file:
    script = script_file.readlines()

vars = {}
for line in script:
    if "=" not in line or "\t" in line:
        continue
    var, val = line.strip("\n").split("=")
    vars[var] = val.strip('""').strip("''")

for src_type in [k for k in vars.keys() if "sources" in k]:
    suffix = src_type.split("_")[1]
    if suffix != "":
        suffix = "_" + suffix

    # Read all the links
    links = [link.strip('""').strip("''") for link in vars[src_type].strip("()").split()]

    # Get the old sums
    old_sums = vars["checksums" + suffix].strip("()").split()
    old_sums = [sum.strip('""').strip("''") for sum in old_sums]

    checksums = []
    for i, link in enumerate(links):
        if old_sums[i] == "SKIP":
            checksums.append("SKIP")
            continue
        # Try to do variable expansions (works up to one level, should be enough)
        to_replace = list(set(re.findall("(${.+?})", link)))
        for str in to_replace:
            str_clean = str.strip("${}")
            link = link.replace(str, vars[str_clean])

        filename = subprocess.run(
            ["curl", "-sLO", "-w", "%{filename_effective}", link], stdout=subprocess.PIPE
        )
        filename = filename.stdout.decode("utf-8")

        checksum = subprocess.run(["sha256sum", filename], stdout=subprocess.PIPE)
        checksum = checksum.stdout.decode("utf-8").split()[0]
        checksums.append(checksum)

    # Build the output line
    sum_out = "checksums" + suffix + "=('" + "' '".join(checksums) + "')\n"
    for i, line in enumerate(script):
        if "checksums" + suffix in line:
            script[i] = sum_out
            print("Updated checksums for " + suffix[1:] + " sources")

timestamp = "{}".format(int(time.time()))

with open(timestamp, "w") as tempfile:
    tempfile.writelines(script)

os.rename("lure.sh", "lure-" + timestamp + ".sh")
os.rename(timestamp, "lure.sh")

print("Done!")
