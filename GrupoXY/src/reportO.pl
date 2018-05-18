#!/bin/perl


print "-----------------------------ReportO------------------------------\n";
print "Ingrese el código del país: ";
$codPais = <STDIN>;
chomp($codPais);
print "Ingrese el código del sistema: ";
$codSistema = <STDIN>;
chomp($codSistema);
print "Ingrese la fecha inicial del período: ";
$inicialPeriodo = <STDIN>;
chomp($inicialPeriodo);
print "Ingrese la fecha final del periódo: ";
$finalPeriodo = <STDIN>;
chomp($finalPeriodo);

$maestro = "PPI.mae";
open(ENTRADA,"<$maestro") || die "ERROR: No se puede abrir el archivo maestro";
my @PAIS_ID = ();
my @SIS_ID = ();
my @CTB_ANIO = ();
my @CTB_MES = ();
my @CTB_DIA = ();
my @CTB_ESTADO = ();
my @PRES_FE = ();
my @PRES_ID = ();
my @PRES_TI = ();
my @MT_PRES = ();
my @MT_IMPAGO = ();
my @MT_INDE = ();
my @MT_INNODE = ();
my @MT_DEB = ();

my @variables = (); #este array almacenará los valores de cada línea separados

my @ppi = ();


#lectura de PPI.mae



while ($linea = <ENTRADA>)
{
	@variables = split(/;/,$linea);
	
	push @ppi, {PAIS_ID => $variables[0], SIS_ID => $variables[1], CTB_ANIO => $variables[2], CTB_MES => $variables[3],
	CTB_DIA => $variables[4], CTB_ESTADO => $variables[5], PRES_FE => $variables[6], PRES_ID => $variables[7],
	PRES_TI => $variables[8], MT_PRES => $variables[9], MT_IMPAGO => $variables[10], MT_INDE => $variables[11],
	MT_INNODE => $variables[12], MT_DEB => $variables[13]  } ;
	
}


#CÁLCULO DEL MONTO RESTANTE DEL MAESTRO
my @restanteMaestro = ();

for $i(@ppi)
{
	$restante = $i->{"MT_PRES"} + $i->{"MT_IMPAGO"} + $i->{"MT_INDE"} + $i->{"MT_INNODE"} - $i->{"MT_DEB"};
	push @restanteMaestro,$restante;
}


#LECTURA DE prestamos.pais:
$file = "prestamos." . $codPais;
open(ENTRADA,"<$file");
my @prestamos = ();
while ($linea = <ENTRADA>)
{
	@variables = split(/;/,$linea);
	
	push @prestamos, {SIS_ID => $variables[0], CTB_ANIO => $variables[1], CTB_MES => $variables[2], CTB_DIA => $variables[3],CTB_ESTADO => $variables[4], PRES_ID => $variables[5], MT_PRES => $variables[6], MT_IMPAGO => $variables[7], MT_INDE => $variables[8], MT_INNODE => $variables[9], MT_DEB => $variables[10], MT_REST => $variables[11], PRES_CLI_ID => $variables[12], PRES_CLI => $variables[13], INS_FE => $variables[14], INS_USER => $variables[15] } ;
}

print "$file\n";
print "$prestamos[0]->{INS_USER}\n";





#for $href ( @ppi ) {
#    print "{ ";
#    for $role ( keys %$href ) {
#         print "$role=$href->{$role},\n ";
#    }
#    print "}\n";
#}


