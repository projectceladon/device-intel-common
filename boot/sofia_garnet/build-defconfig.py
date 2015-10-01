#!/usr/bin/env python

#
# This script is designed to build a Linux kernel defconfig file out of an
# arbitrary number of fragments. Input can be passed on stdin or as a list of
# filenames to read as program arguments. Each input line is analyzed for a
# config variable. If found, any previous setting of that variable is discarded
# and replaced with the new setting. If no previous setting of the variable
# existed, the new setting is added as-is.
#

import fileinput, sys, re

# Extract the CONFIG_ variable name from an input line:
def varname(line):
	comments_stripped = re.sub( r'^[# \t]*', "", line)
	tokens = re.split( '[= ]', comments_stripped)
	return tokens[0]

# Determine if line specifies a CONFIG variable or not:
def is_config(line):
	if re.search( '^\s*CONFIG', line):                    return True
	if re.search( '^\s*#\s*CONFIG.*is not set\s*', line): return True
	return False

if __name__ == "__main__":
	output = []
	cache = {}
	for input_line in fileinput.input():

		# Pass comments directly through:
		if not is_config(input_line):
			output.append(input_line)
			continue

		# If we've already seen this variable, update it:
		name = varname(input_line)
		if name in cache:
			lineno = cache[name]
			output[lineno] = input_line
			continue

		# If we haven't seen this variable before, cache it and pass it
		# through:
		cache[name] = len(output)
		output.append(input_line)

	sys.stdout.writelines(output)
	sys.exit(0)

# Test dataset:

# # Un-duplicated variable
# CONFIG_A=A
#
# # Variable gets changed
# CONFIG_B=B
# CONFIG_B=A
#
# # Not set variable gets passed through
# # CONFIG_C is not set
#
# # Not set variable gets set
# # CONFIG_D is not set
# CONFIG_D=D
#
# # Set variable gets unset
# CONFIG_E=E
# # CONFIG_E is not set

# Output should be:

# # Un-duplicated variable
# CONFIG_A=A
#
# # Variable gets changed
# CONFIG_B=A
#
# # Not set variable gets passed through
# # CONFIG_C is not set
#
# # Not set variable gets set
# CONFIG_D=D
#
# # Set variable gets unset
# # CONFIG_E is not set

