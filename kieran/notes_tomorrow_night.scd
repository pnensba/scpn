(
// d.morceaux est la liste des morceaux QUI RESTE A JOUER

// ~scramble construit une liste aléatoire des 20 morceaux
// et s'assurre que le dernier morceau joué ne sera pas le prochain tiré
~scramble = {
	d.morceaux = (0..20).scramble;
	while ({d.morceaux[20]==d.morceau},
		{d.morceaux = (0..20).scramble;}
	)
};



// dm = durée minimale du délai
// dM = durée maximale du délai
// hp n° du couple de hps

~tirage = {|delaiDelta=0, delaiMax=240, hp=0, startnow=false|
	var delai, dur, morceau, synth;
	// si la liste est vide alors il faut en recréer une
	if (d.morceaux.size()==0,
		{~scramble.()},
		{}
	);
	morceau = d.morceaux.pop(); // le morceau courant
	// on tire une durée au hasard
	delai = delaiDelta+((1.0.sum3rand+1)*delaiMax/2);
	("délai choisi: "++delai).postln;
	("morceau : "++morceau).postln;
	if (startnow==false) {delai.wait;}; // on attend

	synth = ~joue.(morceau,hp); // on joue le morceau sur son couple hp
	dur = ~dur.(morceau);
	("durée du morceau: "++dur).postln;
	dur.wait; // on attend la fin
	~tirage.(0, delaiMax,hp);
};
(
~init = {
	{~tirage.(hp:0, startnow:true)}.fork;
	{~tirage.(60,hp:1)}.fork;
	{~tirage.(120,hp:2)}.fork;
	{~tirage.(180,hp:3)}.fork;
}
);
)

~init.()
d.morceau = 0; ~scramble.();
s.queryAllNodes



// test
{~tirage.(0,5,0)}.fork
~morceaux
~morceau



/*
~tirage.(); ~morceaux.postln; ~morceau;
~morceaux.pop();
~morceaux
*/