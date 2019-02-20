#! /bin/bash

# bash cheat sheet

for i in {1..5}
do
   echo "Welcome $i times"
done

# test ints
if [[ $i = 5 ]]; then
	echo "it is 5"
fi

# test strings
today="Friday"
if [[ "$today" = "Friday" ]]; then
	echo "\"\$today\" = \"Friday\""
	echo "    yay, it's Friday"
fi

# test regex
if [[ $today =~ y$ ]]; then
	echo "\$today =~ y\$"
	echo "    only on days that end in y"
fi

echo "\$today =~ a\$"
if [[ $today =~ a$ ]]; then
	echo "    only on days that end in a"
else
	echo "    nope"
fi

# chmodx filename.sh +x
