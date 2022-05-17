f = readNPY('Data/Power_measurement_1651664034.3606765.npy');
s = readNPY('Data/Power_measurement_1651664833.231332.npy');

opt = detectImportOptions('data_clean.txt');
T = readtable('data_clean.txt', opt)

y=num2str(time);
st=num2str(time(1));
start=str2num(st(:,[1:2]))*3600 + str2num(st(:,[3:4]))*60 + str2num(st(:,[5:6]));
seconds=str2num(y(:,[1:2]))*3600 + str2num(y(:,[3:4]))*60 + str2num(y(:,[5:6]))-start;




hum = T.Var11;
alt = T.Var6;

p=f(:,2)';
q=s(:,2)';

all=[q, p]';
all(end+1:max(seconds))=-120;

[b, a] = butter(5, 0.05);

all = circshift(all,(size(f)+size(s))-max(time));

filt = filtfilt(b, a, all);


timeF = f(:,[1])-f(1);
timeS = s(:,[1])-f(1);

d=datetime(s(:,[1]),'convertfrom', 'posixtime', 'Format', 'HH:mm:ss')





figure(1)
subplot(2,1,1)
plot(allMov)
hold on
plot(filt,'o')
hold off

subplot(2,1,2)
plot(seconds, hum)
hold on
plot(seconds, alt/200, '.', LineWidth=.1)
hold off