(
SynthDef(\sori,
	{
		arg amp = 1, freq = 20, freq2 = 20, gate = 1, ph = 0,
		freq3 = 10, filfreq = 100, rq = 0.2, freq4 = 100, dop = 0.5, harm = 200 ;
		var sig, env, sig2, env2, sig3, sig4, fil;
		//		env2 = EnvGen.kr(Env.perc(0.1, 0.5), gate, doneAction: 2);
		env2 = EnvGen.kr(Env.asr, gate, doneAction: 2);
		//		sig2 = SinOsc.kr(freq2*env2, ph);
		//		sig2 = LFTri.kr(freq2*env2, ph);
		//		sig2 = WhiteNoise.kr(1);
		sig4 = Blip.kr(freq4, harm);
		sig3 = SinOsc.kr(freq3);
		sig2 = LFNoise0.kr(freq2);

		sig = SinOsc.ar(freq*sig4, mul: 1);
		env = EnvGen.kr(Env.asr, gate, doneAction: 2);
		fil = RHPF.ar(sig, freq, rq);
		Out.ar(0, Pan2.ar(fil*env*amp));
	}
).add;
)

a = Synth(\sori, [\freq, 200, \freq4, 10, \rq, 0.9]);
a.set(\amp, 0)
a.set(\freq, 90);
a.set(\freq2, 400);
a.set(\harm, 800);
a.set(\freq3, 50);
a.set(\freq4, 0.5);
a.set(\rq, 0.1);
a.set(\filfreq, 100);
a.release(1);
a.set(\gate, 0);

FreqScope.new



//lead
(
c = Pbind(
        \instrument,        \sori,
//        \nharms,            32,
	// \root,             [-3, 12],
	\dur,           Pseq([5, 5, 5, 4, 4, 3, 7, 3, 2, 4, 6, 2]/5, 12),
	\freq,           Pseq([50, 100, 200, 300, 100, 300, 200], 12),
	\freq4,          Pseq([4, 6, 9, 2, 3, 4, 6, 2, 8, 2, 1, 30], 12),
        \amp,               0.02

    ).play;
)

//ambient
(
c = Pbind(
        \instrument,        \sori,
        \dur,               Pseq([4, 2, 1, 5, 1, 2, 0.4, 0.2, 0.5]/3, 9),
        \degree,            Pseq( [1, 2, 7, 2, 22, 39, 44]/148, 9),
        \amp,               0.2

    ).play;
)


(
c.stream = Pbind(
        \instrument,        \liedR,
        \dur,               Pseq([4, 2, 1, 5, 1, 2, 0.4, 0.2, 0.5]/3, 9),
        \degree,            Pseq( [1, 2, 7, 2, 22, 39, 44]/148, 9),
        \amp,               0.2

    ).asStream;
)
