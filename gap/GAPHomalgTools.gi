#############################################################################
##
##  GAPHomalgTools.gi         RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for the external rings provided by the ring packages
##  of the GAP implementation of homalg.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( CommonHomalgTableForGAPHomalgTools,
        
        rec(
               Zero := HomalgExternalRingElement( R -> homalgSendBlocking( [ "Zero(", R, ")" ], "need_output", HOMALG_IO.Pictograms.Zero ), "GAP", IsZero ),
               
               One := HomalgExternalRingElement( R -> homalgSendBlocking( [ "One(", R, ")" ], "need_output", HOMALG_IO.Pictograms.One ), "GAP", IsOne ),
               
               MinusOne := HomalgExternalRingElement( R -> homalgSendBlocking( [ "MinusOne(", R, ")" ], "need_output", HOMALG_IO.Pictograms.MinusOne ), "GAP" ),
               
               IsZero := r -> homalgSendBlocking( [ "IsZero(", r, ")" ] , "need_output", HOMALG_IO.Pictograms.IsZero ) = "true",
               
               IsOne := r -> homalgSendBlocking( [ "IsOne(", r, ")" ] , "need_output", HOMALG_IO.Pictograms.IsOne ) = "true",
               
               Minus :=
                 function( a, b )
                   
                   return homalgSendBlocking( [ a, "-(", b, ")" ], "need_output", HOMALG_IO.Pictograms.Minus );
                   
                 end,
               
               DivideByUnit :=
                 function( a, u )
                   
                   return homalgSendBlocking( [ "(", a, ")/(", u, ")"  ], "need_output", HOMALG_IO.Pictograms.DivideByUnit );
                   
                 end,
               
               IsUnit :=
                 function( R, u )
                   
                   return homalgSendBlocking( [ "IsUnit(", R, u, ")" ], "need_output", HOMALG_IO.Pictograms.IsUnit ) = "true";
                   
                 end,
               
               Sum :=
                 function( a, b )
                   
                   return homalgSendBlocking( [ a, "+", b ], "need_output", HOMALG_IO.Pictograms.Sum );
                   
                 end,
               
               Product :=
                 function( a, b )
                   
                   return homalgSendBlocking( [ "(", a, ")*(", b, ")" ], "need_output", HOMALG_IO.Pictograms.Product );
                   
                 end,
               
               CopyMatrix :=
                 function( C )
                   
                   return HomalgMatrix( homalgSendBlocking( [ "ShallowCopy(", C, ")" ], HOMALG_IO.Pictograms.CopyMatrix ), NrRows( C ), NrColumns( C ), HomalgRing( C ) );
                   
                 end,
               
               ZeroMatrix :=
                 function( C )
                   
                   return homalgSendBlocking( [ "HomalgZeroMatrix(", NrRows( C ), NrColumns( C ), HomalgRing( C ), ")" ], HOMALG_IO.Pictograms.ZeroMatrix );
                   
                 end,
               
               IdentityMatrix :=
                 function( C )
                   
                   return homalgSendBlocking( [ "HomalgIdentityMatrix(", NrRows( C ), HomalgRing( C ), ")" ], HOMALG_IO.Pictograms.IdentityMatrix );
                   
                 end,
               
               AreEqualMatrices :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ A, "=", B ] , "need_output", HOMALG_IO.Pictograms.AreEqualMatrices ) = "true";
                   
                 end,
               
               Involution :=
                 function( M )
                   
                   return homalgSendBlocking( [ "Involution(", M, ")" ], HOMALG_IO.Pictograms.Involution );
                   
                 end,
               
               CertainRows :=
                 function( M, plist )
                   
                   return homalgSendBlocking( [ "CertainRows(", M, plist, ")" ], HOMALG_IO.Pictograms.CertainRows );
                   
                 end,
               
               CertainColumns :=
                 function( M, plist )
                   
                   return homalgSendBlocking( [ "CertainColumns(", M, plist, ")" ], HOMALG_IO.Pictograms.CertainColumns );
                   
                 end,
               
               UnionOfRows :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ "UnionOfRows(", A, B, ")" ], HOMALG_IO.Pictograms.UnionOfRows );
                   
                 end,
               
               UnionOfColumns :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ "UnionOfColumns(", A, B, ")" ], HOMALG_IO.Pictograms.UnionOfColumns );
                   
                 end,
               
               DiagMat :=
                 function( e )
                   local f;
                   
                   f := Concatenation( [ "DiagMat([" ], e, [ "])" ] );
                   
                   return homalgSendBlocking( f, HOMALG_IO.Pictograms.DiagMat );
                   
                 end,
               
               KroneckerMat :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ "KroneckerMat(", A, B, ")" ], HOMALG_IO.Pictograms.KroneckerMat );
                   
                 end,
               
               MulMat :=
                 function( a, A )
                   
                   return homalgSendBlocking( [ "(", a, ")*", A ], HOMALG_IO.Pictograms.MulMat );
                   
                 end,
               
               AddMat :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ A, "+", B ], HOMALG_IO.Pictograms.AddMat );
                   
                 end,
               
               SubMat :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ A, "-", B ], HOMALG_IO.Pictograms.SubMat );
                   
                 end,
               
               Compose :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ A, "*", B ], HOMALG_IO.Pictograms.Compose );
                   
                 end,
               
               NrRows :=
                 function( C )
                   
                   return StringToInt( homalgSendBlocking( [ "NrRows(", C, ")" ], "need_output", HOMALG_IO.Pictograms.NrRows ) );
                   
                 end,
               
               NrColumns :=
                 function( C )
                   
                   return StringToInt( homalgSendBlocking( [ "NrColumns(", C, ")" ], "need_output", HOMALG_IO.Pictograms.NrColumns ) );
                   
                 end,
               
               IsZeroMatrix :=
                 function( M )
                   
                   return homalgSendBlocking( [ "IsZero(", M, ")" ] , "need_output", HOMALG_IO.Pictograms.IsZeroMatrix ) = "true";
                   
                 end,
               
               IsIdentityMatrix :=
                 function( M )
                   
                   return homalgSendBlocking( [ "IsIdentityMatrix(", M, ")" ] , "need_output", HOMALG_IO.Pictograms.IsIdentityMatrix ) = "true";
                   
                 end,
               
               IsDiagonalMatrix :=
                 function( M )
                   
                   return homalgSendBlocking( [ "IsDiagonalMatrix(", M, ")" ] , "need_output", HOMALG_IO.Pictograms.IsDiagonalMatrix ) = "true";
                   
                 end,
               
               ZeroRows :=
                 function( C )
                   local list_string;
                   
                   list_string := homalgSendBlocking( [ "ZeroRows(", C, ")" ], "need_output", HOMALG_IO.Pictograms.ZeroRows );
                   
                   return StringToIntList( list_string );
                   
                 end,
               
               ZeroColumns :=
                 function( C )
                   local list_string;
                   
                   list_string := homalgSendBlocking( [ "ZeroColumns(", C, ")" ], "need_output", HOMALG_IO.Pictograms.ZeroColumns );
                   
                   return StringToIntList( list_string );
                   
                 end,
               
               GetColumnIndependentUnitPositions :=
                 function( M, pos_list )
                   
                   return StringToDoubleIntList( homalgSendBlocking( [ "GetColumnIndependentUnitPositions(", M, pos_list, ")" ], "need_output", HOMALG_IO.Pictograms.GetColumnIndependentUnitPositions ) );
                   
                 end,
               
               GetRowIndependentUnitPositions :=
                 function( M, pos_list )
                   
                   return StringToDoubleIntList( homalgSendBlocking( [ "GetRowIndependentUnitPositions(", M, pos_list, ")" ], "need_output", HOMALG_IO.Pictograms.GetRowIndependentUnitPositions ) );
                   
                 end,
               
               GetUnitPosition :=
                 function( M, pos_list )
                   local list_string;
                   
                   list_string := homalgSendBlocking( [ "GetUnitPosition(", M, pos_list, ")" ], "need_output", HOMALG_IO.Pictograms.GetUnitPosition );
                   
                   if list_string = "fail" then
                       return fail;
                   else
                       return StringToIntList( list_string );
                   fi;
                   
                 end,
               
               DivideEntryByUnit :=
                 function( M, i, j, u )
                   
                   homalgSendBlocking( [ "DivideEntryByUnit(", M, i, j, u, ")" ], "need_command", HOMALG_IO.Pictograms.DivideEntryByUnit );
                   
                 end,
               
               DivideRowByUnit :=
                 function( M, i, u, j )
                   
                   homalgSendBlocking( [ "DivideRowByUnit(", M, i, u, j, ")" ], "need_command", HOMALG_IO.Pictograms.DivideRowByUnit );
                   
                 end,
               
               DivideColumnByUnit :=
                 function( M, j, u, i )
                   
                   homalgSendBlocking( [ "DivideColumnByUnit(", M, j, u, i, ")" ], "need_command", HOMALG_IO.Pictograms.DivideColumnByUnit );
                   
                 end,
               
               CopyRowToIdentityMatrix :=
                 function( M, i, L, j )
                   
                   homalgSendBlocking( [ "CopyRowToIdentityMatrix(", M, i, ",[", L[1], ",", L[2], "],", j, ")" ], "need_command", HOMALG_IO.Pictograms.CopyRowToIdentityMatrix );
                   
                 end,
               
               CopyColumnToIdentityMatrix :=
                 function( M, j, L, i )
                   
                   homalgSendBlocking( [ "CopyColumnToIdentityMatrix(", M, j, ",[", L[1], ",", L[2], "],", i, ")" ], "need_command", HOMALG_IO.Pictograms.CopyColumnToIdentityMatrix );
                   
                 end,
               
               SetColumnToZero :=
                 function( M, i, j )
                   
                   homalgSendBlocking( [ "SetColumnToZero(", M, i, j, ")" ], "need_command", HOMALG_IO.Pictograms.SetColumnToZero );
                   
                 end,
               
               GetCleanRowsPositions :=
                 function( M, clean_columns )
                   local list_string;
                   
                   list_string := homalgSendBlocking( [ "GetCleanRowsPositions(", M, clean_columns, ")" ], "need_output", HOMALG_IO.Pictograms.GetCleanRowsPositions );
                   
                   return StringToIntList( list_string );
                   
                 end,
               
               ConvertRowToMatrix :=
                 function( M, r, c )
                   
                   return homalgSendBlocking( [ "ConvertRowToMatrix(", M, r, c, ")" ], HOMALG_IO.Pictograms.ConvertRowToMatrix );
                   
                 end,
               
               ConvertColumnToMatrix :=
                 function( M, r, c )
                   
                   return homalgSendBlocking( [ "ConvertColumnToMatrix(", M, r, c, ")" ], HOMALG_IO.Pictograms.ConvertColumnToMatrix );
                   
                 end,
               
               ConvertMatrixToRow :=
                 function( M )
                   
                   return homalgSendBlocking( [ "ConvertMatrixToRow(", M, ")" ], HOMALG_IO.Pictograms.ConvertMatrixToRow );
                   
                 end,
               
               ConvertMatrixToColumn :=
                 function( M )
                   
                   return homalgSendBlocking( [ "ConvertMatrixToColumn(", M, ")" ], HOMALG_IO.Pictograms.ConvertMatrixToColumn );
                   
                 end,
               
        )
 );
