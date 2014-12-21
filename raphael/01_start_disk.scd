
d = (); // création d'un dictionnaire
d.root = thisProcess.nowExecutingPath.dirname++"/";
d.sons = (d.root++"sons/*.wav").pathMatch;
d.n = d.sons.size;
d.bufsize = 262144; // buffer of 3 seconds at 44100Hz

// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
s.options.device = "install raph"; // choix de la carte
//s.options.device = "Fireface 400 (7DF)"; // choix de la carte
s.options.numOutputBusChannels = 18;
s.boot;

~loaded = {|b| b.postln};
~free = {|a| a.size.do{|i| a[i].free}};

~init = {
	s.freeAll();
	~free.(d.bufs);
	~free.(d.disks);
	~free.(d.mags);

	d.bufs = Array.newClear(d.n);
	d.disks = Array.newClear(d.n);
	d.mags = Array.newClear(d.n);
};


~init.();

s.doWhenBooted({
	d.sons.size.do{|i|
		var nout;
		if (i>7, {nout=i+2},{nout=i}); // spdif outputs jump
		d.bufs[i] = Buffer.cueSoundFile(s, d.sons[i], 0, 1, d.bufsize);
		1.wait; // assume that 1 second is sufficient to load buffer in RAM
		d.disks[i] = {Out.ar(nout, VDiskIn.ar(1, d.bufs[i].bufnum, rate:1, loop:1))};
	};
	d.sons.size.do{|i|
		d.mags[i] = d.disks[i].play;
	};
});
