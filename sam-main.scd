// Run sam-pattern.scd first.

(
var stom1, stom2, verbL, verbR, latoon, hafen, woonglong, coint, ende = 0;
var gate = Array.newFrom(Array[0,0,0,0,0,1,1,0,0,0]);
var syn = Array.newClear(10);


f = fork{
	1.do{

	if(gate[0] == 1,{
		"Seq 0 Start.".postln;
		4.do({
			~pat[1].play;
			2.wait;
			~pat[1].stop;
			latoon = Synth(\latooncarfian);
			2.wait;
			latoon.free;
		});
	});


	if(gate[1] == 1,{
		"Seq 1 Start.".postln;
		3.do({
			~pat[1].play;
			1.wait;
			hafen = Synth(\hafen);
			3.wait;
			~pat[1].stop;
			2.wait;
			hafen.free;
		});
	});


	if(gate[2] == 1,{
		"Seq 2 Start.".postln;
		4.do({
			~pat[1].play;
			2.wait;
			~pat[1].stop;
			hafen = Synth(\hafen, [\freqScale, 300]);
			latoon = Synth(\latooncarfian);
			2.wait;
			latoon.free;
			hafen.free;
		});
	});


	if(gate[3] == 1,{
		"Seq 3 Start.".postln;
		4.do({|i|
			woonglong = Synth(\woonglong);
			1.wait;
			hafen = Synth(\hafen, [\freqScale, 2000]);
			latoon =  Synth(\latooncarfian);
			0.5.wait;
			latoon.free;
			1.wait;
			latoon =  Synth(\latooncarfian);
			2.wait;
			latoon.free;
			0.3.wait;
			latoon =  Synth(\latooncarfian);
			hafen.set(\freqScale, 1700);
			3.wait;
			woonglong.release(3 - i);
			2.5.wait;
			latoon.free;
			0.5.wait;
			hafen.free;

		});
	});


	stom1 = Synth(\stom, [\inBus, 30, \outBus, 0]);
	stom2 = Synth(\stom, [\inBus, 32, \outBus, 1]);
	verbL = Synth(\verb, [\in, 20, \out, 30]);
	verbR = Synth(\verb, [\in, 21, \out, 32]);
	latoon = Synth(\latooncarfian, [\out, 20]);


	// >>
	if(gate[4] == 1,{
		"Seq 4 Start.".postln;
		20.do({|i|
			latoon.set(\chFreq1, 2 + (i*3));
			latoon.set(\chFreq2, 2 + (i*3));
			latoon.set(\amp, 0.3-(i*0.015));
			(4-(i*0.2)).wait;
			i.postln;
		});
	});

	~pat[1].play;
	10.wait;

	// <<
	if(gate[5] == 1,{
		"Seq 5 Start.".postln;
		20.do({|i|

			if (i == 6, {
				coint = Synth(\coint, [\bufnum, ~buf_1, \amp, 1.5, \rateNum, 2, \rateFreq, 1, \trigF, 1/8]);

			});

			if (i > 6, {coint.set(\amp, (0.5 + ((i-6) * 0.1) + ((i-6) + 0.01)));
				("amp: " + (0.5 + ((i-6) * 0.1) + ((i-6) + 0.01))).postln;
			});

			(case
				// { i == 5 } {coint.set(\rateFreq, 1); i.postln;}
				// { i == 6 } {coint.set(\rateFreq, 0.7)}
				{ i == 7 } {coint.set(\rateFreq, 1.1); "rateFreq set start.".postln;}
				{ i == 8 } {coint.set(\rateFreq, 1.7)}
				{ i == 9 } {coint.set(\rateFreq, 2.5)}
				{ i == 10 } {coint.set(\rateFreq, 4.2)}
				{ i == 11 } {coint.set(\rateFreq, 1)}
				{ i == 12 } {coint.set(\rateFreq, 0.7)}
				{ i == 13 } {coint.set(\rateFreq, 1.1)}
				{ i == 14 } {coint.set(\rateFreq, 1.7)}
				{ i == 15 } {coint.set(\rateFreq, 2.5)}
				{ i == 16 } {coint.set(\rateFreq, 4.2)}
				{ i == 17 } {coint.set(\rateFreq, 1)}
				{ i == 18 } {coint.set(\rateFreq, 0.7)}
				{ i == 19 } {coint.set(\rateFreq, 1.1)};
			);


			latoon.set(\chFreq1, 62 - (i*3));
			latoon.set(\chFreq2, 62 - (i*3));
			latoon.set(\amp, 0.01+(i*0.015));
			(1+(i*0.2)).wait;
			i.postln;
		});
	});


	if(gate[6] == 1,{
		"Seq 6 Start.".postln;
		1.do({|i|
				coint.set(\trigF, 1/40);
				~pat[2].play;

				latoon.free;

				~pat[0].stream = ~stream[0,4];
				~pat[0].play;
				40.wait;

		});
	});


};

"Das Ende.".postln;
};


//CmdPeriod.doOnce{~buf_1.free;};

)
