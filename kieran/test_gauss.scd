a = Pgauss(50, 25, inf);
a.asStream.next()
c = a.asStream.nextN(50000).abs
c.plot(bounds: Rect(10, 10, 520, 380), discrete: true, parent: w);

a.asStream.next().abs