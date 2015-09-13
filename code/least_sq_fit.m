function [theta, y_hat, err] = least_sq_fit(x,y,n_degree)

poly_x = [zeros(length(x), n_degree+1)];
for n = 0:n_degree
	poly_x(:,n_degree+1-n) = x.^n;
end
theta = poly_x\y;

y_hat = poly_x*theta;
err = mean(mean((y-y_hat).^2));