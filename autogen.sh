#!/bin/bash

escape() {
	escaped=`echo $1 | sed -e "s/ /\\ /g"`
	echo ${escaped}
}

if [ -e Remove ]; then
	echo "Initializing started."
	rm -rf Remove
	mkdir Remove
	echo "Initializing finished."
fi

if [ ! -e Data ]; then
	echo "Data directory does NOT exist in the current directory."
	exit
fi

cwd=`dirname ${0}`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

cd ${cwd}
find Install -name "*.zip" | while read InstallZip
do
	echo "Processing "${InstallZip}" ..."
	RemoveZip=`echo "Remove/"${InstallZip#*/}`
	cd ${cwd}
	cd Install
	unzip ${InstallZip#*/} > /dev/null
	find Data -type f | while read FileName
	do
		cd ${cwd}
		echo "-- Install/"${FileName}
		FileName=`escape ${FileName}`
		if [ -e ${FileName} ]; then
			FilePath="Remove/""${FileName}"
			mkdir -p "${FilePath%/*}"
			cp "${FileName}" "${FilePath}"
		fi
	done
	cd ${cwd}
	cd Install
	rm -rf Data
	cd ${cwd}
	cd Remove
	echo "Archiving ${InstallZip#*/}"
	zip -r ${InstallZip#*/} Data > /dev/null
	rm -rf Data
	cd ${cwd}
done
