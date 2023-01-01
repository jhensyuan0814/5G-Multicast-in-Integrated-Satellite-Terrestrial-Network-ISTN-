function printW(SFNNum)
    global W;
    for i = 1:SFNNum
        fprintf("SFN %d has ",i);
        fprintf("%d ",find(W(i,:)));
        fprintf("\n");
    end
    fprintf("$$$$$$$$$$$$$$$\n");
end
