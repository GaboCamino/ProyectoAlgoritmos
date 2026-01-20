unit maneja_archivo;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,Conductores,Infracciones,usuario,dos, SysUtils;

{ambc conductores}
procedure Alta_Cond(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt; buscado: shortstring; op:boolean);
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);
procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);
procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);
procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:char);
Procedure ABMC (var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);

{amc infracciones}
procedure asignarDescuento(var inf: t_dato_infraccion);
procedure registrarinf(var x: t_dato_conductor; var Inf: t_dato_infraccion);
procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint);
procedure Consulta_Infracciones(var Arch_I: T_Archivo_I; dni_bus: string);
procedure Buscar_Infraccion_ID(var Arch_I: T_Archivo_I;id_bus: string;var pos: longint;var encontrado: boolean);
procedure Modificar_datosinf(var Arch_I: T_Archivo_I;var inf: T_Dato_Infraccion;pos_i: longint);
procedure Apelar_Infraccion(var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var inf: T_Dato_Infraccion;pos_i: longint);
procedure Modificar_Infraccion(var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I);
procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt);


{estadisticas}
function conductoresScoreCero(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
function conductoresPorcentajeReincidencias(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
function porcentaje_infapeladas(var Arch_I: T_Archivo_I): real;
procedure rangoEtario(var arch_c:T_Archivo_C; x:T_Dato_Conductor);


implementation

procedure Ingresa_Cond(var x: T_Dato_Conductor;  buscado: shortstring);    {cargar datos de un conductor y verifica si se encuentra existente}
var
   i:longint;
   op:boolean;
begin
     for i:=1 to length(buscado) do
     begin                                                     {itera para validar si es de tipo caracter el buscado}
          if buscado[i] in ['a'..'z','A'..'Z'] then
          begin
               op:=true;
          end else
          op:=false;
     end;

     if op=true then
     begin
          x.Apynom:=buscado;
          gotoxy(30,4); write('Apellido y nombre: ',buscado);        {en el caso de ser caracter considera que es un apynom}
          gotoxy(30,6); write('DNI: '); readln(x.dni);
     end else
     if op=false then
     begin
          gotoxy(30,4); write('DNI: ', buscado);
          x.dni:=buscado;                                                   {si es numerico es el dni}
          gotoxy(30,6); write('Apellido y nombre: '); readln(x.apynom);
     end;

     gotoxy(30,8); write('Fecha de nacimiento (DD/MM/AAAA): '); readln(x.nacim);     //ver cómo usar IngresaFecha
     gotoxy(30,10); write('Telefono: '); readln(x.tel);
     gotoxy(30,12); write('Email: '); readln(x.mail);

     x.Score:= 20;
     x.Hab:= 'S';
 //  x.fecha_hab:=fecha;
     x.Reincidencias:= 0;
end;

procedure Alta_Cond(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt; buscado: shortstring; op:boolean);     {crea un nuevo conductor en el archivo de conductores}
var
   x: T_Dato_Conductor;
   x1: t_dato_arbol;
begin
     ingresa_cond(x,buscado);         {el buscado se podría usar para agregar mediante el arbol de apynom}
     x1.pos:= filesize(Arch_C);  //indica la posición donde se agregará el último registro
     seek(arch_c,x1.pos);
     write(arch_c,x);
     x1.clave:= x.dni;
     agregar(arbol_dni,x1);
     x1.clave:= x.apynom;
     agregar(arbol_apynom,x1);

     gotoxy(30,14); writeln('¡Alta registrada!');

delay(1000);
end;
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);   {inhabilita un conductor en el archivo de conductores}
var
   op: char;
begin
     Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom);
     writeln;
     seek(Arch_C, pos); read(Arch_C, x);
     write('Confirmar baja? S/N: '); readln(op);
     if upcase(op)='S' then
     begin
          x.Hab:='N';
          seek(arch_c,pos);
          write(Arch_C,x);
          writeln('¡Baja registrada!');
     end;
delay(1000);
clrscr;
end;
procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);      {consultar datos sobre un conductor}
var
  x: T_Dato_Conductor;
begin
begin
     if (pos >= 0) then
     begin
          seek(Arch_C, pos);
          read(Arch_C, x);
          Titulos_List_Cond;
          Mostrar_Cond_planilla(x,3);  // mostrar un solo registro
     end else
     writeln('Posición inválida o no encontrada');
end;
end;
procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);    {modificar datos de un conductor}
var
   x: T_Dato_Conductor;
   op:char;
begin
      Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom); writeln();
      gotoxy(1,6); writeln('MODIFICAR DATOS DEL CONDUCTOR');
      gotoxy(1,10); writeln('1. Fecha de nacimiento (DD/MM/AAAA)');
      gotoxy(1,12); writeln('2. Telefóno');
      gotoxy(1,14); writeln('3. Dirección de mail');
      gotoxy(1,16); writeln('4. Dar de baja');
      gotoxy(1,18); writeln('5. Aplicar reincidencia');
      gotoxy(1,20); Writeln('0. Regresar');
      gotoxy(1,22); write('Que desea modificar? '); readln(op);
      if op in ['1'..'5'] then
      begin
           seek(arch_c, pos);read(arch_c, x);
           clrscr;
           Actualizar_cond(x,arch_c,pos,arbol_dni,arbol_apynom,op);
           seek(Arch_c, pos);
           write(Arch_C,x);
           writeln('Modificación registrada');
      end;
      delay(1000);clrscr;
end;
procedure reincidencia_cond(var x: T_Dato_Conductor);
var
  op: char;
begin
  if x.Score <= 0 then
  begin

    writeln('El conductor posee score 0.');
    gotoxy(2,4);
    writeln('¿Cumplió con los cursos obligatorios?');
    readln(op);
    if (upcase(op)) = 'S' then
    begin
      x.Score := 20;
      x.Hab := 'S';
      x.Reincidencias:= x.Reincidencias + 1;
      writeln('Reincidencia aplicada correctamente.');
      writeln('Score restaurado a 20.');
    end
    else
    begin
      writeln('No se aplicó la reincidencia.');
    end;
  end
  else
  begin
    writeln('El conductor no posee score 0, No requiere reincidencia');
  end;

  readkey;
end;

procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:char);     {actualiza los datos de un conductor en el archivo}
begin
     case op of
          '1':begin
                   write('Fecha de nacimiento (DD/MM/AAAA): '); readln(x.Nacim);
          end;
          '2':begin
                   write('Telefono: '); readln(x.tel);
          end;
          '3':begin
                   write('Email: '); readln(x.mail);
          end;
          '4':begin
                   Baja_Cond(Arch_C, pos,x,arbol_dni,arbol_apynom);
          end;
          '5':begin
                   reincidencia_cond (x);
          end;
     end;
end;
Procedure ABMC (var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);                       {menú de alta-baja-modificacion-consulta}
var
   buscado:string[50];
   pos:longint;
   op:boolean;
begin
     pos:=0;
     Write('Búsqueda por DNI/Apellido y nombre: '); Readln(Buscado); clrscr;
     Busqueda(arbol_dni, buscado, pos,op);  //dni               {buscar forma para que si existe no se haga la alta nuevamente}
     if pos=-1 then
     begin
          busqueda(arbol_apynom,buscado,pos,op); //apynom
     end;
     op:=true;
     if (pos=-1) and (op=true) then                                                           {siempre distinto de -1}
     begin
          Alta_Cond(Arch_C,arbol_dni,arbol_apynom, buscado,op)
     end else
         begin
              Modifica_Cond(Arch_C, pos,arbol_dni,arbol_apynom)
         end;
end;

procedure asignarDescuento(var inf: t_dato_infraccion);                      {asignar infraccion a un conductor con dicho puntaje}
begin
  case inf.tipo of
    1, 2: inf.Descontar := 2;

    3..6: inf.Descontar := 4;

    7..12: inf.Descontar := 5;

    13..18: inf.Descontar := 10;

    19, 20: inf.Descontar := 20;
  end;

end;

procedure registrarinf(var x: t_dato_conductor; var Inf: t_dato_infraccion);     {registrar infracción a un conductor}
begin
  writeln('infracciones');
   writeln('1- Circular sin placas de identificación');
   writeln('2- Estacionar en lugares prohibidos');
   writeln('3- Circular sin Revisión Técnica Obligatoria (RTO/VTV)');
   writeln('4- No utilizar cinturón de seguridad');
   writeln('5- Transportar menores sin sistema de retención');
   writeln('6- No respetar prioridad de peatones o emergencias');
   writeln('7- No respetar semáforos');
   writeln('8- Circular con licencia vencida');
   writeln('9- Motociclistas sin casco reglamentario');
   writeln('10- Utilizar teléfono celular durante la conducción');
   writeln('11- Circular en contramano');
   writeln('12- Exceso de velocidad (hasta 30%)');
   writeln('13- Conducir bajo efectos de alcohol y/o estupefacientes');
   writeln('14- Conducir con impedimentos físicos o psíquicos');
   writeln('15- Exceso de velocidad (más del 30%)');
   writeln('16- Conducción peligrosa o temeraria');
   writeln('17- Negarse a control de alcoholemia');
   writeln('18- Conducir transporte sin habilitación');
   writeln('19- Conducir con licencia suspendida o inhabilitado');
   writeln('20- Competencias ilegales en vía pública');
   writeln('0- Volver');
  write('Ingrese el número de infracción: ');
  readln(Inf.Tipo);
  AsignarDescuento(Inf);

  x.Score := x.Score - Inf.Descontar;

  writeln;
  writeln('Infracción penalizada por: ', inf.Descontar, ' puntos.');

     if x.Score <= 0 then
     begin
       x.Score := 0;
       x.Hab := 'N';
       writeln('Score restante: 0');
     end else
     begin
       x.Hab := 'S';
       writeln('Score restante: ', x.Score);
     end;

  write('Estado del conductor: ');
  if x.Hab = 'S' then
    writeln('Conductor habilitado')
  else
    writeln('Conductor inhabilitado');
end;


procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint);      {generar infraccion a un conductor}
var
  x: T_Dato_Conductor;
  inf: T_Dato_Infraccion;
  f:string;
begin
  seek(Arch_C, pos);
  read(Arch_C, x);
  clrscr;

  registrarinf(x, inf);
  if inf.tipo<>0 then
  begin
  inf.DNI := x.DNI;
  inf.Apelada := 'N';
  Write('Ingrese fecha: '); IngresaFecha(f);

  seek(Arch_C, pos);
  inf.fecha:=f;
  write(Arch_C, x);

  inf.Id := IntToStr(FileSize(Arch_I) + 1);
  seek(Arch_I, FileSize(Arch_I));
  write(Arch_I, inf);


  writeln;
  writeln('Infracción registrada correctamente');
  end;
  delay(1500);
  clrscr;
end;
procedure Consulta_Infracciones(var Arch_I: T_Archivo_I; dni_bus: string);
var
  inf: T_Dato_Infraccion;
  infraccion: boolean;
  y: byte;
begin
  infraccion := false;
  y := 3;

  clrscr;
  textcolor(black);
  gotoxy(1,1);  Write('ID');
  gotoxy(22,1); Write('DNI');
  gotoxy(37,1); Write('FECHA');
  gotoxy(52,1); Write('TIPO DE INFRACCION');
  gotoxy(75,1); Write('DESCUENTO');
  gotoxy(92,1); Write('APELADA');
  textcolor(15);
  seek(Arch_I, 0);
  while not eof(Arch_I) do
  begin
    read(Arch_I, inf);
    if inf.DNI = dni_bus then
    begin
      infraccion := true;
      gotoxy(1, y);  write(inf.ID);
      gotoxy(19, y); write(inf.DNI);
      gotoxy(36, y); muestraFecha(inf);
      gotoxy(62, y); write(inf.Tipo);
      gotoxy(71, y); write(inf.Descontar);
      gotoxy(96, y); write(inf.Apelada);
      inc(y);
    end;

 end;
  if not infraccion then
  begin
    writeln;
    writeln('El conductor no posee infracciones registradas.');
  end;
  writeln;
  readkey;
end;

procedure Buscar_Infraccion_ID(var Arch_I: T_Archivo_I;id_bus: string;var pos: longint;var encontrado: boolean);
var
  inf: T_Dato_Infraccion;
begin
  encontrado := false;
  pos := 0;
  seek(Arch_I, 0);

  while not eof(Arch_I) and not encontrado do
  begin
    read(Arch_I, inf);
    if (inf.ID = id_bus) then
    begin
      pos := FilePos(Arch_I) - 1;


      encontrado := true;
      end
    else
      inc(pos);
  end;

  if not encontrado then
    pos := -1;
end;
procedure Modificar_datosinf(var Arch_I: T_Archivo_I;var inf: T_Dato_Infraccion;pos_i: longint);
var op1:byte;
  f:string;
begin

  writeln('1. Cambiar tipo de infraccion');
  writeln('2. modificar fecha de infraccion');
  write('Opción: '); readln(op1);
  case op1 of
     1: begin clrscr;
        write('Nuevo tipo de infracción: ');
        readln(inf.Tipo);
        AsignarDescuento(inf);
        seek(Arch_I, pos_i);
        write(Arch_I, inf); writeln('Infracción modificada');readkey;
        clrscr;
        end;

      2: begin
         clrscr;
         IngresaFecha(f);
         seek(Arch_I, pos_i);
         write(Arch_I, inf);
         writeln;
         writeln('Fecha de infracción modificada');
         readkey;
       end;
  end;

  clrscr;
end;
procedure Apelar_Infraccion(var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var inf: T_Dato_Infraccion;pos_i: longint);
var
  x: T_Dato_Conductor;
  pos_c: longint;
  op: char;
begin
  clrscr;

  if inf.Apelada = 'N' then
  begin
    writeln('Procesando apelación ');
    delay(1500);
    writeln;
    writeln('Resultado de la apelación');
    writeln('1- Aceptada');
    writeln('2- Rechazada');
    write('Opción: ');
    readln(op);

  case op of
   '1': begin
      pos_c := 0;
      seek(Arch_C, 0);
      while not eof(Arch_C) do
      begin
        read(Arch_C, x);
        if x.DNI = inf.DNI then
        begin
          x.Score := x.Score + inf.Descontar;
          if x.Score > 20 then
            x.Score := 20;

            x.Hab := 'S';

            seek(Arch_C, pos_c);
            write(Arch_C, x);
        end;
        inc(pos_c);
      end;
      inf.Apelada := 'S';
      seek(Arch_I, pos_i);
      write(Arch_I, inf);
      writeln('Apelación aceptada');
      readkey;
    end;

  '2':  begin
      inf.Apelada := 'S';
      seek(Arch_I, pos_i);
      write(Arch_I, inf);
      writeln('Apelación rechazada');
      readkey;
       end;
  end;
  end else
  begin
    writeln('La infracción ya fue apelada');
    readkey;
  end;
  clrscr;
 end;


procedure Modificar_Infraccion(var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I);
var
  id_bus: string;
  pos: longint;
  encontrado: boolean;
  inf: T_Dato_Infraccion;
  op,op1: char;
begin
  writeln;
  write('Desea realizar alguna modificación? S/N'); readln(op);
  if upcase(op)='S' then
  begin
       write('Ingrese ID de la infracción: ');
  readln(id_bus);

  Buscar_Infraccion_ID(Arch_I, id_bus, pos, encontrado);

  if encontrado then
  begin
    seek(Arch_I, pos);
    read(Arch_I, inf);

    writeln;
    writeln('1: Apelar infracción');
    writeln('2: Modificar datos');
    writeln('0: Volver');
    readln(op);

    case op of
      '1': Apelar_Infraccion(Arch_C, Arch_I, inf, pos);
      '2': Modificar_datosinf(Arch_I, inf, pos);
    end;
  end
  else
  begin
    writeln('ID inexistente');
    readkey;
  end;
  end;

end;



procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt);
var
   buscado:string[50];
   pos:longint;
   op:boolean;
   op2:char;
   x: T_Dato_Conductor;
begin
     pos:=0;
     Write('Búsqueda por DNI del conductor: ');
     Readln(Buscado);
     clrscr;

     Busqueda(arbol_dni, buscado, pos, op);

     if pos = -1 then
     begin
       writeln('Conductor no encontrado');
       readkey;
     end
     else
     begin
       seek(Arch_C, pos);
       read(Arch_C, x);

       Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom);
       writeln;

       gotoxy(30,6);  writeln('1: Agregar infracción a un conductor');
       gotoxy(30,8);  writeln('2: Modificar infracciones de un conductor');
       gotoxy(30,10); writeln('3: Consultar infracciones de un conductor');
       gotoxy(30,12); writeln('0: Regresar');
       gotoxy(30,14); write('Opción: ');
       gotoxy(38,14); readln(op2);
       clrscr;

       case op2 of
         '1': begin
                if x.Hab = 'N' then
                begin
                  writeln('Conductor inhabilitado');
                  writeln('No es posible registrar nuevas infracciones');
                  readkey;
                end
                else
                  Alta_Infraccion(Arch_C, Arch_I, pos);
              end;

         '2': begin
                Consulta_Infracciones(Arch_I, buscado);
                Modificar_Infraccion(Arch_C, Arch_I);
              end;

         '3': begin
                Consulta_Infracciones(Arch_I, buscado);
              end;
       end;
     end;
end;



{estadísticas debe ir en otra unit, de momento lo pongo acá, luego organizamos bien}

function conductoresScoreCero(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
var
	cant_personas,contador:integer;
begin
        cant_personas:=0; contador:=0;
	seek(arch_c,0);
	while not eof(arch_c) do
	begin
		read(arch_c,x);
		if x.score = 0 then
		begin
			inc(contador);                  {incrementa el contador solo si la persona tuvo score 0}
		end;
	inc(cant_personas);                             {incrementa en +1 la cant de personas}
	end;
if cant_personas<>0 then
begin
	conductoresScoreCero:=(contador*100)/cant_personas;
end else
	conductoresScoreCero:=0;
end;

function conductoresPorcentajeReincidencias(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
var
	cant_personas,contador:integer;
begin
        cant_personas:=0; contador:=0;
	seek(arch_c,0);
	while not eof(arch_c) do
	begin
		read(arch_c,x);
		if x.Reincidencias>0 then
		begin
			inc(contador);                  {incrementa el contador solo si la persona tuvo reincidencias mayor qué 0}
		end;
	inc(cant_personas);                             {incrementa en +1 la cant de personas}
	end;
if cant_personas<>0 then
begin
	conductoresPorcentajeReincidencias:=(contador*100)/cant_personas;
end else
	conductoresPorcentajeReincidencias:=0;
end;

function porcentaje_infapeladas(var Arch_I: T_Archivo_I): real;
var
  cantpersonas, apeladas: integer;
  inf: T_Dato_Infraccion;
begin
  cantpersonas := 0; apeladas := 0;
  seek(Arch_I, 0);
  while not eof(Arch_I) do
  begin
    read(Arch_I, inf);
    inc(cantpersonas);

    if inf.Apelada = 'S' then
      inc(apeladas);
  end;

  if cantpersonas <> 0 then
    porcentaje_infapeladas := (apeladas * 100) / cantpersonas
  else
    porcentaje_infapeladas := 0;
end;


procedure rangoEtario(var arch_c:T_Archivo_C; x:T_Dato_Conductor);
var
        cont1,cont2,cont3,edad:integer;
        year,mont,mday,wday:word;
        nac:word;
        anioNac:shortstring;
begin
     cont1:=0; cont2:=0; cont3:=0;
     getdate(year,mont,mday,wday);           {funcion que obtiene el año}
     seek(arch_c,0);
     while not eof(arch_c) do
     begin
          read(arch_c,x);
          anioNac:=copy(x.nacim,7,10);             {extraigo el año}
          edad:=year-StrToInt(anioNac);            {calculo la edad actual y a su vez convierto la cadena en un entero}
          if (edad>=18) and (edad<=30) then
          begin
               inc(cont1);
          end else
          if (edad>31) and (edad<=50) then
          begin
               inc(cont2);
          end else
          if (edad>50) and (edad<=110) then
          begin
               inc(cont3);
          end;
     end;
     writeln('Cantidad de infracciones a menores de 30 años: ',cont1);
     writeln('Cantidad de infracciones entre 31 a 50 años: ',cont2);
     writeln('Cantidad de infracciones a mayores de 50 años: ',cont3);
end;
end.

