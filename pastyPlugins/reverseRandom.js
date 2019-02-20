exports.calledName = "";
exports.names=["reverseRandom"];

exports.parms=[
	{"name":"separator","value":null,"defaultValue":"\n"}
];

exports.helpText = "Randomly reorders the alphabet, and then sorts in reverse\r\n"+
	"Syntax: pasty reverseRandom\r\n"+
	"Example: echo abcd | pasty reverseRandom\r\n"+
	">> abcd";
exports.oneLiner = "Randomly reorders the alphabet, and then sorts in reverse";

var alpha = {};

exports.edit=function(input, switches){
	var sep = exports.parms[0].value;
	var sepRx = new RegExp(escapeRegex(sep),"gi");
	var items = input.split(sepRx);

	var origAlpha = "abcdefghijklmnopqrstuvwxyz";
	origAlpha.split("").forEach(function(x,i){
		alpha[x] = Math.random();
	});

	items.sort(reverseRand);
	//stick the random alphabet on the list so you can see how it worked.
	items.push(origAlpha.split("").sort(randoSort).join(""));
	
	return items.join(sep);
};

function reverseRand(a,b){
	return randoSort(b,a);
}

function randoSort(a,b){
	for(var i=0;i<a.length;i++){
		if(!b[i]) return -1;
		ach = a[i].toLowerCase();
		bch = b[i].toLowerCase();

		if(ach === bch){
			continue;
		}
		if(!alpha[ach] || !alpha[bch]){
			if(ach.charCodeAt(0) > bch.charCodeAt(0)){
				return 1;
			}
			return -1;
		}

		if(alpha[ach] > alpha[bch]) {return 1;}
		if(alpha[ach] < alpha[bch]) {return -1;}
	}
	return 0;
}

