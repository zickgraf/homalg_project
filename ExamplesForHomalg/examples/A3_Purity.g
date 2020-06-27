##  <#GAPDoc Label="A3_Purity">
##  <Subsection Label="A3_Purity">
##  <Heading>A3_Purity</Heading>
##  This is Example B.4 in <Cite Key="BaSF"/>.
##  <Example><![CDATA[
##  gap> Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";
##  Q[x,y,z]
##  gap> A3 := RingOfDerivations( Qxyz, "Dx,Dy,Dz" );
##  Q[x,y,z]<Dx,Dy,Dz>
##  gap> nmat := HomalgMatrix( "[ \
##  > 3*Dy*Dz-Dz^2+Dx+3*Dy-Dz,           3*Dy*Dz-Dz^2,     \
##  > Dx*Dz+Dz^2+Dz,                     Dx*Dz+Dz^2,       \
##  > Dx*Dy,                             0,                \
##  > Dz^2-Dx+Dz,                        3*Dx*Dy+Dz^2,     \
##  > Dx^2,                              0,                \
##  > -Dz^2+Dx-Dz,                       3*Dx^2-Dz^2,      \
##  > Dz^3-Dx*Dz+Dz^2,                   Dz^3,             \
##  > 2*x*Dz^2-2*x*Dx+2*x*Dz+3*Dx+3*Dz+3,2*x*Dz^2+3*Dx+3*Dz\
##  > ]", 8, 2, A3 );
##  <A 8 x 2 matrix over an external ring>
##  gap> N := LeftPresentation( nmat );
##  <A left module presented by 8 relations for 2 generators>
##  gap> filt := PurityFiltration( N );
##  <The ascending purity filtration with degrees [ -3 .. 0 ] and graded parts:
##     0:   <A zero left module>
##  
##  -1:   <A cyclic reflexively pure grade 1 left module presented by 1 relation for\
##   a cyclic generator>
##  
##  -2:   <A cyclic reflexively pure grade 2 left module presented by 2 relations fo\
##  r a cyclic generator>
##  
##  -3:   <A cyclic reflexively pure grade 3 left module presented by 3 relations fo\
##  r a cyclic generator>
##  of
##  <A non-pure grade 1 left module presented by 8 relations for 2 generators>>
##  gap> II_E := SpectralSequence( filt );
##  <A stable homological spectral sequence with sheets at levels 
##  [ 0 .. 2 ] each consisting of left modules at bidegrees [ -3 .. 0 ]x
##  [ 0 .. 3 ]>
##  ]]></Example>
##  </Subsection>
##  <#/GAPDoc>

ReadPackage( "ExamplesForHomalg", "examples/Coupling.g" );

filt := PurityFiltration( N );

II_E := SpectralSequence( filt );

m := IsomorphismOfFiltration( filt );

#Display( StringTime( homalgTime( A3 ) ) );
