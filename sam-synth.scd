//Sammelungen Synth Definition

(

//Buffer
~buf_1 = Buffer.read(s, "/Users/giy/Music/SuperCollider Recordings/coin_.aiff");


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
	atTime = 0.15, relTime = 0.05,
	gate = 1, amp = 0.1;
    var s1, s2, env;
    env = EnvGen.kr(Env.perc(atTime, relTime), gate, doneAction: 2);
    s1 = LatoocarfianN.ar(SampleRate.ir/4, a, b, c, d, mul: 0.1);
    s2 = LatoocarfianN.ar(SampleRate.ir/4, aa, bb, cc, dd, mul: 0.1);

Out.ar(out, [s1, s2]*env*amp);

}).add;


// Synthdef 4 - Reverb
SynthDef(\verb,
    {
        arg in = 0, out = 0, pos = 0, room = 2, rtime = 1, dam = 0.3, sp = 5, tail = 0.2, amp = 1.0;
        var sig, fil;
        sig = In.ar(in, 1);
        fil = GVerb.ar(sig, room = 2, rtime, dam, 0.5, spread: sp, taillevel: tail);
		Out.ar(out, Pan2.ar(fil, pos, amp));

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


// Synthdef 9
SynthDef(\film,{
	arg freq = 1, ffreq = 100, rq = 0.05, amp = 0.6, gate = 1, out = 0;
	var sig1, sig2, sig3, sigsum, fil, env;
	sig1 = Impulse.ar(freq);
	sig2 = LFPulse.ar(freq, 0.1);
	sig3 = Pulse.ar(freq, 0.3, mul: 0.01);
	sigsum = sig1 + sig2 + sig3;
	fil = BPF.ar(sigsum, ffreq, rq, add: sigsum * 0.7);
	env = EnvGen.kr(Env.perc(0.01, 0.2), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(fil * env, LFNoise0.kr(SinOsc.kr(1, mul: 3, add: 3)), amp));

	}).add;

// Synthdef 10
SynthDef(\coint,
	{
		arg freq = 100, bufnum = ~buf_1, trigF = 1/8, rateFreq = 2, gate = 1, amp = 0.5, out = 0, rateNum = 0;
		var sig, env, rate, rates;
		rates = [
			LFNoise0.kr(rateFreq, add: 1),
			LFClipNoise.kr(SinOsc.kr(rateFreq).range(2, 9)),
			LFPulse.kr(rateFreq),
			LFPulse.kr(SinOsc.kr(rateFreq).range(2, 9)),
			LFNoise1.kr(rateFreq)
		];
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * Select.kr(rateNum, rates), LFPulse.kr(trigF), loop: 1, doneAction:2);
		env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
		Out.ar(out, Pan2.ar(sig * env, 0, amp));
}).add;


// Synthdef 11 - summing streo signals to mono
SynthDef(\stom,{
	arg inBus = 0, outBus = 0;
	var inSig_1, inSig_2, sumSig;
	inSig_1 = In.ar(inBus, 1);
	inSig_2 = In.ar(inBus+1, 1);
	sumSig = Mix.ar([inSig_1, inSig_2]);
	Out.ar(outBus, inSig_1);
}).add;

) //Synthdef END









//TEST AREA

(
SynthDef(\film,{
	arg freq = 1, ffreq = 100, rq = 0.05, amp = 0.6, relTime = 0.2, gate = 1, level = 1, out = 0;
	var sig1, sig2, sig3, sigsum, fil, env;
	sig1 = Impulse.ar(freq);
	sig2 = LFPulse.ar(freq, 0.1);
	sig3 = Pulse.ar(freq, 0.3, mul: 0.01);
	sigsum = sig1 + sig2 + sig3;
	fil = BPF.ar(sigsum, ffreq, rq, add: sigsum * 0.7);
	env = EnvGen.kr(Env.perc(0.01, relTime), gate, level, doneAction: 2);
	Out.ar(out, Pan2.ar(fil * env, LFNoise0.kr(SinOsc.kr(1, mul: 3, add: 3)), amp));

	}).add;
)



(
SynthDef(\delay, {
	arg inBus = 100, outBus = 0, mdTime = 0.3, dTime = 0.2, mul = 1.0, pan = 0, amp = 1.0, inamp = 1.0;
	var in, delay;
	in = In.ar(inBus);
	delay = DelayC.ar(in, mdTime, dTime, mul, 0, in * inamp);
	Out.ar(outBus, Pan2.ar(delay, pan, amp))
}).add;
)


(
SynthDef(\FreeVerb2x2, {|outbus, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|
    var signal;

    signal = In.ar(outbus, 2);

    ReplaceOut.ar(outbus,
        FreeVerb2.ar( // FreeVerb2 - true stereo UGen
            signal[0], // Left channel
            signal[1], // Right Channel
            mix, room, damp, amp)); // same params as FreeVerb 1 chn version

}).add;
)

a = Synth(\FreeVerb2x2, [\outbus, 0], addAction:\addToTail)
a.set(\mix, 0.3, \room, 0.8)

a = Synth(\delay, [\in, 100])

a.set(\mdTime, 2.5, \dTime, 2.4)

b = Synth

b.free;
b = Synth(\verb, [\in, 101])
x = Synth(\film, [\out, 0, \amp, 0.5, \freq, 300]);
x.set(\freq, 0.2)
x.set(\ffreq, 400, \rq, 0.3)
e = Synth(\film)

(
d = Pbind(\instrument, \film,

	\dur,
	Pn(Pseq([Prand((1,2..4)/5, 2), Prand((1,2..4)/10, 1), Prand((1,2..4)/12, 1)], inf)),
	\freq, 800,
	\amp, 0.3,
	\level, Prand([0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\relTime, Prand((0.08, 0.09 .. 0.5), inf),
	\out, 0

).play;
)

b.set(\amp, 0.2)
b.set(\rtime, 2, \room, 5, \dam, 0.6, \sp, 0, \tail, 0.8)


// Synthdef 4 - Reverb
SynthDef(\verb,
    {
        arg in = 0, out = 0, pos = 0, room = 2, rtime = 1, dam = 0.3, sp = 5, tail = 0.2, amp = 1.0;
        var sig, fil;
        sig = In.ar(in, 1);
        fil = GVerb.ar(sig, room = 2, rtime, dam, 0.5, spread: sp, taillevel: tail);
		Out.ar(out, Pan2.ar(fil, pos, amp));

}).add;




d.stop;

d.set


)
)
{Impulse.ar(1)!2}.play;
{LFPulse.ar(1, mul: 0.1)!2}.play;
{Pulse.ar(1, mul: 0.01)!2}.play;






//TEST2

b = Buffer.read(s, "/Users/giy/Music/SuperCollider Recordings/coin_.aiff"); // remember to free the buffer later.
b.play;

(

SynthDef(\coint,
	{
		arg freq = 100, bufnum = b, trigF = 1/8, rateFreq = 2, gate = 1, amp = 0.5, out = 0, rateNum = 0;
		var sig, env, rate, rates;
		rates = [
			LFNoise0.kr(rateFreq, add: 1),
			LFClipNoise.kr(SinOsc.kr(rateFreq).range(2, 9)),
			LFPulse.kr(rateFreq),
			LFPulse.kr(SinOsc.kr(rateFreq).range(2, 9)),
			LFNoise1.kr(rateFreq)
		];
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * Select.kr(rateNum, rates), LFPulse.kr(trigF), loop: 1, doneAction:2);
		env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
		Out.ar(out, Pan2.ar(sig * env, 0, amp));
}).add;
)

c = Synth(\coint, [\amp, 1.5, \bufnum, ~buf_1, \rateNum, 2, \rateFreq, 1, \trigF, 1/8]);
c.set(\rateFreq, 0.95)
c.set(\trigF, 1/40)
c.set(\rateNum, 2)
c.set(\amp, 4.5)
b.free;

~buf_1.play;
{LFClipNoise.ar(10, mul: 0.5, add: 1)}.plot(1)
{LFPulse.ar(10)}.plot(1)
{LFNoise0.ar(10, add: 1)}.plot(1)


{LFClipNoise.kr(SinOsc.kr(2).range(2, 9))}.plot(10)



{LFSaw.kr(1/8)}.plot(8);
{VarSaw.kr(1/8)}.plot(8);


// TEST3

~pat[0].play;


