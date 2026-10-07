clear; clc; close all;
%% 1. Define Model Parameters
alpha = 0.5; % Goods market speed of adjustment
gamma = 0.2; % Price/Inflation adjustment speed
cY = 0.6; % Marginal propensity to consume (0 < cY < 1)
iR = -0.5; % Investment sensitivity to interest rate (iR < 0)
phi_Y = 0.4; % Policy responsiveness to output gap (phi_Y > 0)
phi_P = 1.5; % Policy responsiveness to price/inflation (phi_P > 0)

%% 2. Construct the 2x2 Jacobian Matrix (J)
J11 = alpha * (cY - 1 + iR * phi_Y);
J12 = alpha * iR * phi_P;
J21 = gamma;
J22 = 0;
J = [J11, J12; J21, J22];

%% 3. Calculate Trace, Determinant, and Routh-Hurwitz
tr_J = trace(J);
det_J = det(J);
disc_J = tr_J^2 - 4*det_J;
disp(J);
disp(tr_J);
disp(det_J);
disp(disc_J);

%% 3. Dynamic Simulation Configuration (ode45)
% Define the system of differential equations: dX/dt = J * X
% where X = [Y; P]
macro_system = @(t, X) [J11*X(1) + J12*X(2); 
 J21*X(1) + J22*X(2)];

% Simulation conditions: Start from a major economic shock
tspan = [0, 25]; % Time horizon (0 to 25 periods)
Y0 = 2.5; P0 = -2.0; % Initial state: positive output gap, low prices
X0 = [Y0; P0];

% Execute numerical solver
[t_vec, X_sim] = ode45(macro_system, tspan, X0);
Y_sim = X_sim(:, 1);
P_sim = X_sim(:, 2);

%% 4. Visualization Setup
figure('Color', 'white', 'Position', [100, 100, 1100, 500]);

% --- SUBPLOT 1: Phase Portrait & Nullclines ---
subplot(1, 2, 1);
[Y_grid, P_grid] = meshgrid(linspace(-3, 3, 20), linspace(-3, 3, 20));
dY = J11 * Y_grid + J12 * P_grid;
dP = J21 * Y_grid + J22 * P_grid;

% Plot vector field
quiver(Y_grid, P_grid, dY, dP, 1.5, 'Color', [0.7 0.7 0.7], 'HandleVisibility', 'off');
hold on;

% Plot Nullclines
% dY/dt = 0 => P = (-J11/J12) * Y
Y_vals = linspace(-3, 3, 100);
P_null_dY = (-J11 / J12) * Y_vals;
plot(Y_vals, P_null_dY, 'r--', 'LineWidth', 2, 'DisplayName', 'dY/dt = 0 Nullcline');

% dP/dt = 0 => J21 * Y = 0 => Y = 0 (Vertical line)
line([0, 0], [-3, 3], 'Color', 'b', 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'dP/dt = 0 Nullcline');

% Plot Simulated Time Path Trajectory
plot(Y_sim, P_sim, 'k-', 'LineWidth', 2.5, 'DisplayName', 'ode45 Trajectory');
plot(Y0, P0, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g', 'DisplayName', 'Initial Shock (X_0)');
plot(0, 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Steady State (Origin)');
xlabel('Output Gap (Y)', 'FontSize', 11);
ylabel('Price Level (P)', 'FontSize', 11);
title('Phase Space with Nullclines', 'FontSize', 12, 'FontWeight', 'bold');
grid on; axis([-3 3 -3 3]); box on;
legend('Location', 'southwest');

% --- SUBPLOT 2: Dynamic Time-Path Simulation ---
subplot(1, 2, 2);
plot(t_vec, Y_sim, 'Color', [0 0.447 0.741], 'LineWidth', 2, 'DisplayName', 'Output Gap (Y)');
hold on;
plot(t_vec, P_sim, 'Color', [0.85 0.325 0.098], 'LineWidth', 2, 'DisplayName', 'Price Level (P)');
xlabel('Time (t)', 'FontSize', 11);
ylabel('Variable Value', 'FontSize', 11);
title('Dynamic Macroeconomic Time Paths', 'FontSize', 12, 'FontWeight', 'bold');
grid on; box on;
legend('Location', 'northeast');

% =========================================================================
% AI DISCLOSURE: 
% Portions of this script were generated using Google Gemini Chat (Gemini 2.5 Pro)
% (August 2026). Specifically, AI was used to generate the meshgrid phase diagram.
% =========================================================================
