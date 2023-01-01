function ini_BSMU_hex(R,BSNum,MUNum,scenario)
    rng(9163);
    global AN;
    global MU;
    h = R*sqrt(3)/2;
    side = R/sqrt(3);
    center_x = cat(2,0, R*cos(pi*[1/6:1/3:11/6]),2*R*cos(pi*[0:1/6:11/6]));
    center_y = cat(2,0, R*sin(pi*[1/6:1/3:11/6]),2*R*sin(pi*[0:1/6:11/6]));
    BS = complex(center_x,center_y);
    BS = BS(1:BSNum);
    AN = [0 BS];
    %disp(AN);
    if scenario == 0 %completely random position
        bound = max(center_y(1:BSNum))*2 + R;
        temp_cx = bound*(rand(1,4*MUNum)-0.5);
        temp_cy = bound*(rand(1,4*MUNum)-0.5);
        IN = zeros(1,4*MUNum);
        for i = 1:BSNum
            temp_vx = center_x(i)+ side* cos((0:6)*pi/3) ; 
            temp_vy = center_y(i)+ side* sin((0:6)*pi/3) ; 
            IN = IN | inpolygon(temp_cx, temp_cy, temp_vx, temp_vy);
        end
        temp_cx = temp_cx(IN); temp_cy = temp_cy(IN);
        index = randperm(MUNum);
        MU = complex(temp_cx(index),temp_cy(index));
    elseif scenario == 1 %Fixed density with uniform distribution
        MU = R * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        tv = repmat(BS,1,ceil(MUNum/BSNum));
        MU = MU + tv(1:MUNum);
    elseif scenario == 2 %Fixed density with clustered distribution
        MU = 0.25 * R * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        tv1 = BS + 0.75 * R * (complex(rand(1, BSNum)-0.5, rand(1, BSNum) - 0.5));
        tv2 = repmat(tv1,1,ceil(MUNum/BSNum));
        MU = MU + tv2(1:MUNum);
    elseif scenario == 3 %Variable density with uniform distribution
        MU = R * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        Nd = randi([1,floor(BSNum/2)],1);
        tb = randperm(BSNum);
        DenseBS = tb(1:Nd);
        sparseBS = setdiff([1:BSNum],DenseBS);
        tv1 = zeros(1,BSNum);
        tv1(DenseBS) = 0.9/Nd;
        tv1(sparseBS) = 0.1/(BSNum-Nd);
        %disp(DenseBS);
        c = cumsum(tv1);
        r = rand(MUNum, 1);
        x = arrayfun(@(x) find(x <= c, 1, 'first'), r);
        h = hist(x, 1:BSNum); %number of MUs for each BS
        %disp(h);
        h = cumsum(h);
        %disp(h);
        if h(1) >= 1
            MU(1:h(1)) = MU(1:h(1)) + BS(1);
        end
        for i = 2:BSNum
            if h(i) >= h(i-1)+1
                MU((h(i-1)+1):h(i)) = MU((h(i-1)+1):h(i)) + BS(i);
            end
        end
    elseif scenario == 4 %Variable density with clustered distribution
        MU =  0.25 * R * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        tv1 = BS + 0.75 * R * (complex(rand(1, BSNum)-0.5, rand(1, BSNum) - 0.5));
        Nd = randi([1,floor(BSNum/2)],1);
        tb = randperm(BSNum);
        DenseBS = tb(1:Nd);
        sparseBS = setdiff([1:BSNum],DenseBS);
        tv2 = zeros(1,BSNum);
        tv2(DenseBS) = 0.9/Nd;
        tv2(sparseBS) = 0.1/(BSNum-Nd);
        %disp(DenseBS);
        c = cumsum(tv2);
        r = rand(MUNum, 1);
        x = arrayfun(@(x) find(x <= c, 1, 'first'), r);
        h = hist(x, 1:BSNum); %number of MUs for each BS
        %disp(h);
        h = cumsum(h);
        %disp(h);
        if h(1) >= 1
            MU(1:h(1)) = MU(1:h(1)) + tv1(1);
        end
        for i = 2:BSNum
            if h(i) >= h(i-1)+1
                MU((h(i-1)+1):h(i)) = MU((h(i-1)+1):h(i)) + tv1(i);
            end
        end
    end
end