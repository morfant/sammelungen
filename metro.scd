(
// get elapsed time, round up to next second
v = Main.elapsedTime.ceil;

// create two clocks in a 5:2 relation, starting at time v.
t = TempoClock(1, 0, v);
u = TempoClock(0.5, 0, v);

// start two functions at beat zero in each clock.
t.schedAbs(0, { arg beat, sec; b = Synth(\lfp); 1 });
u.schedAbs(0, { arg beat, sec; d = Synth(\dirac); 1 });
)

(
u.tempo = u.tempo * 2/3;
t.tempo = t.tempo * 2;
)
u.tempo;
t.tempo;

(
u.tempo = u.tempo * 1/4;
t.tempo = t.tempo * 1/4;
)

(
t.stop;
u.stop;
)