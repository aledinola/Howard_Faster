function [V1,Policy] = fun_vfi(n_a,n_z,pi_z,ReturnMat,beta,verbose)

tol   = 1e-5;
maxit = 600;
maxit_howard = 100;

pi_z_transpose = pi_z';

V0 = zeros(n_a,n_z);
V1 = zeros(n_a,n_z);
Policy = ones(n_a,n_z);

err = tol+1;
iter = 1;

while err>tol && iter<=maxit

    % V0(a',z')*pi_z(z,z')^T ==> EV(a',z)
    EV = V0*pi_z_transpose; 

    for z_c=1:n_z
        for a_c=1:n_a
            entireRHS = ReturnMat(:,a_c,z_c)+beta*EV(:,z_c);
            [max_val,max_ind] = max(entireRHS);
            V1(a_c,z_c) = max_val;
            Policy(a_c,z_c) = max_ind;
        end
    end

    % Howard
    Ftemp = zeros(n_a,n_z);
    for z_c=1:n_z
        for a_c=1:n_a
            Ftemp(a_c,z_c) = ReturnMat(Policy(a_c,z_c),a_c,z_c);
        end
    end

    for iter_h=1:maxit_howard
        Vtemp = V1;
        for z_c=1:n_z
            EV_z = Vtemp(Policy(:,z_c),:)*pi_z(z_c,:)';
            V1(:,z_c) = Ftemp(:,z_c)+beta*EV_z;
        end
    end

    err = max(max(abs(V1-V0)));

    if verbose==1
        fprintf('iter = %d, err = %f \n',iter,err)
    end

    % Update
    V0 = V1;
    iter = iter+1;


end %end while

end %end function