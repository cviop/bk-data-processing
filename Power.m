f = readNPY('Data/Power_measurement_1651664034.3606765.npy');
s = readNPY('Data/Power_measurement_1651664833.231332.npy');
f(719,2) = -83;
opt = detectImportOptions('data_clean_long.txt');
T = readtable('data_clean_long.txt', opt);
T.Properties.VariableNames = {'Time','Lat','N/S','Long', 'E/W', 'Alt', 'Speed', 'Temp1', 'Press', 'Temp2', 'Humidity','GPS fix type', 'nSats', 'HDOP', 'VDOP', 'DOP', 'AccMin', 'AccX', 'AccY', 'AccZ', 'GyroX', 'GyroY', 'GyroZ', 'MagX', 'MagY', 'MagZ'};

time= T.Time;
hum = T.Humidity;
alt = T.Alt;

%[b, a] = butter(10, 0.1);
formatOut = 'HHMMSS';

windowSize = 10; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

commas = {';'};

y=num2str(time);
st=num2str(time(1));
%bsec=strcat(y(:, [1 2]), ":",y(:, [3 4]), ":",y(:, [5 6]))

H= str2num(y(:, [1 2]));
MI= str2num(y(:, [3 4]));
S= str2num(y(:, [5 6]));

Y = 2022;
M = 5;
D = 4;

T.Time = datetime(Y,M,D,H,MI,S);



bsec=str2num(y(:,[1:2]))*3600 + str2num(y(:,[3:4]))*60 + str2num(y(:,[5:6]));




dtf=datetime(f(:,[1]),'convertfrom', 'posixtime');
dts=datetime(s(:,[1]),'convertfrom', 'posixtime');



dtfstring=datestr(dtf,formatOut);
fsec=str2num(dtfstring(:,[1:2]))*3600 + str2num(dtfstring(:,[3:4]))*60 + str2num(dtfstring(:,[5:6]));

dtsstring=datestr(dts,formatOut);
ssec=str2num(dtsstring(:,[1:2]))*3600 + str2num(dtsstring(:,[3:4]))*60 + str2num(dtsstring(:,[5:6]));


timeoffset = max(ssec) - max(bsec);

ssec =(ssec-timeoffset);
fsec =(fsec-timeoffset);

init = min(fsec);

bsec = bsec- init;
ssec=ssec-init;
fsec=fsec-init;

f(:,1) = fsec;
s(:,1) = ssec;

f(:,3) = filtfilt(b, a, f(:,2));
s(:,3) = filtfilt(b, a, s(:,2));




pow = [f', s']';
P=array2table(pow);
P.Properties.VariableNames = {'Time', 'Power_received', 'Power_filtered'};

PH = [str2num(dtfstring(:,[1 2]))',str2num(dtsstring(:,[1 2]))']';
PM = [str2num(dtfstring(:,[3 4]))',str2num(dtsstring(:,[3 4]))']';
PS = [str2num(dtfstring(:,[5 6]))',str2num(dtsstring(:,[5 6]))']';
P.Time = datetime(Y,M,D,PH,PM,PS);

P.Time =P.Time + seconds(-260);

Ttim = table2timetable(T);
Ptim = table2timetable(P);
data = synchronize(Ttim, Ptim);
valid = data.Power_received<0;


baseTime = -233:1:2235;
baseTab = array2table(baseTime');
baseTab.Properties.VariableNames = {'Time'};

%tt= synchronize(T, P);
%J = join(P, B)

ggg=data.Power_received;

Z = smooth(ggg,2);
Z(Z>=0) = NaN;
Zfil(Zfil>=0) = NaN;
data.Power_received = Z;

cla reset

%%%%%%%%%%%%%%%%%%%%%%%%

fg=figure(1);

fg.Position = [100 100 800 500];
t = tiledlayout(1,1);

ax1 = axes(t);

plot(ax1,bsec,alt/1000, '-b', 'LineWidth',1.5)
hold on
plot(ax1,bsec,hum/10, ':b', 'LineWidth',1.5)
ax1.YColor = 'b';
ax1.XColor = 'none';
ylabel("nadmořská výška (km) & relativní vlhkost (10 %)")
legend('nadmořská výška','relativní vlhkost','Location','northwest')
hold on
grid on


ax3 = axes(t);
plot(ax3, data.Time, Z, '-c')
hold on
plot(ax3, data.Time, data.Power_filtered, '.r', 'LineWidth',2)
ax3.YColor = 'r';
ax3.YAxisLocation = 'right';

ylim([-90 -40])
ylabel("přijatý výkon (dBm)")
legend('změřený výkon','hodnoty výkonu filtrované kouzavým průměrem','Location','northeast')
ax3.Color = 'none';
ax1.Box = 'off';

ax3.Box = 'off';
xlabel("čas (s)")

hold off

%print -depsc alt_hum_p_p_filt
