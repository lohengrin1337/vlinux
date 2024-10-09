#!/usr/bin/env bash

#
# 1049118f5fdbbdf8ba870393a182804f
# vlinux
# sed1
# v1
# oljn22
# 2024-10-09 10:07:11
# v4.0.0 (2019-03-05)
#
# Generated 2024-10-09 12:07:11 by dbwebb lab-utility v4.0.0 (2019-03-05).
# https://github.com/dbwebb-se/lab
#

export ANSWER
. .dbwebb.bash
echo "${PROMPT}Ready to begin."



# ==========================================================================
# Lab 3 - vlinux 
# 
# A lab where you use Unix tools available from the command line interface to
# manipulate a textfile. Have a look at https://regex101.com/. It is a good
# tool when trying out regular expressions.
#

# --------------------------------------------------------------------------
# Section 1. Sed 
# 
# Work with the command `sed` to parse/match text from files. This lab is
# constructed for GNU/sed. Use `man sed` as reference.
#
# To answer the questions, use the following structure:
# `ANSWER = $(sed <flag> '/regex/p' < textfile.txt)`
#
# The relevant flags are `-E` (Extended) and `-n` (just print the matching
# lines)
#

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.1 (1 points) 
# 
# Use the `sed` command and match `192.168.0.1` from the file `numbers.txt`.
# The content of the file is:
#
# > 192.168.0.1<br />
# 192-168-0-1<br />
# 19216801<br />
# 19.21.68.01<br />
# 192.168.0-1<br />
#
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="numbers.txt"

ANSWER=$( sed -E -n '/192\.168\.0\.1/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "1.1" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.2 (1 points) 
# 
# Use the `sed` command and match all lines starting with the word `The` in
# the file `quotes.txt`. The content of the file is:
#
# > People say nothing is impossible, but I do nothing every day.<br />
# The best thing about the future is that it comes one day at a time.<br />
# The only mystery in life is why the kamikaze pilots wore helmets.<br />
# I don’t believe in astrology; I’m a Sagittarius and we’re
# skeptical.<br />
# My opinions may have changed, but not the fact that I’m right.<br />
# A bank is a place that will lend you money if you can prove that you
# don’t need it.<br />
#
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="quotes.txt"

ANSWER=$( sed -E -n '/^The\b/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "1.2" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.3 (1 points) 
# 
# Use the `sed` command and match all lines having an `e` in the last word in
# the file `quotes.txt`. The content of the file is:
#
# > People say nothing is impossible, but I do nothing every day.<br />
# The best thing about the future is that it comes one day at a time.<br />
# The only mystery in life is why the kamikaze pilots wore helmets.<br />
# I don’t believe in astrology; I’m a Sagittarius and we’re
# skeptical.<br />
# My opinions may have changed, but not the fact that I’m right.<br />
# A bank is a place that will lend you money if you can prove that you
# don’t need it.<br />
#
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="quotes.txt"

ANSWER=$( sed -E -n '/\w*e\w*\.?$/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "1.3" false

# --------------------------------------------------------------------------
# Section 2. Capturing groups and substitution 
# 
# Practise on working with grouping and substitution. Do not edit the file
# inplace, work with the printed result.
#
# The structure of a command may look like:
# `$(sed -E 's/<match>/<substitution>/g')`.
#

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 2.1 (1 points) 
# 
# You will use the file `substitution.txt`. Thor is feeling stronger so help
# him to change the username to `MightyThor`.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="substitution.txt"

ANSWER=$( sed -E -n 's/(.*)Thor(.*)/\1MightyThor\2/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "2.1" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 2.2 (1 points) 
# 
# You will use the file `substitution.txt`. Thor is not mighty anymore, but
# he want to change `home` to `Asgaard`. Help him do that.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="substitution.txt"

ANSWER=$( sed -E -n 's/^(\/)home(\/.*)/\1Asgaard\2/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "2.2" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 2.3 (1 points) 
# 
# You will use the file `substitution.txt`. Help Thor to combine the two
# former questions.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="substitution.txt"

ANSWER=$( sed -E -n 's/(.*)home(.*)Thor(.*)/\1Asgaard\2MightyThor\3/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "2.3" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 2.4 (1 points) 
# 
# You will use the file `substitution.txt`. Thor got a picture that he wants
# to put in the family folder. Create a new entry under
# `/home/Thor/Pictures/Family/` where Thor gets his own folder containing a
# picture, called `selfie.png`.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="substitution.txt"

regex_family_folder=".*Family\/$"

family_folder=$(sed -E -n "/${regex_family_folder}/p" < $file)

ANSWER=$( sed -E "/${regex_family_folder}/a\\${family_folder}Thor/selfie.png" < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "2.4" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 2.5 (1 points) 
# 
# You will use the logfile `access-medium.log`. Use sed to get the year,
# month and day from each line in the log. Present the result in the format:
# `YYYY-Mmm-dd`, for example 2019-May-18.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="access-medium.log"

ANSWER=$( sed -E -n 's/.*([0-9]{2})\/([A-Za-z]{3})\/([0-9]{4}).*/\3-\2-\1/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "2.5" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 2.6 (1 points) 
# 
# You will use the logfile `access-medium.log`. Use sed to get only the
# ip-addresses from each line where the first digit is between 4 and 6 (4 and
# 6 included).
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="access-medium.log"

ANSWER=$( sed -E -n 's/^([4-6][0-9.]+).*/\1/p' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "2.6" false

# --------------------------------------------------------------------------
# Section 3. Extra assignments 
# 
# Solve these optional questions to earn extra points. You might want to look
# at more flags and options for the sed command.
#

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 3.1 (3 points) 
# 
# You will use the logfile `access-medium.log`. Use sed to get all URL's (the
# domain) from the file. Do not match URL's with only uppercase.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#




file="access-medium.log"

ANSWER=$( sed -E -n 's/.*(https?:\/\/(www\.)?[a-z0-9.]+).*/\1/pg' < $file )

# I will now test your answer - change false to true to get a hint.
assertEqual "3.1" false


exitWithSummary
