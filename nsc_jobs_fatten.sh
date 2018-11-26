#!/bin/bash
#
# Fatten job files for slurmd job scheduler 
# Copyright (C) 2017-2018  Robert Pilstål
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
NUMSETTINGS=1;
# If you require a target list, of minimum 1, otherwise NUMSETTINGS
let NUMREQUIRED=${NUMSETTINGS}+1;
# Start of list
let LISTSTART=${NUMSETTINGS}+1;

# I/O-check and help text
if [ $# -lt ${NUMREQUIRED} ]; then
  echo "USAGE: $0 <memory> <target1> [<target2> [...]]";
  echo "";
  echo " OPTIONS:";
  echo "  memory - amount of memory to require";
  echo "  target - job-files to fatten";
  echo "";
  echo " EXAMPLES:";
  echo "  # Run on two files, with 360G of memory reservation (sigma)";
  echo "  $0 360G job_001.job job_002.job";
  echo "";
  echo "$(basename $0 .sh)  Copyright (C) 2017-2018  Robert Pilstål;"
  echo "This program comes with ABSOLUTELY NO WARRANTY.";
  echo "This is free software, and you are welcome to redistribute it";
  echo "under certain conditions; see supplied General Public License.";
  exit 0;
fi;

# Parse settings
memory=$1;
targetlist=${@:$LISTSTART};

tmpsuffix=`date +%s`

# Loop over arguments
for target in ${targetlist}; do
  echo ${target};
  grep -v '#SBATCH --mem' ${target} \
    | sed -e 's/\#!\/bin\/bash/\#!\/bin\/bash\n\#SBATCH --mem '${memory}'/' > ${target}.${tmpsuffix};
  mv ${target}.${tmpsuffix} ${target};
done;
