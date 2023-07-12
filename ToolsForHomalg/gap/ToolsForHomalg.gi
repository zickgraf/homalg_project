# SPDX-License-Identifier: GPL-2.0-or-later
# ToolsForHomalg: Special methods and knowledge propagation tools
#
# Implementations
#

####################################
#
# representations:
#
####################################

##  <#GAPDoc Label="IsStructureObjectOrFinitelyPresentedObjectRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="M" Name="IsStructureObjectOrFinitelyPresentedObjectRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The &GAP; representation of finitley generated &homalg; objects. <P/>
##      It is a representation of the &GAP; category <Ref Filt="IsHomalgObject"/>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsStructureObjectOrFinitelyPresentedObjectRep",
        IsStructureObjectOrObject,
        [ ] );

# a new representation for the GAP-category IsHomalgObject
# which is a subrepresentation of the representation IsStructureObjectOrFinitelyPresentedObjectRep and IsHomalgRingOrModule:
DeclareRepresentation( "IsHomalgRingOrFinitelyPresentedModuleRep",
        IsStructureObjectOrFinitelyPresentedObjectRep and
        IsHomalgRingOrModule,
        [ ] );

# a new representation for the GAP-category IsContainerForWeakPointers:
DeclareRepresentation( "IsContainerForWeakPointersRep",
        IsContainerForWeakPointers,
        [ "weak_pointers", "active", "deleted", "counter", "cache_hits" ] );

# a new subrepresentation of IsContainerForWeakPointersRep:
DeclareRepresentation( "IsContainerForWeakPointersOnObjectsRep",
        IsContainerForWeakPointersRep,
        [ "weak_pointers", "active", "deleted", "counter", "accessed", "cache_misses", "cache_hits" ] );

# a new subrepresentation of IsContainerForWeakPointersOnObjectsRep:
DeclareRepresentation( "IsContainerForWeakPointersOnComputedValuesRep",
        IsContainerForWeakPointersOnObjectsRep,
        [ "weak_pointers", "weak_pointers_on_values", "active", "deleted", "counter", "accessed", "cache_misses", "cache_hits" ] );

# a new subrepresentation of IsContainerForWeakPointersOnObjectsRep:
DeclareRepresentation( "IsContainerForWeakPointersOnContainersRep",
        IsContainerForWeakPointersOnObjectsRep,
        [ "weak_pointers", "active", "deleted", "counter" ] );

####################################
#
# representations for pointer object
#
####################################

# a new representation for the GAP-category IsContainerForPointers:
DeclareRepresentation( "IsContainerForPointersRep",
        IsContainerForPointers,
        [ "pointers", "counter", "cache_hits", "cache_misses" ] );

# a new subrepresentation of IsContainerForPointersRep:
DeclareRepresentation( "IsContainerForPointersOnObjectsRep",
        IsContainerForPointersRep,
        [ "pointers", "counter", "accessed" ] );

# a new subrepresentation of IsContainerForPointersOnObjectsRep:
DeclareRepresentation( "IsContainerForPointersOnComputedValuesRep",
        IsContainerForPointersOnObjectsRep,
        [ "pointers", "pointers_on_values", "counter", "accessed" ] );

# a new subrepresentation of IsContainerForPointersOnObjectsRep:
DeclareRepresentation( "IsContainerForPointersOnContainersRep",
        IsContainerForPointersOnObjectsRep,
        [ "pointers", "counter" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfContainersForWeakPointers",
        NewFamily( "TheFamilyOfContainersForWeakPointers" ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointers",
        NewType( TheFamilyOfContainersForWeakPointers,
                IsContainerForWeakPointersRep ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointersOnObjects",
        NewType( TheFamilyOfContainersForWeakPointers,
                IsContainerForWeakPointersOnObjectsRep ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointersOnComputedValues",
        NewType( TheFamilyOfContainersForWeakPointers,
                IsContainerForWeakPointersOnComputedValuesRep ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointersOnContainers",
        NewType( TheFamilyOfContainersForWeakPointers,
                IsContainerForWeakPointersOnContainersRep ) );

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

InstallValue( HOMALG_TOOLS,
        rec(
            TotalRuntimes := 0,
            
            minus_infinity := -999999,
            
            ReadPackageOnce := [ ],
            
            ## ContainersForWeakPointers "will be added below",
            
            )
        );

## cannot move it to read.g
if IsBound( MakeThreadLocal ) then
    MakeThreadLocal( "HOMALG_TOOLS" );
fi;

####################################
#
# global functions:
#
####################################

InfoOfObject :=
  function( arg )
    local o, depth, attr, cmpn, cats, reps, prop, tprp, all, i, r, a;
    
    o := arg[1];
    
    if Length( arg ) > 1 then
        depth := arg[2];
    else
        depth := 1;
    fi;
        
    if depth = 0 then
        return o;
    elif IsAttributeStoringRep( o ) then
        attr := KnownAttributesOfObject( o );
        cmpn := Filtered( NamesOfComponents( o ), a -> not( a in attr ) );
        cats := CategoriesOfObject( o );
        reps := RepresentationsOfObject( o );
        prop := KnownPropertiesOfObject( o );
        
        all := rec( attributes := attr,
                    components := cmpn,
                    categories := cats,
                    representations := reps,
                    properties := prop );
    elif IsComponentObjectRep( o ) then
        cats := CategoriesOfObject( o );
        reps := RepresentationsOfObject( o );
        
        all := rec( components := NamesOfComponents( o ),
                    categories := cats,
                    representations := reps );
    else
        return o;
    fi;
    
    ## below o is an AttributeStoringRep or at least a ComponentObjectRep:
    
    for i in NamesOfComponents( all ) do
        if i in [ "attributes" ] then
            r := rec( );
            for a in all.(i) do
                r.(a) := InfoOfObject( ValueGlobal( a )( o ), depth-1 );
            od;
            all.(i) := r;
        elif i in [ "components" ] then
            r := rec( );
            for a in all.(i) do
                r.(a) := InfoOfObject( o!.(a), depth-1 );
            od;
            all.(i) := r;
        elif i = "properties" then
            r := rec( );
            for a in all.(i) do
                r.(a) := ValueGlobal( a )( o );
            od;
            all.(i) := r;
        fi;
    od;
    
    return all;
    
end;

##
InstallGlobalFunction( ContainerForWeakPointers,
  function( arg )
    local nargs, container, component, type, containers;
    
    nargs := Length( arg );
    
    container := rec( weak_pointers := WeakPointerObj( [ ] ),
                      active := [ ],
                      deleted := [ ],
                      counter := 0,
                      accessed := 0,
                      cache_misses := 0,
                      cache_hits := 0 );
    
    for component in arg{[ 2 .. nargs ]} do
        container.( component[1] ) := component[2];
    od;
    
    type := arg[1];
    
    ## Objectify:
    Objectify( type, container );
    
    if IsBound( HOMALG_TOOLS.ContainersForWeakPointers ) then
        _AddElmWPObj_ForHomalg( HOMALG_TOOLS.ContainersForWeakPointers, container );
    fi;
    
    if IsContainerForWeakPointersOnComputedValuesRep( container ) then
        container!.weak_pointers_on_values := WeakPointerObj( [ ] );
    fi;
    
    return container;
    
end );

HOMALG_TOOLS.ContainersForWeakPointers := ContainerForWeakPointers( TheTypeContainerForWeakPointersOnContainers );
Unbind( HOMALG_TOOLS.ContainersForWeakPointers!.accessed );
Unbind( HOMALG_TOOLS.ContainersForWeakPointers!.cache_misses );
Unbind( HOMALG_TOOLS.ContainersForWeakPointers!.cache_hits );

##
InstallGlobalFunction( homalgTotalRuntimes,
  function( arg )
    local r, t;
    
    r := Runtimes( );
    
    HOMALG_TOOLS.TotalRuntimes := r.user_time;
    
    if IsBound( r.system_time ) and r.system_time <> fail then
        HOMALG_TOOLS.TotalRuntimes := HOMALG_TOOLS.TotalRuntimes + r.system_time;
    fi;
    
    if IsBound( r.user_time_children ) and r.user_time_children <> fail then
        HOMALG_TOOLS.TotalRuntimes := HOMALG_TOOLS.TotalRuntimes + r.user_time_children;
    fi;
    
    if IsBound( r.system_time_children ) and r.system_time_children <> fail then
        HOMALG_TOOLS.TotalRuntimes := HOMALG_TOOLS.TotalRuntimes + r.system_time_children;
    fi;
    
    if Length( arg ) = 0 then
        return HOMALG_TOOLS.TotalRuntimes;
    fi;
    
    t := HOMALG_TOOLS.TotalRuntimes - arg[1];
    
    if Length( arg ) > 1 then
        return Concatenation( StringTime( t ), " h" );
    fi;
    
    return t;
    
end );

##
InstallGlobalFunction( AddLeftRightLogicalImplicationsForHomalg,
  function( list, properties )
    local prop, property, left_property, right_property, add;
    
    for prop in properties do;
        
        if IsList( prop ) and Length( prop ) = 2 and ForAll( prop, IsString ) then
            
            property := ValueGlobal( Concatenation( prop[1], prop[2] ) );
            left_property := ValueGlobal( Concatenation( prop[1], "Left", prop[2] ) );
            right_property := ValueGlobal( Concatenation( prop[1], "Right", prop[2] ) );
            
            add := [
                    
                    [ left_property, "and", right_property,
                      "define", property ],
                    
                    [ property,
                      "implies by definition", left_property ],
                    
                    [ property,
                      "implies by definition", right_property ],
                    
                    [ IsCommutative, "and", left_property,
                      "trivially imply", right_property ],
                    
                    [ IsCommutative, "and", right_property,
                      "trivially imply", left_property ],
                    
                    ## we also need these two for their contra positions to get installed
                    [ IsCommutative, "and", left_property,
                      "trivially imply", property ],
                    
                    [ IsCommutative, "and", right_property,
                      "trivially imply", property ],
                    
                    ];
            
        elif IsList( prop ) and Length( prop ) = 3 and ForAll( prop, IsString ) then
            
            property := ValueGlobal( Concatenation( prop[1], prop[2] ) );
            left_property := ValueGlobal( Concatenation( prop[1], "Left", prop[2] ) );
            right_property := ValueGlobal( Concatenation( prop[1], "Right", prop[2] ) );
            
            add := [
                    
                    [ IsCommutative, "and", left_property,
                      "trivally imply", right_property ],
                    
                    [ IsCommutative, "and", left_property,
                      "trivally imply", property ],
                    
                    [ IsCommutative, "and", right_property,
                      "trivally imply", left_property ],
                    
                    [ IsCommutative, "and", right_property,
                      "trivally imply", property ],
                    
                    [ IsCommutative, "and", property,
                      "trivally imply", left_property ],
                    
                    [ IsCommutative, "and", property,
                      "trivally imply", right_property ]
                    
                    ];
            
        elif IsList( prop ) and Length( prop ) = 3 and ForAll( prop{[ 1 .. 2 ]}, IsString ) and IsOperation( prop[3] ) then
            
            property := ValueGlobal( Concatenation( prop[1], prop[2] ) );
            left_property := ValueGlobal( Concatenation( prop[1], "Left", prop[2] ) );
            right_property := ValueGlobal( Concatenation( prop[1], "Right", prop[2] ) );
            
            add := [
                    
                    [ left_property, "and", right_property,
                      "define", property ],
                    
                    [ property,
                      "implies by definition", left_property ],
                    
                    [ property,
                      "implies by definition", right_property ],
                    
                    ];
            
        fi;
        
        Append( list, add );
        
    od;
    
end );

## a global function for logical implications:
InstallGlobalFunction( LogicalImplicationsForOneHomalgObject,
  function( statement, filter )
    local len, propA, propB, propC, prop;
    
    len := Length( statement );
    
    if len = 3 then
        
        propA := statement[1];
        prop := statement[3];
        
        #InstallTrueMethod( prop, filter and propA );
        
        InstallImmediateMethod( prop,
            filter and propA,
            function( o )
                
                return true;
                
            end );
        
        InstallImmediateMethod( propA,
                filter and Tester( prop ), 0,
                
          function( o )
            if not prop( o ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
    elif len = 5 then
        
        propA := statement[1];
        propB := statement[3];
        prop := statement[5];
        
        InstallTrueMethod( prop, filter and propA and propB );
        
        InstallImmediateMethod( propA,
                filter and Tester( propB ) and Tester( prop ), 0,
                
          function( o )
            if propB( o ) and not prop( o ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
        InstallImmediateMethod( propB,
                filter and Tester( propA ) and Tester( prop ), 0,
                
          function( o )
            if propA( o ) and not prop( o ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
    elif len = 7 then
        
        propA := statement[1];
        propB := statement[3];
        propC := statement[5];
        prop := statement[7];
        
        InstallTrueMethod( prop, filter and propA and propB and propC );
        
        InstallImmediateMethod( propA,
                filter and Tester( propB ) and Tester( propC ) and Tester( prop ), 0,
                
          function( o )
            if propB( o ) and propC( o ) and not prop( o ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
        InstallImmediateMethod( propB,
                filter and Tester( propA ) and Tester( propC ) and Tester( prop ), 0,
                
          function( o )
            if propA( o ) and propC( o ) and not prop( o ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
        InstallImmediateMethod( propC,
                filter and Tester( propA ) and Tester( propB ) and Tester( prop ), 0,
                
          function( o )
            if propA( o ) and propB( o ) and not prop( o ) then
                return false;
            fi;
            
            TryNextMethod( );
            
        end );
        
    fi;
    
end );

##
InstallGlobalFunction( InstallLogicalImplicationsForHomalgBasicObjects,
  function( arg )
    local nargs, properties, filter, subobj_filter, statement;
    
    nargs := Length( arg );
    
    if nargs < 2 then
        Error( "too few arguments\n" );
    fi;
    
    properties := arg[1];
    filter := arg[2];
    
    if nargs = 2 then
    
        for statement in properties do;
            
            LogicalImplicationsForOneHomalgObject( statement, filter );
            
        od;
        
    elif nargs = 3 then
        
        subobj_filter := arg[3];
        
        for statement in properties do;
            
            LogicalImplicationsForTwoHomalgBasicObjects( statement, filter, subobj_filter );
            
        od;
        
    fi;
    
end );

## a global function for left/right attributes:
InstallGlobalFunction( LeftRightAttributesForHomalg,
  function( attr, filter )
    local attribute, left_attribute, right_attribute;
    
    attribute := ValueGlobal( attr );
    left_attribute := ValueGlobal( Concatenation( "Left", attr ) );
    right_attribute := ValueGlobal( Concatenation( "Right", attr ) );
    
    InstallImmediateMethod( left_attribute,
            filter and Tester( attribute ), 0,
            
      function( o )
        
        return attribute( o );
        
    end );
    
    InstallImmediateMethod( right_attribute,
            filter and Tester( attribute ), 0,
            
      function( o )
        
        return attribute( o );
        
    end );
    
    InstallImmediateMethod( attribute,
            filter and Tester( left_attribute ) and Tester( right_attribute ), 0,
            
      function( o )
        local l;
        
        l := left_attribute( o );
        
        if l = right_attribute( o ) then
            return l;
        fi;
        
        TryNextMethod( );
        
    end );
    
    ## extra for homalg rings
    if filter = IsStructureObject then
        
        InstallImmediateMethod( left_attribute,
                filter and Tester( right_attribute ) and IsCommutative, 0,
                
          function( o )
            
            return right_attribute( o );
            
        end );
        
        InstallImmediateMethod( right_attribute,
                filter and Tester( left_attribute ) and IsCommutative, 0,
                
          function( o )
            
            return left_attribute( o );
            
        end );
        
    fi;
    
end );

##
InstallGlobalFunction( InstallLeftRightAttributesForHomalg,
  function( attributes, filter )
    local attribute;
    
    for attribute in attributes do;
        
        LeftRightAttributesForHomalg( attribute, filter );
        
    od;
    
end );

##
InstallGlobalFunction( MatchPropertiesAndAttributes,
  function( arg )
    local S, T, properties, attributes, propertiesS, propertiesT,
          attributesS, attributesT, p, a, components, c, attributes_do_not_check_their_equality;
    
    S := arg[1];
    T := arg[2];
    properties := arg[3];
    attributes := arg[4];
    
    propertiesS := Intersection2( KnownPropertiesOfObject( S ), properties );
    propertiesT := Intersection2( KnownPropertiesOfObject( T ), properties );
    
    attributesS := Intersection2( KnownAttributesOfObject( S ), attributes );
    attributesT := Intersection2( KnownAttributesOfObject( T ), attributes );
    
    ## for properties:
    for p in propertiesS do ## also check if properties already set for both objects coincide
        Setter( ValueGlobal( p ) )( T, ValueGlobal( p )( S ) );
    od;
    
    ## now backwards
    for p in Difference( propertiesT, propertiesS ) do
        Setter( ValueGlobal( p ) )( S, ValueGlobal( p )( T ) );
    od;
    
    ## for attributes:
    for a in Difference( attributesS, attributesT ) do
        Setter( ValueGlobal( a ) )( T, ValueGlobal( a )( S ) );
    od;
    
    ## now backwards
    for a in Difference( attributesT, attributesS ) do
        Setter( ValueGlobal( a ) )( S, ValueGlobal( a )( T ) );
    od;
    
    ## also check if properties already set for both objects coincide
    
    ## by now, more attributes than the union might be konwn
    attributesS := Intersection2( KnownAttributesOfObject( S ), attributes );
    attributesT := Intersection2( KnownAttributesOfObject( T ), attributes );
    
    for a in Intersection2( attributesS, attributesT ) do
        if ValueGlobal( a )( S ) <> ValueGlobal( a )( T ) then
            Error( "the attribute ", a, " has different values for source and target object\n" );
        fi;
    od;
    
    if Length( arg ) > 4 then
        components := arg[5];
        
        for c in components do
            if IsBound( S!.(c) ) and not IsBound( T!.(c) ) then
                T!.(c) := S!.(c);
            elif IsBound( T!.(c) ) and not IsBound( S!.(c) ) then
                S!.(c) := T!.(c);
            fi;
        od;
        
    fi;
    
    if Length( arg ) > 5 then
        ## checking their equality might again trigger MatchPropertiesAndAttributes
        ## and cause infinite loops
        attributes_do_not_check_their_equality := arg[6];
        
        attributesS := Intersection2( KnownAttributesOfObject( S ), attributes_do_not_check_their_equality );
        attributesT := Intersection2( KnownAttributesOfObject( T ), attributes_do_not_check_their_equality );
        
        ## for attributes:
        for a in Difference( attributesS, attributesT ) do
            Setter( ValueGlobal( a ) )( T, ValueGlobal( a )( S ) );
        od;
        
        ## now backwards
        for a in Difference( attributesT, attributesS ) do
            Setter( ValueGlobal( a ) )( S, ValueGlobal( a )( T ) );
        od;
        
    fi;
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullPropertyOrAttribute,
  function( filter1, filter2, prop_attr, trigger, get_remote_object );
    
    InstallImmediateMethod( prop_attr,
            filter1 and Tester( trigger ), 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop_attr )( U ) then
            return prop_attr( U );
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop_attr,
            "for homalg objects with an underlying object (PullPropertyOrAttribute)",
            [ filter2 ],
            
      function( M )
        
        return prop_attr( get_remote_object( M ) );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToConditionallyPullPropertyOrAttribute,
  function( filter1, filter2, prop_attr, condition, trigger, get_remote_object );
    
    InstallImmediateMethod( prop_attr,
            filter1 and Tester( trigger ) and condition, 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop_attr )( U ) then
            return prop_attr( U );
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop_attr,
            "for homalg objects with an underlying object (ConditionallyPullPropertyOrAttribute)",
            [ filter2 ],
            
      function( M )
        
        return condition( M ) and prop_attr( get_remote_object( M ) );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullPropertyOrAttributeWithDifferentName,
  function( filter1, filter2, prop_attr, trigger, get_remote_object );
    
    InstallImmediateMethod( prop_attr[1],
            filter1 and Tester( trigger ), 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop_attr[2] )( U ) then
            return prop_attr[2]( U );
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop_attr[1],
            "for homalg objects with an underlying object (PullPropertyOrAttributeWithDifferentName)",
            [ filter2 ],
            
      function( M )
        
        return prop_attr[2]( get_remote_object( M ) );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullPropertiesOrAttributes,
  function( filter1, filter2, PROP_ATTR, triggers, get_remote_object )
    local trigger, prop_attr;
    
    for trigger in triggers do
        
        for prop_attr in PROP_ATTR do
            
            if IsString( prop_attr ) then
                
                if prop_attr <> trigger then
                    InstallImmediateMethodToPullPropertyOrAttribute(
                            filter1,
                            filter2,
                            ValueGlobal( prop_attr ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            elif IsList( prop_attr ) and Length( prop_attr ) = 2 and
              IsString( prop_attr[1] ) and IsList( prop_attr[2] ) and IsString( prop_attr[2][1] ) then
                
                if prop_attr[1] <> trigger then
                    InstallImmediateMethodToConditionallyPullPropertyOrAttribute(
                            filter1,
                            filter2,
                            ValueGlobal( prop_attr[1] ),
                            ValueGlobal( prop_attr[2][1] ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            elif IsList( prop_attr ) and Length( prop_attr ) = 2 and ForAll( prop_attr, IsString ) then
                
                if prop_attr[1] <> trigger then
                    InstallImmediateMethodToPullPropertyOrAttributeWithDifferentName(
                            filter1,
                            filter2,
                            List( prop_attr, ValueGlobal ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            fi;
            
        od;
        
    od;
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullTrueProperty,
  function( filter1, filter2, prop, trigger, get_remote_object );
    
    InstallImmediateMethod( prop,
            filter1 and Tester( trigger ), 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop )( U ) and prop( U ) then
            return true;
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop,
            "for homalg objects with an underlying object (MethodToPullTrueProperty)",
            [ filter2 ],
            
      function( M )
        
        if prop( get_remote_object( M ) ) then
            return true;
        fi;
        
        TryNextMethod();
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToConditionallyPullTrueProperty,
  function( filter1, filter2, prop, condition, trigger, get_remote_object );
    
    InstallImmediateMethod( prop,
            filter1 and Tester( trigger ) and condition, 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop )( U ) and prop( U ) then
            return true;
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop,
            "for homalg objects with an underlying object (ConditionallyPullTrueProperty)",
            [ filter2 ],
            
      function( M )
        
        if condition( M ) and prop( get_remote_object( M ) ) then
            return true;
        fi;
        
        TryNextMethod();
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullTruePropertyWithDifferentName,
  function( filter1, filter2, prop, trigger, get_remote_object );
    
    InstallImmediateMethod( prop[1],
            filter1 and Tester( trigger ), 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop[2] )( U ) and prop[2]( U ) then
            return true;
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop[1],
            "for homalg objects with an underlying object (PullTruePropertyWithDifferentName)",
            [ filter2 ],
            
      function( M )
        
        if prop[2]( get_remote_object( M ) ) then
            return true;
        fi;
        
        TryNextMethod();
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullTrueProperties,
  function( filter1, filter2, PROP, triggers, get_remote_object )
    local trigger, prop;
    
    for trigger in triggers do
        
        for prop in PROP do
            
            if IsString( prop ) then
                
                if prop <> trigger then
                    InstallImmediateMethodToPullTrueProperty(
                            filter1,
                            filter2,
                            ValueGlobal( prop ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            elif IsList( prop ) and Length( prop ) = 2 and
              IsString( prop[1] ) and IsList( prop[2] ) and IsString( prop[2][1] ) then
                
                if prop[1] <> trigger then
                    InstallImmediateMethodToConditionallyPullTrueProperty(
                            filter1,
                            filter2,
                            ValueGlobal( prop[1] ),
                            ValueGlobal( prop[2][1] ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            elif IsList( prop ) and Length( prop ) = 2 and ForAll( prop, IsString ) then
                
                if prop[1] <> trigger then
                    InstallImmediateMethodToPullTruePropertyWithDifferentName(
                            filter1,
                            filter2,
                            List( prop, ValueGlobal ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            fi;
            
        od;
        
    od;
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullFalseProperty,
  function( filter1, filter2, prop, trigger, get_remote_object );
    
    InstallImmediateMethod( prop,
            filter1 and Tester( trigger ), 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop )( U ) and not prop( U ) then
            return false;
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop,
            "for homalg objects with an underlying object (PullFalseProperty)",
            [ filter2 ],
            
      function( M )
        
        if not prop( get_remote_object( M ) ) then
            return false;
        fi;
        
        TryNextMethod();
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToConditionallyPullFalseProperty,
  function( filter1, filter2, prop, condition, trigger, get_remote_object );
    
    InstallImmediateMethod( prop,
            filter1 and Tester( trigger ) and condition, 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop )( U ) and not prop( U ) then
            return false;
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop,
            "for homalg objects with an underlying object (ConditionallyPullFalseProperty)",
            [ filter2 ],
            
      function( M )
        
        if condition( M ) and not prop( get_remote_object( M ) ) then
            return false;
        fi;
        
        TryNextMethod();
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullFalsePropertyWithDifferentName,
  function( filter1, filter2, prop, trigger, get_remote_object );
    
    InstallImmediateMethod( prop[1],
            filter1 and Tester( trigger ), 0,
            
      function( M )
        local U;
        
        U := get_remote_object( M );
        
        if Tester( prop[2] )( U ) and not prop[2]( U ) then
            return false;
        fi;
        
        TryNextMethod();
        
    end );
    
    InstallMethod( prop[1],
            "for homalg objects with an underlying object (PullFalsePropertyWithDifferentName)",
            [ filter2 ],
            
      function( M )
        
        if not prop[2]( get_remote_object( M ) ) then
            return false;
        fi;
        
        TryNextMethod();
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPullFalseProperties,
  function( filter1, filter2, PROP, triggers, get_remote_object )
    local trigger, prop;
    
    for trigger in triggers do
        
        for prop in PROP do
            
            if IsString( prop ) then
                
                if prop <> trigger then
                    InstallImmediateMethodToPullFalseProperty(
                            filter1,
                            filter2,
                            ValueGlobal( prop ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            elif IsList( prop ) and Length( prop ) = 2 and
              IsString( prop[1] ) and IsList( prop[2] ) and IsString( prop[2][1] ) then
                
                if prop[1] <> trigger then
                    InstallImmediateMethodToConditionallyPullFalseProperty(
                            filter1,
                            filter2,
                            ValueGlobal( prop[1] ),
                            ValueGlobal( prop[2][1] ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            elif IsList( prop ) and Length( prop ) = 2 and ForAll( prop, IsString ) then
                
                if prop[1] <> trigger then
                    InstallImmediateMethodToPullFalsePropertyWithDifferentName(
                            filter1,
                            filter2,
                            List( prop, ValueGlobal ),
                            ValueGlobal( trigger ),
                            get_remote_object
                            );
                fi;
                
            fi;
            
        od;
        
    od;
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushPropertyOrAttribute,
  function( twitter, filter, prop_attr, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and Tester( prop_attr ), 0,
            
      function( M )
        
        Setter( prop_attr )( get_remote_object( M ), prop_attr( M ) );
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToConditionallyPushPropertyOrAttribute,
  function( twitter, filter, prop_attr, condition, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and Tester( prop_attr ) and condition, 0,
            
      function( M )
        
        Setter( prop_attr )( get_remote_object( M ), prop_attr( M ) );
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushPropertyOrAttributeWithDifferentName,
  function( twitter, filter, prop_attr, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and Tester( prop_attr[1] ), 0,
            
      function( M )
        
        Setter( prop_attr[2] )( get_remote_object( M ), prop_attr[1]( M ) );
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushPropertiesOrAttributes,
  function( twitter, filter, PROP_ATTR, get_remote_object )
    local prop_attr;
    
    for prop_attr in PROP_ATTR do
        if IsString( prop_attr ) then
            
            InstallImmediateMethodToPushPropertyOrAttribute(
                    twitter,
                    filter,
                    ValueGlobal( prop_attr ),
                    get_remote_object
                    );
            
        elif IsList( prop_attr ) and Length( prop_attr ) = 2 and
          IsString( prop_attr[1] ) and IsList( prop_attr[2] ) and IsString( prop_attr[2][1] ) then
            
            InstallImmediateMethodToConditionallyPushPropertyOrAttribute(
                    twitter,
                    filter,
                    ValueGlobal( prop_attr[1] ),
                    ValueGlobal( prop_attr[2][1] ),
                    get_remote_object
                    );
            
        elif IsList( prop_attr ) and Length( prop_attr ) = 2 and ForAll( prop_attr, IsString ) then
            
            InstallImmediateMethodToPushPropertyOrAttributeWithDifferentName(
                    twitter,
                    filter,
                    List( prop_attr, ValueGlobal ),
                    get_remote_object
                    );
            
        fi;
        
    od;
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushTrueProperty,
  function( twitter, filter, prop, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and prop, 0,
            
      function( M )
        
        Setter( prop )( get_remote_object( M ), true );
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushTruePropertyWithDifferentName,
  function( twitter, filter, prop, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and prop[1], 0,
            
      function( M )
        
        Setter( prop[2] )( get_remote_object( M ), true );
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushTrueProperties,
  function( twitter, filter, PROP, get_remote_object )
    local prop;
    
    for prop in PROP do
        if IsString( prop ) then
            
            InstallImmediateMethodToPushTrueProperty(
                    twitter, filter, ValueGlobal( prop ), get_remote_object
                    );
            
        elif IsList( prop ) and Length( prop ) = 2 and ForAll( prop, IsString ) then
            
            InstallImmediateMethodToPushTruePropertyWithDifferentName(
                    twitter, filter, List( prop, ValueGlobal ), get_remote_object
                    );
            
        fi;
        
    od;
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushFalseProperty,
  function( twitter, filter, prop, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and Tester( prop ), 0,
            
      function( M )
        
        if not prop( M ) then
            Setter( prop )( get_remote_object( M ), false );
        fi;
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushFalsePropertyWithDifferentName,
  function( twitter, filter, prop, get_remote_object )
    
    InstallImmediateMethod( twitter,
            filter and Tester( prop[1] ), 0,
            
      function( M )
        
        if not prop[1]( M ) then
            Setter( prop[2] )( get_remote_object( M ), false );
        fi;
        
        TryNextMethod( );
        
    end );
    
end );

##
InstallGlobalFunction( InstallImmediateMethodToPushFalseProperties,
  function( twitter, filter, PROP, get_remote_object )
    local prop;
    
    for prop in PROP do
        if IsString( prop ) then
            
            InstallImmediateMethodToPushFalseProperty(
                    twitter, filter, ValueGlobal( prop ), get_remote_object
                    );
            
        elif IsList( prop ) and Length( prop ) = 2 and ForAll( prop, IsString ) then
            
            InstallImmediateMethodToPushFalsePropertyWithDifferentName(
                    twitter, filter, List( prop, ValueGlobal ), get_remote_object
                    );
            
        fi;
        
    od;
    
end );

# This function declares an attribute, but does not install the standard getter.
# instead, a getter given as third argument is installed.
# the primary use of this method is for morphism aids: we are able to set lazy
# morphism aids and compute them by the getter.
##
InstallGlobalFunction( DeclareAttributeWithCustomGetter,
  function ( arg )
    local  attr, name, custom_getter, nname, gvar, pos, filter, new_attribute_args;
    name := arg[1];
    custom_getter := arg[3];
    new_attribute_args := ShallowCopy( arg );
    Remove( new_attribute_args, 3 );
    if IsBoundGlobal( name )  then
        Error( "expected a name not bound" );
    else
        attr := CallFuncList( NewAttribute, new_attribute_args );
        BindGlobal( name, custom_getter );
        nname := "Set";
        Append( nname, name );
        BindGlobal( nname, SETTER_FILTER( attr ) );
        nname := "Has";
        Append( nname, name );
        BindGlobal( nname, TESTER_FILTER( attr ) );
    fi;
    return;
end );

##
InstallGlobalFunction( AppendToAhomalgTable,
  function( RP, RP_addon )
    local component;
    
    for component in NamesOfComponents( RP_addon ) do
        RP!.(component) := RP_addon.(component);
    od;
    
end );

##
InstallGlobalFunction( homalgNamesOfComponentsToIntLists,
  function( arg )
    
    return Filtered(
                   List( NamesOfComponents( arg[1] ),
                         function( a )
                           local l;
                           l := SplitString( a, ",", "[ ]" );
                           if Length( l ) = 1 then
                               if Length( l[1] ) <= 24 then
                                   return Int( l[1] );
                               else
                                   return fail;
                               fi;
                           else
                               return List( l, Int );
                           fi;
                         end
                       ),
                  b -> b <> fail );
end );

##
InstallGlobalFunction( IncreaseExistingCounterInObject,
  function( o, component )
    
    o!.(component) := o!.(component) + 1;
    
end );

InstallGlobalFunction( IncreaseExistingCounterInObjectWithTiming,
  function( o, component, t )
    
    o!.(component) := o!.(component) + [ 1, t ];
    
end );

##
InstallGlobalFunction( IncreaseCounterInObject,
  function( o, component )
    
    if IsBound( o!.(component) ) then
        o!.(component) := o!.(component) + 1;
    else
        o!.(component) := 1;
    fi;
    
end );

##
InstallGlobalFunction( MemoryToString,
  function( memory )
    local m;
    
    m := memory;
    
    if m < 1024 then
        return Concatenation( String( m ), " Bytes" );
    fi;
    
    m := Float( m / 1024 );
    
    if m < 1024 then
        return Concatenation( String( m ), " KB" );
    fi;
    
    m := Float( m / 1024 );
    
    if m < 1024 then
        return Concatenation( String( m ), " MB" );
    fi;
    
    m := Float( m / 1024 );
    
    if m < 1024 then
        return Concatenation( String( m ), " GB" );
    fi;
    
    m := Float( m / 1024 );
    
    return Concatenation( String( m ), " TB" );
    
end );

##
InstallGlobalFunction( PrimePowerExponent,
  function( n, p )
    local a;
    
    if not IsPrime( p ) then
        Error( "the second argument is not a prime\n" );
    fi;
    
    a := -1;
    
    repeat
        a := a + 1;
        n := n / p;
    until not IsInt( n );
    
    return a;
    
end );

##
InstallMethod( ViewList,
        [ "IsList" ],
        
  function( L )
    local l, i;
    
    l := Length( L );
    
    if l = 0 then
        ViewObj( [ ] );
        return;
    fi;
    
    Print( "[ " );
    ViewObj( L[1] );
    
    for i in [ 2 .. l ] do
        Print( ",\n  " );
        ViewObj( L[i] );
    od;
    
    Print( " ]\n" );
    
end );

##
InstallMethod( IdenticalPosition,
        "for a list and an object",
        [ IsList, IsObject ],
        
  function( L, o )
    
    return PositionProperty( L, x -> IsIdenticalObj( x, o ) );
    
end );

##
InstallMethod( AppendNew,
        "for two lists",
        [ IsList, IsList ],
        
  function( L, N )
    local n, p;
    
    for n in N do
        p := IdenticalPosition( L, n );
        if p = fail then
            Add( L, n );
        fi;
    od;
    
end );

##
InstallMethod( PositionsOfMaximalObjects,
        "for a list and a function",
        [ IsList, IsFunction ],
        
  function( L, f )
    local l, r, i, p;
    
    l := [ 1 .. Length( L ) ];
    
    r := [ ];
    
    for i in l do
        
        if i in r then
            continue;
        fi;
        
        p := PositionProperty( l, j -> not j = i and not j in r and f( L[i], L[j] ) );
        
        if not p = fail then
            Add( r, i );
        fi;
        
    od;
    
    return Difference( l, r );
    
end );

##
InstallMethod( MaximalObjects,
        "for a list and a function",
        [ IsList, IsFunction ],
        
  function( L, f )
    
    return L{PositionsOfMaximalObjects( L, f )};
    
end );

##
InstallGlobalFunction( ExecForHomalg,
  function( arg )
    local str,  output, cmd,  i,  shell,  cs,  dir;
    
    str := "";
    output := OutputTextString( str, true );
    
    # simply concatenate the arguments
    cmd := ShallowCopy( arg[1] );
    if not IsString(cmd) then
      Error("the command ",cmd," is not a name.\n",
      "possibly a binary is missing or has not been compiled.");
    fi;
    for i  in [ 2 .. Length(arg) ]  do
        Append( cmd, " " );
        Append( cmd, arg[i] );
    od;
    
    # select the shell, bourne shell is the default: sh -c cmd
    if ARCH_IS_WINDOWS() then
        # on Windows, we use the native shell such that behaviour does
        # not depend on whether cygwin is installed or not.
        # cmd.exe is preferrable to old-style `command.com'
        shell := Filename( DirectoriesSystemPrograms(), "cmd.exe" );
        cs := "/C";
    else
        shell := Filename( DirectoriesSystemPrograms(), "sh" );
        cs := "-c";
    fi;
    
    # execute in the current directory
    dir := DirectoryCurrent();
    
    # execute the command
    Process( dir, shell, InputTextUser(), output, [ cs, cmd ] );
    
    return str;
    
end );

##
InstallMethod( ShaSum,
        "for a string",
        [ IsString ],
        
  function( str )
    local sha;
    
    sha := ExecForHomalg( "echo",  "\"", str, "\" | shasum" );
    
    NormalizeWhitespace( sha );
    
    return sha{[ 1 .. Length( sha ) - 2 ]};
    
end );

##
InstallGlobalFunction( GetTimeOfDay,
  function( arg )
    local t;
    
    t := ExecForHomalg( "date +\"%Y-%m-%d:%H:%M:%S,%N\"" );
    
    NormalizeWhitespace( t );
    
    return t;
    
end );

##
InstallGlobalFunction( CallFuncListWithTime,
  function( func, arguments )
    local output, t0, t1;
    
    if not IsList( arguments ) then
      
      return CallFuncListWithTime( func, [ arguments ] );
      
    fi;
    
    t0 := NanosecondsSinceEpoch( );
    
    output := CallFuncList( func, arguments );
    
    t1 := NanosecondsSinceEpoch( );
    
    Print( Float( ( t1 - t0 ) / 10^9 ), " Secs.\n" );
    
    return output;
    
end );

##
InstallGlobalFunction( CollectEntries,
  function( list )
    local comparing_func, o, n;
    
    comparing_func := ValueOption( "ComparingFunction" );
    
    if comparing_func = fail or not IsFunction( comparing_func ) then
        comparing_func := \=;
    fi;
    
    if IsEmpty( list ) then
        return [ ];
    fi;
    
    o := list[ 1 ];
    
    n := PositionProperty( list, x -> not comparing_func( o, x ) );
    
    if n = fail then
        return [ [ o, Length( list ) ] ];
    else
        return Concatenation( [ [ o, n - 1 ] ], CollectEntries( list{ [ n .. Length( list ) ] } ) );
    fi;
    
end );

##
InstallGlobalFunction( DotToSVG,
  function( dotstr )
    
    dotstr := ReplacedString( dotstr, "\"", "\\\"" );
    
    return ExecForHomalg( "echo",  "\"", dotstr, "\" | dot -Tsvg" );
    
end );

##
InstallGlobalFunction( WriteFileForHomalg,
  function( path, string )
    local nr_bytes_written;
    
    nr_bytes_written := FileString( path, string );
    
    if nr_bytes_written = fail then
        
        Error( "could not write to file ", path );
        
    fi;
    
end );

##
InstallGlobalFunction( ReadFileForHomalg,
  function( path )
    local content;
    
    content := StringFile( path );
    
    if content = fail then
        
        Error( "could not read file ", path );
        
    fi;
    
    return content;
    
end );


##
InstallGlobalFunction( ReplacedStringForHomalg,
  function( string, L )
    local old_new;
    
    for old_new in L do
        string := ReplacedString( string, old_new[1], old_new[2] );
    od;
    
    return string;
    
end );

##
InstallGlobalFunction( ReplacedFileForHomalg,
  function( filename_source, L )
    local string;
    
    string := ReadFileForHomalg( filename_source );
    
    return ReplacedStringForHomalg( string, L );
    
end );

##
InstallGlobalFunction( EvalReplacedFileForHomalg,
  function( filename_source, L )
    local string;
    
    string := ReplacedFileForHomalg( filename_source, L );
    
    EvalString( string );
    
end );

##
InstallGlobalFunction( WriteReplacedFileForHomalg,
  function( path_source, L, path_target )
    local header, string, parts, header_parts;
    
    header := ValueOption( "header" );
    
    if not IsString( header ) then
        header := "";
    fi;
    
    string := ReplacedFileForHomalg( path_source, L );
    
    # put `header` below the default file header (i.e. below the first 5 lines)
    
    parts := SplitString( string, '\n' );
    
    if Last( string ) = '\n' then
        
        # add empty part corresponding to the trailing new line which is dropped by SplitString
        Add( parts, "" );
        
    fi;
    
    header_parts := SplitString( header, '\n' );
    
    if Last( header ) = '\n' then
        
        # add empty part corresponding to the trailing new line which is dropped by SplitString
        Add( header_parts, "" );
        
    fi;
    
    if Length( parts ) < 5 then
        
        Error( "the source file has no proper header, this is not supported" );
        
    fi;
    
    parts := Concatenation( parts{[ 1 .. 5 ]}, header_parts, parts{[ 6 .. Length( parts ) ]} );
    
    string := JoinStringsWithSeparator( parts, "\n" );
    
    WriteFileForHomalg( path_target, string );
    
end );

##
InstallGlobalFunction( WriteFileInPackageForHomalg,
  function( package_name, filename, string )
    local dirs, path;
    
    dirs := DirectoriesPackageLibrary( package_name, "gap" );
    
    if Length( dirs ) <> 1 then
        
        Error( Concatenation( "could not find gap directory of package ", package_name ) );
        
    fi;
    
    path := Filename( dirs[1], filename );
    
    WriteFileForHomalg( path, string );
    
end );

##
InstallGlobalFunction( IsExistingFileInPackageForHomalg,
  function( package_name, filename )
    local dirs, path;
    
    dirs := DirectoriesPackageLibrary( package_name, "gap" );
    
    if Length( dirs ) <> 1 then
        
        Error( Concatenation( "could not find gap directory of package ", package_name ) );
        
    fi;
    
    path := Filename( dirs[1], filename );
    
    return IsExistingFile( path );
    
end );

##
InstallGlobalFunction( ReadFileFromPackageForHomalg,
  function( package_name, filename )
    local dirs, path;
    
    dirs := DirectoriesPackageLibrary( package_name, "gap" );
    
    if Length( dirs ) <> 1 then
        
        Error( Concatenation( "could not find gap directory of package ", package_name ) );
        
    fi;
    
    path := Filename( dirs[1], filename );
    
    return ReadFileForHomalg( path );
    
end );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( ExamplesForHomalg,
        [  ], 0,
        
  function( )
    
    if LoadPackage( "ExamplesForHomalg" ) = true then
        ExamplesForHomalg( );
    else
        return fail;
    fi;
    
end );

##
InstallMethod( ExamplesForHomalg,
        [ IsInt ], 0,
        
  function( d )
    
    if LoadPackage( "ExamplesForHomalg" ) = true then
        ExamplesForHomalg( d );
    else
        return fail;
    fi;
    
end );

##
InstallMethod( UpdateContainerOfWeakPointers,
        "for containers of weak pointer lists",
        [ IsContainerForWeakPointersRep ],
        
  function( container )
    local weak_pointers, l, active, l_active, i;
    
    weak_pointers := container!.weak_pointers;
    
    l := LengthWPObj( weak_pointers );
    
    active := Filtered( container!.active, i -> i <= l );
    
    l_active := Length( active );
    
    i := 1;
    
    while i <= l_active do
        if ElmWPObj( weak_pointers, active[i] ) <> fail then
            i := i + 1;
        else ## active[i] is no longer active
            Remove( active, i );
            l_active := l_active - 1;
        fi;
    od;
    
    ## UpdateContainerOfWeakPointers is only called
    ## from view and display methods, which we do not want
    ## to count as accesses:
    # container!.accessed := container!.accessed + 1;
    
    container!.active := active;
    container!.deleted := Difference( [ 1 .. l ], active );
    
end );

##
InstallMethod( UpdateContainerOfWeakPointers,
        "for containers of weak pointer lists",
        [ IsContainerForWeakPointersOnComputedValuesRep ],
        
  function( container )
    local weak_pointers, weak_pointers_on_values, l, active, l_active, i;
    
    weak_pointers := container!.weak_pointers;
    weak_pointers_on_values := container!.weak_pointers_on_values;
    
    l := Minimum( LengthWPObj( weak_pointers ), LengthWPObj( weak_pointers_on_values ) );
    
    active := Filtered( container!.active, i -> i <= l );
    
    l_active := Length( active );
    
    i := 1;
    
    while i <= l_active do
        if ElmWPObj( weak_pointers, active[i] ) <> fail and
           ElmWPObj( weak_pointers_on_values, active[i] ) <> fail then
            i := i + 1;
        else ## active[i] is no longer active
            Remove( active, i );
            l_active := l_active - 1;
        fi;
    od;
    
    ## UpdateContainerOfWeakPointers is only called
    ## from view and display methods, which we do not want
    ## to count as accesses:
    # container!.accessed := container!.accessed + 1;
    
    container!.active := active;
    container!.deleted := Difference( [ 1 .. l ], active );
    
end );

##
InstallGlobalFunction( _AddElmWPObj_ForHomalg,
  function( container, obj )
    local weak_pointers, l, deleted, active, l_active, d;
    
    weak_pointers := container!.weak_pointers;
    
    l := LengthWPObj( weak_pointers );
    
    deleted := Filtered( container!.deleted, i -> i <= l );
    active := Filtered( container!.active, i -> i <= l );
    
    ## check assertion
    Assert( 10,
            Intersection2( deleted, active ) = [ ] and
            Union2( deleted, active ) = [ 1 .. l ] );
    
    l_active := Length( active );
    
    if deleted = [ ] then
        SetElmWPObj( weak_pointers, l_active + 1, obj );
        Add( active, l_active + 1 );
        l := l + 1;
    else
        d := deleted[1];
        SetElmWPObj( weak_pointers, d, obj );
        Remove( deleted, 1 );
        Add( active, d, d );
    fi;
    
    container!.deleted := deleted;
    container!.active := active;
    
    ## here we increase container!.counter instead of container!.accessed;
    container!.counter := container!.counter + 1;
    
end );

##
InstallGlobalFunction( _AddTwoElmWPObj_ForHomalg,
  function( container, ref, value )
    local weak_pointers, weak_pointers_on_values, l, deleted, active, l_active, d;
    
    weak_pointers := container!.weak_pointers;
    weak_pointers_on_values := container!.weak_pointers_on_values;
    
    l := Minimum( LengthWPObj( weak_pointers ), LengthWPObj( weak_pointers_on_values ) );
    
    deleted := Filtered( container!.deleted, i -> i <= l );
    active := Filtered( container!.active, i -> i <= l );
    
    ## check assertion
    Assert( 10,
            Intersection2( deleted, active ) = [ ] and
            Union2( deleted, active ) = [ 1 .. l ] );
    
    l_active := Length( active );
    
    if deleted = [ ] then
        SetElmWPObj( weak_pointers, l_active + 1, ref );
        SetElmWPObj( weak_pointers_on_values, l_active + 1, value );
        Add( active, l_active + 1 );
        l := l + 1;
    else
        d := deleted[1];
        SetElmWPObj( weak_pointers, d, ref );
        SetElmWPObj( weak_pointers_on_values, d, value );
        Remove( deleted, 1 );
        Add( active, d, d );
    fi;
    
    container!.deleted := deleted;
    container!.active := active;
    
    ## here we increase container!.counter instead of container!.accessed;
    container!.counter := container!.counter + 1;
    
end );

##
InstallMethod( _ElmWPObj_ForHomalg,
        "for a container of weak pointer lists and two objects (a reference and a return fail value)",
        [ IsContainerForWeakPointersOnComputedValuesRep, IsObject, IsObject ], 0,
        
  function( container, obj, FAIL )
    local weak_pointers, weak_pointers_on_values, l, active, cache_hit, l_active, i, ref, value;
    
    weak_pointers := container!.weak_pointers;
    weak_pointers_on_values := container!.weak_pointers_on_values;
    
    l := Minimum( LengthWPObj( weak_pointers ), LengthWPObj( weak_pointers_on_values ) );
    
    active := Filtered( container!.active, i -> i <= l );
    
    cache_hit := false;
    
    l_active := Length( active );
    
    i := 1;
    
    while i <= l_active do
        value := ElmWPObj( weak_pointers_on_values, active[i] );
        if value <> fail then
            ref := ElmWPObj( weak_pointers, active[i] );
            if ref <> fail then
                if IsIdenticalObj( ref, obj ) then
                    cache_hit := true;
                    break;
                fi;
                i := i + 1;
            else ## active[i] is no longer active
                Remove( active, i );
                l_active := l_active - 1;
            fi;
        else ## active[i] is no longer active
            Remove( active, i );
            l_active := l_active - 1;
        fi;
    od;
    
    container!.active := active;
    container!.deleted := Difference( [ 1 .. l ], active );
    
    container!.accessed := container!.accessed + 1;
    container!.cache_misses := container!.cache_misses + i - 1;
    
    if cache_hit then
        container!.cache_hits := container!.cache_hits + 1;
        return value;
    fi;
    
    return FAIL;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for weak pointer containers of objects",
        [ IsContainerForWeakPointersOnObjectsRep ],
        
  function( o )
    local a;
    
    UpdateContainerOfWeakPointers( o );
    
    a := Length( o!.active );
    
    Print( "<A container for weak pointers " );
    
    if IsBound( o!.operation ) then
        Print( "on computed values of ", o!.operation );
    else
        Print( "on objects" );
    fi;
    
    Print( ": active = ", a, ", deleted = ", o!.counter - a, ", counter = ", o!.counter, ", accessed = ", o!.accessed, ", cache_misses = ", o!.cache_misses, ", cache_hits = ", o!.cache_hits, ">" );
    
end );

##
InstallMethod( ViewObj,
        "for weak pointer containers of containers",
        [ IsContainerForWeakPointersOnContainersRep ],
        
  function( o )
    local a;
    
    UpdateContainerOfWeakPointers( o );
    
    a := Length( o!.active );
    
    Print( "<A container for weak pointers on containers: active = ", a, ", deleted = ", o!.counter - a, ", counter = ", o!.counter, ">" );
    
end );

##
InstallMethod( Display,
        "for weak pointer containers of objects",
        [ IsContainerForWeakPointersOnObjectsRep ],
        
  function( o )
    local weak_pointers;
    
    weak_pointers := o!.weak_pointers;
    
    Print( List( [ 1 .. LengthWPObj( weak_pointers ) ], function( i ) if IsBoundElmWPObj( weak_pointers, i ) then return i; else return 0; fi; end ), "\n" );
    
end );

##
InstallMethod( Display,
        "for weak pointer containers of containers",
        [ IsContainerForWeakPointersOnContainersRep ],
        
  function( o )
    local weak_pointers, a, obj;
    
    UpdateContainerOfWeakPointers( o );
    
    weak_pointers := o!.weak_pointers;
    
    for a in o!.active do
        obj := ElmWPObj( weak_pointers, a );
        if obj <> fail and
           ( not IsBound( obj!.counter ) or obj!.counter <> 0 ) then
            Print( a, ":\t" );
            ViewObj( obj );
            Print( "\n" );
        fi;
    od;
    
end );

##
InstallMethod( Display,
        "for weak pointer containers of containers",
        [ IsContainerForWeakPointersOnContainersRep, IsString ],
        
  function( o, string )
    local weak_pointers, a, obj;
    
    string := LowercaseString( string );
    
    if string = "a" or string = "all" then
        
        UpdateContainerOfWeakPointers( o );
        
        weak_pointers := o!.weak_pointers;
        
        for a in o!.active do
            obj := ElmWPObj( weak_pointers, a );
            if obj <> fail then
                Print( a, ":\t" );
                ViewObj( obj );
                Print( "\n" );
            fi;
        od;
        
    else
        
        Display( o );
        
    fi;
    
end );

####################################
#
# ContainerForPointers
#
####################################

# a new family:
BindGlobal( "TheFamilyOfContainersForPointers",
        NewFamily( "TheFamilyOfContainersForPointers" ) );

# a new type:
BindGlobal( "TheTypeContainerForPointers",
        NewType( TheFamilyOfContainersForPointers,
                IsContainerForPointersRep ) );

# a new type:
BindGlobal( "TheTypeContainerForPointersOnObjects",
        NewType( TheFamilyOfContainersForPointers,
                IsContainerForPointersOnObjectsRep ) );

# a new type:
BindGlobal( "TheTypeContainerForPointersOnComputedValues",
        NewType( TheFamilyOfContainersForPointers,
                IsContainerForPointersOnComputedValuesRep ) );

# a new type:
BindGlobal( "TheTypeContainerForPointersOnContainers",
        NewType( TheFamilyOfContainersForPointers,
                IsContainerForPointersOnContainersRep ) );

##
InstallGlobalFunction( ContainerForPointers,
  function( arg )
    local nargs, container, component, type, containers;
    
    nargs := Length( arg );
    
    container := rec( pointers :=  [ ],
                      counter := 0,
                      accessed := 0,
                      cache_hits := 0,
                      cache_misses := 0 );
    
    for component in arg{[ 2 .. nargs ]} do
        container.( component[1] ) := component[2];
    od;
    
    type := arg[1];
    
    ## Objectify:
    Objectify( type, container );
    
    if IsBound( HOMALG_TOOLS.ContainersForPointers ) then
        _AddElmPObj_ForHomalg( HOMALG_TOOLS.ContainersForPointers, container );
    fi;
    
    if IsContainerForPointersOnComputedValuesRep( container ) then
        container!.pointers_on_values := [ ];
    fi;
    
    return container;
    
end );

HOMALG_TOOLS.ContainersForPointers := ContainerForPointers( TheTypeContainerForPointersOnContainers );
Unbind( HOMALG_TOOLS.ContainersForPointers!.accessed );

##
InstallGlobalFunction( _AddElmPObj_ForHomalg,
  function( container, obj )
    
    Add( container!.pointers, obj );
    
    ## here we increase container!.counter instead of container!.accessed;
    container!.counter := container!.counter + 1;
    
end );

##
InstallGlobalFunction( _AddTwoElmPObj_ForHomalg,
  function( container, ref, value )
    
    Add( container!.pointers, ref );
    Add( container!.pointers_on_values, value );
    
    ## here we increase container!.counter instead of container!.accessed;
    container!.counter := container!.counter + 1;
    
end );

##
InstallMethod( _ElmPObj_ForHomalg,
        "for a container of weak pointer lists and two objects (a reference and a return fail value)",
        [ IsContainerForPointersOnComputedValuesRep, IsObject, IsObject ], 0,
        
  function( container, obj, FAIL )
    local pointers, pointers_on_values, l, cache_hit, i;
    
    pointers := container!.pointers;
    
    pointers_on_values := container!.pointers_on_values;
    
    l := Length( pointers );
    
    i := 1;
    
    cache_hit := false;
    
    while i <= l do
        
        if IsIdenticalObj( pointers[ i ], obj ) then
            
            cache_hit := true;
            
            break;
            
        fi;
        
        i := i + 1;
        
    od;
    
    container!.accessed := container!.accessed + 1;
    container!.cache_misses := container!.cache_misses + i - 1;
    
    if cache_hit then
        container!.cache_hits := container!.cache_hits + 1;
        return pointers_on_values[ i ];
    fi;
    
    return FAIL;
    
end );

##
InstallGlobalFunction( FillWithCharacterAfterDecimalNumber,
  function( decimal_number, c, n )
    
    if decimal_number = 0 then
        decimal_number := 1;
    elif decimal_number < 0 then
        decimal_number := -10 * decimal_number;
    fi;
    
    n := n - Int( Log10( Float( decimal_number ) ) ) - 1;
    
    if n < 0 then
        n := 0;
    fi;
    
    c := ListWithIdenticalEntries( n, c );
    
    ConvertToStringRep( c );
    
    return c;
    
end );
    
####################################
#
# View, Print, and Display methods:
#
####################################

## fallback method
InstallMethod( IsShowable,
        [ IsString, IsObject ],

  function ( mime, obj )
    
    if mime in [ "text/plain" ] then
        return true;
    fi;
    
    return false;
    
end );

##
InstallGlobalFunction( "MakeShowable", function( mime_types, filter )
    
    if not IsList( mime_types ) then
        
        Error( "the first argument must be a list\n" );
        
    fi;
    
    if not IsFilter( filter ) then
        
        Error( "the second argument must be a filter\n" );
        
    fi;
    
    InstallMethod( IsShowable,
            [ IsString, filter ],
            
      function ( mime, e )
        
        if not mime in mime_types then
            TryNextMethod();
        fi;
        
        return true;
        
    end );
    
end );

##
InstallGlobalFunction( "MakeShowableWithLaTeX", function( filter )
    
    MakeShowable( [ "text/latex", "application/x-latex" ], filter );
    
end );

##
InstallMethod( ViewObj,
        "for pointer containers of objects",
        [ IsContainerForPointersOnObjectsRep ],
        
  function( o )
    local a;
    
    a := Length( o!.pointers );
    
    Print( "<A container for pointers " );
    
    if IsBound( o!.operation ) then
        Print( "on computed values of ", o!.operation );
    else
        Print( "on objects" );
    fi;
    
    Print( ": active = ", a, ", counter = ", o!.counter, ", accessed = ", o!.accessed, ", cache_misses = ", o!.cache_misses, ", cache_hits = ", o!.cache_hits, ">" );
    
end );

##
InstallMethod( ViewObj,
        "for pointer containers of containers",
        [ IsContainerForPointersOnContainersRep ],
        
  function( o )
    local a;
    
    a := Length( o!.pointers );
    
    Print( "<A container for weak pointers on containers: active = ", a, ", counter = ", o!.counter, ">" );
    
end );

##
InstallMethod( Display,
        "for pointer containers of objects",
        [ IsContainerForPointersOnObjectsRep ],
        
  function( o )
    
    Print( o!.pointers, "\n" );
    
end );

##
InstallMethod( Display,
        "for pointer containers of containers",
        [ IsContainerForPointersOnContainersRep ],
        
  function( o )
    local a, pointers;
    
    pointers := o!.pointers;
    
    for a in [ 1 .. Length( pointers ) ] do
        
        Print( a, ":\t" );
        
        ViewObj( pointers[ a ] );
        
        Print( "\n" );
        
    od;
    
end );

##
InstallMethod( Display,
        "for pointer containers of containers",
        [ IsContainerForPointersOnContainersRep, IsString ],
        
  function( o, string )
    
    Display( o );
    
end );

##
InstallGlobalFunction( "ReplacedStringViaRecord", function( string, record )
  local name;
    
    for name in RecNames( record ) do
        
        # use IsStringRep instead of IsString to differentiate between `""` and `[]`
        if IsStringRep( record.(name) ) then
            
            string := ReplacedString( string, name, record.(name) );
            
        elif IsList( record.(name) ) then
            
            string := ReplacedString( string, Concatenation( name, "..." ), JoinStringsWithSeparator( record.(name), ", " ) );
            
        else
            
            Error( "the record's values must be strings or lists of strings" );
            
        fi;
        
    od;
    
    return string;
    
end );

BindGlobal( "TOOLS_FOR_HOMALG_INTERNAL_TIMERS", rec( ) );

##
InstallGlobalFunction( StartTimer, function( name )
    
    if not IsString( name ) then
        
        Error( "<name> must be a string" );
        return;
        
    fi;
    
    if not IsBound( TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name) ) then
        
        # first entry is the number of times the timer was started
        # second entry is the elapsed time
        TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name) := [ 0, 0 ];
        
    fi;
    
    if TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] < 0 then
        
        Print( "WARNING: Timer with name ", name, " is already running.\n" );
        
    else
        
        TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[1] := TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[1] + 1;
        TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] := TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] - Runtime( );
        
    fi;
    
end );

##
InstallGlobalFunction( StopTimer, function( name )
  local current_time;
    
    # make this more precise by getting the time immediately
    current_time := Runtime( );
    
    if not IsString( name ) then
        
        Error( "<name> must be a string" );
        return;
        
    fi;
    
    if not IsBound( TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name) ) then
        
        Error( "Timer with name ", name, " was never started." );
        return;
        
    fi;
    
    if TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] >= 0 then
        
        Print( "WARNING: Timer with name ", name, " was not running.\n" );
        
    else
        
        TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] := TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] + current_time;
        
    fi;
    
end );

##
InstallGlobalFunction( DisplayTimer, function( name )
  local current_time, elapsed_time, state, execs;
    
    # make this more precise by getting the time immediately
    current_time := Runtime( );
    
    if not IsString( name ) then
        
        Error( "<name> must be a string" );
        return;
        
    fi;
    
    if not IsBound( TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name) ) then
        
        Error( "Timer with name ", name, " was never started." );
        return;
        
    fi;
    
    if TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] >= 0 then
        
        state := "stopped";
        elapsed_time := TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2];
        
    else
        
        state := "running";
        elapsed_time := TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[2] + current_time;
        
    fi;
    
    execs := TOOLS_FOR_HOMALG_INTERNAL_TIMERS.(name)[1];
    
    Print(
        "Timer ", name, " (", state, "):",
        " started ",
        execs,
        " times with a total runtime of ",
        elapsed_time,
        " ms ( = ",
        Int( elapsed_time / execs * 1000 ),
        " μs per run)\n"
    );
    
end );

## copied from gap/lib/methwhy.g
InstallGlobalFunction( ListImpliedFilters,
  function(filter)
  local flags, implied, f, extra_implications, implication, name, diff_reqs,
        diff_impls, reduced, list;

  flags:=FLAGS_FILTER(filter);
  implied := WITH_IMPS_FLAGS(flags);
  atomic readonly IMPLICATIONS_SIMPLE do
    # select all implications which involved <filter> in the requirements
    f:=Filtered(IMPLICATIONS_SIMPLE, x->IS_SUBSET_FLAGS(x[2],flags));
    Append(f, Filtered(IMPLICATIONS_COMPOSED, x->IS_SUBSET_FLAGS(x[2],flags)));
  od; # end atomic

  # remove "obvious" implications
  if IS_ELEMENTARY_FILTER(filter) then
    implied := SUB_FLAGS(implied, flags);
  fi;

  reduced:= function( trues )
    atomic readonly FILTER_REGION do
      return Filtered( trues,
      i -> not ( INFO_FILTERS[i] in FNUM_TPRS
                 and FLAG1_FILTER( FILTERS[i] ) in trues ) );
    od;
  end;

  list := [ NamesFilter( filter )[1] ];
  
  if SIZE_FLAGS(implied) > 0 then
      Append( list, NamesFilter( reduced( TRUES_FLAGS( implied ) ) ) );
  fi;
  
  return SortedList( list );
  
end);

BindGlobal( "TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS", rec( ) );

##
InstallGlobalFunction( Breakpoint, function( name, args... )
  local break_at, break_function;
    
    if Length( args ) = 0 then
        
        break_at := -1;
        break_function := ReturnTrue;
        
    elif Length( args ) = 1 then
        
        break_at := args[1];
        break_function := ReturnTrue;
        
    elif Length( args ) = 2 then
        
        break_at := args[1];
        break_function := args[2];
        
    else
        
        Error( "Breakpoint must be called with at most 3 arguments" );
        
    fi;
    
    if not IsString( name ) then
        
        Error( "<name> must be a string" );
        return;
        
    fi;
    
    if not IsInt( break_at ) then
        
        Error( "<break_at> must be an integer" );
        return;
        
    fi;
    
    if not IsFunction( break_function ) then
        
        Error( "<break_function> must be a function" );
        return;
        
    fi;
    
    if not IsBound( TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name) ) then
        
        TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name) := 0;
        
    fi;
    
    TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name) := TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name) + 1;
    
    if TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name) = break_at then
        
        break_function( );
        
        Error( "Breakpoint ", name, ": ", TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name) );
        
    else
        
        Print( "Breakpoint ", name, ": ", TOOLS_FOR_HOMALG_INTERNAL_BREAKPOINTS.(name), "\n" );
        
    fi;
    
end );

##
InstallGlobalFunction( ReadPackageOnce,
  function( arg... )
    local pos, relpath, pkgname, namespace, filename;
    
    if Length( arg ) = 1 then
        pos := Position( arg[1], '/' );
        if pos = fail then
            ErrorNoReturn( arg[1], " is not a filename in the form 'package/filepath'" );
        fi;
        relpath := arg[1]{[ pos + 1 .. Length( arg[1] ) ]};
        pkgname := LowercaseString( arg[1]{[ 1 .. pos - 1 ]} );
        namespace := GAPInfo.PackagesInfo.(pkgname)[1].PackageName;
    elif Length( arg ) = 2 then
        pkgname := LowercaseString( arg[1] );
        namespace := GAPInfo.PackagesInfo.(pkgname)[1].PackageName;
        relpath := arg[2];
    else
        Error( "expected 1 or 2 arguments" );
    fi;
    filename := Filename( DirectoriesPackageLibrary( pkgname, "" ), relpath );
    if filename <> fail and IsReadableFile( filename ) then
        if filename in HOMALG_TOOLS.ReadPackageOnce then
            return true;
        fi;
        Add( HOMALG_TOOLS.ReadPackageOnce, filename );
        return CallFuncList( ReadPackage, arg );
    else
        return false;
    fi;
    
end );
