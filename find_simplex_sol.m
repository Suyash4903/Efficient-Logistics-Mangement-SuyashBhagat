function [ret, all_ans, maxz] = find_simplex_sol(A, b, c, list_of_basic)
    % Initialize variables
    temp = size(A);
    row = temp(1);
    col = temp(2);
    new_row = row + 1;
    new_col = col + 2;

    % Initialize simplex table
    mat = zeros(new_row, new_col);
    mat(2:end, col + 2) = b;
    mat(1, col + 2) = 0; % z = 0 for Zj - Cj row

    for i = 1:row
        mat(i + 1, 1) = list_of_basic(i, 1);
    end
    mat(2:end, 2:col + 1) = A;

    % Compute Zj - Cj
    CB = list_of_basic;
    for i = 1:length(CB)
        CB(i) = c(CB(i));
    end

    for i = 2:col + 1
        Zj = sum(CB .* mat(2:end, i));
        Cj = c(i - 1);
        mat(1, i) = Zj - Cj;
    end
    mat(1, col + 2) = sum(CB .* mat(2:end, col + 2)); % z value

    % Start simplex iterations
    count = 2;
    while (1)
        [min_element, id] = is_solution(mat);
        if (min_element == 0)
            break;
        end

        % Find leaving variable
        mrv = zeros(new_row, 1);
        mrv(1, 1) = -1;
        lv = inf;
        lvid = 0;

        for i = 2:new_row
            if (mat(i, id) > 0)
                mrv(i) = mat(i, new_col) / mat(i, id);
                if (mrv(i) < lv)
                    lv = mrv(i);
                    lvid = i;
                end
            end
        end

        if (lvid == 0)
            fprintf('Could not find leaving variable.\n');
            break;
        end

        % Pivot operation
        pivot = mat(lvid, id);
        new_mat = mat;
        new_mat(lvid, 2:end) = (1 / pivot) .* new_mat(lvid, 2:end);
        new_mat(lvid, 1) = id - 1;

        for i = 1:new_row
            if (i ~= lvid)
                factor = -1 * new_mat(i, id);
                new_mat(i, 2:end) = new_mat(i, 2:end) + factor .* new_mat(lvid, 2:end);
            end
        end
        mat = new_mat;

        fprintf('Iteration is %d\n', count);
        count = count + 1;
    end

    maxz = mat(1, new_col);
    all_ans = zeros(col, 1);
    for i = 2:new_row
        all_ans(mat(i, 1), 1) = mat(i, new_col);
    end
    ret = mat;
end
