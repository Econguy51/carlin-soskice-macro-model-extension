clear; clc; close all;
%% 1. Define Model Parameters
alpha = 0.5; % Goods market speed of adjustment
gamma = 0.2; % Price/Inflation adjustment speed
theta = 0.8; % Central bank policy smoothing/adjustment speed (new for 3x3)
cY = 0.6; % Marginal propensity to consume (0 < cY < 1)
iR = -0.5; % Investment sensitivity to interest rate (iR < 0)
phi_Y = 0.4; % Policy responsiveness to output gap (phi_Y > 0)
phi_P = 1.5; % Policy responsiveness to price/inflation (phi_P > 0)

%% 2. Construct the 3x3 Jacobian Matrix (J)
% State vector x = [Y; P; R]
% dY/dt = alpha * (cY * Y - Y + iR * R)
% dP/dt = gamma * Y
% dR/dt = theta * (phi_Y * Y + phi_P * P - R)
J11 = alpha * (cY - 1); J12 = 0; J13 = alpha * iR;
J21 = gamma; J22 = 0; J23 = 0;
J31 = theta * phi_Y; J32 = theta * phi_P; J33 = -theta;
J = [J11, J12, J13;
 J21, J22, J23;
 J31, J32, J33];

%% 3. Calculate Trace, Determinant, and Polynomial Coefficients
matrix_trace = trace(J);
matrix_det = det(J);
% Characteristic Polynomial: lambda^3 + a1*lambda^2 + a2*lambda + a3 = 0
% We can find these coefficients using the poly() function or analytically
poly_coeffs = poly(J); 
a1 = poly_coeffs(2); % Equals -trace(J)
a2 = poly_coeffs(3); % Equals sum of principal minors
a3 = poly_coeffs(4); % Equals -det(J)
fprintf('=== 3x3 Jacobian Matrix Metrics ===\n');
disp('Jacobian Matrix (J):');
disp(J);
fprintf('Trace (Tr) : %.4f\n', matrix_trace);
fprintf('Determinant (Det) : %.4f\n\n', matrix_det);
fprintf('=== Characteristic Polynomial Coefficients ===\n');
fprintf('a1 (lambda^2 coeff) : %.4f\n', a1);
fprintf('a2 (lambda^1 coeff) : %.4f\n', a2);
fprintf('a3 (constant term) : %.4f\n\n', a3);

%% 4. Routh-Hurwitz Stability Criterion for 3x3 Systems
% For a 3x3 system to be stable, the Routh-Hurwitz conditions require:
% 1) a1 > 0
% 2) a3 > 0
% 3) a1 * a2 > a3
cond1 = (a1 > 0);
cond2 = (a3 > 0);
cond3 = ((a1 * a2) > a3);
fprintf('--- Routh-Hurwitz Stability Check ---\n');
fprintf('Condition 1 (a1 > 0) : %s (Value: %.4f)\n', string(cond1), a1);
fprintf('Condition 2 (a3 > 0) : %s (Value: %.4f)\n', string(cond2), a3);
fprintf('Condition 3 (a1 * a2 > a3) : %s (Value: %.4f > %.4f)\n\n', string(cond3), a1*a2, a3);
if cond1 && cond2 && cond3
 disp('Result: The 3x3 economic system is asymptotically stable.');
else
 disp('Result: The 3x3 economic system is unstable.');
end

%% 5. 3D Phase Space Trajectory Generation
% Since it's a 3D system, a 3D stream/trajectory line replaces the 2D plane grid
figure('Color', 'white');
[X, Y, Z] = meshgrid(linspace(-2,2,8), linspace(-2,2,8), linspace(-2,2,8));
% Compute vector field
U = J(1,1)*X + J(1,2)*Y + J(1,3)*Z;
V = J(2,1)*X + J(2,2)*Y + J(2,3)*Z;
W = J(3,1)*X + J(3,2)*Y + J(3,3)*Z;
% Plot 3D vectors
quiver3(X, Y, Z, U, V, W, 1.2, 'Color', [0.7 0.7 0.7]);
hold on;
% Simulate and plot a sample trajectory starting away from equilibrium
tspan = 0:0.1:30;
initial_state = [1.5; -1.0; 2.0]; % Initial [Y; P; R]
[t, states] = ode45(@(t,x) J*x, tspan, initial_state);
plot3(states(:,1), states(:,2), states(:,3), 'b-', 'LineWidth', 2.5);
plot3(initial_state(1), initial_state(2), initial_state(3), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); % Start
plot3(0, 0, 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Origin Equilibrium
xlabel('Output Gap (Y)');
ylabel('Price Level (P)');
zlabel('Interest Rate (R)');
title('3D Phase Space Trajectory and Vector Field');
grid on;
view(45, 20);

% =========================================================================
% AI DISCLOSURE: 
% Portions of this script were generated using Google Gemini Chat (Gemini 2.5 Pro)
% (August 2026). Specifically, AI was used to draft the 
% mathematical implementation of the meshgrid phase diagram and the Routh-Hurwitz array formulation.
% =========================================================================
