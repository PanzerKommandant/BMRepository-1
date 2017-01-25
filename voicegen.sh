#!/bin/bash
cd Install
find . -name "sfx.voice_en.*" | while read file
do
	unzip $file
	mv Data/Sfx/ingame_voice_en.fsb Data/Sfx/ingame_voice_ru.fsb
	outfile=`echo $file | sed -e 's/voice_en/voice_ru/'`
	zip -r $outfile Data
	rm -rf Data
done
