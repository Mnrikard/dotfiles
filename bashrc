# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

source ~/.git-prompt.sh
export PS1="\[\e]0;\w\a\]\n\[\e[32;1m\]\u@\h \[$MAGENTA\]\$(__git_ps1) \[\e[33;1m\]\w\[\e[0m\]\n$ "

source ~/.bash_git

if [ `uname -o` = "Cygwin" ]; then
	function gv {
		newpath=`cygpath -w $1`
		cygstart gvim $newpath
	}
fi


function gcomm {
	git commit $*
}

function gfetch {
	git fetch $*
}

function gstat {
	git status $*
}

function gpush {
	branch=`git rev-parse --abbrev-ref HEAD`
	git push origin $branch
}

function gpull {
	branch=`git rev-parse --abbrev-ref HEAD`
	git pull origin $branch
}

function browse {
	base=`git remote -v | grep \(fetch\)`
	base=${base/origin/}
	base=${base/\(fetch\)/}
	base=`echo $base | sed 's/:\(\w\)/\/\1/g' | sed 's/\.git//g' | sed 's/git@/https:\/\//g'`
	branch=`git rev-parse --abbrev-ref HEAD`

	url="$base/tree/$branch/"

	if [ `uname -o` = "Cygwin" ]; then
		cygstart $url
	fi
}

function title {
   PROMPT_COMMAND="echo -ne \"\033]0;$1\007\""
}

reset="\[\017\]"
normal="\[\033[0m\]"
red="\[\033[31;1m\]"
yellow="\[\033[33;1m\]"
white="\[\033[37;1m\]"
green="\[\033[1;32;40m\]"
smiley="${white}:)${normal}"
frowny="${red}:(${normal}"
select="if [ \$? = 0 ]; then echo \"${smiley}\"; else echo \"${frowny}\"; fi"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

export PS1="${reset}\n${green}\$(date +"%T.%3N")${normal} \`${select}\` ${yellow}\w \$(__git_ps1)\n\$${normal} "

