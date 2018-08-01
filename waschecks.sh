#!/bin/bash
# @author Michael McCurry
# Description: this script searches for the existence of certain files and information on WAS and ODR nodes.
# 7/31/18 - v1.0
# 8/1/18 - v1.1: Added comments to document script and fixed the case statement
#
# Place these commands in a script, or run the following line to create the file: 
# touch waschecks.sh; chmod 755 waschecks.sh; vi waschecks.sh

cat /etc/security/limits.conf|grep 131072
if [ $? -eq 1 ]; then
        echo 'At least one of these lines does not exist. Exiting...'
        exit 2
fi

# The following looks for "hard nofile 131072" and "soft nofile 131072". Shell exits when these two lines aren't found.
if [ `cat /etc/security/limits.conf|grep 131072|wc -l` -eq 2 ]; then
        echo 'hard nofile 131072 and soft nofile 131072 both exist!' | tee results.txt
else
        echo 'Only one line found. Exiting...'
        exit 3
fi

# Ask user for input to verify that the lines found were "hard nofile 131072" and "soft nofile 131072"
echo 'Were these the lines you were looking for? y or n'
read input

# Determine flow of program. If user enters 'y', the program continues. Otherwise, the program ends.
case $input in
        'y')
                echo 'Good'
                ;;
        'n')
                echo 'Exiting...'
				exit 4
                ;;
        *)
                echo 'Invalid input. Exiting...'
				exit 5
                ;;
        esac

# Checks to see if the local.conf file already exists. If it does, it outputs the file. Otherwise, the file is created.
if [ -f /etc/fonts/local.conf ]; then
        echo 'local.conf already exists. Outputting...' | tee -a results.txt
		echo ''
        cat /etc/fonts/local.conf
		echo ''
else
        echo "<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <alias>
    <family>serif</family>
    <prefer><family>Utopia</family></prefer>
  </alias>
  <alias>
    <family>sans-serif</family>
    <prefer><family>Utopia</family></prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer><family>Utopia</family></prefer>
  </alias>
  <alias>
    <family>dialog</family>
    <prefer><family>Utopia</family></prefer>
  </alias>
  <alias>
    <family>dialoginput</family>
    <prefer><family>Utopia</family></prefer>
  </alias>
</fontconfig>" > /etc/fonts/local.conf
        echo 'local.conf created in /etc/fonts' | tee -a results.txt
fi

# Outputs Linux version
echo "Platform: `cat /etc/system-release`" | tee -a results.txt
echo 'Success. Please see results.txt log for information'

exit 0