% rng(45)

x1 = randn(1,100);
x2 = randn(1,100);
x3 = x1 + 0.5;

plot(x1), hold on
plot(x2);
plot(x3);

d1 = x1;
d2 = x2;
d3 = x3;

tx = [d1; d2; d3];
nx = generate_iAAFTn(tx');

subplot(2,1,1)
plot(tx', 'Linewidth', 2); 
title('Originals');
subplot(2,1,2)
plot(nx, 'Linewidth', 2);
title('Surrogates');

set(gcf, 'color', 'w');
    