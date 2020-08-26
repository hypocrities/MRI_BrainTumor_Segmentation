function phi = drlse_edge(phi_0, g, alfa, timestep, iter)
%  根据迭代方程使水平集函数逐步演化
%  输入水平集函数及其他参数，输出更新后水平集函数


phi=phi_0;
[gx, gy]=gradient(g);   %求梯度
for k=1:iter
    [phi_x,phi_y]=gradient(phi);
    s=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=1e-10;  
    Nx=phi_x./(s+smallNumber); % 加上一个小正数，避免被0除
    Ny=phi_y./(s+smallNumber);
    curvature=div(Nx,Ny);  %求曲率   
   

    dx_f=Dx_forward(phi);
    dy_f=Dy_forward(phi);
    dx_b=Dx_backward(phi);
    dy_b=Dy_backward(phi);
    norm_grad_p_u =sqrt((max(dx_b,0)).^2+(min(dx_f,0)).^2  + (max(dy_b,0)).^2+(min(dy_f,0)).^2);
    norm_grad_n_u=sqrt((max(dx_f,0)).^2+(min(dx_b,0)).^2  + (max(dy_f,0)).^2+(min(dy_b,0)).^2); 

    phi=phi+timestep*(g.*s.*curvature + alfa*(max(g,0).*norm_grad_p_u + min(g,0).*norm_grad_n_u) + (max(gx,0).*dx_b + min(gx,0).*dx_f + max(gy,0).*dy_b + min(gy,0).*dy_f));
end




function f = div(nx,ny)
[nxx,junk]=gradient(nx);  
[junk,nyy]=gradient(ny);
f=nxx+nyy;

function fx=Dx_forward(f);
% computes forward difference 
[nr,nc]=size(f);
fx=zeros(nr,nc);
fx(:,1:nc-1)=f(:,2:nc)-f(:,1:nc-1);
fx(:,nc) = f(:,nc)-f(:,nc-1);  

function fx=Dx_backward(f);
% computes backward difference 
[nr,nc]=size(f);
fx=zeros(nr,nc);
fx(:,2:nc)=f(:,2:nc)-f(:,1:nc-1);
fx(:,1)=f(:,2)-f(:,1);

function fy=Dy_forward(f);
% computes forward difference 
[nr,nc]=size(f);
fy=zeros(nr,nc);
fy(1:nr-1,:)=f(2:nr,:)-f(1:nr-1,:);
fy(nr,:)=f(nr,:)-f(nr-1,:);  

function fy=Dy_backward(f);
% computes backward difference 
[nr,nc]=size(f);
fy=zeros(nr,nc);
fy(2:nr,:)=f(2:nr,:)-f(1:nr-1,:);
fy(1,:)=f(2,:)-f(1,:); 

