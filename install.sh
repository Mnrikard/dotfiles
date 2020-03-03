apt install vim zsh curl

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

function link() {
	src=$1
	dst=$2

	if [[ -f $dst ]]; then
		over=(read "$dst exists and is an actual file: overwrite? [Yn]")
		if [[ "$over" =~ "y" ]]; then
				
		fi
	fi
}

