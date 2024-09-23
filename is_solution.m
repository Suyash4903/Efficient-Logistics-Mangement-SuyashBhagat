function [ret, id] = is_solution(mat)
    % Check if the current simplex table has a valid solution
    ret = min(mat(1, 2:end - 1));
    temp = size(mat);
    row = temp(1);
    col = temp(2);

    for i = 2:col - 1
        if (ret == mat(1, i))
            id = i;
            break;
        end
    end
end
