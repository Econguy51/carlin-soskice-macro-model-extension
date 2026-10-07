clear; clc; close all;
%% 1. Fixed Base Parameters
alpha = 0.5; 
gamma = 0.2; 
theta = 0.8; 
cY = 0.6; 
iR = -0.5; 

%% 2. Define Sweep Resolution
resolution = 200;
phi_Y_range = linspace(0, 5, resolution);
phi_P_range = linspace(0, 30, resolution);
% Preallocate stability grid (0 = unstable, 1 = stable)
stability_grid = zeros(resolution, resolution);

%% 3. Execute Parameter Sweep Loop
for i = 1:resolution
 for j = 1:resolution
 current_phi_Y = phi_Y_range(i);
 current_phi_P = phi_P_range(j);
 
 % Construct Jacobian for current pair
 J11 = alpha * (cY - 1); 
 J12 = 0; 
 J13 = alpha * iR;
 J21 = gamma; 
 J22 = 0; 
 J23 = 0;
 J31 = theta * current_phi_Y; 
 J32 = theta * current_phi_P; 
 J33 = -theta;
 
 J = [J11, J12, J13; J21, J22, J23; J31, J32, J33];
 
 % Evaluate Routh-Hurwitz Coefficients
 poly_coeffs = poly(J);
 a1 = poly_coeffs(2); 
 a2 = poly_coeffs(3); 
 a3 = poly_coeffs(4);
 
 % Check conditions
 cond1 = (a1 > 0);
 cond2 = (a3 > 0);
 cond3 = ((a1 * a2) > a3);
 
 if cond1 && cond2 && cond3
 stability_grid(j, i) = 1; % Stable
 end
 end
end

%% 4. Plot the Stability Map
figure('Color', 'w');
imagesc(phi_Y_range, phi_P_range, stability_grid);
set(gca, 'YDir', 'normal'); % Flip axis to standard Cartesian
colormap([1 0.4 0.4; 0.4 0.8 0.4]); % Red for unstable, Green for stable
hold on;
% Plot the exact analytical boundary line: phi_P = 4 + 5*phi_Y
analytical_phi_P = 4 + 5 * phi_Y_range;
plot(phi_Y_range, analytical_phi_P, 'k--', 'LineWidth', 2);
title('Macroeconomic System Stability Map');
xlabel('Output Gap Aggressiveness (\phi_Y)');
ylabel('Inflation Aggressiveness (\phi_P)');
grid on;
legend('Boundary (\phi_P = 4 + 5\phi_Y)', 'Location', 'NorthWest');
fprintf('Sweep complete. Analytical Boundary: phi_P = 4 + 5 * phi_Y\n');

% =========================================================================
% AI DISCLOSURE: 
% Portions of this script were generated using Google Gemini Chat (Gemini 2.5 Pro)
% (August 2026). Specifically, AI was used to draft the 
% mathematical implementation of the nested loops for the parameter sweep.
% =========================================================================
