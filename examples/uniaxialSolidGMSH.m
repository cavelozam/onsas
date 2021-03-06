%% Example uniaxialSolid
% Linear elastic solid submitted to uniaxial loading. 
% Geometry given by $L_x$, $L_y$ and $L_z$, tension $p$ applied on 
% face $x=L_x$.
%
% Analytical solution to be compared with numerical:
% $$ u_x(x=L_x,y,z) = \frac{p L_x}{E} $$
%%

% uncomment to delete variables and close windows
clear all, close all

%% General data
dirOnsas = [ pwd '/..' ] ;
problemName = 'uniaxialSolidGMSH' ;

addpath( [ dirOnsas '/sources/' ] );

%% Structural properties

tic
% Nodes and Conectivity matrix from .dxf file
[ nodesMat, conecMat, physicalNames ] = msh4Reader('uniaxialSolid.msh') ;
[ nodesMat, conecMat ] = esmacParser( nodesMat, conecMat, physicalNames ) ;
tiempoLecturaGMSH = toc 


% Support matrix	: Is defined by the corresponding support label. I.e., in torre.dxf there is ony one label for supports, then
% 									the matrix will have only one row. The structure of the matrix is: [ ux thetax uy thetay uz thetaz ]
suppsMat = [ inf 0  0 	0   0 	0 ; ...
             0 	 0  inf 0   0   0 ; ...
             0 	 0  0   0   inf 0 ] ;

% Loads matrix: 		Is defined by the corresponding load label. First entry is a boolean to assign load in Global or Local axis. (Recommendation: Global axis). 
%										Global axis -> 1, local axis -> 0. 
%										The structure of the matrix is: [ 1/0 Fx Mx Fy My Fz Mz ]
p = 210e8 ; Lx = 1 ;

loadsMat = [0   0 0 0 0 p 0 ] ;

% Previously defined matrices to ONSAS format
[Nodes, Conec, nodalVariableLoads, nodalConstantLoads, unifDisLoadL, unifDisLoadG, nodalSprings ] = inputFormatConversion ( nodesMat, conecMat, loadsMat, suppsMat ) ;


%~ for i=1:size(Conec,1)
  %~ tetcoordmat = Nodes( Conec(i,1:4) ,:)' ; 
  %~ [ deriv , vol ] =  DerivFun( tetcoordmat ) ;

  %~ if vol<0
    %~ Conec(i,1:4) = Conec(i,[1 3 2 4] ) ;
    %~ tetcoordmat = Nodes( Conec(i,1:4) ,:)' ; 
    %~ [ deriv , vol ] =  DerivFun( tetcoordmat ) ; 
  %~ end
%~ end


clear nodesMat conecMat loadsMat suppsMat

% Constitutive properties: Structure: [ 1 E nu ]
E = 210e9 ; nu = 0.3 ;
hyperElasParams = cell(1,1) ;
hyperElasParams{1} = [ 1  E  nu ] ;

% Sections
secGeomProps = [ 0 0 0 0 ] ;

% Analysis parameters
%~ nonLinearAnalysisBoolean 	= 0 ;
nonLinearAnalysisBoolean 	= 1 ;
dynamicAnalysisBoolean 		= 0 ;

stopTolIts       = 30     ;
stopTolDeltau    = 1.0e-10 ;
stopTolForces    = 1.0e-6 ;
targetLoadFactr  = 1    ;
nLoadSteps       = 2    ;

controlDofInfo = [ 7 1 1 ] ;

numericalMethodParams = [ 1 stopTolDeltau stopTolForces stopTolIts ...
                            targetLoadFactr nLoadSteps ] ; 


% Analytic sol
analyticSolFlag        = 1             ;
analyticCheckTolerance = 1e-8          ;
analyticFunc           = @(w) w*p*Lx/E ;

%% Output parameters
plotParamsVector = [ 3 ] ; printflag = 2 ;

%% ONSAS execution
% move to onsas directory and ONSAS execution

acdir = pwd ;
cd(dirOnsas);
ONSAS
cd(acdir) ;
  
