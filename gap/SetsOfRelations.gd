#############################################################################
##
##  SetsOfRelations.gd          homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for sets of relations.
##
#############################################################################

####################################
#
# categories:
#
####################################

# A new GAP-category:

DeclareCategory( "IsSetsOfRelations",
        IsAttributeStoringRep );

####################################
#
# properties:
#
####################################

####################################
#
# attributes:
#
####################################

####################################
#
# function-operation-Attribute triples
#
####################################

KeyDependentOperation( "TransitionMap", IsSetsOfRelations, IsList, ReturnTrue );

####################################
#
# global functions and operations:
#
####################################

# constructors:

DeclareGlobalFunction( "CreateSetsOfRelationsForLeftModule" );

DeclareGlobalFunction( "CreateSetsOfRelationsForRightModule" );

# basic operations:

DeclareOperation( "PositionOfLastStoredSetOfRelations",
        [ IsSetsOfRelations ] );

