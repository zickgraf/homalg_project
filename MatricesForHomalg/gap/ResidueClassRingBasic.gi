# SPDX-License-Identifier: GPL-2.0-or-later
# MatricesForHomalg: Matrices for the homalg project
#
# Implementations
#

####################################
#
# global variables:
#
####################################

##
InstallValue( CommonHomalgTableForResidueClassRingsBasic,

        rec(
               
               ## Must only then be provided by the RingPackage in case the default
               ## "service" function does not match the Ring
               
               ##  <#GAPDoc Label="BasisOfRowModule:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M" Name="BasisOfRowModule" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               BasisOfRowModule :=
                 function( M )
                   local Mrel;
                   
                   Mrel := StackedRelations( M );
                   
                   Mrel := HomalgResidueClassMatrix(
                                   BasisOfRowModule( Mrel ), HomalgRing( M ) );
                   
                   return GetRidOfObsoleteRows( Mrel );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="BasisOfColumnModule:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M" Name="BasisOfColumnModule" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               BasisOfColumnModule :=
                 function( M )
                   local Mrel;
                   
                   Mrel := AugmentedRelations( M );
                   
                   Mrel := HomalgResidueClassMatrix(
                                   BasisOfColumnModule( Mrel ), HomalgRing( M ) );
                   
                   return GetRidOfObsoleteColumns( Mrel );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="BasisOfRowsCoeff:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M, T" Name="BasisOfRowsCoeff" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               BasisOfRowsCoeff :=
                 function( M, T )
                   local Mrel, TT, bas, nz;
                   
                   Mrel := StackedRelations( M );
                   
                   TT := HomalgVoidMatrix( HomalgRing( Mrel ) );
                   
                   bas := BasisOfRowsCoeff( Mrel, TT );
                   
                   bas := HomalgResidueClassMatrix( bas, HomalgRing( M ) );
                   
                   nz := NonZeroRows( bas );
                   
                   SetEval( T, CertainRows( CertainColumns( TT, [ 1 .. NumberRows( M ) ] ), nz ) );
                   
                   ResetFilterObj( T, IsVoidMatrix );
                   
                   ## the generic BasisOfRowsCoeff will assume that
                   ## ( NumberRows( B ) = 0 ) = IsZero( B )
                   return CertainRows( bas, nz );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="NonReducedBasisOfRowsCoeff:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M, T" Name="NonReducedBasisOfRowsCoeff" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               NonReducedBasisOfRowsCoeff :=
                 function( M, T )
                   local Mrel, TT, bas, nz;
                   
                   Mrel := StackedRelations( M );
                   
                   TT := HomalgVoidMatrix( HomalgRing( Mrel ) );
                   
                   bas := NonReducedBasisOfRowsCoeff( Mrel, TT );
                   
                   bas := HomalgResidueClassMatrix( bas, HomalgRing( M ) );
                   
                   nz := NonZeroRows( bas );
                   
                   SetEval( T, CertainRows( CertainColumns( TT, [ 1 .. NrRows( M ) ] ), nz ) );
                   
                   ResetFilterObj( T, IsVoidMatrix );
                   
                   ## the generic NonReducedBasisOfRowsCoeff will assume that
                   ## ( NrRows( B ) = 0 ) = IsZero( B )
                   return CertainRows( bas, nz );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="BasisOfColumnsCoeff:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M, T" Name="BasisOfColumnsCoeff" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               BasisOfColumnsCoeff :=
                 function( M, T )
                   local Mrel, TT, bas, nz;
                   
                   Mrel := AugmentedRelations( M );
                   
                   TT := HomalgVoidMatrix( HomalgRing( Mrel ) );
                   
                   bas := BasisOfColumnsCoeff( Mrel, TT );
                   
                   bas := HomalgResidueClassMatrix( bas, HomalgRing( M ) );
                   
                   nz := NonZeroColumns( bas );
                   
                   SetEval( T, CertainColumns( CertainRows( TT, [ 1 .. NumberColumns( M ) ] ), nz ) );
                   
                   ResetFilterObj( T, IsVoidMatrix );
                   
                   ## the generic BasisOfColumnsCoeff will assume that
                   ## ( NumberColumns( B ) = 0 ) = IsZero( B )
                   return CertainColumns( bas, nz );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="NonReducedBasisOfColumnsCoeff:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M, T" Name="NonReducedBasisOfColumnsCoeff" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               NonReducedBasisOfColumnsCoeff :=
                 function( M, T )
                   local Mrel, TT, bas, nz;
                   
                   Mrel := AugmentedRelations( M );
                   
                   TT := HomalgVoidMatrix( HomalgRing( Mrel ) );
                   
                   bas := NonReducedBasisOfColumnsCoeff( Mrel, TT );
                   
                   bas := HomalgResidueClassMatrix( bas, HomalgRing( M ) );
                   
                   nz := NonZeroColumns( bas );
                   
                   SetEval( T, CertainColumns( CertainRows( TT, [ 1 .. NrColumns( M ) ] ), nz ) );
                   
                   ResetFilterObj( T, IsVoidMatrix );
                   
                   ## the generic NonReducedBasisOfColumnsCoeff will assume that
                   ## ( NrColumns( B ) = 0 ) = IsZero( B )
                   return CertainColumns( bas, nz );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="DecideZeroRows:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="A, B" Name="DecideZeroRows" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               DecideZeroRows :=
                 function( A, B )
                   local Brel;
                   
                   Brel := StackedRelations( B );
                   
                   Brel := BasisOfRowModule( Brel );
                   
                   return HomalgResidueClassMatrix(
                                  DecideZeroRows( Eval( A ), Brel ), HomalgRing( A ) );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="DecideZeroColumns:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="A, B" Name="DecideZeroColumns" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               DecideZeroColumns :=
                 function( A, B )
                   local Brel;
                   
                   Brel := AugmentedRelations( B );
                   
                   Brel := BasisOfColumnModule( Brel );
                   
                   return HomalgResidueClassMatrix(
                                  DecideZeroColumns( Eval( A ), Brel ), HomalgRing( A ) );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="DecideZeroRowsEffectively:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="A, B, T" Name="DecideZeroRowsEffectively" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               DecideZeroRowsEffectively :=
                 function( A, B, T )
                   local Brel, TT, red;
                   
                   Brel := StackedRelations( B );
                   
                   TT := HomalgVoidMatrix( HomalgRing( Brel ) );
                   
                   red := DecideZeroRowsEffectively( Eval( A ), Brel, TT );
                   
                   SetEval( T, CertainColumns( TT, [ 1 .. NumberRows( B ) ] ) );
                   
                   ResetFilterObj( T, IsVoidMatrix );
                   
                   return HomalgResidueClassMatrix( red, HomalgRing( A ) );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="DecideZeroColumnsEffectively:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="A, B, T" Name="DecideZeroColumnsEffectively" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               DecideZeroColumnsEffectively :=
                 function( A, B, T )
                   local Brel, TT, red;
                   
                   Brel := AugmentedRelations( B );
                   
                   TT := HomalgVoidMatrix( HomalgRing( Brel ) );
                   
                   red := DecideZeroColumnsEffectively( Eval( A ), Brel, TT );
                   
                   SetEval( T, CertainRows( TT, [ 1 .. NumberColumns( B ) ] ) );
                   
                   ResetFilterObj( T, IsVoidMatrix );
                   
                   return HomalgResidueClassMatrix( red, HomalgRing( A ) );
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="SyzygiesGeneratorsOfRows:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M" Name="SyzygiesGeneratorsOfRows" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               SyzygiesGeneratorsOfRows :=
                 function( M )
                   local R, ring_rel, rel, S;
                   
                   R := HomalgRing( M );
                   
                   ring_rel := RingRelations( R );
                   
                   rel := MatrixOfRelations( ring_rel );
                   
                   if IsHomalgRingRelationsAsGeneratorsOfRightIdeal( ring_rel ) then
                       rel := Involution( rel );
                   fi;
                   
                   rel := DiagMat( ListWithIdenticalEntries( NumberColumns( M ), rel ) );
                   
                   S := SyzygiesGeneratorsOfRows( Eval( M ), rel );
                   
                   S := HomalgResidueClassMatrix( S, R );
                   
                   S := GetRidOfObsoleteRows( S );
                   
                   if IsZero( S ) then
                       
                       SetIsLeftRegular( M, true );
                       
                   fi;
                   
                   return S;
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="SyzygiesGeneratorsOfColumns:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M" Name="SyzygiesGeneratorsOfColumns" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               SyzygiesGeneratorsOfColumns :=
                 function( M )
                   local R, ring_rel, rel, S;
                   
                   R := HomalgRing( M );
                   
                   ring_rel := RingRelations( R );
                   
                   rel := MatrixOfRelations( ring_rel );
                   
                   if IsHomalgRingRelationsAsGeneratorsOfLeftIdeal( ring_rel ) then
                       rel := Involution( rel );
                   fi;
                   
                   rel := DiagMat( ListWithIdenticalEntries( NumberRows( M ), rel ) );
                   
                   S := SyzygiesGeneratorsOfColumns( Eval( M ), rel );
                   
                   S := HomalgResidueClassMatrix( S, R );
                   
                   S := GetRidOfObsoleteColumns( S );
                   
                   if IsZero( S ) then
                       
                       SetIsRightRegular( M, true );
                       
                   fi;
                   
                   return S;
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="RelativeSyzygiesGeneratorsOfRows:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M, M2" Name="RelativeSyzygiesGeneratorsOfRows" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               RelativeSyzygiesGeneratorsOfRows :=
                 function( M, M2 )
                   local M2rel, S;
                   
                   M2rel := StackedRelations( M2 );
                   
                   S := SyzygiesGeneratorsOfRows( Eval( M ), M2rel );
                   
                   S := HomalgResidueClassMatrix( S, HomalgRing( M ) );
                   
                   S := GetRidOfObsoleteRows( S );
                   
                   if IsZero( S ) then
                       
                       SetIsLeftRegular( M, true );
                       
                   fi;
                   
                   return S;
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               ##  <#GAPDoc Label="RelativeSyzygiesGeneratorsOfColumns:ResidueClassRing">
               ##  <ManSection>
               ##    <Func Arg="M, M2" Name="RelativeSyzygiesGeneratorsOfColumns" Label="ResidueClassRing"/>
               ##    <Returns>a &homalg; matrix over the ambient ring</Returns>
               ##    <Description>
               ##    <Listing Type="Code"><![CDATA[
               RelativeSyzygiesGeneratorsOfColumns :=
                 function( M, M2 )
                   local M2rel, S;
                   
                   M2rel := AugmentedRelations( M2 );
                   
                   S := SyzygiesGeneratorsOfColumns( Eval( M ), M2rel );
                   
                   S := HomalgResidueClassMatrix( S, HomalgRing( M ) );
                   
                   S := GetRidOfObsoleteColumns( S );
                   
                   if IsZero( S ) then
                       
                       SetIsRightRegular( M, true );
                       
                   fi;
                   
                   return S;
                   
                 end,
               ##  ]]></Listing>
               ##    </Description>
               ##  </ManSection>
               ##  <#/GAPDoc>
               
               X_ReducedBasisOfRowModule :=
                 function( M )
                   local Mrel;
                   
                   Mrel := StackedRelations( M );
                   
                   Mrel := HomalgResidueClassMatrix( ReducedBasisOfRowModule( Mrel ), HomalgRing( M ) );
                   
                   return GetRidOfObsoleteRows( Mrel );
                   
                 end,
               
               X_ReducedBasisOfColumnModule :=
                 function( M )
                   local Mrel;
                   
                   Mrel := AugmentedRelations( M );
                   
                   Mrel := HomalgResidueClassMatrix( ReducedBasisOfColumnModule( Mrel ), HomalgRing( M ) );
                   
                   return GetRidOfObsoleteColumns( Mrel );
                   
                 end,
               
               X_ReducedSyzygiesGeneratorsOfRows :=
                 function( M )
                   
                 end,
               
               X_ReducedSyzygiesGeneratorsOfColumns :=
                 function( M )
                   
                 end,
               
        )
 );
