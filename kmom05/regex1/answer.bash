#!/usr/bin/env bash

#
# 5a5e8a0ef9620ff45f83bfb220c23dbb
# vlinux
# regex1
# v1
# oljn22
# 2024-09-24 06:19:42
# v4.0.0 (2019-03-05)
#
# Generated 2024-09-24 08:19:42 by dbwebb lab-utility v4.0.0 (2019-03-05).
# https://github.com/dbwebb-se/lab
#

export ANSWER
. .dbwebb.bash
echo "${PROMPT}Ready to begin."



# ==========================================================================
# regex1 - vlinux 
# 
# A lab where you use Unix tools available from the command line interface to
# manipulate a textfile. Have a look at https://regex101.com/. It is a good
# tool when trying out regular expressions. All
# names in the provided file are generated and has no real connection to
# anyone. The names and cities are randomly generated.
#

# --------------------------------------------------------------------------
# Section 1. Regex 1 
# 
# Work with the command `grep` to match text from files. This lab is
# constructed for GNU/grep.
#
# Use `man grep` as reference.
#
# The name of the file: names.csv
#
# To answer the questions, use the following structure:
# `ANSWER = "$(grep <flag> 'regex'  <filename>)"`
#
# Tips: Use the flag `-E` (Extended).
#

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.1 (1 points) 
# 
# Use the `grep` command and match all rows containg the substring `anna`
# from the file `names.csv`.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#

FILE="names.csv"




ANSWER="$( grep -E "anna" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.1" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.2 (1 points) 
# 
# Use the `grep` command and match all rows with firstnames starting with C-E
# immediately followed by some letter g-j.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#






ANSWER="$( grep -E "^[C-E][g-j]" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.2" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.3 (1 points) 
# 
# Use the `grep` command and match all rows with phonenumbers starting with
# 555 immediately followed by a 4, 6 or 8.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -E ",555[468]" $FILE )"
# ANSWER="$( grep -E "^(?:[-\sa-öA-Ö]+,){3}[-0-9]+,555[468]" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.3" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.4 (1 points) 
# 
# Reuse the command from last question and match all that also are born 2009.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -E ",2009-.*,555[468]" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.4" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.5 (1 points) 
# 
# Use the `grep` command and match all rows where the person lives in a town
# ending with "lilla".
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -E "^\w+,\w+,\w*lilla," $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.5" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.6 (1 points) 
# 
# Use the `grep` command and match all rows where there are five or six
# number 5's in a row.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -E "5{5,6}" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.6" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.7 (1 points) 
# 
# Use the `grep` command and match all rows that fulfil the criterias:
#
# 1. Firstname starts with a capital F.
# 2. Lastname starts with capital S or H.
# 3. The domain name of their email addresses has one or two `l` in a row in
# them.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -E "^F\w+,[SH].*@\w*l{1,2}" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.7" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.8 (1 points) 
# 
# Use the `grep` command and match all rows that fulfil the criterias:
#
# 1. Firstname does not start with a vowel (including swedish vowels).
# 2. Are born in the range of 1994 to 1998, 2004 or 2005.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -E "^[^AOUÅEIYÄÖ].*?,(199[4-8]|2004|2005)-" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.8" false

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.9 (1 points) 
# 
# Use the `grep` command and match and print only the city containing four
# spaces.
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -Eo "([[:alpha:]åäöÅÄÖ]+[[:space:]]){4}[[:alpha:]åäöÅÄÖ]+" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.9" true

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Exercise 1.10 (1 points) 
# 
# Use the `grep` command and match all rows that fulfil the criterias. Print
# only the match.
#
# 1. The domain name of the email address should start with an "r" and end
# with a vowel.
#
#
# Answer with the result.
#
# Write your code below and put the answer into the variable ANSWER.
#





ANSWER="$( grep -Eo "[[:alnum:]é.]+@r\w+[aouåeiyäö]\.\w+$" $FILE )"

# I will now test your answer - change false to true to get a hint.
assertEqual "1.10" true


exitWithSummary
