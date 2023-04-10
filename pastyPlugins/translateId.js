
exports.calledName = "";
exports.names=["translateId"];

exports.parms=[
	{"name":"Column Separator","value":null,"defaultValue":"\t"},
	{"name":"Row Separator","value":null,"defaultValue":"\n"}
];

exports.helpText = "translateId - converts OriginalId,SiteId to TranslatedId and appends\n\n"+
	"Copy text containing 2 UUID's per \"row\" and it will treat the first UUID as an OriginalId and the second one\n"+
	"as a SiteId.\n"+
	"it will translate the OriginalId through the SiteId and append the translated ID at the end of the \"row\"\n\n"+
	"Syntax: pasty translateId [column Separator={tab}] [row Separator={new line}]\n\n"+
    "Example:\n\n"+
	">> echo \"D8284548-D026-43F5-BB07-01EB082C2A49,204FC093-F644-4434-BD5A-357162C0532F\" > inputfile.txt\n"+
    ">> echo \"8731A086-FE6F-4731-A977-02187C20C4F1,204FC093-F644-4434-BD5A-357162C0532F\" >> inputfile.txt\n>> \n"+
	">> cat inputfile.txt | pasty translateId ',' '\\n'\n"+
	">> D8284548-D026-43F5-BB07-01EB082C2A49,204FC093-F644-4434-BD5A-357162C0532F,f86785db-2662-47c1-865d-349a6aec7966\n"+
    ">> 8731A086-FE6F-4731-A977-02187C20C4F1,204FC093-F644-4434-BD5A-357162C0532F,a77e6015-082b-4305-942d-37691ee097de";
exports.oneLiner = "translateId - converts OriginalId,SiteId to TranslatedId and appends";

const mapIdToArray = function (id) {
	return new Uint8Array(id.match(/[\da-f]{2}/gi)
		.map(function (h) {
			return parseInt(h, 16);
		}));
}

const mapArrayToId = function (a) {
	let hex = a.reduce(function (h, i) {
		return h + ('0' + i.toString(16)).slice(-2);
	}, '');

	let hexIndex = 0;
	return 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'.replace(/[x]/g, function () {
		return hex.charAt(hexIndex++);
	});
}

const translateId = function(originalId, siteId) {
	let siteIdArray = mapIdToArray(siteId);
	let origIdArray = mapIdToArray(originalId);
	let newIdArray = new Uint8Array(16);
	for (let i = 0; i < newIdArray.length; i++) {
		newIdArray[i] = origIdArray[i] ^ siteIdArray[i];
	}

	newIdArray[6] = (newIdArray[6] & 0x0f) | 0x40;
	newIdArray[8] = (newIdArray[8] & 0x3f) | 0x80;

	return mapArrayToId(newIdArray);
}

exports.edit=function(input, switches){
	let cs = exports.parms[0].value;
	let rs = exports.parms[1].value;
	let rowSeparator = new RegExp(rs);
	let colSeparator = new RegExp(cs);
	let rows = input.split(rowSeparator);
	let output = [];
	rows.forEach(function(row, r) {
		let cols = row.split(colSeparator);
		if (cols.length >= 2) {
			output[r] = cols[0] + cs + cols[1] + cs + translateId(cols[0], cols[1]);
		}
	});

	return output.join(rs);
};

