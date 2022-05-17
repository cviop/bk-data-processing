f = readNPY('Data/Power_measurement_1651664034.3606765.npy');
s = readNPY('Data/Power_measurement_1651664833.231332.npy');

opt = detectImportOptions('data_clean_long.txt');
T = readtable('data_clean_long.txt', opt)

time= T.Var1;
hum = T.Var11;
alt = T.Var6;

[b, a] = butter(5, 0.05);

y=num2str(time);
st=num2str(time(1));
seconds=str2num(y(:,[1:2]))*3600 + str2num(y(:,[3:4]))*60 + str2num(y(:,[5:6]));



filt = filtfilt(b, a, all);

dtf=datetime(f(:,[1]),'convertfrom', 'posixtime');
dts=datetime(s(:,[1]),'convertfrom', 'posixtime');

formatOut = 'HHMMSS';

dtfstring=datestr(dtf,formatOut);
fsec=str2num(dtfstring(:,[1:2]))*3600 + str2num(dtfstring(:,[3:4]))*60 + str2num(dtfstring(:,[5:6]));

dtsstring=datestr(dts,formatOut);
ssec=str2num(dtsstring(:,[1:2]))*3600 + str2num(dtsstring(:,[3:4]))*60 + str2num(dtsstring(:,[5:6]));





timeoffset = max(ssec) - max(seconds);
fsec =fsec-timeoffset;
ssec =ssec-timeoffset;



f(:,1) = fsec;
s(:,1) = ssec;



figure(1)
plot(seconds, alt/1000-90)
hold on
plot(f(:,1),f(:,2))
hold on
plot(s(:,1),s(:,2))
hold off  


cla reset
figure(1)
t = tiledlayout(1,1);
ax1 = axes(t);
plot(ax1,seconds,alt/1000, '.b')
ax1.YColor = 'b';

xlabel("čas (s)")
ylabel("Nadmořská výška (km)")
hold on

ax2 = axes(t);
plot(ax2, f(:,1), f(:,2), '-r')
hold on
plot(ax2, s(:,1), s(:,2), '-r')
ax2.YColor = 'r';
ax2.YAxisLocation = 'right';
ax2.Color = 'none';
ax1.Box = 'off';
ax2.Box = 'off';

ylabel("přijatý výkon (dBi)")
hold off


