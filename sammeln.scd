(
// Synthdef 1
SynthDef("latooncarfian", { arg out = 0, freq = 440, chFreq1 = 2, chFreq2 = 2,
	a = 1, b = 3, c = 0.5, d = 0.5, gate = 1, amp = 0.3;
    var s1, s2, env;
        s1 = LatoocarfianN.ar(
    SampleRate.ir/4,
    LFNoise2.kr(chFreq1,1.5,1.5),
    LFNoise2.kr(chFreq1,1.5,1.5),
    LFNoise2.kr(chFreq1,0.5,1.5),
    LFNoise2.kr(chFreq1,0.5,1.5), mul: 0.1
);

        s2 = LatoocarfianN.ar(
    SampleRate.ir/4,
    LFNoise2.kr(chFreq2,1.5,1.5),
    LFNoise2.kr(chFreq2,1.5,1.5),
    LFNoise2.kr(chFreq2,0.5,1.5),
    LFNoise2.kr(chFreq2,0.5,1.5), mul: 0.1
);

Out.ar(out, [s1, s2] * amp);

}).add;


// Synthdef 2
SynthDef(
    \hafen,
    {
        arg freqScale = 200, amp = 0.1, gate = 1, inNum = 0;
        var sig, env, envgen, inputs, n = 32;
        inputs = [PinkNoise.ar(0.3), WhiteNoise.ar(0.1), ClipNoise.ar(0.1), BrownNoise.ar(0.2)];
        sig = DynKlank.ar(`[ (1..13)*freqScale, 1/(1..13), nil ],
            Select.ar(inNum, inputs));
        env = Env(
		[0]++{0.8.rand.squared}.dup(n-1) ++ [0],
				{rrand(0.1,0.3)}.dup(n),
				\lin, n-8, 8 );
        envgen = EnvGen.kr(env, gate, doneAction: 2);
        Out.ar(0, Pan2.ar(sig * envgen, 0, amp));
    }
).add;


// Synthdef 3
SynthDef("lfp", { arg out = 100, freq = 440, chFreq1 = 2, chFreq2 = 2,
	a = 1, b = 3, c = 0.5, d = 0.5,
	aa = 1, bb = 3, cc = 0.5, dd = 0.5,
	gate = 1, amp = 0.1;
    var s1, s2, env;
    env = EnvGen.kr(Env.perc(0.15, 0.05), gate, doneAction: 2);
    s1 = LatoocarfianN.ar(SampleRate.ir/4, a, b, c, d, mul: 0.1);
    s2 = LatoocarfianN.ar(SampleRate.ir/4, aa, bb, cc, dd, mul: 0.1);

Out.ar(out, [s1, s2]*env*amp);

}).add;


// Synthdef 4 - Reverb
SynthDef(\verb,
    {
        arg in = 0, room = 2, rtime = 1, dam = 0.3, sp = 5, tail = 0.2;
        var sig, fil;
        sig = In.ar(in, 1);
        fil = GVerb.ar(sig, room = 2, rtime, dam, 0.5, sp, taillevel: tail);
        Out.ar(0, fil);

}).add;


// Synthdef 5
SynthDef(\woong,
    {
        arg cutoff = 202, rq = 1.0, sn = 8;
        var sig, fil, lfo;

        lfo = LFClipNoise.kr(sn, mul: 0.5, add: 0.5);
        sig = Saw.ar([50, 75], lfo);
        fil = RLPF.ar(sig, cutoff, rq);
        Out.ar(0, fil);
    }
).add;


// Synthdef 6
SynthDef(\woonglong,
    {
        arg cutoff = 202, rq = 1.0, sn = 8, gate = 1, amp = 0.6;
        var sig, fil, lfo, env;

        env = EnvGen.kr(Env.asr(1.3, 1, 3), gate, doneAction: 2);
        sig = Saw.ar([50, 75], 1);
        fil = RLPF.ar(sig, cutoff, rq);
        Out.ar(0, fil * env * amp);
    }
).add;


// Synthdef 7
SynthDef(\dirac, {| out, amp = 0.03, freq = 100, decay = 0.01, pos = -1 |
		var i = Impulse.ar(0), sig;
//		sig = Mix.fill(6, {Ringz.ar(i, Rand(freq, freq*[1.5, 2]), decay)});
		sig = Mix.fill(6, {Ringz.ar(i, Rand(freq, freq*1.5), decay)});
		DetectSilence.ar(sig, doneAction: 2);
		sig = Pan2.ar(sig, pos, amp);
		Out.ar(out, sig);
	}).add;


// Synthdef 8
SynthDef("help-TCoin", { arg out=0, prob=0.5;
	var trig;
	trig = Impulse.ar(20, 0, SinOsc.kr(0.5,0,1,1));
	Out.ar(out,
		Mix.fill(3, {Ringz.ar(CoinGate.ar(prob, trig*0.5), #[1,1.5]*Rand(5000, 9000), 0.01)})*0.2
	)
}).add;

) //Synthdef END


(//Pattern for synth \lfp
p = Pbind(
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

).play;
)


(
p.stream = Pbind(
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
    \amp, 0.1
).asStream;
)


asStream



a = Synth(\latooncarfian);

a.set(\chFreq1, 5, \chFreq2, 3);


// randomly modulate all params
(
t = { LatoocarfianC.ar(
    SampleRate.ir/4,
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,0.5,1.5),
    LFNoise2.kr(2,0.5,1.5)
) * 0.2 }.play(s);
)

t.play;
t.free;



{ Logistic.ar(MouseX.kr(3, 3.99), MouseY.kr(10, 10000, 'exponential'), 0.25, 0.5) }.play


(
{
var signal, filter, cutoff, resonance;

signal = Saw.ar([50, 75], 0.7);
cutoff = MouseX.kr(40,1000,1).poll;
resonance =  MouseY.kr(0.01, 2.0).poll; // resonance가 0.01에 가까울수록 cutoff주파수에 해당하는 주파수를 가진 하나의 연속되는 소리가 들림.

RLPF.ar(signal, cutoff, resonance)}.play;
//BPF.ar(signal, cutoff, resonance)}.freqscope
)


(

c = Synth(\woonglong)
c.release(3);
c.set(\gate, 0)
b = Synth(\woong)
b.set(\sn, 8)
b.set(\rq, 1.02)
b.set(\curoff, 200)
b.free;

a.free;
(

)


(//Pattern for \dirac
p = Pbind(
		\instrument,		\dirac,
		\dur,	Pwhite(0.01, 0.2, inf),
		\decay,	Prand((1..4)*0.01, inf),
		\freq,	Pbeta(500, 5000, 0.2, 0.3),
		\amp,	Pbeta(0.05, 0.1, 0.2, 0.2),
//		\pos,	Pbeta(0, 2, 0.2, 0.2) //주로 앞에서 나다가 가끔씩 뒤에서 나는 효과
	\pos,	Prand([-1, 1], inf) //100개의 이벤트 만에 한바퀴를 도는 panning
).play;
)
t.play;
a.play;
p.stop;


(
f = fork{
    4.do({
        p.play;
        2.wait;
        p.stop;
        a = Synth(\latooncarfian);
        2.wait;
        a.free;
    });

    3.do({
        p.play;
        1.wait;
        b = Synth(\hafen);
        3.wait;
        p.stop;
        2.wait;
        b.free;
    });

    4.do({
        p.play;
        2.wait;
        p.stop;
        b = Synth(\hafen, [\freqScale, 300]);
        a = Synth(\latooncarfian);
        2.wait;
        a.free;
        b.free;
    });

    4.do({|i|
        c = Synth(\woonglong);
        1.wait;
        b = Synth(\hafen, [\freqScale, 2000]);
        a = Synth(\latooncarfian);
        0.5.wait;
        a.free;
        1.wait;
        a = Synth(\latooncarfian);
        2.wait;
        a.free;
        0.3.wait;
        a = Synth(\latooncarfian);
        b.set(\freqScale, 1700);
        3.wait;
        c.release(3 - i);
        2.5.wait;
        b.free;
        0.5.wait;
        a.free;

    });

		d = Synth(\verb, [\in, 100]);
		a = Synth(\latooncarfian, [\out, 100]);

	// >>
	20.do({|i|
		a.set(\chFreq1, 2 + (i*3));
		a.set(\chFreq2, 2 + (i*3));
		a.set(\amp, 0.3-(i*0.015));
		(4-(i*0.2)).wait;
		i.postln;
    });

	p.play;
	10.wait;

	// <<
	20.do({|i|
		a.set(\chFreq1, 62 - (i*3));
		a.set(\chFreq2, 62 - (i*3));
		a.set(\amp, 0.01+(i*0.015));
		(1+(i*0.2)).wait;
		i.postln;
    });

}
)


(3.rand)-1;

(
fork{


}
)

f.beats;
f.seconds;
f.clock;
f.run;
f.next;
f.stop;
f.resume;
f.reset;
f.value;





Routine






(
p.stream = Pbind(
		\instrument,		\dirac,
		\dur,	Pwhite(0.15, 0.3, inf),
		\decay,	Prand((1..4)*0.01, inf),
		\freq,	Pbeta(3500, 5000, 0.2, 0.3),
		\amp,	Pbeta(0.05, 0.1, 0.2, 0.2),
//		\pos,	Pbeta(0, 2, 0.2, 0.2) //주로 앞에서 나다가 가끔씩 뒤에서 나는 효과
		\pos,	Pseq((0..100)*0.02, inf) //100개의 이벤트 만에 한바퀴를 도는 panning
).asStream;
)



s.sendMsg("n_free", 1007)



PulseDivider //trig, div, start, 합주의 sync맞추는 등에 사용할 수 있을 듯.
(
{
	var p, a, b;
	p = Impulse.ar(8);
	a = SinOsc.ar(1200, 0, Decay2.ar(p, 0.005, 0.1));
	b = SinOsc.ar(600,  0, Decay2.ar(PulseDivider.ar(p, MouseX.kr(1,8).round(1)), 0.005, 0.5));

	[a, b] * 0.4
}.scope(2, zoom:4);
)




(//release node, loop node 를 이용해서 주기성 랜덤을 만드는 아이디어
// randomly generated envelope
z = { arg gate=1;
	var env, n=32;
	env = Env(
		[0]++{1.0.rand.squared}.dup(n-1) ++ [0],
				{rrand(0.005,0.3)}.dup(n),
				\lin, n-8, 8 );
	EnvGen.kr(env, gate, doneAction: 2) * LFTri.ar(220,0,0.4)
}.scope(1, zoom:4);
)


(
t = { arg gate=1, prob = 0.4;
	var env, n=32, sig, trig;
	trig = Impulse.ar(10, 0, SinOsc.kr(0.5,0,1,1));

	sig = Mix.fill(3, {Ringz.ar(CoinGate.ar(prob, trig*0.5), #[1,1.5]*Rand(5000, 6000), 0.1)})*0.2;
	env = Env(
		[0]++{1.0.rand.squared}.dup(n-1) ++ [0],
				{rrand(0.005,0.3)}.dup(n),
				\lin, n-8, 8 );
	EnvGen.kr(env, gate, doneAction: 2) * sig
}.scope(1, zoom:4);
)





// bass
d = { Klank.ar(`[ (1..13)*200, 1/(1..13), nil ], PinkNoise.ar(0.01)) }.play;




a = Synth(\hafen)
p.stop;


(
{
	var p, a, b;
	p = Impulse.ar(8);
	a = SinOsc.ar(1200, 0, Decay2.ar(p, 0.005, 0.1));
	b = SinOsc.ar(600,  0, Decay2.ar(PulseDivider.ar(p, MouseX.kr(1,8).round(1)), 0.005, 0.5));

	[a, b] * 0.4
}.scope(2, zoom:4);
)


(
SynthDef("testeee", {
    arg out = 0, freq = 440, chFreq1 = 2, chFreq2 = 2,
	a = 1, b = 3, c = 0.5, d = 0.5,
	aa = 1, bb = 3, cc = 0.5, dd = 0.5,
    freqScale = 200, inNum = 0,
	gate = 1, amp = 0.1;

    var s1, s2, env1, env2, envgen, syncSig, kSig, inputs, n = 32;

    syncSig = Impulse.ar(3);
    s1 = LatoocarfianN.ar(SampleRate.ir/4, a, b, c, d, mul: Decay2.ar(syncSig, 0.1, 0.2));
    s2 = LatoocarfianN.ar(SampleRate.ir/4, aa, bb, cc, dd, mul: Decay2.ar(syncSig, 0.1, 0.2));


    inputs = [PinkNoise.ar(0.3), WhiteNoise.ar(0.1), ClipNoise.ar(0.1), BrownNoise.ar(0.2)];

    kSig = DynKlank.ar(`[ (1..13)*freqScale, 1/(1..13), nil ],
            Select.ar(inNum, inputs)) * Decay2.ar(PulseDivider.ar(syncSig, 4), 3, 2.5);

    env2 = Env([0]++{0.8.rand.squared}.dup(n-1) ++ [0], {rrand(0.1,0.3)}.dup(n), \lin, n-2, 2 );
    envgen = EnvGen.kr(env2, gate, doneAction: 2);

    Out.ar(0, ([s1, s2] + (kSig * envgen)) * amp);

}).add;
)

a = Synth(\testeee)
p.stop;

(
p = Pbind(
	\instrument, \latooncarfian,
    \dur, 0.4,
	\a, Prand((0.1, 0.2..3.0), inf),
	\b, Prand((0.1, 0.2..3.0), inf),
	\c, Prand((0.1, 0.2..3.0), inf),
	\d, Prand((0.1, 0.2..3.0), inf),
	\aa, Prand((0.1, 0.2..3.0), inf),
	\bb, Prand((0.1, 0.2..3.0), inf),
	\cc, Prand((0.1, 0.2..3.0), inf),
	\dd, Prand((0.1, 0.2..3.0), inf)

).play;

q = Pbind(
	\instrument, \hafen,
	\freqScale, 100,
    \amp, 0.1


).play;


)
p.play;

(
p.stream = Pbind(
	\instrument, \latooncarfian,
    \dur, 1,
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
)



(
SynthDef(\ttt,{
arg a = 1, b = 3, c = 0.5, d = 0.5, aa = 1, bb = 3, cc = 0.5, dd = 0.5, amp = 1;
var s1, s2, p;

    p = Impulse.ar(8);
    s1 = LatoocarfianN.ar(SampleRate.ir/4, a, b, c, d, mul: Decay2.ar(p, 0.1, 0.2));
    s2 = LatoocarfianN.ar(SampleRate.ir/4, aa, bb, cc, dd, mul: Decay2.ar(p, 0.1, 0.2));

    Out.ar(0, [s1, s2] * amp);
}).play;
)


c = Synth(\ttt)


    [s1, s2] * 0.5
).scope(2);
)



b = Synth(\latooncarfian);

a = Synth(\hafen);
a.set(\amp, 0.01);
a.set(\inNum, 2);
a.set(\freqScale, 70);
a.free;

s.sendMsg("/n_free", 1350);
