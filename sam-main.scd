// Run sam-pattern.scd first.

(
var stom1, stom2, verbL, verbR, latoon, hafen, woonglong, coint, freeverb, ende = 0;
var gate = Array.newFrom(Array[0,0,0,0,0,1,1,1,1,1]);
var syn = Array.newClear(10);

// Length check
var bh, bm, bs, eh, em, es;
bh = Date.getDate.format("%I").asInteger;
bm = Date.getDate.format("%M").asInteger;
bs = Date.getDate.format("%S").asInteger;


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
	~pat[1].stream = ~stream[1, 1]; // fade out

	// <<
	if(gate[5] == 1,{
		"Seq 5 Start.".postln;
		20.do({|i|

			if (i == 6, {
				coint = Synth(\coint, [\bufnum, ~buf_1, \amp, 1.5, \rateNum, 2, \rateFreq, 1, \trigF, 1/8]);

			});

			if (i > 6, {coint.set(\amp, (0.5 + ((i-6) * 0.06) + ((i-6) + 0.01)));
				("amp: " + (0.5 + ((i-6) * 0.06) + ((i-6) + 0.01))).postln;
			});

				if (i == 7, {~pat[0].stop;});

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

		3.3.wait;

	if(gate[6] == 1,{
		"Seq 6 Start.".postln;
		1.do({|i|


				coint.set(\trigF, 1/40);

				1.7.wait;
				verbL.release(2);
				verbR.release(4);
				stom1.free;
				stom2.free;


				freeverb = Synth(\FreeVerb, [\outbus, 0, \inbus, 54], addAction:\addToTail);
				~pat[2].stream = ~stream[2,0];
				~pat[2].play;

				latoon.free;

				~pat[0].stream = ~stream[0,4];
				~pat[0].play;
				38.3.wait;
				coint.set(\trigF, 1/80);
				7.wait;

				~pat[2].stream = ~stream[2,1]; //Freq incresing
				23.wait;
				~pat[2].stream = ~stream[2,2]; //Freq fix
				freeverb.set(\mix, 0.3 + rrand(0.1, -0.1), \room, 0.8 + rrand(0.1, -0.1));
				10.wait;
		});
	});


	if(gate[7] == 1,{
			var ampval = 15;
		"Seq 7 Start.".postln;
		20.do({|i|
				ampval = ampval - 0.5;

				i.postln;
				("ampval: " ++ ampval).postln;


				if (i >= 1, {coint.set(\amp, ampval) });

				if (i == 3, {~pat[0].stream = ~stream[0,5];}); // amp fadeout

				if (i == 19, {
					coint.release(4);
					~pat[2].stream = ~stream[2,3];
				});

		});
	});


	if(gate[8] == 1,{
		"Seq 8 Start.".postln;
		1.do({|i|
				9.wait;
				~pat[2].stream = ~stream[2,4];
				40.wait;
				~pat[2].stream = ~stream[2,5];
				30.wait;
		});
	});


	if(gate[9] == 1,{
		"Seq 9 Start.".postln;
		1.do({|i|
				coinend = Synth(\coinend, [\out, 0, \bufnum, ~buf_1]);
				7.wait;
				coinend.release(1);
		});
	});


		3.wait;
		~pat[2].stop;

};

"Das Ende.".postln;

// Length check
eh = Date.getDate.format("%I").asInteger;
em = Date.getDate.format("%M").asInteger;
es = Date.getDate.format("%S").asInteger;

("Length - "++(eh - bh)++":"++(em - bm)++":"++(es - bs)).postln;


};


//CmdPeriod.doOnce{~buf_1.free;};

)
