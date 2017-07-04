#!/bin/bash
#
# Wrapper for nsc_jobs_ass.sh, running for each target found by regex
# Copyright (C) 2017  Robert Pilstål
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.
set -e;

# Number of settings options
NUMSETTINGS=4;
# If you require a target list, of minimum 1, otherwise NUMSETTINGS
let NUMREQUIRED=${NUMSETTINGS}+1;
# Start of list
let LISTSTART=${NUMSETTINGS}+1;

# I/O-check and help text
if [ $# -lt ${NUMREQUIRED} ]; then
  echo "USAGE: [NUMCORES=] [DEPTH=1] $0 <path> <regex> <jobname> <hours> \\";
  echo "                      [command and parameters]";
  echo "";
  echo " OPTIONS:";
  echo "  path    - Path in where to run regex";
  echo "  regex   - Regular expression for finding files (find, egrep)";
  echo "  jobname - Job type name";
  echo "  hours   - Number of hours to run (max 168, 1 week)";
  echo "";
  echo " ENVIRONMENT:";
  echo "  DEPTH    - find execution depth, default=1";
  echo "  NUMCORES - If \$NUMCORES is set (currently \"$NUMCORES\") the ";
  echo "             scripts will  be sent to cores (-n <num>) and not ";
  echo "             to nodes (-N)."
  echo "";
  echo " EXAMPLES:";
  echo "  # Run bogus_script.sh on all fasta files in current directory";
  echo "  ${0} ./ '.*\\.fasta' bogus 10 ./bogus_script.sh;"
  echo "";
  echo "nsc_jobs_ass_multi  Copyright (C) 2017  Robert Pilstål;"
  echo "This program comes with ABSOLUTELY NO WARRANTY.";
  echo "This is free software, and you are welcome to redistribute it";
  echo "under certain conditions; see supplied General Public License.";
  exit 0;
fi;

# Parse settings
path=$1
regex=$2;
jobname=$3;
hours=$4;
cmd=${@:$LISTSTART};

# Set default values
if [ -z ${DEPTH} ]; then
  DEPTH=1;
fi


# Loop over targets found 
num=1;
for target in `find ${path} -maxdepth ${DEPTH} -regextype egrep -regex ${regex}`; do
  nsc_jobs_ass.sh ${jobname} ${hours} ${num} 1 ${target} ${cmd} ${target};
  let num=num+1;
done;
