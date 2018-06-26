
alias gadd="git add -A"
alias -g gcomm="git commit"
alias gfetch="git fetch -p"
alias gstat="git status"
alias gsql="git rm ChangeScripts/*/*/*.sql"
alias githere="git --no-pager"

function gpush {
	branch=`git rev-parse --abbrev-ref HEAD`
	git push origin $branch
	if [[ `git remote show` =~ github ]]; then;
		git push github $branch
	fi;
}

function gpull {
	branch=`git rev-parse --abbrev-ref HEAD`
	git pull origin $branch --rebase
}


vstsTeam="gis-stratus"
function browse {
	base=`git remote -v | grep \(push\) | grep "origin" | sed -e 's/origin[ \t]*//g' -e 's/[ \t]*(push)//g'`
	branch=`git rev-parse --abbrev-ref HEAD`
	url=""

	if [[ $base =~ github ]]; then
		base=`echo $base | sed -e 's/:\(\w\)/\/\1/g' -e 's/\.git//g' -e 's/git@/https:\/\//g' | xargs`
		url="$base/tree/$branch/"
	fi

	if [[ $base =~ visualstudio\.com ]]; then
		url=`echo $base | gawk -F"/" '{print "visualstudio.com/"$4"/_git/"$6"?version=GB";}'`
		url="https://$vstsTeam.$url$branch"
	fi

	echo $url

	if [ `uname -o` = "Cygwin" ]; then
		cygstart $url
	fi
}

function sslToggle {
	onoff=`git config --global http.sslVerify`
	if [ "$onoff" = "false" ]; then
		onoff="true"
	else
		onoff="false"
	fi

	npm config -g set strict-ssl $onoff
	git config --global http.sslVerify $onoff
	security="secure"
	if [ "$onoff" = "false" ]; then
		security="INSECURE"
	fi
	echo "SSL verification is $security"
}

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="matthewrikard"

BULLETTRAIN_STATUS_SHOW=true
BULLETTRAIN_TIME_SHOW=true
BULLETTRAIN_VIRTUALENV_SHOW=false
BULLETTRAIN_RUBY_SHOW=false
VIRTUAL_ENV_DISABLE_PROMPT=false

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# bindkey -v
alias ...="cd ../.."
