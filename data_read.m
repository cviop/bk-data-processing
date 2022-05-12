opt = detectImportOptions('data_clean.txt');
T = readtable('data_clean.txt', opt)


lat = T.Var2;
long = T.Var4;
alt = T.Var6;
speed = T.Var7;
temp1 = T.Var8;
press = T.Var9;
temp2 = T.Var10;
hum = T.Var11;
accmin = T.Var17;
accx = T.Var18;
accy = T.Var19;
accz = T.Var20;

accznormal = 8750;

[b, a] = butter(5,0.1);
accfilt = filter(b, a, accmin);
cla reset
figure(1)
t = tiledlayout(1,1);
ax1 = axes(t);
plot(ax1,temp1,alt, '.b')
ax1.XColor = 'b';

xlabel("Teplota (°C)")
ylabel("Nadmořská výška (m)")
hold on

ax2 = axes(t);
plot(ax2, hum, alt, '.r')
ax2.XColor = 'r';
ax2.XAxisLocation = 'top';
ax2.Color = 'none';
ax1.Box = 'off';
ax2.Box = 'off';

xlabel("Vlhkost (%)")
hold off

ang = real(asin(accmin/accznormal));

figure(2)
plot(accmin, 'c-','LineWidth',0.1)
hold on
plot(accfilt, '.r','LineWidth',2)
plot(accx)
plot(accy)
plot(accz)
plot(alt*50-20000, '.-')
ylim([-5000 20000])
yline(accznormal)
hold off

figure(3)
plot(90 - ang.*(180/pi))


