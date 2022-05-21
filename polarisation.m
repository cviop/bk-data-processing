clc; clear all;

opt = detectImportOptions("Data/dvorak_polar.csv");
P    = readtable("Data/dvorak_polar.csv",opt);
Q  = readtable("Data/QHA_pol45.csv",opt);
R = readtable("Data/QHA_polmmm45.csv",opt);

ang=P.Var2;
gain = P.Var3;


minu=min(P.Var3)
minv=min(Q.Var3)
minw=min(R.Var3)

u=1/ 10^(minu/20)
v=1/ 10^(minv/20)
w=1/ 10^(minw/20)

figure(1)
plot(P.Var2, P.Var3)
hold on
plot(Q.Var2, Q.Var3)
plot(R.Var2, R.Var3)
xlabel('úhel natočení (°)')
ylabel('relativní výkon (dB)')
grid on
box off