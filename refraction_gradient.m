f = readNPY('Data/Power_measurement_1651664034.3606765.npy');
s = readNPY('Data/Power_measurement_1651664833.231332.npy');

opt = detectImportOptions('data_clean.txt');
T = readtable('data_clean.txt', opt);


[b, a] = butter(5,0.1);


time = T.Var1;
lat = T.Var2;
long = T.Var4;
alt = T.Var6;
speed = T.Var7;
tmp = T.Var8;
pr = T.Var9;
temp2 = T.Var10;
hum = T.Var11;
accmin = T.Var17;
accx = T.Var18;
accy = T.Var19;
accz = T.Var20;
accfilt = filtfilt(b, a, accmin);

p=f(:,2)';
q=s(:,2)';

all=[q, p];



humsmooth = filtfilt(b,a,hum);

eh=6.1121*hum/100 .*exp((tmp*17.502)./(240.97+tmp));

N=(77.6./(tmp + 273.15)) .* (pr/100 + (eh*4810)./(tmp + 273.15));


%p- tlak hPa, T- abs temp (K), e- tlak vodních par v hPa

h0 = 7.35;
N0 = 315;

N1 = N0*exp(-alt/(1000*h0));
NL = -40/1000*alt +314.283;

Nfit = fit(alt,N,'exp1');
Nfiteq = Nfit.a*exp(alt*Nfit.b);


cla reset
figure(1)
t = tiledlayout(1,1);
ax1 = axes(t);
plot(ax1,N,alt/1000, '-b',LineWidth=1)
hold on
plot(ax1,N1,alt/1000, '-.b',LineWidth=1)
plot(ax1,NL,alt/1000, ':b',LineWidth=1)
ax1.XColor = 'b';
xlim([0 310])
legend('model vypočtený z naměřených dat','exponenciální model ITU-R 836','lineární model')
grid on

xlabel("refraktivita (N)")
ylabel("nadmořská výška (km)")
hold on

ax2 = axes(t);
tmplot = plot(ax2, tmp, alt/1000, ':r',LineWidth=.1);
hold on
humplot = plot(ax2, humsmooth, alt/1000, '-r',LineWidth=.1);
legend([tmplot, humplot],'telpota', 'relativní vlhkost','Location','east')
ax2.XLim=([-40 50]);
ax2.XColor = 'r';
ax2.XAxisLocation = 'top';
ax2.Color = 'none';
ax1.Box = 'off';
ax2.Box = 'off';


xlabel(" teplota (°C), relativní vlhkost (%)")
hold off

figure(2)
plot(N, alt/1000, '.','MarkerSize',14,'Color',[0.8 0.8 1])
hold on
plot(Nfiteq, alt/1000, 'LineWidth',2)
hold on
plot(N1,alt/1000, '-.b',LineWidth=1)
xlabel("refraktivita (N)")
ylabel("nadmořská výška (km)")
xlim([0 310])
grid on
xl = xlim;
yl = ylim;
xt = 0.5 * (xl(2)-xl(1)) + xl(1);
yt = 0.75 * (yl(2)-yl(1)) + yl(1);
caption = sprintf('N(h) = %f * exp(%f*h)', Nfit.a, Nfit.b);
text(xt, yt, caption, 'FontSize', 12, 'Color', 'r', 'FontWeight', 'normal');
legend('model vypočtený z naměřených dat','exponenciální proložení vypočteného modelu','exponenciální model ITU-R 836')
box off
hold off



figure(3)
plot(N,alt/1000, '.b',LineWidth=1)
ylim([0 2])
xlabel('refraktivita (N)')
ylabel('nadmořská výška (km)')
grid on
hold off







