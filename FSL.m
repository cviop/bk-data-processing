d = (0:0.1:50);
FSLL = 32.4+20*log10(869.63)+20*log10(d);

figure(1)
plot(d, FSLL)
xlabel('vzdálenost (km)')
ylabel('FSL (dB)')
grid on
ylim([60 130])

