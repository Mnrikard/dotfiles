#! /bin/bash

filename=$1;

function browse-url() {
	url=$1
	if [[ "$(uname -o)" = "Cygwin" ]]; then
		cygstart "$url";
	else
		if [[ "$(type cmd.exe)" = "cmd.exe not found" ]]; then
			if [[ "$(type explorer.exe)" = "explorer.exe not found" ]]; then
				sensible-browser "$url";
			else
				explorer.exe "$url";
			fi
		else
			cmd.exe /c start "$url";
		fi
	fi
};

pandoc --standalone --highlight-style=haddock --to=html5 --from=markdown --metadata pagetitle=copy --output=mdToHtml.html $filename;

browse-url "mdToHtml.html"

sleep 2s

rm -f "mdToHtml.html"
