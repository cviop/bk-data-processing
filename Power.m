f = readNPY('Data/Power_measurement_1651664034.3606765.npy');
s = readNPY('Data/Power_measurement_1651664833.231332.npy');

opt = detectImportOptions('data_clean_long.txt');
T = readtable('data_clean_long.txt', opt)

time= T.Var1;
hum = T.Var11;
alt = T.Var6;

y=num2str(time);
st=num2str(time(1));
start=str2num(st(:,[1:2]))*3600 + str2num(st(:,[3:4]))*60 + str2num(st(:,[5:6]));
seconds=str2num(y(:,[1:2]))*3600 + str2num(y(:,[3:4]))*60 + str2num(y(:,[5:6]));





p=f(:,2)';
q=s(:,2)';

all=[p, q]';


[b, a] = butter(5, 0.05);



filt = filtfilt(b, a, all);


timeF = f(:,[1]);
timeS = s(:,[1]);
timePow = [timeF', timeS']';
d=datetime(timePow(:,[1]),'convertfrom', 'posixtime');

formatOut = 'HHMMSS';

strintimespec=datestr(d,formatOut);
startspec=datestr(d(1),formatOut);
secondsspec=str2num(strintimespec(:,[1:2]))*3600 + str2num(strintimespec(:,[3:4]))*60 + str2num(strintimespec(:,[5:6]));



timeoffset = max(secondsspec) - max(seconds);
secondsspec =secondsspec-timeoffset;

seconds = seconds - secondsspec(1);
secondsspec = secondsspec-secondsspec(1);






figure(1)
plot(secondsspec, all)
hold on
plot(seconds, hum)
hold on
plot(seconds, alt/200, '.', LineWidth=.1)
hold off


