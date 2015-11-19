
(
var patNum = 10, strNum = 10;

// EventStreamPlayer
~pat = Array.newClear(patNum);
~stream = Array2D.new(10, 10);

patNum.do{|i| ~pat[i] = Pbind().play;~pat[i].stop; };
patNum.do{|i| (strNum).do{|j| ~stream[i,j] = Routine.new({});}};


//Patterns for Synth "lfp" : ~stream[0,n]
~stream[0,0] = Pbind(
	\instrument, \lfp,
    \dur, 0.1,
	\a, Prand((0.1, 0.2..3.0), inf),
	\b, Prand((0.1, 0.2..3.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Prand((0.1, 0.2..3.0), inf),
	\bb, Prand((0.1, 0.2..3.0), inf),
	\cc, Prand((0.1, 0.2..3.0), inf),
	\dd, Prand((0.1, 0.2..3.0), inf)

).asStream;


~stream[0,1] = Pbind(
	\instrument, \lfp,
    \dur, 0.5,
	\a, Prand((0.1, 0.2..3.0), inf),
	\b, Prand((0.1, 0.2..3.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\bb, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\cc, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\dd, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
    \amp, 0.1
).asStream;


~stream[0,2] = Pbind(
	\instrument, \lfp,
    \dur, 1.0,
	\a, Prand((0.1, 0.2..3.0), inf),
	\b, Prand((0.1, 0.2..3.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\bb, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\cc, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\dd, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\atTime, Pseq((0.01, 0.02 .. 2.0), inf),
    \amp, 0.1
).asStream;


~stream[0,3] = Pbind(
	\instrument, \lfp,
    \dur, 0.1,
	\a, Prand((0.1, 0.2..3.0), inf),
	\b, Prand((0.1, 0.2..3.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\bb, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\cc, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\dd, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\atTime, Pseq((0.01, 0.02 .. 2.0), inf),
    \amp, 0.1
).asStream;

~stream[0,4] = Pbind(
	\instrument, \lfp,
	\dur, 0.2,
	\a, Prand((0.1, 0.2..1.0), inf),
	\b, Prand((0.1, 0.2..1.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\bb, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\cc, Pbeta(0.1, 1.0, 0.2, 0.2, inf),
	\dd, Pbeta(0.1, 1.0, 0.2, 0.2, inf),
	\atTime, Pbeta(0.05, 0.2, 3, 0.1, inf),
    \amp, 0.2
).asStream;

~stream[0,5] = Pbind(
	\instrument, \lfp,
	\dur, 0.2,
	\a, Prand((0.1, 0.2..1.0), inf),
	\b, Prand((0.1, 0.2..1.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\bb, Pbeta(0.1, 3.0, 0.2, 0.2, inf),
	\cc, Pbeta(0.1, 1.0, 0.2, 0.2, inf),
	\dd, Pbeta(0.1, 1.0, 0.2, 0.2, inf),
	\atTime, Pbeta(0.05, 0.2, 3, 0.1, inf),
	\amp,
	Pn(Prand((0.1, 0.11.. 0.15), 10), Prand((0.1, 0.11.. 0.15)-0.05, 10), Prand((0.1, 0.11.. 0.15)-0.09, 10), inf)
).asStream;

//Patterns for Synth "dirac" : ~stream[1,n]
~stream[1,0] = Pbind(
		\instrument,		\dirac,
		\dur,	Pwhite(0.01, 0.2, inf),
		\decay,	Prand((1..4)*0.01, inf),
		\freq,	Pbeta(500, 5000, 0.2, 0.3),
		\amp,	Pbeta(0.05, 0.1, 0.2, 0.2),
//		\pos,	Pbeta(0, 2, 0.2, 0.2) //주로 앞에서 나다가 가끔씩 뒤에서 나는 효과
	\pos,	Prand([-1, 1], inf) //100개의 이벤트 만에 한바퀴를 도는 panning
).asStream;


~stream[1,1] = Pbind(
		\instrument,		\dirac,
		\dur,	Pwhite(0.01, 0.2, inf),
		\decay,	Prand((1..4)*0.01, inf),
		\freq,	Pbeta(500, 5000, 0.2, 0.3),
	\amp,	Pseq((0.2, 0.19..0.0), 21),
//		\pos,	Pbeta(0, 2, 0.2, 0.2) //주로 앞에서 나다가 가끔씩 뒤에서 나는 효과
	\pos,	Prand([-1, 1], inf) //100개의 이벤트 만에 한바퀴를 도는 panning
).asStream;


//Patterns for Synth "film" : ~stream[2,n](
~stream[2,0] = Pbind(\instrument, \film,
	\dur, Prand((1,2..4)/5, inf),
	\freq, 1,
	\amp, 0.5,
	\out, 54
).asStream;


~stream[2,1] = Pbind(\instrument, \film,
	\dur,
	Pn(Pseq([Prand((1,2..4)/5, 2), Prand((1,2..4)/10, 1), Prand((1,2..4)/12, 1)], inf)),
	\freq, Pseq((10, 17.. 800), 113),
	\amp, 0.3,
	\level, Prand([0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\relTime, Prand((0.08, 0.09 .. 0.5), inf),
	\out, 54
).asStream;


~stream[2,2] = Pbind(\instrument, \film,
	\dur,
	Pn(Pseq([Prand((1,2..4)/5, 2), Prand((1,2..4)/10, 1), Prand((1,2..4)/12, 1)], inf)),
	\freq, 800 + rrand(3.0, -3.0),
	\amp, 0.3,
	\level, Prand([0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\relTime, Prand((0.08, 0.09 .. 0.5), inf),
	\out, 54
).asStream;


~stream[2,3] = Pbind(\instrument, \film, //amp increse little
	\dur,
	Pn(Pseq([Prand((1,2..4)/5, 2), Prand((1,2..4)/10, 1), Prand((1,2..4)/12, 1)], inf)),
	\freq, 800 + rrand(3.0, -3.0),
	\amp, 0.4 + rrand(0.1, -0.05),
	\level, Prand([0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\relTime, Prand((0.08, 0.09 .. 0.5), inf),
	\out, 54
).asStream;


~stream[2,4] = Pbind(\instrument, \film,
	\dur,
	Pn(Pseq([Prand((1,2..4)/3, 2), Prand((1,2..4)/7, 1), Prand((1,2..4)/4, 1)], inf)),
	\freq, 800 + rrand(10.0, -30.0),
	\amp, 0.4 + rrand(0.1, -0.05),
	\level, Prand([0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\relTime, Prand((0.08, 0.09 .. 0.5)+0.08, inf),
	\out, 54
).asStream;

~stream[2,5] = Pbind(\instrument, \film,
	\dur,
	Pseq([

	Pn(
		Pseq([Prand((1,2..4)/3, 2), Prand((1,2..4)/7, 1), Prand((1,2..4)/4, 1),
		Prand((1,2..4)/3, 1), Prand((1,2..4)/5, 1), Prand((1,2..4)/5, 1),
		Prand((1,2..4)/2, 1), Prand((1,2..4)/3, 1), Prand((1,2..4)/3, 1),], 50)
	),
	Pn(
		Pseq([Prand((1,2..4)/3, 2), Prand((1,2..4)/7, 1), Prand((1,2..4)/4, 1),
		Prand((1,2..4)/3, 1), Prand((1,2..4)/3, 1), Prand((1,2..4)/4, 1),
		Prand((1,2..4)/2, 1), Prand((1,2..4)/3, 1), Prand((1,2..4)/3, 1),], 50)
	),
	Pn(
		Pseq([Prand((1,2..4)/3, 2), Prand((1,2..4)/3, 1), Prand((1,2..4)/4, 1),
		Prand((1,2..4)/3, 1), Prand((1,2..4)/2, 1), Prand((1,2..4)/2, 1),
		Prand((1,2..4)/2, 1), Prand((1,2..4)/2, 1), Prand((1,2..4)/1, 1),], 200)
	),

	], 2),
	\freq, 800 + rrand(50.0, -30.0),
	\amp, Pseq((0.4, 0.41..0.8), inf) + rrand(0.1, -0.05),
	\level, Prand([0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\relTime, Prand((0.08, 0.09 .. 0.5)+0.08, inf),
	\out, 54
).asStream;

// Set pattern to EventStreamPlayer

patNum.do{|i| ~pat[i].stream = ~stream[i,0];};


);

