# SPDX-License-Identifier: GPL-2.0-or-later
# MatricesForHomalg: Matrices for the homalg project
#
# Implementations
#

####################################
#
# representations:
#
####################################

##  <#GAPDoc Label="IsHomalgInternalRingRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="R" Name="IsHomalgInternalRingRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The internal representation of &homalg; rings. <P/>
##      (It is a representation of the &GAP; category <C>IsHomalgRing</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgInternalRingRep",
        IsHomalgRing and IsHomalgRingOrFinitelyPresentedModuleRep,
        [ "ring", "homalgTable" ] );

##
DeclareRepresentation( "IsContainerForWeakPointersOnIdentityMatricesRep",
        IsContainerForWeakPointersRep,
        [ "weak_pointers" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgRingElements",
        NewFamily( "TheFamilyOfHomalgRingElements" ) );

# a new family:
BindGlobal( "TheFamilyOfHomalgRings",
        CollectionsFamily( TheFamilyOfHomalgRingElements ) );

# a new type:
BindGlobal( "TheTypeHomalgInternalRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgInternalRingRep ) );

# a new family:
BindGlobal( "TheFamilyOfContainersForWeakPointersOfIdentityMatrices",
        NewFamily( "TheFamilyOfContainersForWeakPointersOfIdentityMatrices" ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointersOnIdentityMatrices",
        NewType( TheFamilyOfContainersForWeakPointersOfIdentityMatrices,
                IsContainerForWeakPointersOnIdentityMatricesRep ) );

####################################
#
# global variables:
#
####################################

##
InstallValue( CommonHomalgTableForRings,
        rec(
            RingName :=
              function( R )
                local minimal_polynomial, var, brackets, r;
                
                if IsBound( R!.MinimalPolynomialOfPrimitiveElement ) then
                    minimal_polynomial := R!.MinimalPolynomialOfPrimitiveElement;
                fi;
                
                ## the Weyl algebra (relative version):
                if HasRelativeIndeterminateDerivationsOfRingOfDerivations( R ) then
                    
                    var := RelativeIndeterminateDerivationsOfRingOfDerivations( R );
                    
                    brackets := [ "<", ">" ];
                    
                ## the Weyl algebra:
                elif HasIndeterminateDerivationsOfRingOfDerivations( R ) then
                    
                    var := IndeterminateDerivationsOfRingOfDerivations( R );
                    
                    brackets := [ "<", ">" ];
                    
                ## the exterior algebra (relative version):
                elif HasRelativeIndeterminateAntiCommutingVariablesOfExteriorRing( R ) then
                    
                    var := RelativeIndeterminateAntiCommutingVariablesOfExteriorRing( R );
                    
                    brackets := [ "{", "}" ];
                    
                ## the exterior algebra:
                elif HasIndeterminateAntiCommutingVariablesOfExteriorRing( R ) then
                    
                    var := IndeterminateAntiCommutingVariablesOfExteriorRing( R );
                    
                    brackets := [ "{", "}" ];
                    
                ## the pseudo double-shift algebra:
                elif HasIndeterminateShiftsOfPseudoDoubleShiftAlgebra( R ) then
                    
                    var := IndeterminateShiftsOfPseudoDoubleShiftAlgebra( R );
                    
                    brackets := [ "<", ">" ];
                    
                ## the pseudo double-shift algebra:
                elif HasIndeterminateShiftsOfRationalPseudoDoubleShiftAlgebra( R ) then
                    
                    var := IndeterminateShiftsOfRationalPseudoDoubleShiftAlgebra( R );
                    
                    brackets := [ "<", ">" ];
                    
                ## the biased double-shift algebra:
                elif HasIndeterminateShiftsOfBiasedDoubleShiftAlgebra( R ) then
                    
                    var := IndeterminateShiftsOfBiasedDoubleShiftAlgebra( R );
                    
                    brackets := [ "<", ">" ];
                    
                ## the (free) polynomial ring (relative version):
                elif HasBaseRing( R ) and HasRelativeIndeterminatesOfPolynomialRing( R ) and
                  not IsIdenticalObj( R, BaseRing( R ) ) then
                    
                    var := RelativeIndeterminatesOfPolynomialRing( R );
                    
                    brackets := [ "[", "]" ];
                    
                ## the (free) polynomial ring:
                elif HasIndeterminatesOfPolynomialRing( R ) then
                    
                    var := IndeterminatesOfPolynomialRing( R );
                    
                    brackets := [ "[", "]" ];
                    
                elif HasRationalParameters( R ) then
                    
                    var := RationalParameters( R );
                    
                    if IsBound( minimal_polynomial ) then
                        brackets := [ "[", "]" ];
                    else
                        brackets := [ "(", ")" ];
                    fi;
                    
                fi;
                
                if not IsBound( var ) then
                    return fail;
                fi;
                
                var := JoinStringsWithSeparator( List( var, String ) );
                
                var := Concatenation( brackets[1], var, brackets[2] );
                
                if HasBaseRing( R ) and HasCoefficientsRing( R ) and
                   not IsIdenticalObj( BaseRing( R ), CoefficientsRing( R ) ) then
                    r := RingName( BaseRing( R ) );
                elif HasCoefficientsRing( R ) then
                    r := CoefficientsRing( R );
                    if IsBound( r!.MinimalPolynomialOfPrimitiveElement ) and IsSubset( RingName( r ), "/" ) then
                        r := Concatenation( "(", RingName( r ), ")" );
                    else
                        r := RingName( r );
                    fi;
                else
                    r := "(some ring)";
                fi;
                
                r := Concatenation( r, var );
                
                if IsBound( minimal_polynomial ) then
                    r := Concatenation( r, "/(", minimal_polynomial, ")" );
                fi;
                
                return String( r );
                
            end,
         
         )
);

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( Zero,
        "for homalg rings",
        [ IsHomalgInternalRingRep ], 10001,
        
  function( R )
    
    return Zero( R!.ring );
    
end );

##
InstallMethod( Zero,
        "for homalg rings",
        [ IsHomalgInternalRingRep ], 10001,
        
  function( R )
    local RP;
    
    RP := homalgTable( R );
    
    if IsBound( RP!.Zero ) then
        return RP!.Zero;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( One,
        "for homalg rings",
        [ IsHomalgInternalRingRep ], 1001,
        
  function( R )
    
    return One( R!.ring );
    
end );

##
InstallMethod( One,
        "for homalg rings",
        [ IsHomalgInternalRingRep ], 1001,
        
  function( R )
    local RP;
    
    RP := homalgTable( R );
    
    if IsBound( RP!.One ) then
        return RP!.One;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( MinusOne,
        "for homalg rings",
        [ IsHomalgInternalRingRep ],
        
  function( R )
    
    return -One( R );
    
end );

##
InstallMethod( MinusOne,
        "for homalg rings",
        [ IsHomalgInternalRingRep ],
        
  function( R )
    local RP;
    
    RP := homalgTable( R );
    
    if IsBound( RP!.MinusOne ) then
        return RP!.MinusOne;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( ZeroMutable,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return Zero( HomalgRing( r ) );
    
end );

##
InstallMethod( OneMutable,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return One( HomalgRing( r ) );
    
end );

##
InstallMethod( Inverse,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return One( r ) / r;
    
end );

##
InstallMethod( MinusOneMutable,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return MinusOne( HomalgRing( r ) );
    
end );

##
InstallMethod( Characteristic,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return Characteristic( HomalgRing( r ) );
    
end );

## for the computeralgebra course
InstallOtherMethod( IndeterminateOfLaurentPolynomial,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, indets;
    
    R := HomalgRing( r );
    
    indets := IndeterminatesOfPolynomialRing( R );
    
    return indets[Length( indets )];
    
end );

## for the computeralgebra course
InstallOtherMethod( CoefficientsRing,
        "for ring elements",
        [ IsRingElement ],
        
  function( r )
    local R;
    
    if IsHomalgRingElement( r ) then
        R := HomalgRing( r );
    else
        R := DefaultRing( r );
    fi;
    
    return CoefficientsRing( R );
    
end );

##
InstallMethod( AssociatedPolynomialRing,
        "for homalg fields",
        [ IsHomalgRing and IsFieldForHomalg ],
        
  function( R )
    local a, r;
    
    if not HasRationalParameters( R ) then
        Error( "the field has no rational parameters" );
    elif not HasCoefficientsRing( R ) then
        Error( "the field has no subfield of coefficients" );
    fi;
    
    r := CoefficientsRing( R );
    
    a := RationalParameters( R );
    
    return r * List( a, String );
    
end );

##
InstallMethod( PolynomialRingWithProductOrdering,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local B, C;
    
    if not IsIdenticalObj( BaseRing( R ), CoefficientsRing( R ) ) then
        TryNextMethod( );
    fi;
    
    return R;
    
end );

##
InstallMethod( BaseRing,
        "for homalg rings",
        [ IsHomalgRing and HasCoefficientsRing ],
        
  CoefficientsRing );

##
InstallMethod( PrimitiveElement,
        "for homalg fields",
        [ IsFieldForHomalg ],
        
  function( R )
    
    if not IsBound( R!.NameOfPrimitiveElement ) then
        TryNextMethod( );
    fi;
    
    return R!.NameOfPrimitiveElement / R;
    
end );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( HomalgRing,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    
    return R;
    
end );

##
InstallMethod( \=,
        "for two homalg rings",
        [ IsHomalgRing, IsHomalgRing ], 10001,
        
  IsIdenticalObj );

##
InstallMethod( HomalgRing,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return r!.ring;
    
end );

##
InstallMethod( LT,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( a, b )
    
    return LT( String( a ), String( b ) );
    
end );

##
InstallMethod( InverseMutable,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return Inverse( r );
    
end );

##
InstallMethod( \*,
        "for homalg ring elements",
        [ IS_RAT, IsHomalgRingElement ],
        
  function( a, b )
    
    if IS_INT( a ) then
        TryNextMethod( );
    fi;
    
    return ( NUMERATOR_RAT( a ) * b ) / ( DENOMINATOR_RAT( a ) * One( b ) );
    
end );

##
InstallMethod( \*,
        "for homalg ring elements",
        [ IsHomalgRingElement, IS_RAT ],
        
  function( a, b )
    
    if IS_INT( b ) then
        TryNextMethod( );
    fi;
    
    return ( NUMERATOR_RAT( b ) * a ) / ( DENOMINATOR_RAT( b ) * One( a ) );
    
end );

##
InstallMethod( \+,
        "for homalg ring elements",
        [ IS_RAT, IsHomalgRingElement ],
        
  function( a, b )
    
    return a * One( b ) + b;
    
end );

##
InstallMethod( \+,
        "for homalg ring elements",
        [ IsHomalgRingElement, IS_RAT ],
        
  function( a, b )
    
    return a + b * One( a );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminatesOfPolynomialRing ],
        
  function( R )
    
    return IndeterminatesOfPolynomialRing( R );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminatesOfExteriorRing ],
        
  function( R )
    
    return IndeterminatesOfExteriorRing( R );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminateCoordinatesOfRingOfDerivations ],
        
  function( R )
    
    return
      Concatenation(
              IndeterminateCoordinatesOfRingOfDerivations( R ),
              IndeterminateDerivationsOfRingOfDerivations( R )
              );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminateCoordinatesOfPseudoDoubleShiftAlgebra ],
        
  function( R )
    
    return
      Concatenation(
              IndeterminateCoordinatesOfPseudoDoubleShiftAlgebra( R ),
              IndeterminateShiftsOfPseudoDoubleShiftAlgebra( R )
              );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminateCoordinatesOfDoubleShiftAlgebra ],
        
  function( R )
    
    return
      Concatenation(
              IndeterminateCoordinatesOfDoubleShiftAlgebra( R ),
              IndeterminateShiftsOfDoubleShiftAlgebra( R )
              );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminateCoordinatesOfBiasedDoubleShiftAlgebra ],
        
  function( R )
    
    return
      Concatenation(
              IndeterminateCoordinatesOfBiasedDoubleShiftAlgebra( R ),
              IndeterminateShiftsOfBiasedDoubleShiftAlgebra( R )
              );
    
end );

##
InstallMethod( Indeterminates,
        "for homalg fields",
        [ IsHomalgRing and IsFieldForHomalg ],
        
  function( R )
    
    return [ ];
    
end );

##
InstallMethod( Indeterminates,
        "for homalg ring of integers",
        [ IsHomalgRing and IsIntegersForHomalg ],
        
  function( R )
    
    return [ ];
    
end );

## Fallback method
InstallMethod( RelativeIndeterminatesOfPolynomialRing,
        "for homalg rings",
        [ IsHomalgRing and HasCoefficientsRing ],
        
  IndeterminatesOfPolynomialRing );

##
InstallMethod( AssignGeneratorVariables,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local indets;
    
    indets := Indeterminates( R );
    
    DoAssignGenVars( indets );
    
    return;
    
end );

##
InstallMethod( ExportIndeterminates,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local indets, x_name, x;
    
    indets := Indeterminates( R );
    
    for x in indets do
        x_name := String( x );
        if IsBoundGlobal( x_name ) then
            if not IsHomalgRingElement( ValueGlobal( x_name ) ) then
                Error( "the name ", x_name, " is not bound to a homalg ring element\n" );
            elif IsReadOnlyGlobal( x_name ) then
                MakeReadWriteGlobal( x_name );
            fi;
            UnbindGlobal( x_name );
        fi;
        BindGlobal( x_name, x );
    od;
    
    return indets;
    
end );

##
InstallMethod( ExportRationalParameters,
        "for homalg rings",
        [ IsHomalgRing and HasRationalParameters ],
        
  function( R )
    local params, x_name, x;
    
    params := RationalParameters( R );
    
    for x in params do
        x_name := ShallowCopy( String( x ) );
        RemoveCharacters( x_name, "()" );
        if IsBoundGlobal( x_name ) then
            if not IsHomalgRingElement( ValueGlobal( x_name ) ) then
                Error( "the name ", x_name, " is not bound to a homalg ring element\n" );
            elif IsReadOnlyGlobal( x_name ) then
                MakeReadWriteGlobal( x_name );
            fi;
            UnbindGlobal( x_name );
        fi;
        BindGlobal( x_name, x );
    od;
    
    return params;
    
end );

##
InstallMethod( ExportVariables,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    
    return ExportIndeterminates( R );
    
end );

##
InstallMethod( ExportVariables,
        "for homalg rings",
        [ IsHomalgRing and HasRationalParameters ],
        
  function( R )
    
    return Concatenation(
                   ExportRationalParameters( R ),
                   ExportIndeterminates( R ) );
    
end );

##
InstallMethod( Indeterminate,
        "for homalg rings",
        [ IsHomalgRing, IsPosInt ],
        
  function( R, i )
    
    return Indeterminates( R )[i];
    
end );

##
InstallMethod( ProductOfIndeterminates,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    
    return Product( Indeterminates( R ) );
    
end );

##
InstallMethod( ProductOfIndeterminatesOverBaseRing,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminatesOfPolynomialRing ],
        
  function( R )
    
    return Product( IndeterminatesOfPolynomialRing( R ) );
    
end );

##
InstallMethod( ProductOfIndeterminatesOverBaseRing,
        "for homalg rings",
        [ IsHomalgRing and HasRelativeIndeterminatesOfPolynomialRing ], 100, ## otherwise the above method is triggered :(
        
  function( R )
    
    return Product( RelativeIndeterminatesOfPolynomialRing( R ) );
    
end );

## provided to avoid branching in the code and always returns fail
InstallMethod( PositionOfTheDefaultPresentation,
        "for ring elements",
        [ IsRingElement ],
        
  function( r )
    
    return fail;
    
end );

##
InstallMethod( \=,
        "for two homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( r1, r2 )
    
    if IsIdenticalObj( HomalgRing( r1 ), HomalgRing( r2 ) ) then
        return IsZero( r1 - r2 );
    fi;
    
    return false;
    
end );

##
InstallMethod( \=,
        "for a rational and a homalg ring element",
        [ IS_RAT, IsHomalgRingElement ],
        
  function( r1, r2 )
    
    return r1 / HomalgRing( r2 ) = r2;
    
end );

##
InstallMethod( \=,
        "for a homalg ring element and a rational",
        [ IsHomalgRingElement, IS_RAT ],
        
  function( r1, r2 )
    
    return r1 = r2 / HomalgRing( r1 );
    
end );

##
InstallMethod( StandardBasisRowVectors,
        "for homalg rings",
        [ IsInt, IsHomalgRing ],
        
  function( n, R )
    local id;
    
    id := HomalgIdentityMatrix( n, R );
    
    return List( [ 1 .. n ], r -> CertainRows( id, [ r ] ) );
    
end );

##
InstallMethod( StandardBasisColumnVectors,
        "for homalg rings",
        [ IsInt, IsHomalgRing ],
        
  function( n, R )
    local id;
    
    id := HomalgIdentityMatrix( n, R );
    
    return List( [ 1 .. n ], c -> CertainColumns( id, [ c ] ) );
    
end );

##
InstallMethod( RingName,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local RP, var, r, c;
    
    if HasName( R ) then
        return Name( R );
    fi;
    
    ## ask the ring table
    RP := homalgTable( R );
    
    if IsBound(RP!.RingName) then
        
        if IsFunction( RP!.RingName ) then
            r := RP!.RingName( R );
        else
            r := RP!.RingName;
        fi;
        
        if r <> fail then
            return r;
        fi;
        
    fi;
    
    ## residue class rings/fields of the integers
    if HasIsResidueClassRingOfTheIntegers( R ) and
       IsResidueClassRingOfTheIntegers( R ) and
       HasCharacteristic( R ) then
        
        c := Characteristic( R );
        
        if c = 0 then
            return "Z";
        elif IsPrime( c ) then
            if HasDegreeOverPrimeField( R ) and DegreeOverPrimeField( R ) > 1 then
                r := [ "GF(", String( c ), "^", String( DegreeOverPrimeField( R ) ), ")" ];
            else
                r := [ "GF(", String( c ), ")" ];
            fi;
        else
            r := [ "Z/", String( c ), "Z" ];
        fi;
        
        return String( Concatenation( r ) );
        
    fi;
    
    ## the rationals
    if HasIsRationalsForHomalg( R ) and IsRationalsForHomalg( R ) then
        return "Q";
    fi;
    
    return "(homalg ring)";
    
end );

##
InstallMethod( homalgRingStatistics,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    
    return R!.statistics;
    
end );

##
InstallMethod( IncreaseRingStatistics,
        "for homalg rings",
        [ IsHomalgRing, IsString ],
        
  function( R, s )
    
    R!.statistics.(s) := R!.statistics.(s) + 1;
    
end );

##
InstallMethod( DecreaseRingStatistics,
        "for homalg rings",
        [ IsHomalgRing, IsString ],
        
  function( R, s )
    
    R!.statistics.(s) := R!.statistics.(s) - 1;
    
end );

##
InstallOtherMethod( AsList,
        "for homalg internal rings",
        [ IsHomalgInternalRingRep ],
        
  function( r )
    
    return AsList( r!.ring );
    
end );

##
InstallMethod( homalgSetName,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsString ],
        
  SetName );

##
InstallMethod( IrreducibleFactors,
        "for ring elements",
        [ IsRingElement ],
        
  PrimeDivisors );

##
InstallMethod( IrreducibleFactors,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, factors;
    
    R := HomalgRing( r );
    
    if IsHomalgInternalRingRep( R ) then
        if not IsBound( r!.IrreducibleFactors ) then
            r!.IrreducibleFactors := PrimeDivisors( EvalString( String( r ) ) );
        fi;
    fi;
    
    factors := RadicalDecompositionOp( HomalgMatrix( [ r ], 1, 1, R ) );
    
    r!.Factors := List( factors, a -> a[ 1, 1 ] );
    
    return r!.Factors;
    
end );

##
InstallMethod( Factors,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, factors, primary, prime, one, divide;
    
    R := HomalgRing( r );
    
    if IsHomalgInternalRingRep( R ) then
        if not IsBound( r!.Factors ) then
            r!.Factors := Factors( EvalString( String( r ) ) );
        fi;
    fi;
    
    factors := PrimaryDecompositionOp( HomalgMatrix( [ r ], 1, 1, R ) );
    
    primary := List( factors, a -> a[1][ 1, 1 ] );
    prime := List( factors, a -> a[2][ 1, 1 ] );
    
    one := One( R );
    
    divide :=
      function( q, p )
        local list;
        
        list := [ ];
        
        repeat
            q := q / p;
            Add( list, p );
        until IsZero( DecideZero( one, q ) );
        
        return list;
        
    end;
    
    factors := List( [ 1 .. Length( factors ) ], i -> divide( primary[i], prime[i] ) );
    
    factors := Concatenation( factors );
    
    factors[1] := ( r / Product( factors ) ) * factors[1];
      
    r!.Factors := factors;
    
    return r!.Factors;
    
end );

##
InstallMethod( Roots,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, roots;
    
    R := HomalgRing( r );
    
    if not IsHomalgInternalRingRep( R ) then
        TryNextMethod( );
    fi;
    
    if not IsBound( r!.Roots ) then
        roots := RootsOfUPol( EvalString( String( r ) ) );
        Sort( roots );
        r!.Roots := roots;
    fi;
    
    return r!.Roots;
    
end );

##
InstallMethod( DecideZero,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    IsZero( r );
    
    return r;
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing, IsHomalgRing, IsList ],
        
  function( S, R, var )
    local param, paramS, d;
    
    d := Length( var );
    
    if d > 0 then
        SetIsFinite( S, false );
    fi;
    
    SetCoefficientsRing( S, R );
    
    if HasRationalParameters( R ) then
        param := RationalParameters( R );
        paramS := List( param, a -> a / S );
        Perform( [ 1 .. Length( param ) ], function( i ) SetName( paramS[i], Name( param[i] ) ); end );
        SetRationalParameters( S, paramS );
    fi;
    
    if HasCharacteristic( R ) then
        SetCharacteristic( S, Characteristic( R ) );
    fi;
    
    SetIsCommutative( S, true );
    
    SetIndeterminatesOfPolynomialRing( S, var );
    
    if HasContainsAField( R ) and ContainsAField( R ) then
        SetContainsAField( S, true );
    fi;
    
    if d > 0 then
        SetIsLeftArtinian( S, false );
        SetIsRightArtinian( S, false );
    fi;
    
    if HasGlobalDimension( R ) then
        SetGlobalDimension( S, d + GlobalDimension( R ) );
    fi;
    
    if HasKrullDimension( R ) then
        SetKrullDimension( S, d + KrullDimension( R ) );
    fi;
    
    SetGeneralLinearRank( S, 1 );       ## Quillen-Suslin Theorem (see [McCRob, 11.5.5]
    
    if d = 1 then                       ## [McCRob, 11.5.7]
        SetElementaryRank( S, 1 );
    elif d > 2 then
        SetElementaryRank( S, 2 );
    fi;
    
    SetIsIntegralDomain( S, true );
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsWeylRing, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, R, der )
    local r, b, param, paramS, var, d;
    
    r := CoefficientsRing( R );
    
    if HasBaseRing( R ) then
        b := BaseRing( R );
    else
        b := r;
    fi;
    
    var := IndeterminatesOfPolynomialRing( R );
    var := List( var, a -> a / S );
    
    d := Length( var );
    
    if d > 0 then
        SetIsFinite( S, false );
    fi;
    
    SetCoefficientsRing( S, r );
    
    if HasRationalParameters( r ) then
        param := RationalParameters( r );
        paramS := List( param, a -> a / S );
        Perform( [ 1 .. Length( param ) ], function( i ) SetName( paramS[i], Name( param[i] ) ); end );
        SetRationalParameters( S, paramS );
    fi;
    
    SetCharacteristic( S, Characteristic( R ) );
    
    SetIsCommutative( S, der = [ ] );
    
    SetCenter( S, Center( b ) );
    
    SetIndeterminateCoordinatesOfRingOfDerivations( S, var );
    
    if HasRelativeIndeterminatesOfPolynomialRing( R ) then
        SetRelativeIndeterminateCoordinatesOfRingOfDerivations(
                S, RelativeIndeterminatesOfPolynomialRing( R ) );
    fi;
    
    SetIndeterminateDerivationsOfRingOfDerivations( S, der );
    
    if d > 0 then
        SetIsLeftArtinian( S, false );
        SetIsRightArtinian( S, false );
    fi;
    
    SetIsLeftNoetherian( S, true );
    SetIsRightNoetherian( S, true );
    
    if HasGlobalDimension( r ) then
        SetGlobalDimension( S, d + GlobalDimension( r ) );
    fi;
    
    if HasIsFieldForHomalg( b ) and IsFieldForHomalg( b ) and Characteristic( S ) = 0 then
        SetGeneralLinearRank( S, 2 );   ## [Stafford78], [McCRob, 11.2.15(i)]
        SetIsSimpleRing( S, true );     ## [Coutinho, Thm 2.2.1]
    fi;
    
    if HasIsIntegralDomain( r ) and IsIntegralDomain( r ) then
        SetIsIntegralDomain( S, true );
    fi;
    
    if d > 0 then
        SetIsLeftPrincipalIdealRing( S, false );
        SetIsRightPrincipalIdealRing( S, false );
        SetIsPrincipalIdealRing( S, false );
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
    SetAreUnitsCentral( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsLocalizedWeylRing, IsString ],
        
  function( S, _var )
    local var, d;
    
    var := SplitString( _var, ",", "[]" );
    var := List( var, a -> a / S );
    
    SetIndeterminateCoordinatesOfRingOfDerivations( S, var );
    
    d := Length( var );
    
    ## SetCoefficientsRing( S, r );
    
    SetCharacteristic( S, 0 );
    
    SetIsCommutative( S, false );
    
    ## SetCenter( S, r );
    
    SetIndeterminateCoordinatesOfRingOfDerivations( S, var );
    
    ## SetIndeterminateDerivationsOfRingOfDerivations( S, der );
    
    if d > 0 then
        SetIsLeftArtinian( S, false );
        SetIsRightArtinian( S, false );
    fi;
    
    SetIsLeftNoetherian( S, true );
    SetIsRightNoetherian( S, true );
    
    SetGlobalDimension( S, d + 0 );     ## Janet only knows Q as the coefficient ring
    
    ## SetGeneralLinearRank( S, 2 );    ## [Stafford78], [McCRob, 11.2.15(i)]
    SetIsSimpleRing( S, true );         ## [Coutinho, Thm 2.2.1]
    
    if d > 0 then
        SetIsPrincipalIdealRing( S, false );
    fi;
    
    if d = 1 then
        SetIsLeftPrincipalIdealRing( S, true );
        SetIsRightPrincipalIdealRing( S, true );
    elif d > 0 then
        SetIsLeftPrincipalIdealRing( S, false );
        SetIsRightPrincipalIdealRing( S, false );
    fi;
    
    SetIsIntegralDomain( S, true );
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
    SetAreUnitsCentral( S, false );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsExteriorRing, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( A, S, anti )
    local r, d, param, paramA, comm, T;
    
    r := CoefficientsRing( S );
    
    d := Length( anti );
    
    SetCoefficientsRing( A, r );
    
    if HasRationalParameters( r ) then
        param := RationalParameters( r );
        paramA := List( param, a -> a / A );
        Perform( [ 1 .. Length( param ) ], function( i ) SetName( paramA[i], Name( param[i] ) ); end );
        SetRationalParameters( A, paramA );
    fi;
    
    SetCharacteristic( A, Characteristic( S ) );
    
    if d <= 1 or Characteristic( A ) = 2 then
        
        ## the Center is then automatically set to S
        SetIsCommutative( A, true );
        
    else
        
        ## the center is the even part, which is
        ## bigger than the coefficients ring r
        SetIsCommutative( A, false );
        
    fi;
    
    SetIsSuperCommutative( A, true );
    
    SetIsIntegralDomain( A, d = 0 );
    
    comm := [ ];
    
    if HasBaseRing( S ) then
        T := BaseRing( S );
        if HasIndeterminatesOfPolynomialRing( T ) then
            comm := IndeterminatesOfPolynomialRing( T );
        fi;
    fi;
    
    if not HasIndeterminateAntiCommutingVariablesOfExteriorRing( A ) then
        
        SetIndeterminateAntiCommutingVariablesOfExteriorRing( A, anti );
        
    fi;
    
    if not HasIndeterminatesOfExteriorRing( A ) then
        
        SetIndeterminatesOfExteriorRing( A, Concatenation( comm, anti ) );
        
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( A, true );
    
    SetAreUnitsCentral( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsPseudoDoubleShiftAlgebra, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, R, shift )
    local r, b, param, paramS, var, d;
    
    r := CoefficientsRing( R );
    
    if HasBaseRing( R ) then
        b := BaseRing( R );
    else
        b := r;
    fi;
    
    var := IndeterminatesOfPolynomialRing( R );
    var := List( var, a -> a / S );
    
    d := Length( var );
    
    if d > 0 then
        SetIsFinite( S, false );
    fi;
    
    SetCoefficientsRing( S, r );
    
    if HasRationalParameters( r ) then
        param := RationalParameters( r );
        paramS := List( param, a -> a / S );
        Perform( [ 1 .. Length( param ) ], function( i ) SetName( paramS[i], Name( param[i] ) ); end );
        SetRationalParameters( S, paramS );
    fi;
    
    SetCharacteristic( S, Characteristic( R ) );
    
    SetIsCommutative( S, shift = [ ] );
    
    SetIndeterminateCoordinatesOfPseudoDoubleShiftAlgebra( S, var );
    
    if HasRelativeIndeterminatesOfPolynomialRing( R ) then
        SetRelativeIndeterminateCoordinatesOfPseudoDoubleShiftAlgebra(
                S, RelativeIndeterminatesOfPolynomialRing( R ) );
    fi;
    
    SetIndeterminateShiftsOfPseudoDoubleShiftAlgebra( S, shift );
    
    if d > 0 then
        SetIsLeftArtinian( S, false );
        SetIsRightArtinian( S, false );
    fi;
    
    SetIsLeftNoetherian( S, true );
    SetIsRightNoetherian( S, true );
    
    if HasIsIntegralDomain( r ) and IsIntegralDomain( r ) then
        SetIsIntegralDomain( S, true );
    fi;
    
    if d > 0 then
        SetIsLeftPrincipalIdealRing( S, false );
        SetIsRightPrincipalIdealRing( S, false );
        SetIsPrincipalIdealRing( S, false );
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsRationalPseudoDoubleShiftAlgebra, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, R, shift )
    local r, b, param, paramS, var, d;
    
    r := CoefficientsRing( R );
    
    if HasBaseRing( R ) then
        b := BaseRing( R );
    else
        b := r;
    fi;
    
    var := IndeterminatesOfPolynomialRing( R );
    var := List( var, a -> a / S );
    
    d := Length( var );
    
    if d > 0 then
        SetIsFinite( S, false );
    fi;
    
    SetCoefficientsRing( S, r );
    
    if HasRationalParameters( r ) then
        param := RationalParameters( r );
        paramS := List( param, a -> a / S );
        Perform( [ 1 .. Length( param ) ], function( i ) SetName( paramS[i], Name( param[i] ) ); end );
        SetRationalParameters( S, paramS );
    fi;
    
    SetCharacteristic( S, Characteristic( R ) );
    
    SetIsCommutative( S, shift = [ ] );
    
    SetParametersOfRationalPseudoDoubleShiftAlgebra( S, var );
    
    if HasRelativeIndeterminatesOfPolynomialRing( R ) then
        SetRelativeParametersOfRationalPseudoDoubleShiftAlgebra(
                S, RelativeIndeterminatesOfPolynomialRing( R ) );
    fi;
    
    SetIndeterminateShiftsOfRationalPseudoDoubleShiftAlgebra( S, shift );
    
    if d > 0 then
        SetIsLeftArtinian( S, false );
        SetIsRightArtinian( S, false );
    fi;
    
    SetIsLeftNoetherian( S, true );
    SetIsRightNoetherian( S, true );
    
    if HasIsIntegralDomain( r ) and IsIntegralDomain( r ) then
        SetIsIntegralDomain( S, true );
    fi;
    
    if d > 0 then
        SetIsLeftPrincipalIdealRing( S, false );
        SetIsRightPrincipalIdealRing( S, false );
        SetIsPrincipalIdealRing( S, false );
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsBiasedDoubleShiftAlgebra, IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, R, shift )
    local r, b, param, paramS, var, d;
    
    r := CoefficientsRing( R );
    
    if HasBaseRing( R ) then
        b := BaseRing( R );
    else
        b := r;
    fi;
    
    var := IndeterminatesOfPolynomialRing( R );
    var := List( var, a -> a / S );
    
    d := Length( var );
    
    if d > 0 then
        SetIsFinite( S, false );
    fi;
    
    SetCoefficientsRing( S, r );
    
    if HasRationalParameters( r ) then
        param := RationalParameters( r );
        paramS := List( param, a -> a / S );
        Perform( [ 1 .. Length( param ) ], function( i ) SetName( paramS[i], Name( param[i] ) ); end );
        SetRationalParameters( S, paramS );
    fi;
    
    SetCharacteristic( S, Characteristic( R ) );
    
    SetIsCommutative( S, shift = [ ] );
    
    SetIndeterminateCoordinatesOfBiasedDoubleShiftAlgebra( S, var );
    
    if HasRelativeIndeterminatesOfPolynomialRing( R ) then
        SetRelativeIndeterminateCoordinatesOfBiasedDoubleShiftAlgebra(
                S, RelativeIndeterminatesOfPolynomialRing( R ) );
    fi;
    
    SetIndeterminateShiftsOfBiasedDoubleShiftAlgebra( S, shift );
    
    if d > 0 then
        SetIsLeftArtinian( S, false );
        SetIsRightArtinian( S, false );
    fi;
    
    SetIsLeftNoetherian( S, true );
    SetIsRightNoetherian( S, true );
    
    if HasIsIntegralDomain( r ) and IsIntegralDomain( r ) then
        SetIsIntegralDomain( S, true );
    fi;
    
    if d > 0 then
        SetIsLeftPrincipalIdealRing( S, false );
        SetIsRightPrincipalIdealRing( S, false );
        SetIsPrincipalIdealRing( S, false );
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( S, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsPrincipalIdealRing and IsCommutative, IsInt ],
        
  function( R, c )
    local RP, powers;
    
    SetCharacteristic( R, c );
    
    if HasIsFieldForHomalg( R ) and IsFieldForHomalg( R ) then
        TryNextMethod( );
    elif HasIsResidueClassRingOfTheIntegers( R ) and
      IsResidueClassRingOfTheIntegers( R ) then
        TryNextMethod( );
    fi;
    
    if c = 0 then
        SetContainsAField( R, false );
        SetIsIntegralDomain( R, true );
        SetIsArtinian( R, false );
        SetKrullDimension( R, 1 ); ## FIXME: it is not set automatically although an immediate method is installed
    elif not IsPrime( c ) then
        SetIsSemiLocalRing( R, true );
        SetIsIntegralDomain( R, false );
        powers := List( Collected( FactorsInt( c ) ), a -> a[2] );
        if Set( powers ) = [ 1 ] then
            SetIsSemiSimpleRing( R, true );
        else
            SetIsRegular( R, false );
            if Length( powers ) = 1 then
                SetIsLocal( R, true );
            fi;
        fi;
        SetKrullDimension( R, 0 );
    fi;
    
    RP := homalgTable( R );
    
    if HasIsIntegralDomain( R ) and IsIntegralDomain( R ) then
        if IsBound( RP!.RowRankOfMatrixOverDomain ) then
            RP!.RowRankOfMatrix := RP!.RowRankOfMatrixOverDomain;
        fi;
        
        if IsBound( RP!.ColumnRankOfMatrixOverDomain ) then
            RP!.ColumnRankOfMatrix := RP!.ColumnRankOfMatrixOverDomain;
        fi;
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( R, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsResidueClassRingOfTheIntegers, IsInt ],
        
  function( R, c )
    local RP, powers;
    
    SetCharacteristic( R, c );
    
    SetIsRationalsForHomalg( R, false );
    
    if c = 0 then
        SetIsIntegersForHomalg( R, true );
        SetContainsAField( R, false );
        SetIsArtinian( R, false );
        SetKrullDimension( R, 1 ); ## FIXME: it is not set automatically although an immediate method is installed
    elif IsPrime( c ) then
        SetIsFieldForHomalg( R, true );
        SetRingProperties( R, c );
    else
        SetIsSemiLocalRing( R, true );
        SetIsIntegralDomain( R, false );
        powers := List( Collected( FactorsInt( c ) ), a -> a[2] );
        if Set( powers ) = [ 1 ] then
            SetIsSemiSimpleRing( R, true );
        else
            SetIsRegular( R, false );
            if Length( powers ) = 1 then
                SetIsLocal( R, true );
            fi;
        fi;
        SetKrullDimension( R, 0 );
    fi;
    
    RP := homalgTable( R );
    
    if HasIsIntegralDomain( R ) and IsIntegralDomain( R ) then
        if IsBound( RP!.RowRankOfMatrixOverDomain ) then
            RP!.RowRankOfMatrix := RP!.RowRankOfMatrixOverDomain;
        fi;
        
        if IsBound( RP!.ColumnRankOfMatrixOverDomain ) then
            RP!.ColumnRankOfMatrix := RP!.ColumnRankOfMatrixOverDomain;
        fi;
    fi;
    
    SetBasisAlgorithmRespectsPrincipalIdeals( R, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsFieldForHomalg, IsInt ],
        
  function( R, c )
    local RP;
    
    SetCharacteristic( R, c );
    
    if HasRationalParameters( R ) and Length( RationalParameters( R ) ) > 0 then
        SetIsRationalsForHomalg( R, false );
        SetIsResidueClassRingOfTheIntegers( R, false );
    else
        SetDegreeOverPrimeField( R, 1 );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound( RP!.RowRankOfMatrixOverDomain ) then
        RP!.RowRankOfMatrix := RP!.RowRankOfMatrixOverDomain;
    fi;
    
    if IsBound( RP!.ColumnRankOfMatrixOverDomain ) then
        RP!.ColumnRankOfMatrix := RP!.ColumnRankOfMatrixOverDomain;
    fi;
    
    SetFilterObj( R, IsField );
    SetLeftActingDomain( R, R );
    
    SetBasisAlgorithmRespectsPrincipalIdeals( R, true );
    
end );

##
InstallMethod( SetRingProperties,
        "for homalg rings",
        [ IsHomalgRing and IsFieldForHomalg, IsInt, IsInt ],
        
  function( R, c, d )
    local RP;
    
    SetCharacteristic( R, c );
    SetDegreeOverPrimeField( R, d );
    
    if HasRationalParameters( R ) and Length( RationalParameters( R ) ) > 0 then
        SetIsRationalsForHomalg( R, false );
        SetIsResidueClassRingOfTheIntegers( R, false );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound( RP!.RowRankOfMatrixOverDomain ) then
        RP!.RowRankOfMatrix := RP!.RowRankOfMatrixOverDomain;
    fi;
    
    if IsBound( RP!.ColumnRankOfMatrixOverDomain ) then
        RP!.ColumnRankOfMatrix := RP!.ColumnRankOfMatrixOverDomain;
    fi;
    
    SetFilterObj( R, IsField );
    SetLeftActingDomain( R, R );
    
    SetBasisAlgorithmRespectsPrincipalIdeals( R, true );
    
end );

##
InstallMethod( UnusedVariableName,
        "for a homalg ring and a string",
        [ IsHomalgRing, IsString ],
        
  function( R, t )
    local var;
    
    var := [ ];
    
    if HasRationalParameters( R ) then
        Append( var, List( RationalParameters( R ), Name ) );
    fi;
    
    if HasIndeterminatesOfPolynomialRing( R ) then
        Append( var, List( IndeterminatesOfPolynomialRing( R ), Name ) );
    fi;
    
    while true do
        
        if not t in var then
            return t;
        fi;
        
        t := Concatenation( t, "_" );
    od;
    
end );

##
InstallMethod( EuclideanQuotient,
        "for a homalg ring and two homalg ring elements",
        [ IsHomalgInternalRingRep and IsPrincipalIdealRing and IsCommutative, IsRingElement, IsRingElement ],
        
  function( R, a, b )
    
    return EuclideanQuotient( R!.ring, a, b );
    
end );

##
InstallMethod( EuclideanRemainder,
        "for a homalg ring and two homalg ring elements",
        [ IsHomalgInternalRingRep and IsPrincipalIdealRing and IsCommutative, IsRingElement, IsRingElement ],
        
  function( R, a, b )
    
    return EuclideanRemainder( R!.ring, a, b );
    
end );

##
InstallMethod( QuotientRemainder,
        "for a homalg ring and two homalg ring elements",
        [ IsHomalgInternalRingRep and IsPrincipalIdealRing and IsCommutative, IsRingElement, IsRingElement ],
        
  function( R, a, b )
    
    return QuotientRemainder( R!.ring, a, b );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

##
InstallGlobalFunction( CreateHomalgRing,
  function( arg )
    local nargs, r, IdentityMatrices, statistics, asserts,
          homalg_ring, table, properties, ar, type, matrix_type,
          ring_element_constructor, finalizers, c, el;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "expecting a ring as the first argument\n" );
    fi;
    
    r := arg[1];
    
    IdentityMatrices := ContainerForWeakPointers( TheTypeContainerForWeakPointersOnIdentityMatrices );
    Unbind( IdentityMatrices!.active );
    Unbind( IdentityMatrices!.deleted );
    Unbind( IdentityMatrices!.accessed );
    Unbind( IdentityMatrices!.cache_misses );
    
    statistics := rec(
                      BasisOfRowModule := 0,
                      BasisOfColumnModule := 0,
                      BasisOfRowsCoeff := 0,
                      BasisOfColumnsCoeff := 0,
                      DecideZeroRows := 0,
                      DecideZeroColumns := 0,
                      DecideZeroRowsEffectively := 0,
                      DecideZeroColumnsEffectively := 0,
                      SyzygiesGeneratorsOfRows := 0,
                      SyzygiesGeneratorsOfColumns := 0,
                      RelativeSyzygiesGeneratorsOfRows := 0,
                      RelativeSyzygiesGeneratorsOfColumns := 0,
                      PartiallyReducedBasisOfRowModule := 0,
                      PartiallyReducedBasisOfColumnModule := 0,
                      ReducedBasisOfRowModule := 0,
                      ReducedBasisOfColumnModule := 0,
                      ReducedSyzygiesGeneratorsOfRows := 0,
                      ReducedSyzygiesGeneratorsOfColumns := 0
                      );
    
    
    ##  <#GAPDoc Label="asserts">
    ##   Below you can find the record of the available level-4 assertions,
    ##   which is a &GAP;-component of every &homalg; ring. Each assertion can
    ##   thus be overwritten by package developers or even ordinary users.
    ##      <Listing Type="Code"><![CDATA[
    asserts :=
      rec(
          BasisOfRowModule :=
            function( B ) return ( NumberRows( B ) = 0 ) = IsZero( B ); end,
          
          BasisOfColumnModule :=
            function( B ) return ( NumberColumns( B ) = 0 ) = IsZero( B ); end,
          
          BasisOfRowsCoeff :=
            function( B, T, M ) return B = T * M; end,
          
          BasisOfColumnsCoeff :=
            function( B, M, T ) return B = M * T; end,
          
          DecideZeroRows_Effectively :=
            function( M, A, B ) return M = DecideZeroRows( A, B ); end,
          
          DecideZeroColumns_Effectively :=
            function( M, A, B ) return M = DecideZeroColumns( A, B ); end,
          
          DecideZeroRowsEffectively :=
            function( M, A, T, B ) return M = A + T * B; end,
          
          DecideZeroColumnsEffectively :=
            function( M, A, B, T ) return M = A + B * T; end,
          
          DecideZeroRowsWRTNonBasis :=
            function( B )
              local R;
              R := HomalgRing( B );
              if not ( HasIsBasisOfRowsMatrix( B ) and
                       IsBasisOfRowsMatrix( B ) ) and
                 IsBound( R!.DecideZeroWRTNonBasis ) then
                  if R!.DecideZeroWRTNonBasis = "warn" then
                      Info( InfoWarning, 1,
                            "about to reduce with respect to a matrix",
                            "with IsBasisOfRowsMatrix not set to true" );
                  elif R!.DecideZeroWRTNonBasis = "error" then
                      Error( "about to reduce with respect to a matrix",
                             "with IsBasisOfRowsMatrix not set to true\n" );
                  fi;
              fi;
            end,
          
          DecideZeroColumnsWRTNonBasis :=
            function( B )
              local R;
              R := HomalgRing( B );
              if not ( HasIsBasisOfColumnsMatrix( B ) and
                       IsBasisOfColumnsMatrix( B ) ) and
                 IsBound( R!.DecideZeroWRTNonBasis ) then
                  if R!.DecideZeroWRTNonBasis = "warn" then
                      Info( InfoWarning, 1,
                            "about to reduce with respect to a matrix",
                            "with IsBasisOfColumnsMatrix not set to true" );
                  elif R!.DecideZeroWRTNonBasis = "error" then
                      Error( "about to reduce with respect to a matrix",
                             "with IsBasisOfColumnsMatrix not set to true\n" );
                  fi;
              fi;
            end,
          
          ReducedBasisOfRowModule :=
            function( M, B )
              return GenerateSameRowModule( B, BasisOfRowModule( M ) );
            end,
          
          ReducedBasisOfColumnModule :=
            function( M, B )
              return GenerateSameColumnModule( B, BasisOfColumnModule( M ) );
            end,
          
          ReducedSyzygiesGeneratorsOfRows :=
            function( M, S )
              return GenerateSameRowModule( S, SyzygiesGeneratorsOfRows( M ) );
            end,
          
          ReducedSyzygiesGeneratorsOfColumns :=
            function( M, S )
              return GenerateSameColumnModule( S, SyzygiesGeneratorsOfColumns( M ) );
            end,
          
         );
    ##  ]]></Listing>
    ##  <#/GAPDoc>
    
    homalg_ring := rec(
                       ring := r,
                       IdentityMatrices := IdentityMatrices,
                       statistics := statistics,
                       asserts := asserts,
                       DecideZeroWRTNonBasis := "warn/error"
                       );
    
    if nargs > 1 and IshomalgTable( arg[nargs] ) then
        table := arg[nargs];
    else
        table := CreateHomalgTable( r );
    fi;
    
    if not IsBound( table!.InitialMatrix ) and IsBound( table!.ZeroMatrix ) then
        table!.InitialMatrix := table!.ZeroMatrix;
    fi;
    
    if not IsBound( table!.InitialIdentityMatrix ) and IsBound( table!.IdentityMatrix ) then
        table!.InitialIdentityMatrix := table!.IdentityMatrix;
    fi;
    
    properties := [ ];
    
    for ar in arg{[ 2 .. nargs ]} do
        if IsFilter( ar ) then
            Add( properties, ar );
        elif not IsBound( type ) and IsList( ar ) and Length( ar ) = 2 and ForAll( ar, IsType ) then
            type := ar;
        elif not IsBound( ring_element_constructor ) and IsFunction( ar ) then
            ring_element_constructor := ar;
        elif not IsBound( finalizers ) and IsList( ar ) and ForAll( ar, IsFunction ) then
            finalizers := ar;
        fi;
    od;
    
    if IsBound( type ) then
        matrix_type := type[2];
        type := type[1];
    elif IsSemiringWithOneAndZero( r ) then
        matrix_type := ValueGlobal( "TheTypeHomalgInternalMatrix" ); ## will be defined later in HomalgMatrix.gi
        type := TheTypeHomalgInternalRing;
    else
        Error( "the types of the ring and matrices were not specified\n" );
    fi;
    
    ## Objectify:
    ObjectifyWithAttributes(
            homalg_ring, type,
            homalgTable, table );
    
    if IsBound( matrix_type ) then
        SetTypeOfHomalgMatrix( homalg_ring, matrix_type );
    fi;
    
    if properties <> [ ] then
        for ar in properties do
            Setter( ar )( homalg_ring, true );
        od;
    fi;
    
    if IsBound( HOMALG_MATRICES.RingCounter ) then
        HOMALG_MATRICES.RingCounter := HOMALG_MATRICES.RingCounter + 1;
    else
        HOMALG_MATRICES.RingCounter := 1;
    fi;
    
    ## this has to be done before we call
    ## ring_element_constructor below
    homalg_ring!.creation_number := HOMALG_MATRICES.RingCounter;
    
    ## do not invoke SetRingProperties here, since I might be
    ## the first step of creating a residue class ring!
    
    ## this has to be invoked before we set the distinguished ring elements below;
    ## these functions are used to finalize the construction of the ring
    if IsBound( finalizers ) then
        Perform( finalizers, function( f ) f( homalg_ring ); end );
    fi;
    
    ## add distinguished ring elements like 0 and 1
    ## (sometimes also -1) to the homalg table:
    if IsBound( ring_element_constructor ) then
        
        for c in NamesOfComponents( table ) do
            if IsRingElement( table!.(c) ) then
                table!.(c) := ring_element_constructor( table!.(c), homalg_ring );
            fi;
        od;
        
        ## set the attribute
        SetRingElementConstructor( homalg_ring, ring_element_constructor );
        
    fi;
    
    if IsBound( HOMALG_MATRICES.ByASmallerPresentation ) and HOMALG_MATRICES.ByASmallerPresentation = true then
        homalg_ring!.ByASmallerPresentation := true;
    fi;
    
    ## e.g. needed to construct residue class rings
    homalg_ring!.ConstructorArguments := arg;
    
    homalg_ring!.interpret_rationals_func :=
      function( r )
        local d;
        d := DenominatorRat( r ) / homalg_ring;
        if IsZero( d ) or not IsUnit( homalg_ring, d ) then
            return fail;
        fi;
        return r / homalg_ring;
    end;
    
    return homalg_ring;
    
end );

##  <#GAPDoc Label="HomalgRingOfIntegers">
##  <ManSection>
##    <Func Arg="" Name="HomalgRingOfIntegers" Label="constructor for the integers"/>
##    <Returns>a &homalg; ring</Returns>
##    <Func Arg="c" Name="HomalgRingOfIntegers" Label="constructor for the residue class rings of the integers"/>
##    <Returns>a &homalg; ring</Returns>
##    <Description>
##      The no-argument form returns the ring of integers <M>&ZZ;</M> for &homalg;. <P/>
##      The one-argument form accepts an integer <A>c</A> and returns
##      the ring <M>&ZZ; / c </M> for &homalg;:
##      <List>
##        <Item><A>c</A><M> = 0</M> defaults to <M>&ZZ;</M></Item>
##        <Item>if <A>c</A> is a prime power then the package &GaussForHomalg; is loaded (if it fails to load an error is issued)</Item>
##        <Item>otherwise, the residue class ring constructor <C>/</C>
##          (&see; <Ref Oper="\/" Label="constructor for residue class rings" Style="Number"/>) is invoked</Item>
##      </List>
##      The operation <C>SetRingProperties</C> is automatically invoked to set the ring properties. <P/>
##      If for some reason you don't want to use the &GaussForHomalg; package (maybe because you didn't install it), then use<P/>
##      <C>HomalgRingOfIntegers</C>( ) <C>/</C> <A>c</A>; <P/>
##      but note that the computations will then be considerably slower.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallGlobalFunction( HomalgRingOfIntegers,
  function( arg )
    local nargs, R, c, d, rel;
    
    nargs := Length( arg );
    
    if nargs = 0 or arg[1] = 0 then
        c := 0;
        R := CreateHomalgRing( Integers );
        SetRingFilter( R, IsHomalgRing );
        SetRingElementFilter( R, IsInt );
    elif IsInt( arg[1] ) then
        c := arg[1];
        if Length( Collected( FactorsInt( c ) ) ) = 1 and IsPackageMarkedForLoading( "GaussForHomalg", ">= 2018.09.20") then
            R := HOMALG_RING_OF_INTEGERS_PRIME_POWER_HELPER( arg, c );
        else
            R := HomalgRingOfIntegers( );
            rel := HomalgRingRelationsAsGeneratorsOfLeftIdeal( [ c ], R );
            return R / rel;
        fi;
    else
        Error( "the first argument must be an integer\n" );
    fi;
    
    SetIsResidueClassRingOfTheIntegers( R, true );
    
    SetRingProperties( R, c );
    
    return R;
    
end );

##
InstallMethod( HomalgRingOfIntegersInUnderlyingCAS,
        "for an integer and homalg internal ring",
        [ IsInt, IsHomalgInternalRingRep ],
        
  HomalgRingOfIntegers );

##
InstallOtherMethod( \in,
        "for an object and a homalg internal ring",
        [ IsObject, IsHomalgInternalRingRep ], 100001,
        
  function( r, R )
    
    return r in R!.ring;
    
end );

##
InstallMethod( ParseListOfIndeterminates,
        "for lists",
        [ IsList ],
        
  function( _indets )
    local err, l, indets, i, v, l1, l2, p1, p2, c;
    
    if _indets = [ ] then
        return [ ];
    fi;
    
    err := function( ) Error( "a list of variable strings or range strings is expected\n" ); end;
    
    if ForAll( _indets, IsRingElement and HasName ) then
        return ParseListOfIndeterminates( List( _indets, Name ) );
    fi;
    
    if not ForAll( _indets, e -> IsStringRep( e ) or ( IsList( e ) and ForAll( e, IsInt ) ) ) then
        TryNextMethod( );
    fi;
    
    l := Length( _indets );
    
    indets := [ ];
    
    for i in [ 1 .. l ] do
        v := _indets[i];
        if Position( v, ',' ) <> fail then
            err( );
        elif ForAll( v, IsInt ) then
            ## do nothing
        elif Position( v, '.' ) = fail then
            if i < l and ForAll( _indets[ i + 1 ], IsInt ) then
                Append( indets, List( _indets[ i + 1 ], i -> Concatenation( v, String( i ) ) ) );
            else
                Add( indets, v );
            fi;
        elif PositionSublist( v, ".." ) = fail then
            err( );
        else
            v := SplitString( v, "." );
            v := Filtered( v, s -> not IsEmpty( s ) );
            if Length( v ) <> 2 then
                err( );
            fi;
#             p1 := PositionProperty( v[1], c -> Position( "0123456789", c ) <> fail );
#             p2 := PositionProperty( v[2], c -> Position( "0123456789", c ) <> fail );
            l1 := Flat( List( "0123456789", c -> Positions( v[1], c ) ) );
            Sort( l1 );
            l2 := Flat( List( "0123456789", c -> Positions( v[2], c ) ) );
            Sort( l2 );
            if l1 = [] or l2 = [] then
                err( );
            fi;
            p1 := l1[1];
            p2 := l2[1];
            for i in [ 2 .. Length( l1 ) ] do
                if l1[i-1] + 1 <> l1[i] then
                    p1 := l1[i];
                fi;
            od;
            for i in [ 2 .. Length( l2 ) ] do
                if l2[i-1] + 1 <> l2[i] then
                    p2 := l2[i];
                fi;
            od;
            if p1 = 1 then
                err( );
            fi;
            c := v[1]{[ 1 .. p1 - 1 ]};
            if p1 = p2 and c <> v[2]{[ 1 .. p2 - 1 ]} then
                err( );
            fi;
            p1 := EvalString( v[1]{[ p1 .. Length( v[1] ) ]} );
            p2 := EvalString( v[2]{[ p2 .. Length( v[2] ) ]} );
            Append( indets, List( [ p1 .. p2 ], i -> Concatenation( c, String( i ) ) ) );
        fi;
    od;
    
    return indets;
    
end );

##
InstallGlobalFunction( _PrepareInputForPolynomialRing,
  function( R, indets )
    local var, nr_var, properties, r, var_of_base_ring, param;
    
    if HasRingRelations( R ) then
        Error( "polynomial rings over homalg residue class rings are not supported yet\nUse the generic residue class ring constructor '/' provided by homalg after defining the ambient ring\nfor help type: ?homalg: constructor for residue class rings\n" );
    fi;
    
    ## get the new indeterminates for the ring and save them in var
    if IsString( indets ) and indets <> "" then
        var := SplitString( indets, "," );
    elif indets <> [ ] and ForAll( indets, i -> IsString( i ) and i <> "" ) then
        var := indets;
    else
        Error( "either a non-empty list of indeterminates or a comma separated string of them must be provided as the second argument\n" );
    fi;
    
    if not IsDuplicateFree( var ) then
        Error( "your list of indeterminates is not duplicate free: ", var, "\n" );
    fi;
    
    nr_var := Length( var );
    
    properties := [ IsCommutative ];
    
    ## K[x] is a principal ideal ring for a field K
    if Length( var ) = 1 and HasIsFieldForHomalg( R ) and IsFieldForHomalg( R ) then
        Add( properties, IsPrincipalIdealRing );
    fi;
    
    ## r is set to the ring of coefficients
    ## further a check is done, whether the old indeterminates (if exist) and the new
    ## ones are disjoint
    if HasIndeterminatesOfPolynomialRing( R ) then
        r := CoefficientsRing( R );
        var_of_base_ring := IndeterminatesOfPolynomialRing( R );
        var_of_base_ring := List( var_of_base_ring, Name );
        if Intersection2( var_of_base_ring, var ) <> [ ] then
            Error( "the following indeterminates are already elements of the base ring: ", Intersection2( var_of_base_ring, var ), "\n" );
        fi;
    else
        r := R;
        var_of_base_ring := [ ];
    fi;
    
    var := Concatenation( var_of_base_ring, var );
    
    if HasRationalParameters( r ) then
        param := Concatenation( ",", JoinStringsWithSeparator( RationalParameters( r ) ) );
    else
        param := "";
    fi;
    
    return [ r, var, nr_var, properties, param ];
    
end );

##
InstallMethod( PolynomialRing,
        "for homalg internal rings",
        [ IsHomalgInternalRingRep, IsList ],
        
  function( R, indets )
    
    Error( "given coefficients rings R = ", StringView( R ), " and list of indeterminates = ", indets, ", ",
           "but only univariate polynomial rings over internal homalg fields are supported, ",
           "for multivariate polynomial rings or more general coefficients rings R ",
           "construct the coefficients ring in an external CAS which support the desired construction\n" );
    
end );

##
InstallMethod( PolynomialRing,
        "for homalg internal rings",
        [ IsHomalgInternalRingRep, IsList ],
        
  function( R, indets )
    local ar, r, var, nr_var, properties, S, l;
    
    ar := _PrepareInputForPolynomialRing( R, indets );
    
    r := ar[1];
    var := ar[2];    ## all indeterminates, relative and base
    nr_var := ar[3]; ## the number of relative indeterminates
    properties := ar[4];
    
    ## create the new ring
    S := PolynomialRing( r!.ring, var );
    
    var := IndeterminatesOfPolynomialRing( S );
    
    if not ( HasIsFieldForHomalg( R ) and IsFieldForHomalg( R ) and Length( var ) <= 1 ) then
        TryNextMethod( );
    fi;
    
    S := CallFuncList( CreateHomalgRing, Concatenation( [ S ], properties ) );
    
    SetIsFreePolynomialRing( S, true );
    
    if HasIndeterminatesOfPolynomialRing( R ) and IndeterminatesOfPolynomialRing( R ) <> [ ] then
        SetBaseRing( S, R );
        l := Length( var );
        SetRelativeIndeterminatesOfPolynomialRing( S, var{[ l - nr_var + 1 .. l ]} );
    fi;
    
    SetRingProperties( S, r, var );
    
    SetFilterObj( S, IsUnivariatePolynomialRing );
    
    S!.pre_matrix_constructor := a -> One( S ) * a;
    
    return S;
    
end );

##
InstallMethod( \*,
        "for homalg rings",
        [ IsHomalgRing, IsList ], 1001, ## a high rank is necessary to overwrite the default behaviour of applying R to each list element
        
  function( R, indets )
    
    return PolynomialRing( R, ParseListOfIndeterminates( indets ) );
    
end );

##
InstallMethod( \*,
        "for homalg rings",
        [ IsHomalgRing, IsString ], 1001, ## for this method to be triggered first it has to have at least the same rank as the above method
        
  function( R, indets )
    
    if indets = "" then
        return R;
    else
        return R * SplitString( indets, "," );
    fi;
    
end );

##
InstallOtherMethod( \[\],
        "for homalg rings",
        [ IsHomalgRing, IsString ], 1001, ## for this method to be triggered first it has to have at least the same rank as the above method
        
  function( R, indets )
    
    return R * indets;
    
end );

##
InstallMethod( \*,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing and HasCoefficientsRing,
          IsHomalgRing and IsFreePolynomialRing and HasCoefficientsRing ],
        
  function( R1, R2 )
    local r, var2;
    
    r := CoefficientsRing( R1 );
    
    if not IsIdenticalObj( r, CoefficientsRing( R2 ) ) then
        TryNextMethod( );
    fi;
    
    var2 := IndeterminatesOfPolynomialRing( R2 );
    var2 := List( var2, Name );
    var2 := JoinStringsWithSeparator( var2 );
    
    return PolynomialRing( R1, var2 );
    
end );

##
InstallMethod( PolynomialRing,
        "for homalg rings",
        [ IsHomalgRing, IsString ], 1001,
        
  function( R, _var )
    local var;
    
    if _var = "" then
        return R;
    fi;
    
    var := ParseListOfIndeterminates( SplitString( _var, "," ) );
    
    return PolynomialRing( R, var );
    
end );

##
InstallMethod( PolynomialRingWithLexicographicOrdering,
        "for homalg rings",
        [ IsHomalgRing and HasIndeterminatesOfPolynomialRing ],
        
  function( R )
    local indets;
    
    indets := IndeterminatesOfPolynomialRing( R );
    
    indets := List( indets, String );
    
    return PolynomialRing( CoefficientsRing( R ), indets : order := "lex" );
    
end );

##
InstallMethod( RingOfDerivations,
        "for homalg rings",
        [ IsHomalgRing and IsCommutative, IsString ], 1001,
        
  function( S, _der )
    local der, A;
    
    der := ParseListOfIndeterminates( SplitString( _der, "," ) );
    
    A := RingOfDerivations( S, der );
    
    S!.RingOfDerivations := A;
    
    return A;
    
end );

##
InstallMethod( RingOfDerivations,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local var, A;
    
    if IsBound(R!.RingOfDerivations) then
        return R!.RingOfDerivations;
    fi;
    
    if HasRelativeIndeterminatesOfPolynomialRing( R ) then
        var := RelativeIndeterminatesOfPolynomialRing( R );
    else
        var := IndeterminatesOfPolynomialRing( R );
    fi;
    
    var := List( var, x -> Concatenation( "D", Name( x ) ) );
    
    A := RingOfDerivations( R, var );
    
    R!.RingOfDerivations := A;
    
    return A;
    
end );

##
InstallMethod( ExteriorRing,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, _anti )
    local anti, Base, A;
    
    if IsString( _anti ) then
        return ExteriorRing( S, SplitString( _anti, "," ) );
    else
        anti := ParseListOfIndeterminates( _anti );
    fi;
    
    if HasBaseRing( S ) then
        Base := BaseRing( S );
    else
        Base := CoefficientsRing( S );
    fi;
    A := ExteriorRing( S, CoefficientsRing( S ), Base, anti );
    
    SetRingProperties( A, S, anti );
    
    return A;
    
end );

##
InstallMethod( KoszulDualRing,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing, IsList ],
        
  function( S, anti )
    local A;
    
    if IsBound(S!.KoszulDualRing) then
        return S!.KoszulDualRing;
    fi;
    
    A := ExteriorRing( S, anti );
    
    ## thanks GAP4
    A!.KoszulDualRing := S;
    S!.KoszulDualRing := A;
    
    return A;
    
end );

##
InstallMethod( KoszulDualRing,
        "for homalg rings",
        [ IsHomalgRing ], 10000,
        
  function( S )
    
    if IsBound(S!.KoszulDualRing) then
        return S!.KoszulDualRing;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( KoszulDualRing,
        "for homalg rings",
        [ IsHomalgRing and IsFreePolynomialRing ],
        
  function( S )
    local l, Base, l_base, s1, s2, i;
    
    l := IndeterminatesOfPolynomialRing( S );
    
    if HasBaseRing( S ) then
        Base := BaseRing( S );
    else
        Base := CoefficientsRing( S );
    fi;
    
    if HasIsFreePolynomialRing( Base ) and IsFreePolynomialRing( Base ) then
        l_base := List( Indeterminates( Base ), a -> a / S );
    else
        l_base := [];
    fi;
    
    l := Difference( l, l_base );
    
    s1 := List( l, String );
    
    l := Length( l );
    
    s2 := List( [ 0 .. l - 1 ], a -> Concatenation( "e", String( a ) ) );
    
    for i in s1 do
        if not ( Position( s2, i ) = fail ) then
            Info( InfoWarning, 1,
                  "KoszulDualRing: Variable name ", i, " already in use"
                  );
        fi;
    od;
    
    return KoszulDualRing( S, s2 );
    
end );

## this is a technical method which should not be called by the user
## as its mathematical assumptions are not checked here:
## the relations must only involve the base ring
InstallMethod( KoszulDualRing,
        "for homalg rings",
        [ IsHomalgRing and HasAmbientRing ],
        
  function( S )
    local R, A, E;
    
    R := AmbientRing( S );
    
    A := KoszulDualRing( R );
    
    if HasBaseRing( R ) then
        SetBaseRing( A, BaseRing( R ) );
    fi;
    
    SetIsExteriorRing( A, true );
    
    E := A / MatrixOfRelations( S );
    
    SetIsExteriorRing( E, true );
    
    SetIndeterminatesOfExteriorRing( E,
            List( IndeterminatesOfExteriorRing( A ), e -> e / E ) );
    
    SetIndeterminateAntiCommutingVariablesOfExteriorRing( E,
            List( IndeterminateAntiCommutingVariablesOfExteriorRing( A ), e -> e / E ) );
    
    if HasBaseRing( S ) then
        SetBaseRing( E, BaseRing( S ) );
    fi;
    
    S!.KoszulDualRing := E;
    
    return E;
    
end );

## this is a technical method which should not be called by the user
## as its mathematical assumptions are not checked here:
## the relations must only involve the base ring
InstallMethod( BaseRing,
        "for homalg rings",
        [ IsExteriorRing and HasAmbientRing ],
        
  function( A )
    
    return BaseRing( AmbientRing( A ) );
    
end );

##
InstallGlobalFunction( HomalgRingElement,
  function( arg )
    local nargs, R;
    
    nargs := Length( arg );
    
    R := arg[nargs];

    if IsBound( IsHomalgExternalRingInSingularRep ) and IsBound( IsHomalgResidueClassRingRep ) and ValueGlobal("IsHomalgExternalRingInSingularRep")(R) and ValueGlobal("IsHomalgResidueClassRingRep")(R) then
        arg[1] := ReplacedString(arg[1], "|[ ", "");
        arg[1] := ReplacedString(arg[1], " ]|", "");
    fi;
    
    if HasRingElementConstructor( R ) then
        return CallFuncList( RingElementConstructor( R ), arg );
    elif not IsHomalgInternalRingRep( R ) then
        Error( "the non-internal homalg ring must contain a ring element constructor as the attribute RingElementConstructor\n" );
    elif IsString( arg[1] ) then
        return One( R ) * EvalString( arg[1] );
    fi;
    
    return One( R ) * arg[1];
    
end );

##
InstallMethod( \/,
        "for ring elements",
        [ IsRingElement, IsHomalgRing ],
        
  function( r, R )
    
    return HomalgRingElement( String( r ), R );
    
end );

##
InstallMethod( \/,
        "for strings",
        [ IsStringRep and IsString, IsHomalgRing ],
        
  function( r, R )
    
    return HomalgRingElement( r, R );
    
end );

##
InstallMethod( \/,
        "for strings",
        [ IsString, IsHomalgRing ],
        
  function( r, R )
    
    # IsStringRep( r ) is false since otherwise the method above would have been chosen
    r := CopyToStringRep( r );
    
    return HomalgRingElement( r, R );
    
end );

##
InstallMethod( \/,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRing ],
        
  function( r, R )
    
    if IsIdenticalObj( HomalgRing( r ), R ) then
        return r;
    fi;
    
    return HomalgRingElement( String( r ), R );
    
end );

##
InstallGlobalFunction( StringToElementStringList,
  function( arg )
    
    return SplitString( arg[1], ",", "[ ]\n" );
    
end );

##
InstallGlobalFunction( _CreateHomalgRingToTestProperties,
  function( arg )
    local homalg_ring, type;
    
    homalg_ring := rec( );
    
    type := TheTypeHomalgInternalRing;
    
    ## Objectify:
    CallFuncList( ObjectifyWithAttributes, Concatenation([ homalg_ring, type ], arg ) );
    
    return homalg_ring;
    
end );

##
InstallMethod( UnivariatePolynomial,
        "for a list and a string",
        [ IsList, IsString ],
        
  function( coeffs, r )
    local pol;
    
    pol := List( Reversed( [ 1 .. Length( coeffs ) ] ),
                 i -> Concatenation( "(", String( coeffs[i] ), ")*", r, "^", String( i - 1 ) )
                 );
    
    return JoinStringsWithSeparator( pol, "+" );
    
end );

##
InstallMethod( Homogenization,
        "for a homalg ring element and a homalg ring",
        [ IsHomalgRingElement, IsHomalgRing ],
        
  function( r, S )
    local R, d, indetsR, indetsS, indR, indS, z, coeffs, monoms, diff;
    
    if IsZero( r ) then
        return Zero( S );
    fi;
    
    R := HomalgRing( r );
    
    if not HasIsFreePolynomialRing( R ) and IsFreePolynomialRing( R ) and
       not HasIsFreePolynomialRing( S ) and IsFreePolynomialRing( S ) then
        TryNextMethod( );
    fi;
    
    d := Degree( r );
    
    if d = 0 then
        return r / S;
    fi;
    
    indetsR := Indeterminates( R );
    indetsS := Indeterminates( S );
    
    indS := List( indetsS, String );
    indR := List( indetsR, String );
    
    
    if not IsSubset( indS, indR ) then
        Error( "the indeterminates of the second argument do not contain the indeterminates of the ring underlying the given ring element\n" );
    fi;
    
    z := Difference( indS, indR );
    
    if Length( z ) <> 1 then
        Error( "the indeterminates of the second argument are not exactly one more than the indeterminates of the ring underlying the given ring element\n" );
    fi;
    
    z := Filtered( indetsS, a -> String( a ) = z[1] )[1];
    
    coeffs := Coefficients( r );
    monoms := coeffs!.monomials;
    
    coeffs := List( EntriesOfHomalgMatrix( coeffs ), c -> c / S );
    monoms := List( monoms, m -> ( m / S ) * z^( d - Degree( m ) ) );
    
    return Sum( ListN( coeffs, monoms, \* ) );
    
end );

##
InstallMethod( \*,
        "for an FFE and a homalg ring element",
        [ IsFFE, IsHomalgRingElement ],
        
  function( f, r )
    local R, e;
    
    R := HomalgRing( r );
    
    e := LogFFE( f, Z( Characteristic( R ), DegreeOverPrimeField( R ) ) );
    
    return PrimitiveElement( R )^e * r;
    
end );

##
InstallMethod( \*,
        "for a homalg ring element and an FFE",
        [ IsHomalgRingElement, IsFFE ],
        
  function( r, f )
    
    return f * r;
    
end );

## the second argument is there for method selection
InstallMethod( LcmOp,
        "for homalg objects",
        [ IsList, IsHomalgRingElement ],
        
  function( L, r )
    
    return Iterated( L, LcmOp );
    
end );

##
InstallMethod( LcmOp,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( p, q )
    local R, pp, qq;
    
    if IsZero( p ) or IsZero( q ) then
        return Zero( p );
    fi;
    
    R := HomalgRing( p );
    
    pp := HomalgMatrix( [ p ], 1, 1, R );
    qq := HomalgMatrix( [ q ], 1, 1, R );
    
    ## this can be expressed categorically
    return p * SyzygiesOfRows( pp, qq )[ 1, 1 ];
    
end );

##
InstallOtherMethod( GcdOp,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( p, q )
    local R, pp, qq;
    
    if IsZero( p ) or IsZero( q ) then
        return Zero( p );
    fi;
    
    R := HomalgRing( p );
    
    pp := HomalgMatrix( [ p ], 1, 1, R );
    qq := HomalgMatrix( [ q ], 1, 1, R );
    
    ## this can be expressed categorically
    return q / SyzygiesOfRows( pp, qq )[ 1, 1 ];
    
end );

##
InstallMethod( CoefficientsRing,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return CoefficientsRing( HomalgRing( r ) );
    
end );

##
InstallMethod( CoefficientsRing,
        "for homalg fields",
        [ IsHomalgRing and IsFieldForHomalg ],
        
  IdFunc );

##
InstallMethod( CoefficientsRing,
        "for homalg ring of integers",
        [ IsHomalgRing and IsIntegersForHomalg ],
        
  IdFunc );

##
InstallMethod( BaseRing,
        "for homalg fields",
        [ IsHomalgRing and IsFieldForHomalg ],
        
  IdFunc );

##
InstallMethod( BaseRing,
        "for homalg ring of integers",
        [ IsHomalgRing and IsIntegersForHomalg ],
        
  IdFunc );

##
InstallMethod( Size,
        "for a homalg ring",
        [ IsHomalgRing ],
        
  function( R )
    local p, d;
    
    p := Characteristic( R );
    
    if p = 0 then
        return infinity;
    fi;
    
    if not HasDegreeOverPrimeField( R ) then
        TryNextMethod( );
    fi;
    
    return p^DegreeOverPrimeField( R );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( String,
        "for homalg rings",
        [ IsHomalgRing ],
        
  RingName );

##
InstallMethod( ViewObj,
        "for homalg rings",
        [ IsHomalgRing ], 100,
        
  function( o )
    
    Print( RingName( o ) );
    
end );

##
InstallMethod( Display,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( o )
    
    Print( "<A" );
    
    if HasIsZero( o ) and IsZero( o ) then
        Print( " zero" );
    fi;
    
    if IsBound( o!.description ) then
        Print( o!.description );
    elif IsHomalgInternalRingRep( o ) then
        Print( "n internal" );
    fi;
    
    if IsPreHomalgRing( o ) then
        Print( " pre-homalg" );
    fi;
    
    Print( " ring>", "\n" );
    
end );

##
InstallMethod( DisplayRing,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( o )
    
    Display( o );
    
end );

##
InstallMethod( ViewObj,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( o )
    
    Print( Name( o ) ); ## this sets the attribute Name and the view method is never triggered again (as long as Name is set)
    
end );

##
InstallMethod( ViewString,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  Name );

## fallback method
InstallOtherMethod( LaTeXOutput,
        "for homalg ring elements",
        [ IsRingElement ],
        
  String );

##
InstallOtherMethod( LaTeXOutput,
        "for homalg ring elements",
        [ IsRat ],
        
  function( r )
    local n, d, s, l;
    
    n := NumeratorRat( r );
    d := DenominatorRat( r );
    
    if IsOne( d ) then
        return String( n );
    fi;
    
    s := SignInt( n );
    n := AbsInt( n );
    
    l := Concatenation( "\\frac{", String( n ), "}{", String( d ), "}" );
    
    if s = -1 then
        l := Concatenation( "-", l );
    fi;
    
    return l;
    
end );

##
InstallMethod( LaTeXOutput,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, RP, l;
    
    R := HomalgRing( r );
    
    if IsZero( r ) then
        return "0";
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.LaTeXString) then
        l := RP!.LaTeXString( r );
        RemoveCharacters( l, "\n" );
        return l;
    fi;
    
    TryNextMethod( );
    
end );

## fallback method
InstallMethod( LaTeXOutput,
        "for homalg ring",
        [ IsHomalgRing ],
        
  x -> "R" );

##
InstallMethod( LaTeXOutput,
        "for homalg ring of integers",
        [ IsHomalgRing and IsIntegersForHomalg ],
    x -> "\\mathbb{Z}"
);

##
InstallMethod( LaTeXOutput,
        "for homalg fields",
        [ IsHomalgRing and IsFieldForHomalg ],
        
  function( k )
    
    if HasIsRationalsForHomalg( k ) and IsRationalsForHomalg( k ) then
        return "\\mathbb{Q}";
    elif HasCharacteristic( k ) and IsPrime( Characteristic( k ) ) then
        return Concatenation( "\\mathbb{F}_{", String( Characteristic( k ) ), "}" );
    else
        TryNextMethod( );
    fi;
    
end );

##
InstallMethod( Display,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( o )
    
    Print( Name( o ), "\n" ); ## this sets the attribute Name and the display method is never triggered again (as long as Name is set)
    
end );

##
InstallMethod( Display,
        "for weak pointer containers of identity matrices",
        [ IsContainerForWeakPointersOnIdentityMatricesRep ],
        
  function( o )
    local weak_pointers;
    
    weak_pointers := o!.weak_pointers;
    
    Print( Filtered( [ 1 .. LengthWPObj( weak_pointers ) ], i -> IsBoundElmWPObj( weak_pointers, i ) ), "\n" );
    
end );
