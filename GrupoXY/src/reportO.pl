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

while ($linea = <ENTRADA>)
{
	$i = 0;
	$ant = -1;
	$sub = $linea;
	while ($i < 13)
	{
		$ocurrencia = index($sub, ';');
		$sig = ocurrencia;
		if($i == 0)
		{
			$size = 1;
		}
		else
		{
			$size = $sig - $ant - 1;
		}
		$sub = substr($sub, $sig + 1);
		$valor = substr($linea, $ant + 1, $size);
		$ant = $siguiente;
		push @variables, $valor;
		$i = $i + 1;
	}
	print "@variables\n";
}



