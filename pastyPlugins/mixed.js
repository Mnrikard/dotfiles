exports.calledName = "";
exports.names=["mixed"];
var os = require("os");

exports.parms=[];
exports.getParms = function(){
	return exports.parms;
};

exports.helpText = "mixed - Upper Cases The First Letter Of Each Word"+os.EOL+
	"Parameters: none"+os.EOL+
	"Syntax: pasty mixed"+os.EOL+os.EOL+
	"Example: echo abcd | pasty mixed"+os.EOL+
	">> Abcd";
exports.oneLiner = "Upper Cases The First Letter Of Each Word";

var _columnLengths = [];

function shouldBeLowerCase(word){
	var special = ["the","of","a","an", "for", "and", "nor", "but", "or", "from","on","in","to","with","without","at","by"];
	word = word.trim().toLowerCase();
	for(var i=0;i<special.length;i++){
		if(word === special[i]){
			return true;
		}
	}

	return false;

}

exports.edit=function(input, switches){
	if(exports.calledName.toLowerCase() === "mixed"){
		var output = [];
		var words = input.split(/(\b\w+\b)/g);
		words.forEach(function(word){
			if(word === word.toUpperCase()) {
				output.push(word);
			} else if (shouldBeLowerCase(word)) {
				output.push(word.toLowerCase());
			} else {
				output.push(word.substring(0,1).toUpperCase());
				output.push(word.substring(1,word.length));
			}
		});
		return output.join("");
	}
	return input;
};

