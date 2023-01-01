function ini_ourSFN(ANNum,version)
    global W;
    global bottle_QoE;  
    global SFNNum;
    if version ==2 | version == 4
         W = zeros(2,ANNum);  %satellite + 1 SFN composed of all BSs
         W(1,1) = 1;
         W(2,:) = ones(1,ANNum);
         W(2,1) = 0;
         bottle_QoE = zeros(1,2);
         SFNNum = 2;
    elseif version == 3 && (ANNum == 20 || ANNum == 8)
        reuse_factor = 3; %3 or 4
        W = zeros(reuse_factor+1,ANNum);
        W(1,1) = 1;
        W(2,2) = 1; %first wrap
        for i = 3:reuse_factor+1 %second wrap
            for j = 3:(reuse_factor-1):8
                W(i,i-3+j) = 1; 
            end
        end
        if(ANNum == 20)
           W(2,[9:2:ANNum]) = 1; %third wrap
           for i = 10:2:ANNum
               W(mod(floor(i/2),reuse_factor-1)+3,i) = 1;
           end
        end
        bottle_QoE = zeros(1,ANNum);
        SFNNum = reuse_factor+1;
    else
         W = diag(ones(1,ANNum)); %BS x belongs to SFN x
         bottle_QoE = zeros(1,ANNum);
         SFNNum = ANNum;
    end
end