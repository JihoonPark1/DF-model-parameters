function [Wfd, Fstr, iternum, iterhist] = ...
   posfd(y, argvals, Wfd, Lfdobj, lambda, iterlim, conv, dbglev)
%POSFD fits a positive function to a sample of scalar observations.
%  What is estimated is the log fit, W(t), and the actual fit is exp(W)

%  Arguments are:
%  Y       ... A vector of data values
%  ARGVALS ... A vector of argument values
%  WFD     ... functional data object defining initial log fit
%  LFDOBJ  ... linear differential operator defining roughness penalty
%  LAMBDA  ... smoothing parameter
%  ITERLIM ... iteration limit for scoring iterations
%  CONV    ... convergence criterion
%  DBGLEV  ... level of output of computation history

%  Returns:
%  WFD      ... functional data object defining final log fit
%  FSTR     ... Struct object containing
%               FSTR.F    ... final log likelihood
%               FSTR.NORM ... final norm of gradient
%  ITERNUM  ... Number of iterations
%  ITERHIST ... History of iterations

%  last modified 14 June 2003

if nargin < 2
   error('Less than two arguments are supplied.');
end

%  ensure that both argvals and y are column vectors

if size(argvals,1) > 1 & size(argvals,2) > 1
    error('Argument ARGVALS is not a vector.');
end
if size(y,1) > 1 & size(y,2) > 1
    error('Argument Y is not a vector.');
end
argvals = argvals(:);
y       = y(:);

%  get basis information

basisobj = getbasis(Wfd);
nbasis   = getnbasis(basisobj);
rangex   = getbasisrange(basisobj);
active   = 1:nbasis;
phimat   = getbasismatrix(argvals, basisobj);

%  deal with values out of range

inrng = find(argvals >= rangex(1) & argvals <= rangex(2));
if (length(inrng) ~= length(argvals))
    warning('Some values in X out of range and not used.');
end

argvals = argvals(inrng);
y       = y(inrng);
nobs    = length(argvals);

%  set some default arguments and constants

if nargin < 8, dbglev  = 1;          end
if nargin < 7, conv    = 1e-3;       end
if nargin < 6, iterlim = 50;         end
if nargin < 5, lambda  = 0;          end
if nargin < 4, Lfdobj  = int2Lfd(3); end

%  check LFDOBJ

Lfdobj = int2Lfd(Lfdobj);

%  set up some arrays

climit = [-50,0;0,400]*ones(2,nbasis);
cvec0  = getcoef(Wfd);
hmat   = zeros(nbasis);
dbgwrd = dbglev > 1;

%  initialize matrix Kmat defining penalty term

if lambda > 0
  Kmat = lambda.*eval_penalty(basisobj, Lfdobj);
end

%  evaluate log likelihood
%    and its derivatives with respect to these coefficients

[logl, Dlogl] = loglfnpos(argvals, y, phimat, cvec0);

%  compute initial badness of fit measures

Foldstr.f = -logl;
gvec      = -Dlogl;
if lambda > 0
   gvec = gvec + 2.*(Kmat * cvec0);
   Foldstr.f = Foldstr.f + cvec0' * Kmat * cvec0;
end
Foldstr.norm = sqrt(mean(gvec.^2));

%  compute the initial expected Hessian

hmat = loglhesspos(argvals, y, phimat, cvec0);
if lambda > 0
    hmat = hmat + 2.*Kmat;
end

%  evaluate the initial update vector for correcting the initial bmat

deltac   = -hmat\gvec;
cosangle = -gvec'*deltac/sqrt(sum(gvec.^2)*sum(deltac.^2));

%  initialize iteration status arrays

iternum = 0;
status = [iternum, Foldstr.f, -logl, Foldstr.norm];
fprintf('\nIteration  Criterion  Neg. Log L  Grad. Norm\n')
fprintf('\n%5.f     %10.4f %10.4f %10.4f\n', status);
iterhist = zeros(iterlim+1,length(status));
iterhist(1,:)  = status;
if iterlim == 0
    Fstr = Foldstr;
    iterhist = iterhist(1,:);
    return;
end

%  -------  Begin iterations  -----------

STEPMAX = 5;
MAXSTEP = 400;
trial   = 1;
cvec    = cvec0;
linemat = zeros(3,5);

for iter = 1:iterlim
    iternum = iternum + 1;
    %  take optimal stepsize
    dblwrd = [0,0]; limwrd = [0,0]; stpwrd = 0; ind = 0;
    %  compute slope
    Fstr = Foldstr;
    linemat(2,1) = sum(deltac.*gvec);
    %  normalize search direction vector
    sdg     = sqrt(sum(deltac.^2));
    deltac  = deltac./sdg;
    dgsum   = sum(deltac);
    linemat(2,1) = linemat(2,1)/sdg;
    %  return with error condition if initial slope is nonnegative
    if linemat(2,1) >= 0
        disp('Initial slope nonnegative.')
        ind = 3;
        iterhist = iterhist(1:(iternum+1),:);
        break;
    end
    %  return successfully if initial slope is very small
    if linemat(2,1) >= -1e-5;
        if dbglev>1, disp('Initial slope too small'); end
        iterhist = iterhist(1:(iternum+1),:);
        break;
    end
    linemat(1,1:4) = 0;
    linemat(2,1:4) = linemat(2,1);
    linemat(3,1:4) = Foldstr.f;
    stepiter  = 0;
    if dbglev>1
        fprintf('      %3.f %10.4f %10.4f %10.4f\n', ...
            [stepiter, linemat(:,1)']);
    end
    ips = 0;
    %  first step set to trial
    linemat(1,5) = trial;
    %  Main iteration loop for linesrch
    for stepiter = 1:STEPMAX
        %  ensure that step does not go beyond limits on parameters
        limflg  = 0;
        %  check the step size
        [linemat(1,5),ind,limwrd] = ...
            stepchk(linemat(1,5), cvec, deltac, limwrd, ind, ...
                    climit, active, dbgwrd);
        if linemat(1,5) <= 1e-9
            %  Current step size too small ... terminate
            Fstr    = Foldstr;
            cvecnew = cvec;
            gvecnew = gvec;
            if dbglev > 1
                fprintf('Stepsize too small:  %10.4f\n', linemat(1,5));
            end
            if limflg
                ind = 1;
            else
                ind = 4;
            end
            break;
        end
        cvecnew = cvec + linemat(1,5).*deltac;
        %  compute new function value and gradient
        [logl, Dlogl] = loglfnpos(argvals, y, phimat, cvecnew);
        Fstr.f  = -logl;
        gvecnew = -Dlogl;
        if lambda > 0
            gvecnew = gvecnew + 2.*Kmat * cvecnew;
            Fstr.f = Fstr.f + cvecnew' * Kmat * cvecnew;
        end
        Fstr.norm = sqrt(mean(gvecnew.^2));
        linemat(3,5) = Fstr.f;
        %  compute new directional derivative
        linemat(2,5) = sum(deltac.*gvecnew);
        if dbglev > 1
            fprintf('      %3.f %10.4f %10.4f %10.4f\n', ...
                [stepiter, linemat(:,5)']);
        end
        %  compute next step
        [linemat,ips,ind,dblwrd] = ...
            stepit(linemat, ips, ind, dblwrd, MAXSTEP, dbgwrd);
        trial  = linemat(1,5);
        %  ind == 0 implies convergence
        if ind == 0 | ind == 5, break; end
        %  end iteration loop
    end
    
    cvec = cvecnew;
    gvec = gvecnew;
    Wfd  = putcoef(Wfd, cvec);
    status = [iternum, Fstr.f, -logl, Fstr.norm];
    iterhist(iter+1,:) = status;
    fprintf('%5.f     %10.4f %10.4f %10.4f\n', status);
    %  test for convergence
    if abs(Fstr.f-Foldstr.f) < conv
        iterhist = iterhist(1:(iternum+1),:);
        break;
    end
    if Fstr.f >= Foldstr.f, break; end
    %  compute the Hessian
    hmat = loglhesspos(argvals, y, phimat, cvec);
    if lambda > 0
        hmat = hmat + 2.*Kmat;
    end
    %  evaluate the update vector
    deltac   = -hmat\gvec;
    cosangle = -gvec'*deltac/sqrt(sum(gvec.^2)*sum(deltac.^2));
    if cosangle < 0
        if dbglev > 1, disp('cos(angle) negative'); end
        deltac = -gvec;
    end
    Foldstr = Fstr;
end

%  ---------------------------------------------------------------

function [logl, Dlogl] = loglfnpos(argvals, y, phimat, cvec)
    Wvec   = phimat*cvec;
    EWvec  = exp(Wvec);
    res    = y - EWvec;
    logl   = -sum(res.^2);
    Dlogl  = 2.*phimat'*(res.*EWvec);

%  ---------------------------------------------------------------

function D2logl = loglhesspos(argvals, y, phimat, cvec)
    nbasis = size(phimat,2);
    Wvec   = phimat*cvec;
    EWvec  = exp(Wvec);
    res    = y - EWvec;
    Dres   = ((res.*EWvec)*ones(1,nbasis)) .* phimat;
    D2logl = 2.*Dres'*Dres;

