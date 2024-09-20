# SPDX-License-Identifier: GPL-2.0-or-later
# LocalizeRingForHomalg: A Package for Localization of Polynomial Rings
#
# Implementations
#

##  Implementations of procedures for "fake" localized rings.

####################################
#
# global variables:
#
####################################

InstallValue( CommonHomalgTableForFakeLocalRingsBasic,
        
        rec(
BasisOfRowModule :=
  function( M )

    Error( "BasisOfRowModule is not supported over fake local rings\n" );
    
end,

BasisOfColumnModule :=
  function( M )
    
    Error( "BasisOfColumnModule is not supported over fake local rings\n" );
    
  end,

BasisOfRowsCoeff :=
  function( M, T )

    Error( "BasisOfRowsCoeff is not supported over fake local rings\n" );    
    
  end,

NonReducedBasisOfRowsCoeff :=
  function( M, T )

    Error( "NonReducedBasisOfRowsCoeff is not supported over fake local rings\n" );    
    
  end,

BasisOfColumnsCoeff :=
  function( M, T )
      
      Error( "BasisOfColumnsCoeff is not supported over fake local rings\n" );    

  end,

NonReducedBasisOfColumnsCoeff :=
  function( M, T )
      
      Error( "NonReducedBasisOfColumnsCoeff is not supported over fake local rings\n" );    

  end,

DecideZeroRows :=
  function( A, B )
      
      Error( "DecideZeroRows is not supported over fake local rings\n" );    
      
  end,

DecideZeroColumns :=
  function( A, B )
      
      Error( "DecideZeroColumns is not supported over fake local rings\n" );    
      
  end,

DecideZeroRowsEffectively :=
  function( A, B, T )
      
      Error( "DecideZeroRowsEffectively is not supported over fake local rings\n" );    
      
  end,

DecideZeroColumnsEffectively :=
  function( A, B, T )
      
      Error( "DecideZeroColumnsEffectively is not supported over fake local rings\n" );    
      
  end,

SyzygiesGeneratorsOfRows :=
  function( M )
    
      Error( "SyzygiesGeneratorsOfRows is not supported over fake local rings\n" );    
      
  end,

RelativeSyzygiesGeneratorsOfRows :=
  function( M, N )
    
      Error( "RelativeSyzygiesGeneratorsOfRows is not supported over fake local rings\n" );    
      
  end,

SyzygiesGeneratorsOfColumns :=
  function( M )
        
      Error( "SyzygiesGeneratorsOfColumns is not supported over fake local rings\n" );    
      
  end,
  
RelativeSyzygiesGeneratorsOfColumns :=
  function( M, N )
        
      Error( "RelativeSyzygiesGeneratorsOfColumns is not supported over fake local rings\n" );    
      
  end,

            )
);
