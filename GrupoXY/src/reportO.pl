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
$i = 0;

while ($linea = <ENTRADA>)
{
	@variables = split(/;/,$linea);

	my %fila = ();
	$fila{"PAIS_ID"} = $variables[0];
	$fila{"SIS_ID"} = $variables[1];
	$fila{"CTB_ANIO"} = $variables[2];
	$fila{"CTB_MES"} = $variables[3];
	$fila{"CTB_DIA"} = $variables[4];
	$fila{"CTB_ESTADO"} = $variables[5];
	$fila{"PRES_FE"} = $variables[6];
	$fila{"PRES_ID"} = $variables[7];
	$fila{"PRES_TI"} = $variables[8];
	$fila{"MT_PRES"} = $variables[9];
	$fila{"MT_IMPAGO"} = $variables[10];
	$fila{"MT_INDE"} = $variables[11];
	$fila{"MT_INNODE"} = $variables[12];
	$fila{"MT_DEB"} = $variables[13];
	
	push @ppi,{PAIS_ID => $variables[0], SIS_ID => $variables[1], CTB_ANIO => $variables[2], CTB_MES => $variables[3],
	CTB_DIA => $variables[4], CTB_ESTADO => $variables[5], PRES_FE => $variables[6], PRES_ID => $variables[7],
	PRES_TI => $variables[8], MT_PRES => $variables[9], MT_IMPAGO => $variables[10], MT_INDE => $variables[11],
	MT_INNODE => $variables[12], MT_DEB => $variables[13]  } ;
	
}


#print "@ppi\n";
#print "@ppi[0]\n";
#print "@ppi[1]\n";
#print "@ppi[2]\n";
#print "@ppi[3]\n";
#print %ppi[0];

for $href ( @ppi ) {
    print "{ ";
    for $role ( keys %$href ) {
         print "$role=$href->{$role} ";
    }
    print "}\n";
}


