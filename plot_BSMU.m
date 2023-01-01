function plot_BSMU(BSNum,side,scenario)
    global AN;
    global MU;
    global X;
    a = plot([100000],[0],'r.','MarkerSize',15); hold on;
    b = plot([100000],[1],'b.','MarkerSize',15); hold on;
    labels = reshape(split(num2str(1: 1: BSNum)), 1, BSNum); 
    figure(1); xlabel('x-axis(m)'); ylabel('y-axis(m)'); hold on;%title('Overview');
    satellite = find(X(1,:));
    if scenario == 1 | scenario == 3
        for i = 1:length(MU)
            ANidx = find(X(:,i));
            if(abs(MU(i)-AN(ANidx))>side/2-1000) & isempty(find(satellite==i))
                satellite = [satellite,i];
            end
        end
    end
    terristrial = setdiff([1:length(MU)],satellite);
    plot(MU(satellite)/3,'r.'); hold on;
    plot(MU(terristrial)/3,'b.'); hold on;
    c =plot(AN(2)/3,'k^'); hold on;
    plot(AN(3:BSNum+1)/3,'k^'); hold on;
    text(real(AN(2:BSNum+1))/3, imag(AN(2:BSNum+1))/3, labels, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left','FontSize',14); hold on;
    for i = 2:length(AN)
        temp_vx = real(AN(i))/3+ side/sqrt(3)* cos((0:6)*pi/3)/3 ; 
        temp_vy = imag(AN(i))/3+ side/sqrt(3)* sin((0:6)*pi/3)/3 ; 
        plot(temp_vx,temp_vy,'k-'); hold on;
    end
    legend([c,a,b],'BS','MU - satellite','MU - BSs','FontSize',12);
    hold off;
    if scenario == 3
        scenario = 2;
    elseif scenario == 2
        scenario = 3;
    end
    xlim([-4*10^4 4*10^4]); hold on;
    saveas(gcf,'scenario/'+string(scenario)+'.jpg');
end