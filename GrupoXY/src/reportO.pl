#!/bin/perl

use DateTime::Format::Strptime;


sub compararFechas
{
	$inicial = $_[0];
	$final = $_[1];
	$comparada = $_[2];

	if (DateTime->compare($incial,$comparada) <= 0 )

}


$patronFecha = new DateTime::Format::Strptime(pattern => '%d/%m/%Y');



$otraComparativa = "Y";
while($otraComparativa eq "Y")
{
	system("clear");
	print "-----------------------------ReportO------------------------------\n";
	print "Ingrese el código del país: ";
	$codPais = <STDIN>;
	chomp($codPais);
	print "Ingrese el código del sistema: ";
	$codSistema = <STDIN>;
	chomp($codSistema);
	print "Ingrese la fecha inicial del período (formato DD/MM/AAAA CON BARRAS): ";
	$inicialPeriodo = <STDIN>;
	chomp($inicialPeriodo);
	$fechaInicial = $patronFecha->parse_datetime($inicialPeriodo);
	print "Ingrese la fecha final del periódo (formato DD/MM/AAAA CON BARRAS): ";
	$finalPeriodo = <STDIN>;
	chomp($finalPeriodo);
	$fechaFinal = $patronFecha->parse_datetime($finalPeriodo);



	$maestro = "PPI.mae";
	open(ENTRADA1,"<$maestro") || die "ERROR: No se puede abrir el archivo maestro";

	my @variables = (); #este array almacenará los valores de cada línea separados

	my @ppi = ();


	#lectura de PPI.mae



	while ($linea1 = <ENTRADA1>)
	{
		@variables = split(/;/,$linea1);

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


	print "---------------------------RECOMENDACIÓN-----------------------\n\n";
	$mayor = "0";
	$i = 0;
	open(ENTRADA1,"<$maestro");
	my @posicionMayor = ();
	my @posicionSeleccionada = ();
	while($linea1 = <ENTRADA1>)
	{
		$j = 0;
		open(ENTRADA3,"<$file");
		while($linea2 = <ENTRADA3>)
		{
			if ($ppi[$i]->{"PRES_ID"} eq $prestamos[$j]->{"PRES_ID"} and $ppi[$i]->{"CTB_ANIO"} eq $prestamos[$j]->{"CTB_ANIO"} and $ppi[$i]->{"CTB_MES"} eq $prestamos[$j]->{"CTB_MES"} and $ppi[$i]->{"SIS_ID"} eq $codSistema and $prestamos[$j]->{"SIS_ID"} eq $codSistema)
			{
				push @posicionSeleccionada, $i;
				push @posicionSeleccionada, $j;
			}
			$j = $j + 1;
		}
		$i = $i + 1;
	}




	#Condiciones para la recomendación
	$i = 0;
	@reporteRecomendacion = ();
	while($i < @posicionSeleccionada)
	{
		$recomendacion = "NO-RECAL";
		if ($ppi[$posicionSeleccionada[$i]]->{"CTB_ESTADO"} eq "SMOR" and $prestamos[$posicionSeleccionada[$i + 1]]->{"CTB_ANIO"} ne "SMOR")
		{
			$recomendacion = "RECAL";
		}

		if($restanteMaestro[$posicionSeleccionada[$i]] lt $prestamos[$posicionSeleccionada[$i + 1]]->{"MT_REST"})
		{
			$recomendacion = "RECAL";
		}


		$diferencia = $restanteMaestro[$posicionSeleccionada[$i]] - $prestamos[$posicionSeleccionada[$i+1]]->{"MT_REST"};

		push @reporteRecomendacion, {PAIS => $ppi[$posicionSeleccionada[$i]]->{"PAIS_ID"},
									SISID => $ppi[$posicionSeleccionada[$i]]->{"SIS_ID"},
									PRESID => $ppi[$posicionSeleccionada[$i]]->{"PRES_ID"},
									RECO => $recomendacion,
									M_ESTADO => $ppi[$posicionSeleccionada[$i]]->{"CTB_ESTADO"},
									P_ESTADO => $prestamos[$posicionSeleccionada[$i + 1]]->{"CTB_ESTADO"},
									M_REST => $restanteMaestro[$posicionSeleccionada[$i]],
									P_REST => $prestamos[$posicionSeleccionada[$i + 1]]->{"MT_REST"},
									DIF => $diferencia,
									ANIO => $ppi[$posicionSeleccionada[$i]]->{"CTB_ANIO"},
									MES => $ppi[$posicionSeleccionada[$i]]->{"CTB_MES"},
									DIA => $ppi[$posicionSeleccionada[$i]]->{"CTB_DIA"}
									};
		$i = $i + 2;
	}

	print "PAIS\tSISID\tPRESID\t\tRECO\t\tM.ESTADO\tP.ESTADO\tM.REST\tP.REST\tDIF\tANIO\tMES\tM.DIA\tP.DIA\n\n";

	for $i (@reporteRecomendacion)
	{
		print "$i->{PAIS}\t$i->{SISID}\t$i->{PRESID}\t$i->{RECO}\t$i->{M_ESTADO}\t$i->{P_ESTADO}\t$i->{M_REST}\t$i->{P_REST}\t$i->{DIF}\t$i->{ANIO}\t$i->{MES}\t$i->{DIA}\n";
		if (@ARGV != () and $ARGV[0] == "-g")
		{
			$escritura = "comparado." . $nombrePais;
			open(SALIDA,">>$escritura");
			print SALIDA "$i->{PAIS};$i->{SISID};$i->{PRESID};$i->{RECO};$i->{M_ESTADO};$i->{P_ESTADO};$i->{M_REST};$i->{P_REST};$i->{DIF};$i->{ANIO};$i->{MES};$i->{DIA}\n";
		}
	}
	print "\n\n¿Desea hacer otra comparativa?(Y/n): ";
	$otraComparativa = <STDIN>;
	chomp($otraComparativa);
}


#DIVERGENCIAS EN PORCENTAJE

$otraConsulta = "Y";
while ($otraConsulta eq "Y")
{

	system("clear");
	print "--------------------------DIVERGENCIAS EN PORCENTAJE-----------------------------";
	print "\n\nIngresar porcentaje de referencia: ";
	$porcentaje = <STDIN>;
	chomp($porcentaje);
	$comparado = "comparado." . $nombrePais;
	if (-e $comparado)
	{
		@reportePorcentaje = ();
		open(ENTRADA,"<$comparado");
		$i = 1;
		while($linea = <ENTRADA>)
		{
			@variables = split(/;/,$linea);
			$difPesos = $variables[8];
			if ($variables[6] == 0)
			{
				$difPorcentaje = 0;
			}
			else
			{
					$difPorcentaje = sprintf("%.2f",abs(($difPesos * 100) / $variables[6]));
			}
			if ($difPorcentaje > $porcentaje)
			{
				push @reportePorcentaje, {	M_REST => $variables[6],
											P_REST => $variables[7],
											DIF_PESOS => $difPesos,
											DIF_PORCENTAJE => $difPorcentaje,
											PAIS_ID => $variables[0],
											SIS_ID => $variables[1],
											PRES_ID => $variables[2],
											RECO => $variables[3],
											};
			}
			$i = $i + 1;
		}

		print "\nRegistros con diferencia superior al $porcentaje % : \n\n";

		print "PAIS_ID\tSIS_ID\tPRES_ID\tRECOMENDACIÓN\tMAESTRO\tPRÉSTAMOS\tDIFERENCIA\tDIFERENCIA(%)\n\n";
		$consecutivo = "1";
		$file = "divPorcentaje" . $porcentaje . "(" . $consecutivo .  ")". "." . $nombrePais;
		while (-e $file)
		{
			$consecutivo = $consecutivo + 1;
			$file = "divPorcentaje" . $porcentaje . "(" . $consecutivo .  ")". "." . $nombrePais;
		}
		for $i (@reportePorcentaje)
		{
			print "$i->{PAIS_ID}\t$i->{SIS_ID}\t$i->{PRES_ID}\t$i->{RECO_ID}\t$i->{M_REST}\t$i->{P_REST}\t$i->{DIF_PESOS}\t$i->{DIF_PORCENTAJE}\n";
			if (@ARGV != () and $ARGV[0] == "-g")
			{
				open(SALIDA,">>$file");
				print SALIDA "$i->{PAIS_ID};$i->{SIS_ID};$i->{PRES_ID};$i->{RECO};$i->{M_REST};$i->{P_REST};$i->{DIF_PESOS};$i->{DIF_PORCENTAJE}\n";
			}
		}
		print "\n\n¿Desea realizar otra consulta? (Y/n): ";
		$otraConsulta = <STDIN>;
		chomp($otraConsulta);
	}
	else
	{
		print "ERROR: El archivo $comparado no existe aún. Ejecute primero el comando perl reportO.pl -g e ingrese el código de $nombrePais cuando se lo soliciten.\n\n";
		$otraConsulta = "";
	}

}


#DIVERGENCIAS EN PESOS
$consultaPesos = "Y";
while ($consultaPesos eq "Y")
{
	system("clear");
	print "--------------------------DIVERGENCIAS EN PESOS-----------------------------";
	print "\n\nIngresar valor de referencia en pesos: ";
	$pesos = <STDIN>;
	chomp($pesos);
	$comparado = "comparado." . $nombrePais;
	if (-e $comparado)
	{
		@reportePesos = ();
		open(ENTRADA,"<$comparado");
		$i = 1;
		while($linea = <ENTRADA>)
		{
			@variables = split(/;/,$linea);
			$difPesos = abs($variables[8]);
			if ($difPesos > $pesos)
			{
				push @reportePesos, {		M_REST => $variables[6],
											P_REST => $variables[7],
											DIF_PESOS => $difPesos,
											PAIS_ID => $variables[0],
											SIS_ID => $variables[1],
											PRES_ID => $variables[2],
											RECO => $variables[3],
											};
			}
			$i = $i + 1;
		}

		print "\nRegistros con diferencia superior a $pesos pesos (en valor absoluto) : \n\n";

		print "PAIS_ID\tSIS_ID\tPRES_ID\tRECOMENDACIÓN\tMAESTRO\tPRÉSTAMOS\tDIFERENCIA\n\n";
		$consecutivo = "1";
		$file = "divPesos" . $pesos . "(" . $consecutivo .  ")". "." . $nombrePais;
		while (-e $file)
		{
			$consecutivo = $consecutivo + 1;
			$file = "divPesos" . $pesos . "(" . $consecutivo .  ")". "." . $nombrePais;
		}
		for $i (@reportePesos)
		{
			print "$i->{PAIS_ID}\t$i->{SIS_ID}\t$i->{PRES_ID}\t$i->{RECO}\t$i->{M_REST}\t$i->{P_REST}\t$i->{DIF_PESOS}\n";
			if (@ARGV != () and $ARGV[0] == "-g")
			{
				open(SALIDA,">>$file");
				print SALIDA "$i->{PAIS_ID};$i->{SIS_ID};$i->{PRES_ID};$i->{RECO};$i->{M_REST};$i->{P_REST};$i->{DIF_PESOS}\n";
			}
		}

		print "\n\n¿Desea realizar otra consulta? (Y/n): ";
		$consultaPesos = <STDIN>;
		chomp($consultaPesos);
	}
	else
	{
		print "ERROR: El archivo $comparado no existe aún. Ejecute primero el comando perl reportO.pl -g e ingrese el código de $nombrePais cuando se lo soliciten.\n\n";
		$consultaPesos = "";
	}
}
