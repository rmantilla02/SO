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

while ($linea = <ENTRADA>)
{
	$PAIS_ID = $linea;
	$PAIS_ID =~ sed 's/\(.*;\)-\(.*\)/\1/g' || die "Muérase";
	#$PAIS_ID =~ s/A/B/ || die "Muérase";
	print($PAIS_ID); 
}



