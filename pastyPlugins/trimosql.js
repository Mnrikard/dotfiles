exports.calledName = "";
exports.names=["trimosql"];

exports.parms=[];

exports.helpText = "trimosql - trims each column output of osql\r\n"+
	"Syntax: pasty trimosql\r\n";
exports.oneLiner = "trims each column output of osql for brevity";

var dash = /^[\- ]+$/;

function defineCols(lines){
	var i,h,c,collens,cname,cstart,output=[];
	for(i=0;i<lines.length;i++){
		if(dash.IsMatch(lines[i])){
			collens = lines[i].split(/ /g);
			cstart = 0;
			for(c=0;c<collens.length;c++){
				if(c===0 && collens[c].trim()===""){
					cstart += collens[c].length+1;
					continue;
				}
				output.push({"start":cstart, "len":collens[c].length,"maxlength":0});
				//console.log("column[",(output.length-1),"](",cstart,",",collens[c].length,")");
				cstart += collens[c].length+1;
			}
			return output;
		}
	}
	return output;
}

function max(a,b){
	if(a > b){return a;}
	return b;
}

RegExp.prototype.IsMatch = function(teststr){
	this.lastIndex = 0;
	return this.test(teststr);
};

function getAlignedValue(val, maxlen){
	var output = val.trim().substr(0,maxlen);
	if(output.length < maxlen){
		for(var i=output.length;i<maxlen;i++){
			output += " ";
		}
	}
	return output;
}

exports.edit=function(input, switches){
	var lines=input.split(/\r*\n/g);
	var cols = defineCols(lines);
	var output = [];
	var ignore = /^(Connection: T\(SQLSRV\)|\(\d rows? affected\))/;
	lines.forEach(function(line){
		if(!ignore.IsMatch(line) && !dash.IsMatch(line)){
			for(var c=0;c<cols.length;c++){
				var val = line.substr(cols[c].start, cols[c].len+1).trim();
				cols[c].maxlength = max(cols[c].maxlength, val.length);
			}
		}
	});

	//var cli=0;
	//cols.forEach(function(cl){
	//	console.log("column[",cli++,"](",cl.start,",",cl.len,",",cl.maxlength,")");
	//});

	lines.forEach(function(line){
		if(ignore.IsMatch(line)){
			output.push(line);
		}else{
			var tline = [];
			cols.forEach(function(col){
				tline.push(getAlignedValue(line.substr(col.start,col.len), col.maxlength+1));
			});
			output.push(tline.join(" "));
		}
	});

	return output.join("\n");
};

