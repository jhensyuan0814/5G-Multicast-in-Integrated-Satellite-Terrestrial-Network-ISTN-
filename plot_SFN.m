function plot_SFN(BSNum,side,scenario)
    global AN;
    global W;
    global SFNNum;
    labels = reshape(split(num2str(1: 1: BSNum)), 1, BSNum); 
    figure(2); xlabel('x-axis(m)'); ylabel('y-axis(m)'); hold on;%title('Overview');
    
    
    for i = 2:length(AN)
        temp_vx = real(AN(i))/3+ side/sqrt(3)* cos((0:6)*pi/3)/3 ; 
        temp_vy = imag(AN(i))/3+ side/sqrt(3)* sin((0:6)*pi/3)/3 ; 
        plot(temp_vx,temp_vy,'k-'); hold on;
    end
    colors = get(gca,'colororder');
    p = [];
    s = zeros(1,SFNNum-1);
    s = string(s);
    for j = 2:SFNNum
        BSs = find(W(j,:));
        for i = 1:length(BSs)
            temp_vx = real(AN(BSs(i)))/3+ side/sqrt(3)* cos((0:6)*pi/3)/3 ; 
            temp_vy = imag(AN(BSs(i)))/3+ side/sqrt(3)* sin((0:6)*pi/3)/3 ;
            a = fill(temp_vx,temp_vy,colors(mod((j-2),7)+1,:));  hold on;
        end
         p = [p a];
         s(j-1) = sprintf("SFN %d",j-1);
    end
    c =plot(AN(2)/3,'k^'); hold on;
    plot(AN(3:BSNum+1)/3,'k^'); hold on;
    text(real(AN(2:BSNum+1))/3, imag(AN(2:BSNum+1))/3, labels, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left','FontSize',14); hold on;
    p = [p c];
    s = [s 'BS'];
    legend(p,s,'FontSize',12);
    hold off;
    if scenario == 3
        scenario = 2;
    else if scenario == 2
            scenario = 3;
    end
    saveas(gcf,'SFN/'+string(scenario)+'.jpg');
end