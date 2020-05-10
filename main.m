clc,clear,close all
warning off
format longG
% WDO分驱动优化算法 参数
RT = 3;
g = 0.3;
alpha = 0.35;
c = 0.42;
maxgen = 200;   % 迭代次数
sizepop = 20;  % 种群数量
popmin1 = -1;  popmax1 = 1; % x1
popmin2 = -1;  popmax2 = 1; % x2
nvar = 2;   % 2个未知量
Vmin = -1;  % 最小速度
Vmax = 1;   % 最大速度
% 初始化种群
for i=1:sizepop
    x1 = popmin1 + (popmax1-popmin1)*rand;
    x2 = popmin2 + (popmax2-popmin2)*rand;
    pop(i,1) = x1;
    pop(i,2) = x2;
    fitness(i) = fun([x1,x2]);
    V(i,1) = Vmin + (Vmax-Vmin)*rand;
    V(i,2) = Vmin + (Vmax-Vmin)*rand;
end
% 记录一组最优值
[bestfitness,bestindex]=min(fitness);
zbest=pop(bestindex,:);   % 全局最佳
fitnesszbest=bestfitness; % 全局最佳适应度值

[minfitness,index] = sort(fitness,'descend'); % 升序
pop = pop(index,:);
V = V(index,:);
%% 迭代寻优
for i = 1:maxgen
    for j=1:sizepop
        % 速度更新
        V(j,:) = (1-alpha)*V(j,:)-g*pop(j,:)+...
            (RT*abs(1/i-1)*(zbest-pop(j,:)))+...
            c*V(j,:)/i;
        
        % V--x1
        if V(j,1)>Vmax
            V(j,1)=Vmax;
        end
        if V(j,1)<Vmin
            V(j,1)=Vmin;
        end
        % V--x2
        if V(j,2)>Vmax
            V(j,2)=Vmax;
        end
        if V(j,2)<Vmin
            V(j,2)=Vmin;
        end
        
        % 位置更新
        pop(j,:) = pop(j,:)+V(j,:);
        
        % x1
        if pop(j,1)>popmax1
            pop(j,1)=popmax1;
        end
        if pop(j,1)<popmin1
            pop(j,1)=popmin1;
        end
        % x2
        if pop(j,2)>popmax2
            pop(j,2)=popmax2;
        end
        if pop(j,2)<popmin2
            pop(j,2)=popmin2;
        end
        
        % 适应度更新
        fitness(j) = fun(pop(j,:));
        
        % 比较 个体间比较
        if fitness(j)<bestfitness
            bestfitness = fitness(j);
            zbest =  pop(j,:);
        end
        
    end
   
    fitness_iter(i) = bestfitness;
   
    [minfitness,index] = sort(fitness,'descend'); % 升序
    pop = pop(index,:);
    V = V(index,:);
   
end

disp('最优解')
disp(zbest)
fprintf('\n')

figure('color',[1,1,1])
% plot(fitness_iter,'ro-','linewidth',2)
loglog(fitness_iter,'ro-','linewidth',2)
axis tight
grid on