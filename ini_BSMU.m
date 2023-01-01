function ini_BSMU(side,BSNum,MUNum,scenario)
    rng(9771);
    global AN;
    global MU;
    noiseamp = 0.01;  %param for deviation between BSs
    rowNum = sqrt(BSNum);
    gap = side/(2 * rowNum);
    [tX, tY] = meshgrid([-rowNum + 1: 2: rowNum - 1] * gap, [-rowNum + 1: 2: rowNum - 1] * gap);
    BS = tX + 1j * tY;
    BS = reshape(BS, [1, BSNum]); 
    BS = BS + noiseamp * side * (complex(rand(1, BSNum) - 0.5, rand(1, BSNum) - 0.5));  %uniform version with skews
    AN = [0 BS];
    if scenario == 0 %completely random position
        MU = side * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
    elseif scenario == 1 %Fixed density with uniform distribution
        rad = side/sqrt(BSNum);
        MU = rad * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        tv = repmat(BS,1,ceil(MUNum/BSNum));
        MU = MU + tv(1:MUNum);
    elseif scenario == 2 %Fixed density with clustered distribution
        rad = side/sqrt(BSNum);
        MU = 0.25 * rad * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        tv1 = BS + 0.75 * rad * (complex(rand(1, BSNum)-0.5, rand(1, BSNum) - 0.5));
        tv2 = repmat(tv1,1,ceil(MUNum/BSNum));
        MU = MU + tv2(1:MUNum);
    elseif scenario == 3 %Variable density with uniform distribution
        rad = side/sqrt(BSNum);
        MU = rad * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
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
        rad = side/sqrt(BSNum);
        MU =  0.25 * rad * (complex(rand(1, MUNum)-0.5, rand(1, MUNum) - 0.5));
        tv1 = BS + 0.75 * rad * (complex(rand(1, BSNum)-0.5, rand(1, BSNum) - 0.5));
        Nd = randi([1,floor(BSNum/2)],1);
        tb = randperm(BSNum);
        DenseBS = tb(1:Nd);
        sparseBS = setdiff([1:BSNum],DenseBS);
        tv2 = zeros(1,BSNum);
        tv2(DenseBS) = 0.9/Nd;
        tv2(sparseBS) = 0.1/(BSNum-Nd);
        disp(DenseBS);
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