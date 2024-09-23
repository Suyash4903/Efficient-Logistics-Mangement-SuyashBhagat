function simplex_function()
    clear all;
    close all;
    clc;

    % Sample test case 1
    % Maximize z = 4*x1 + 5*x2
    % Subject to:
    % 2*x1 + 3*x2 + x3 = 1
    % x1 + x2 + x4 = 1
    % x1, x2, x3, x4 >= 0
    mat = [2 3 1 0; 1 1 0 1];
    b = [1; 1];
    objective = [4 5 0 0]; % Maximize case
    
    % Phase 1: Solve for artificial variables
    no_of_var = length(objective);
    no_of_con = length(b);

    for i = 1:length(b)
        if (b(i) < 0)
            mat(i, :) = -1 .* mat(i, :);
            b(i) = -1 * b(i);
        end
    end

    % Create phase 1 objective function
    obj1 = zeros(1, no_of_var + no_of_con);
    for i = 1:no_of_con
        obj1(i + no_of_var) = -1;
    end

    % Update the constraints matrix with artificial variables
    new_mat = [mat, eye(no_of_con)];
    list_of_basic1 = zeros(no_of_con, 1);
    for i = 1:no_of_con
        list_of_basic1(i, 1) = i + no_of_var;
    end

    % Run simplex method for phase 1
    [ret1, all_ans1, maxz1] = find_simplex_sol(new_mat, b, obj1, list_of_basic1);

    % Phase 2
    obj2 = objective; % Original objective
    list_of_basic2 = ret1(2:end, 1);
    b2 = ret1(2:end, end);
    A = ret1(2:end, 2:no_of_var + 1);

    % Solve phase 2
    [final_simplex_table, solution_of_lpp, maximized_z] = find_simplex_sol(A, b2, obj2, list_of_basic2);
end
