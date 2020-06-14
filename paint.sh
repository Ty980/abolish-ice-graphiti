#!/usr/bin/env bash
while read line	 
do		
	IFS='/' read -ra PARAMS <<< "$line"
	D=${PARAMS[0]}
	M=${PARAMS[1]}
	Y=${PARAMS[2]}
	I=180
	d="$Y-$M-$D"
	if [ ! -d "$d" ]; then
	    mkdir -p $d
	fi	
	pushd $d
	for i in $( eval echo {1..$I} )
	do
		echo "$i on $d" > commit.md
		s=$(printf "%02d" $(expr $i % 60))
		m=$(printf "%02d" $(expr $i / 60))
		export GIT_COMMITTER_DATE="$d 12:$m:$s"
		export GIT_AUTHOR_DATE="$d 12:$m:$s"
		git add commit.md -f
		git commit --date="$d 12:$m:$s" -m "$i on $d" --no-gpg-sign
	done
        popd
done < dates.txt
git push origin master
git rm -rf 20**
git commit -am "cleanup" --no-gpg-sign
git push origin master
