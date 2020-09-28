#! /bin/bash
# (c) M.Schiedermeier, Oct 2019
# This script does not work on Macos due to bash syntax changes introduced by apple for the iterator in for-loops. (Script coded for Ubuntu Linux)
# This script requires the git credentials to be set in ~/.netrc -> use syntax:
#> machine github.com
#> login kartoffelquadrat
#> password supersecretpasswordhere

function usage()
{
    echo "usage is: getreports.sh [YYYY-MM-DD]"
    exit -1
}

function extract()
{
	echo "Cloning team $i"

	git clone https://github.com/COMP361/f2020-hexanome-$1.git
	# proceed only of the repo clone was successful
	if [ -d "f2020-hexanome-$1" ]; then
		cd f2020-hexanome-$1
		# remove anything but the reports directory
		ls -a1 -I . -I .. | grep -v reports | xargs rm -rf
		# remove anything but the markdown reports (ignore target date for now, we filter for a specific date later)
		# if the requested report exists, save it by moving it to parent dir.
		if [ -f "reports/$DATE.md" ]; then
			mv reports/$DATE.md .
		fi
		if [ -d "reports" ]; then
			rm -rf reports
		fi
#		find . | cut -c 3- | grep -v *.md | grep -v 2019 | grep "/" | xargs rm -rf
		# remove everything that does not belong here and was not detected by the previous find
#		rm -rf reports/_*
		cd ..
	fi
}

# check if exaclty one param (date string) was provided
if [ $# -ge 2 ]; then
	usage
fi
if [ $# = 0 ]; then
	usage
fi
DATE=$1

# make a new target directory for all reports of the requested date
cd ~/COMP361
mkdir reports-$DATE
cd reports-$DATE

# get all reports for requested date
for i in $(seq -w 01 14); do extract $i; done

# list what has been extracted
cd ..
