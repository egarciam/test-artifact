#!/bin/bash
# Argument = -h -v -i groupId:artifactId:version -c classifier -p packaging -r repository

#shopt -o -s xtrace

# Define Nexus Configuration
NEXUS_BASE=http://gcs-tools.tk:8081/nexus
REST_PATH=/service/local
ART_REDIR=/artifact/maven/redirect

usage()
{
cat <<EOF
usage: $0 options
This script will fetch an artifact from a Nexus server using the Nexus REST redirect service.
OPTIONS:
   -h      Show this message
   -v      Verbose
   -i      GAV coordinate groupId:artifactId:version
   -c      Artifact Classifier
   -p      Artifact Packaging
EOF
}

# Read in Complete Set of Coordinates from the Command Line
GROUP_ID=
ARTIFACT_ID=
VERSION=
CLASSIFIER=""
PACKAGING=war
REPO=
VERBOSE=0

while getopts "hvi:c:p:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         i)
	     OIFS=$IFS
             IFS=":"
	     GAV_COORD=( $OPTARG )
	     GROUP_ID=${GAV_COORD[0]}
             ARTIFACT_ID=${GAV_COORD[1]}
             VERSION=${GAV_COORD[2]}	     
	     IFS=$OIFS
             ;;
         c)
             CLASSIFIER=$OPTARG
             ;;
         p)
             PACKAGING=$OPTARG
             ;;
         v)
             VERBOSE=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $GROUP_ID ]] || [[ -z $ARTIFACT_ID ]] || [[ -z $VERSION ]]
then
     echo "BAD ARGUMENTS: Either groupId, artifactId, or version was not supplied" >&2
     usage
     exit 1
fi

# Define default values for optional components

# If the version requested is a SNAPSHOT use snapshots, otherwise use releases
if [[ "$VERSION" =~ ".*SNAPSHOT" ]]
then
    : ${REPO:="snapshots"}
else
    : ${REPO:="releases"}
fi

# Construct the base URL
REDIRECT_URL=${NEXUS_BASE}${REST_PATH}${ART_REDIR}

# Generate the list of parameters
PARAM_KEYS=( g a v r p c )
PARAM_VALUES=( $GROUP_ID $ARTIFACT_ID $VERSION $REPO $PACKAGING $CLASSIFIER )
PARAMS=""
for index in ${!PARAM_KEYS[*]} 
do
  if [[ ${PARAM_VALUES[$index]} != "" ]]
  then
    PARAMS="${PARAMS}${PARAM_KEYS[$index]}=${PARAM_VALUES[$index]}&"
  fi
done

REDIRECT_URL="${REDIRECT_URL}?${PARAMS}"

echo "Fetching Artifact from $REDIRECT_URL..." >&2
curl -sS -L ${REDIRECT_URL}
