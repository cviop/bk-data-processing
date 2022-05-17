rad0 = load("Data/QHA_LH_0deg.mat");
radm45 = load("Data/QHA_LH_-45deg.mat");
rad45 = load("Data/QHA_LH_45deg.mat");
rad90 = load("Data/QHA_LH_90deg.mat");

polarisation = load("Data/QHA_LH_0deg_polar.mat")


flip(rad0.ampl);
flip(rad45.ampl);
flip(rad90.ampl);

radm45.ampl =radm45.ampl- max(radm45.ampl);
rad0.ampl =rad0.ampl- max(rad0.ampl);
rad45.ampl =rad45.ampl- max(rad45.ampl);
rad90.ampl =rad90.ampl- max(rad90.ampl);

ampl = [rad0.ampl, radm45.ampl, rad45.ampl, rad90.ampl];
phi = [rad0.phi', radm45.phi', rad45.phi', rad90.phi'];
theta = [zeros(361,1)'+0, zeros(361,1)'-45, zeros(361,1)'+45 zeros(361,1)'+90];


figure(1)
B = patternCustom(ampl, theta, phi,'CoordinateSystem','polar','Slice','theta','SliceValue',-45);
hold on
A = patternCustom(ampl, theta, phi,'CoordinateSystem','polar','Slice','theta','SliceValue',0);
C = patternCustom(ampl, theta, phi,'CoordinateSystem','polar','Slice','theta','SliceValue',45);
D = patternCustom(ampl, theta, phi,'CoordinateSystem','polar','Slice','theta','SliceValue',90);

l=legend(gca);l.delete;

legend(gca,'phi=-45 °','phi=0 °','phi=45 °','phi=90 °')
hold off

