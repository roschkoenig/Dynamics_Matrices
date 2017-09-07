% Generate surrogate data with matching amplitude spectrum and
% amplitude distribution (Schreiber and Schmitz, 1996).
% Multivariate extension as described in Schreiber and Schmitz (2000)
%
% Usage: [Xs E] = generate_surrogate (X, specflag);
%	specflag	exact amplitude spectrum (1, default), otherise amp distr
%	X [pp x dim]

function [Xs,E] = generate_surrogate (X, specflag);

if (nargin<1)
	Xs = [];
	return;
end
if (nargin<2)
	specflag = 1;
end
if (isempty(X))
	X2 = [];
	return;
end

max_it = 500;
[pp dim] = size(X);

if (dim==1)
	X = X(:);
	pp = length(X);


	% Initial Conditions
	rn = X(randperm(pp));
	Yamp = abs(fft(X));	% Desired amplitude spectrum
	Xsorted = sort(X);	% Desired signal distribution

	prev_err = 0;
	E = zeros(1,max_it);
	c = 1;
	prev_err = 1000000;
	err = prev_err - 1;
	while (prev_err>err) & (c<max_it)

		% Match Amplitude Spec
		Yrn = fft(rn);
		Yang = angle(Yrn);
		sn = real(ifft(Yamp.*(cos(Yang)+sqrt(-1).*sin(Yang))));

		% Match Signal Distribution
		[sns INDs] = sort(sn);
		rn(INDs) = Xsorted;

		% Eval Convergence
		prev_err = err;
		A2 = abs(Yrn);
		%err = mean(mean(abs(A2-Yamp)));
		err = mean(abs(A2-Yamp));
		E(c) = err;

		c = c+1;
	end
	E = E(1:c-1);
	if (flag==1)
		Xs = sn;	% Exact Amp Spectrum
	else
		Xs = rn;	% Exact Amp Distribution
	end

end

if (dim>1)
	Y = fft(X);		% fft every column
	Yamp = abs(Y);
	Porig = angle(Y);

	% Initial Conditions
	rn = zeros(size(X));
	for k=1:dim
		rn(:,k) = X(randperm(pp),k);
	end
	Xsorted = sort(X);

	prev_err = 1000000;
	err = prev_err - 1;
	c = 1;
	Pcurr = Porig;
	while (prev_err>err) & (c<max_it)
		% Match Amplitude Spec
		Prn = angle(fft(rn));
		goal = Prn - Porig;
		AUX1 = sum(cos(goal),2);
		alpha = repmat((AUX1~=0).*atan(sum(sin(goal),2)./sum(AUX1+(AUX1==0),2)),1,dim);
		alpha = alpha + repmat(pi.*(sum(cos(alpha-goal),2)<0),1,dim);
		Pcurr = Porig + alpha;
		sn = real(ifft(Yamp.*(cos(Pcurr)+sqrt(-1).*sin(Pcurr))));

		% Match Signal Distribution
		[sns INDs] = sort(sn);
		for k=1:dim
			rn(INDs(:,k),k) = Xsorted(:,k);
		end

		% Eval Convergence
		prev_err = err;
		A2 = abs(fft(rn));
		err = mean(mean(abs(A2-Yamp)));
		E(c) = err;
		c = c+1;
	end
	if (flag==1)
		Xs = sn;	% Exact Amp Spectrum
	else
		Xs = rn;	% Exact Amp Distribution
	end

end
