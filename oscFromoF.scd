



b = Buffer.loadDialog;
~buf_0 = Buffer.read(s,"/Users/giy/Desktop/hafen.wav");
~buf_0 = Buffer.read(s,"/Users/giy/Desktop/latoon.wav");
~buf_0.play;
~buf_0.numFrames/s.sampleRate;
~buf_0.free;

a = Synth(\bufFrag, [\bufnum, ~buf_0, \loop, 0, \sp, s.sampleRate*2.9, \len, 0.5, \amp, 0.2])

(
//SynthDef
SynthDef(\bufRead,
	{| freq = 1, bufnum = 0, gate = 1, amp = 0.1, pan = 0, rate = 1, loop = 1 |
		var sig;
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, loop: loop, doneAction: 2);
	Out.ar(0, Pan2.ar(sig, pan, amp));
}).add;


SynthDef(\bufFrag,
	{| freq = 1, bufnum = 0, gate = 1, amp = 0.01, pan = 0, rate = 1, trig = 1, loop = 1, sp = 0, len = 0 |
		var sig, env;
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, trig, sp, loop: loop);
		env = EnvGen.kr(Env.linen(0.01, len-0.02, 0.01), gate, doneAction: 2);
	Out.ar(0, Pan2.ar(sig*env, pan, amp));
}).add;


SynthDef(\bufFrag2,
	{| freq = 1, bufnum = 0, gate = 1, amp = 0.01, pan = 0, rate = 1, trig = 1, loop = 1, sp = 0, len = 0 |
		var sig, env;
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, trig, sp, loop: loop);
		env = EnvGen.kr(Env.linen(0.01, len-0.02, 0.01), gate, doneAction: 2);
	Out.ar(0, Pan2.ar(sig*env, pan, amp));
}).add;

SynthDef(\bufFragLoop,
	{| freq = 1, bufnum = 0, gate = 1, amp = 0.1, pan = 0,
		rate = 1, trig = 1, loop = 1, sp = 0, len = 0 |
		var sig;
		sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, Impulse.kr(freq), sp, loop: loop);
	Out.ar(0, Pan2.ar(sig, pan, amp));
}).add;



)

a = Synth(\bufFrag, [\bufnum, ~buf_1, \sp, 44100, \len, 0.2]);
b = Synth(\bufFragLoop, [\bufnum, ~buf_1, \sp, 44100, \len, 0.2]);

a = Synth(\aya);


(
//Oscfuncs
var ofAddr, oscfn, titleBuf, soundBuf, buf, syn, synFrag, len, lenDiv, lenDivSec,
fragContNum;

fragContNum = Array.newClear(10);
10.do{|i| fragContNum[i] = 0};

ofAddr = NetAddr("127.0.0.1", 20000); // oF addr

oscfn = Array.newClear(10);
soundBuf = Array.newClear(10);
buf = Array.newClear(10);
// syn = Array.newClear(10);
syn = Array2D.new(10, 10);
synFrag = Array.newClear(100);
len = Array.newClear(6);
lenDiv = Array.newClear(6);
lenDivSec = Array.newClear(6);


// Audio buffers
titleBuf = Buffer.read(s, "/Users/giy/subDesktop/wesa/dieSammelungen/title.wav");
soundBuf[0] = Buffer.read(s, "/Users/giy/Desktop/hafen.wav");
soundBuf[1] = Buffer.read(s, "/Users/giy/Desktop/latoon.wav");
soundBuf[2] = Buffer.read(s, "/Users/giy/Desktop/high.wav");
soundBuf[3] = Buffer.read(s, "/Users/giy/Desktop/sewol_girl.wav");
buf[0] = Buffer.read(s, "/Users/giy/subDesktop/wesa/voices/aya.wav");
buf[1] = Buffer.read(s, "/Users/giy/subDesktop/wesa/voices/sewol.wav");

//Polygon body
oscfn[0] = OSCFunc({|msg, time, addr, recvPort| msg.postln;

	//msg[1] : polygonBody idx
	//msg[2] : dupIdx

		// var len = ~buf_0.numFrames/s.sampleRate;
		// ofAddr.sendMsg("/wavLen", 0, len);
		// ("wavLen sended: "+len).postln;

	syn[msg[1], msg[2]] = Synth(\bufRead, [\bufnum, buf[msg[1]]]);




}, '/pbBorn');


oscfn[1] = OSCFunc({|msg, time, addr, recvPort| msg.postln;

	//msg[1] : polygonBody idx
	//msg[2] : dupIdx

	syn[msg[1], msg[2]].free;


}, '/pbBrek');

oscfn[2] = OSCFunc({|msg, time, addr, recvPort| msg.postln;

}, '/pbDest');



//Fragments
oscfn[3] = OSCFunc({|msg, time, addr, recvPort| msg.postln;

	/*
	msg[1] = polygonBodyIdx
	msg[2] = fragIdx
	*/

	len[msg[1]] = buf[msg[1]].numFrames;
	lenDiv[msg[1]] = len[msg[1]]/100;
	lenDivSec[msg[1]] = lenDiv[msg[1]]/s.sampleRate;

	Synth(\bufFrag, [\bufnum, buf[msg[1]], \sp, msg[2]*lenDiv[msg[1]], \len, lenDivSec[msg[1]]]);
	// synFrag[msg[2]] = Synth(\bufFragLoop, [\bufnum, buf[msg[1]], \sp, msg[2]*lenDiv[msg[1]],
	// \freq, lenDivSec[msg[1]].reciprocal]);


}, '/fgBorn');


oscfn[4] = OSCFunc({|msg, time, addr, recvPort| msg.postln;

	/*
	msg[1] = polygonBodyIdx
	msg[2] = fragIdx
	*/

	len[msg[1]] = soundBuf[msg[1]].numFrames;
	lenDiv[msg[1]] = len[msg[1]]/100;
	lenDivSec[msg[1]] = lenDiv[msg[1]]/s.sampleRate;

	// synFrag[msg[2]].free;



	// Synth(\bufFrag, [\bufnum, buf[msg[1]], \sp, msg[2]*lenDiv[msg[1]], \len, lenDivSec[msg[1]]]);
	Synth(\bufFrag, [\bufnum, soundBuf[msg[1]], \sp, fragContNum[msg[1]]*lenDiv[msg[1]], \len, lenDivSec[msg[1]]]);
	fragContNum[msg[1]] = fragContNum[msg[1]] + 1;

	if (fragContNum[msg[1]] == 100, {
		fragContNum[msg[1]] = 0;
	});

	fragContNum[msg[1]].postln;




}, '/fgCont');

oscfn[5] = OSCFunc({|msg, time, addr, recvPort| msg.postln;

	if(msg[1] == 1, {
		titleBuf.play;
	});

}, '/title');


CmdPeriod.doOnce{
	10.do{|i| oscfn[i].free;};
}


)
