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
open(ENTRADA1,"<$maestro") || die "ERROR: No se puede abrir el archivo maestro";

my @variables = (); #este array almacenará los valores de cada línea separados

my @ppi = ();


#lectura de PPI.mae



while ($linea1 = <ENTRADA1>)
{
	@variables = split(/;/,$linea);
	
	push @ppi, {PAIS_ID => $variables[0], SIS_ID => $variables[1], CTB_ANIO => $variables[2], CTB_MES => $variables[3],
	CTB_DIA => $variables[4], CTB_ESTADO => $variables[5], PRES_FE => $variables[6], PRES_ID => $variables[7],
	PRES_TI => $variables[8], MT_PRES => $variables[9], MT_IMPAGO => $variables[10], MT_INDE => $variables[11],
	MT_INNODE => $variables[12], MT_DEB => $variables[13]  } ;
	
}


#SE AVERIGUA EL NOMBRE DEL PAÍS
#Se lee el archivo p-s.mae
open(ENTRADA2,"<p-s.mae");
while($linea = <ENTRADA2>)
{
	@variables = split(/-/,$linea);
	if($variables[0] eq $codPais)
	{
		$nombrePais = $variables[1];
	}
}


#CÁLCULO DEL MONTO RESTANTE DEL MAESTRO
my @restanteMaestro = ();

for $i(@ppi)
{
	$restante = $i->{"MT_PRES"} + $i->{"MT_IMPAGO"} + $i->{"MT_INDE"} + $i->{"MT_INNODE"} - $i->{"MT_DEB"};
	push @restanteMaestro,$restante;
}


#LECTURA DE prestamos.pais:
$file = "prestamos." . $nombrePais;
open(ENTRADA3,"<$file");
my @prestamos = ();
while ($linea = <ENTRADA3>)
{
	@variables = split(/;/,$linea);

	
	push @prestamos, {SIS_ID => $variables[0], CTB_ANIO => $variables[1], CTB_MES => $variables[2], CTB_DIA => $variables[3],CTB_ESTADO => $variables[4], PRES_ID => $variables[5], MT_PRES => $variables[6], MT_IMPAGO => $variables[7], MT_INDE => $variables[8], MT_INNODE => $variables[9], MT_DEB => $variables[10], MT_REST => $variables[11], PRES_CLI_ID => $variables[12], PRES_CLI => $variables[13], INS_FE => $variables[14], INS_USER => $variables[15] } ;
}




#RECOMENDACIÓN
#Se determina la posición que se va a comparar
$mayor = "0";
$i = 0;
while($linea1 = <ENTRADA1> and $linea2 = <ENTRADA3>)
{
	if ($ppi[$i]->{"PRES_ID"} eq $prestamos[$i]->{"PRES_ID"} and $ppi[$i]->{"CTB_ANIO"} eq $prestamos[$i]->{"CTB_ANIO"} and $ppi[$i]->{"CTB_MES"} eq $prestamos[$i]->{"CTB_MES"})
	{
		if ($ppi["CTB_DIA"] gt $mayor)
		{
			$mayor = $ppi["CTB_DIA"];
		}
	}
	$i = $i + 1;
}

$i = 0;
$recomendacion = "holi";
while($linea1 = <ENTRADA1> and $linea2 = <ENTRADA3>)
{
	if ($ppi[$i]->{"PRES_ID"} eq $prestamos[$i]->{"PRES_ID"} and $ppi[$i]->{"CTB_ANIO"} eq $prestamos[$i]->{"CTB_ANIO"} and $ppi[$i]->{"CTB_MES"} eq $prestamos[$i]->{"CTB_MES"} and $ppi[$i] eq $mayor)
	{
		if ($ppi[$i]->{"CTB_ESTADO"} eq "SMOR" and $prestamos[$i]->{"CTB_ESTADO"} ne "SMOR")
		{
			$recomendacion = "RECAL";
		}
		else 
		{
			if ($restanteMaestro[$i] le $prestamos[$i]->{"MT_REST"})
			{
				$recomendacion = "RECAL";
			}
			else
			{
				$recomendacion = "NO-RECAL";
			}
		}
	}
	$i = $i + 1;
}

print "$recomendacion\n";




#for $href ( @ppi ) {
#    print "{ ";
#    for $role ( keys %$href ) {
#         print "$role=$href->{$role},\n ";
#    }
#    print "}\n";
#}


