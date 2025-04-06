% Kieran Woolley
% egykw7@nottingham.ac.uk

%% Preliminary Task - Arduino and Git instillation [10 marks]

clear % arduino was already setup with variable a
a = arduino
for i = 1:100
writeDigitalPin(a,'D5',1)
pause(0.0)
writeDigitalPin(a,'D5',0)
pause(0.5)
end

%%