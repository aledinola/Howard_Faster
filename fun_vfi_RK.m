function [V1,Policy] = fun_vfi_RK(N_a,N_z,pi_z,ReturnMat,beta,verbose)

% Based on 
% https://github.com/vfitoolkit/VFIToolkit-matlab/blob/master/ValueFnIter/InfHorz/ValueFnIter_Case1_NoD_raw.m
tol   = 1e-5;
maxit = 600;
Howards = 100;

V0 = zeros(N_a,N_z);
V1 = zeros(N_a,N_z);
Policy = ones(N_a,N_z);

err = tol+1;
iter = 1;

while err>tol && iter<=maxit

    for z_c=1:N_z
        EV_z=V0.*kron(ones(N_a,1),pi_z(z_c,:));
        %EV_z(isnan(EV_z))=0; %multilications of -Inf with 0 gives NaN, this replaces them with zeros (as the zeros come from the transition probabilites)
        EV_z=sum(EV_z,2);
        for a_c=1:N_a
            entireRHS = ReturnMat(:,a_c,z_c)+beta*EV_z;
            [max_val,max_ind] = max(entireRHS);
            V1(a_c,z_c) = max_val;
            Policy(a_c,z_c) = max_ind;
        end
    end

    % Howard
    Ftemp = zeros(N_a,N_z);
    for z_c=1:N_z
        for a_c=1:N_a
            Ftemp(a_c,z_c) = ReturnMat(Policy(a_c,z_c),a_c,z_c);
        end
    end

    for Howards_counter=1:Howards
        Vtemp=V1;
        for z_c=1:N_z
            EVtemp_z=Vtemp(Policy(:,z_c),:).*kron(pi_z(z_c,:),ones(N_a,1)); %kron(pi_z(z_c,:),ones(nquad,1))
            %EVtemp_z(isnan(EVtemp_z))=0; %Multiplying zero (transition prob) by -Inf (value fn) gives NaN
            V1(:,z_c)=Ftemp(:,z_c)+beta*sum(EVtemp_z,2);
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