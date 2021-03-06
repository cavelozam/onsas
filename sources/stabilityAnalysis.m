% Copyright (C) 2019, Jorge M. Perez Zerpa, J. Bruno Bazzano, Jean-Marc Battini, Joaquin Viera, Mauricio Vanzulli  
%
% This file is part of ONSAS.
%
% ONSAS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% ONSAS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with ONSAS.  If not, see <https://www.gnu.org/licenses/>.

% function for Nonlinear buckling analysis as in section 6.8.2 from Bathe, FEM Procedures 2nd edition. ---

function [ factor_crit, nKeigpos, nKeigneg] = stabilityAnalysis ( KTtm1red, KTtred, currLoadFactor, nextLoadFactor );  

  [a,b] = eig( KTtred ) ;
  Keigvals = diag(b) ; 
  nKeigpos = length( find(Keigvals >  0 ) ) ;
  nKeigneg = length( find(Keigvals <= 0 ) ) ;

  [vecgamma, gammas ] = eig( KTtred, KTtm1red ) ;
  
  gammas = diag( gammas);
 
  if length( find( gammas >  0 ) ) > 0,
  
    gamma_crit  = min ( gammas ( find( gammas >  0 ) ) ) ;
    if gamma_crit ~= 1 
      lambda_crit = 1 / ( 1 - gamma_crit )  ;               
      factor_crit = currLoadFactor + lambda_crit * (nextLoadFactor - currLoadFactor) ;
    else
      factor_crit = 0 ;
    end
  else
    factor_crit = 0;
  end
