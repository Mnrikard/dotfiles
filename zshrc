
alias gadd="git add -A"
alias -g gcomm="git commit"
alias gfetch="git fetch -p"
alias gstat="git status"
alias gsql="git rm ChangeScripts/*/*/*.sql"

function gpush {
	branch=`git rev-parse --abbrev-ref HEAD`
	git push origin $branch
}

function gpull {
	branch=`git rev-parse --abbrev-ref HEAD`
	git pull origin $branch --rebase
}

function browse {
	base=`git remote -v | grep \(fetch\)`
	base=${base/origin/}
	base=${base/\(fetch\)/}
	base=`echo $base | sed 's/:\(\w\)/\/\1/g' | sed 's/\.git//g' | sed 's/git@/https:\/\//g' | xargs`
	branch=`git rev-parse --abbrev-ref HEAD`

	url="$base/tree/$branch/"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# bindkey -v
alias ...="cd ../.."
