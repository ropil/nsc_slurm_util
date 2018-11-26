#!/bin/bash
#
# Simple example runscript for running in a slurm system
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
NUMSETTINGS=0;
# If you require a target list, of minimum 1, otherwise NUMSETTINGS
let NUMREQUIRED=${NUMSETTINGS}+1;
# Start of list
let LISTSTART=${NUMSETTINGS}+1;

# I/O-check and help text
if [ $# -lt ${NUMREQUIRED} ]; then
  echo "USAGE: [EXECUTABLE=] [OPTIONS=] [WORKDIR=\`pwd\`] \\";
  echo "       [NAME=] [OUTPUT=] $0 <target>";
  echo "";
  echo " OPTIONS:";
  echo "  target - File target";
  echo "";
  echo " ENVIRONMENT:";
  echo "  EXECUTABLE - Absolute path of executable";
  echo "  OPTIONS    - Analysis specific executable options";
  echo "  WORKDIR    - Absolute path to directory of output,";
  echo "               default=`pwd`";
  echo "  NAME       - Name of target, defaut=basename of target";
  echo "  OUTPUT     - Relative path of output, default=\$\{NAME\}.out";
  echo "";
  echo " EXAMPLES:";
  echo "  # Run on a target file";
  echo "  $0 file > output.txt";
  echo "";
  echo "nsc_example_runscript  Copyright (C) 2017  Robert Pilstål;"
  echo "This program comes with ABSOLUTELY NO WARRANTY.";
  echo "This is free software, and you are welcome to redistribute it";
  echo "under certain conditions; see supplied General Public License.";
  exit 0;
fi;

# Parse arguments
target=`readlink -f $1`;

# Set default values
if [ -z ${EXECUTABLE} ]; then
  # Absolute path to executable
  EXECUTABLE="<EXECUTABLE>";
fi
if [ -z ${OPTIONS} ]; then
  # Executable options
  OPTIONS="<OPTIONS>";
fi
if [ -z ${WORKDIR} ]; then
  # Where to save output
  WORKDIR="`pwd`";
fi
if [ -z ${NAME} ]; then
  # Target name
  NAME=`basename ${target}`;
fi
if [ -z ${OUTPUT} ]; then
  # Relative path of output file
  OUTPUT=${NAME}.out;
fi

# Move to temporary working directory
mkdir -p ${SNIC_TMP}/${NAME};
cd ${SNIC_TMP}/${NAME};

# Run analysis
${EXECUTABLE} ${OPTIONS} ${target} > ${OUTPUT};

# Copy results
cp ${OUTPUT} ${WORKDIR};
