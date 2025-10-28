% Load Data from CSV
data = csvread('data.csv', 1, 0); % Skip the header row
suspected_cases = data(:, 1);
suspected_deaths = data(:, 2);

% Polynomial Regression (Degree 3)
p = polyfit(suspected_cases, suspected_deaths, 3);

% Display Polynomial Regression Equation
fprintf('Polynomial Regression Degree 3: y = ');
for i = 1:length(p)
    if p(i) < 0
        fprintf(' - %.5fx^%d', abs(p(i)), length(p)-i);
    else
        if i > 1
            fprintf(' + ');
        end
        fprintf('%.5fx^%d', p(i), length(p)-i);
    end
end
fprintf('\n');

polynomial = @(x) polyval(p, x);

% Define the objective function for optimization (Negative for maximization)
objective_function = @(x) -polynomial(x);

% Golden Section Search Implementation
function [x_opt, iterations, log_data] = golden_section_search(f, a, b, tol)
    gr = (sqrt(5) + 1) / 2; % Golden ratio
    c = b - (b - a) / gr;
    d = a + (b - a) / gr;
    iterations = 0;
    log_data = []; % Log each iteration

    while abs(b - a) > tol
        iterations = iterations + 1;
        log_data = [log_data; a, b, c, d, f(c), f(d)];
        if f(c) < f(d)
            a = c;
        else
            b = d;
        end
        c = b - (b - a) / gr;
        d = a + (b - a) / gr;
    end
    x_opt = (b + a) / 2;
end

% Define bounds for optimization
a = min(suspected_cases);
b = max(suspected_cases);

% Apply Golden Section Search
[x_gss, gss_iterations, gss_log] = golden_section_search(objective_function, a, b, 1e-3);

% Apply fminbnd for comparison (this will now find the minimum for the original function)
[x_fminbnd_min, fval_fminbnd_min] = fminbnd(@(x) polynomial(x), a, b);

% Golden Section Search Min
[x_gss_min, gss_min_val] = golden_section_search(@(x) polynomial(x), a, b, 1e-3);

% fminbnd Max (This is now the maximum, since we negate the result in the objective function)
[x_fminbnd_max, fval_fminbnd_max] = fminbnd(objective_function, a, b);

% Generate predictions
predicted_temp = polynomial(suspected_cases);

% Calculate RMSE and MAE
rmse = sqrt(mean((suspected_deaths - predicted_temp).^2));
mae = mean(abs(suspected_deaths - predicted_temp));

% Plotting
x_vals = linspace(a, b, 500);
y_vals = polynomial(x_vals);

figure;
plot(suspected_cases, suspected_deaths, 'ro', 'DisplayName', 'Data Points', 'MarkerSize', 8);
hold on;
plot(x_vals, y_vals, 'b-', 'DisplayName', 'Polynomial Fit (Degree 3)', 'LineWidth', 1.5);

% Plot GSS Max, GSS Min, fminbnd Max, fminbnd Min
x_gss_y = polynomial(x_gss);
x_fminbnd_max_y = polynomial(x_fminbnd_max);
x_fminbnd_min_y = polynomial(x_fminbnd_min);
x_gss_min_y = polynomial(x_gss_min);

plot(x_gss, x_gss_y, 'go', 'MarkerSize', 10, 'DisplayName', 'Golden Section Max');
plot(x_fminbnd_max, x_fminbnd_max_y, 'mo', 'MarkerSize', 10, 'DisplayName', 'fminbnd Max (Negative)');
plot(x_gss_min, x_gss_min_y, 'bo', 'MarkerSize', 10, 'DisplayName', 'Golden Section Min');
plot(x_fminbnd_min, x_fminbnd_min_y, 'co', 'MarkerSize', 10, 'DisplayName', 'fminbnd Min');

% Annotate maxima and minima points
text(x_gss, x_gss_y, sprintf('GSS Max: (%.2f, %.2f)', x_gss, x_gss_y), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(x_fminbnd_max, x_fminbnd_max_y, sprintf('fminbnd Max: (%.2f, %.2f)', x_fminbnd_max, x_fminbnd_max_y), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(x_gss_min, x_gss_min_y, sprintf('GSS Min: (%.2f, %.2f)', x_gss_min, x_gss_min_y), 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
text(x_fminbnd_min, x_fminbnd_min_y, sprintf('fminbnd Min: (%.2f, %.2f)', x_fminbnd_min, x_fminbnd_min_y), 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');

xlabel('Suspected Cases');
ylabel('Suspected Deaths');
title('Suspected Cases and Suspected Deaths');
legend show;
grid on;

% Display Results
fprintf('\n==============================\n');
fprintf('      Optimization Results\n');
fprintf('==============================\n');

fprintf('\nGolden Section Search Results:\n');
fprintf('  Min x: %.5f\n', x_gss);
fprintf('  Min y: %.5f\n', polynomial(x_gss));
fprintf('  Iterations: %d\n', gss_iterations);

fprintf('\nfminbnd Min Results:\n');
fprintf('  Min x: %.5f\n', x_fminbnd_min);
fprintf('  Min y: %.5f\n', polynomial(x_fminbnd_min));

fprintf('\nGolden Section Search Min Results:\n');
fprintf('  Max x: %.5f\n', x_gss_min);
fprintf('  Max y: %.5f\n', polynomial(x_gss_min));

fprintf('\nfminbnd Max Results:\n');
fprintf('  Max x: %.5f\n', x_fminbnd_max);
fprintf('  Max y: %.5f\n', polynomial(x_fminbnd_max));

fprintf('\n==============================\n');
fprintf('      Error Metrics\n');
fprintf('==============================\n');
fprintf('  RMSE: %.5f\n', rmse);
fprintf('  MAE: %.5f\n', mae);
fprintf('==============================\n');


% Save log data
dlmwrite('gss_log_octave.csv', gss_log, ',');


