//Sammelungen Synth Definition

(

//Buffer
~buf_1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ '/' ++ "coin_.aif");

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
SynthDef(\dirac, {| out = 0, amp = 0.03, freq = 100, decay = 0.01, pos = -1 |
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
	arg freq = 1, ffreq = 100, rq = 0.05, amp = 0.6, gate = 1, out = 54;
	var sig1, sig2, sig3, sigsum, fil, env;
	sig1 = Impulse.ar(freq);
	sig2 = LFPulse.ar(freq, 0.1);
	sig3 = Pulse.ar(freq, 0.3, mul: 0.01);
	sigsum = sig1 + sig2 + sig3;
	fil = BPF.ar(sigsum, ffreq, rq, add: sigsum * 0.7);
	env = EnvGen.kr(Env.perc(0.01, 0.2), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(fil * env, LFNoise0.kr(SinOsc.kr(1, mul: 3, add: 3)), amp));

	}).add;

// Synthdef 9-1, pan adjustable
SynthDef(\filmPan,{
	arg freq = 1, ffreq = 100, rq = 0.05, amp = 0.6, pan = 0, gate = 1, out = 54;
	var sig1, sig2, sig3, sigsum, fil, env;
	sig1 = Impulse.ar(freq);
	sig2 = LFPulse.ar(freq, 0.1);
	sig3 = Pulse.ar(freq, 0.3, mul: 0.01);
	sigsum = sig1 + sig2 + sig3;
	fil = BPF.ar(sigsum, ffreq, rq, add: sigsum * 0.7);
	env = EnvGen.kr(Env.perc(0.01, 0.2), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(fil * env, pan, amp));

	}).add;


// Synthdef 10
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


// Synthdef 11 - summing streo signals to mono
SynthDef(\stom,{
	arg inBus = 0, outBus = 0;
	var inSig_1, inSig_2, sumSig;
	inSig_1 = In.ar(inBus, 1);
	inSig_2 = In.ar(inBus+1, 1);
	sumSig = Mix.ar([inSig_1, inSig_2]);
	Out.ar(outBus, inSig_1);
}).add;


// SynthDef 12 - reverb
SynthDef(\FreeVerb, {|inbus = 54, outbus = 32, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|
    var signal;

    signal = In.ar(inbus, 2);

	Out.ar(outbus,
        FreeVerb2.ar( // FreeVerb2 - true stereo UGen
            signal[0], // Left channel
            signal[1], // Right Channel
            mix, room, damp, amp)); // same params as FreeVerb 1 chn version

}).add;

// SynthDef 13
SynthDef(\coinend, {| out = 0, bufnum, gate = 1 |
    var sig, sigD, rate, env;
	env = EnvGen.kr(Env.asr, gate, doneAction: 2);
	rate = LFPar.kr(1/20);
	sig = PlayBuf.ar(1, bufnum, rate, 1.0, 0, 1, 2);
	sigD = DelayN.ar(sig, 0.6, 0.6, add: sig*0.3);
	Out.ar(out, [env * sig, env * sigD * Line.kr(0.2, 1.2, 5)]);
}).add;


// SynthDef 14 - Limiter
SynthDef(\limiter, {| inbus = 32, out = 0, bufnum, gate = 1 |
    var in, sig;
	in = In.ar(inbus, 2);
	sig = Limiter.ar(in, 0.5, 0.02);
	Out.ar(out, sig);
}).add;



) //Synthdef END