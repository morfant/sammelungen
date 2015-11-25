(
~read = {
//timediv 10 is good with coin sound
var files, usingFile, pline, cline, file, freader, fsize, timediv = 50, datares = 0.001, fts, syn;

files = Array.newClear(5);
files = [
	"/Users/giy/Desktop/wesa/data/411_jindoVTS.txt",
	"/Users/giy/Desktop/wesa/data/416_haesubu3.txt",
	"/Users/giy/Desktop/wesa/data/416_jindoVTS.txt",
	"/Users/giy/Desktop/wesa/data/416_militryradar.txt",
	"/Users/giy/Desktop/wesa/data/416_recovered.txt"
];

usingFile = files[0]; //change file number 0 ~ 4
("######START File:" + usingFile + "######").postln;

fts = {arg time;
    var aa, bb, cc, dd;
    aa = (time).split($:).at(0).asInteger;
    bb = (time).split($:).at(1).asInteger;
    cc = (time).split($:).at(2).asInteger;
	dd = (aa*3600) + (bb*60) + cc;
};

pline = Array.newClear(5);
cline = Array.newClear(5);

//read file
file = File(usingFile, "r");
freader = FileReader.read(file);
fsize = freader.size;
file.close;

("List length: " + fsize).postln;

fork{
	1.do{
	(fsize - 1).do{|i|
        var ff, playtime, lng, lat, flng, flat;

		ff = File(usingFile, "r");
		pline = FileReader.read(ff)[i];
        ff.close;
		ff = File(usingFile, "r");
		cline = FileReader.read(ff)[i+1];
        ff.close;

		lng = cline[2];
		lat = cline[3];
		flng = lng.asFloat.round(datares);
		flat = lat.asFloat.round(datares);

		// flng

		flng = (flng - 120) * 1000;
		flng = flng - 5000;
				// flng = flng - 800;


		// flat
				flat = (flat - 34);
				// flat = flat/10;



		//get play time
        playtime = fts.value(cline[1]) - fts.value(pline[1]);
		(pline[1] ++ " - " ++ cline[1]).postln; //timecode
		("idx: " ++ i ++ " / " ++ "dur: " ++ playtime).postln;
		("flng: " ++ flng ++ " / " ++ "flat: " ++ flat).postln;

		1.do{|j|
					~freeverb.set(\mix, 0.3 + (i * (0.7/fsize)), \room, flat);
					syn = Synth(\filmPan, [\freq, flng, \pan, flat, \amp, rrand(0.5, 0.3), \out, 54]);

		};
		(playtime/timediv).wait;
	};
	("######END File:" + usingFile + "######").postln;
	};

}

};
);

~read.value;