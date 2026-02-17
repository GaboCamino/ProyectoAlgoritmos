unit maneja_archivo;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,Conductores,Infracciones,usuario,dos, SysUtils,lista_fecha,validaciones;

{ambc conductores}
procedure Ingresa_Cond(var x: T_Dato_Conductor; buscado: shortstring);
procedure Alta_Cond(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt; buscado: shortstring; op:boolean);
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);
procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);
procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);
procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:char);
Procedure ABMC (var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);

{amc infracciones}
procedure asignarDescuento(var inf: t_dato_infraccion);
procedure registrarinf(var x: t_dato_conductor; var Inf: t_dato_infraccion);
procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint; var l:T_lista);
procedure Consulta_Infracciones(var Arch_I: T_Archivo_I; dni_bus: string);
procedure Buscar_Infraccion_ID(var Arch_I: T_Archivo_I;id_bus: string;var pos: longint;var encontrado: boolean);
procedure Modificar_datosinf(var Arch_I: T_Archivo_I;var inf: T_Dato_Infraccion;pos_i: longint);
procedure Apelar_Infraccion(var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var inf: T_Dato_Infraccion;pos_i: longint);
procedure Modificar_Infraccion(var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I);
procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt;var l:T_lista);


{estadisticas}
function conductoresScoreCero(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
function conductoresPorcentajeReincidencias(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
function porcentaje_infapeladas(var Arch_I: T_Archivo_I): real;
procedure rangoEtario(var Arch_C: T_Archivo_C; var Arch_I: T_Archivo_I);
Procedure EstadisticaFechas(var l:T_lista);

implementation

procedure Ingresa_Cond(var x: T_Dato_Conductor; buscado: shortstring);
var
   f, mensaje,telefono: string;
begin

     if validaNombre(buscado) = true then
     begin
          x.Apynom := buscado;
          gotoxy(30,4); write('Apellido y nombre: ', buscado);
          gotoxy(30,6);  write('DNI: ');
          esDNI(x);
     end
     else
     begin
          gotoxy(30,4); write('DNI: ', buscado);
          x.dni := buscado;
          gotoxy(30,6); write('Apellido y nombre: ');
          esNombre(x);
     end;

     gotoxy(30,8);
     mensaje := 'Ingrese fecha de nacimiento: ';IngresaFecha(f, mensaje);
     x.Nacim := f;

     if edadactual(f)< 18 then
     begin
          writeln('conductor menor de edad');
          readkey;
     end   else
    begin
    telefono:=#0;
     gotoxy(30,10); write('Telefono: '); ValidaTelefono(telefono);
     x.tel:=telefono;

     gotoxy(30,12); write('Email: ');
     readln(x.mail);

     x.Score := 20;
     x.Hab := 'S';
     x.Reincidencias := 0;
     x.Estado:='S';

     gotoxy(30,14); writeln('¡Alta registrada!');
end;

end;

procedure Alta_Cond(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt; buscado: shortstring; op:boolean);     {crea un nuevo conductor en el archivo de conductores}
var
   x: T_Dato_Conductor;
   x1: t_dato_arbol;
   fecha:string;
begin
     ingresa_cond(x,buscado);
     FechaActual(fecha);
     x.Fecha_Hab := fecha;
     x1.pos:= filesize(Arch_C);  //indica la posición donde se agregará el último registro
     seek(arch_c,x1.pos);
     write(arch_c,x);
     x1.clave:= x.dni;
     agregar(arbol_dni,x1);
     x1.clave:= x.apynom;
     agregar(arbol_apynom,x1);
delay(1000);
end;
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);   {inhabilita un conductor en el archivo de conductores}
var
   op: char;
begin
     Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom);
     writeln;
     seek(Arch_C, pos); read(Arch_C, x);
     write('Confirmar baja por defuncion?(S/N) : '); readln(op);
     if upcase(op)='S' then
     begin
          x.Hab:='N';
          x.Estado:='N';
          seek(arch_c,pos);
          write(Arch_C,x);
          writeln('Baja registrada');
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
   y:byte;
begin
      //Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom); writeln();
      clreol; textbackground(green); writeln('Datos del conductor'); textbackground(white); clreol;
      conductor_modificado(arch_c, pos,arbol_dni,arbol_apynom, x, Y);

      gotoxy(1,12); clreol; textbackground(green); writeln('MODIFICAR DATOS DEL CONDUCTOR'); textbackground(white); clreol;
      gotoxy(1,13); writeln('1. Fecha de nacimiento (DD/MM/AAAA)');
      gotoxy(1,14); writeln('2. Telefóno');
      gotoxy(1,15); writeln('3. Dirección de mail');
      gotoxy(1,16); writeln('4. Dar de baja');
      gotoxy(1,17); writeln('5. Aplicar reincidencia');
      gotoxy(1,18); Writeln('0. Regresar');
      repeat
      gotoxy(1,19); write('Que desea modificar? '); clreol; readln(op);


begin
      if op in ['1'..'5'] then
      begin
           seek(arch_c, pos);read(arch_c, x);
           Actualizar_cond(x,arch_c,pos,arbol_dni,arbol_apynom,op);

           if op<>'5' then
           begin
           gotoxy(1,21);write('Confirmar modificación? S/N: '); readln(op);
           if upcase(op)='S' then
           begin
                seek(Arch_c, pos);
                write(Arch_C,x);
                gotoxy(1,22); writeln('¡Modificación registrada!');
                delay(1500);
                gotoxy(1,21); clreol; gotoxy(1,22);  clreol;
           end;

      end;
      end;
      end;
      until op='0';
end;

procedure reincidencia_cond(var x: T_Dato_Conductor);
var
  op: char;
  fecha:string;
begin
  if (x.Score <= 0) and (x.Estado= 'S') then
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
      if (x.Reincidencias > 5) then
      begin
        x.Estado:= 'N';
        x.Hab:= 'N';
        writeln('el conductor llego al maximo de reincidencias');
        writeln('conductor Inhabilitado permanentemente')
      end;
      FechaActual(fecha);
      x.Fecha_hab := fecha;
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
       writeln;
       writeln('El conductor no puede aplicar a la reincidencia');
  end;

  readkey;
end;

procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:char);{actualiza los datos de un conductor en el archivo}
var
f,mensaje,telefono:string;
begin
     case op of
          '1':begin
                   f:=#0;
                   mensaje:=''; gotoxy(22,10); IngresaFecha(f,mensaje);
                   x.Nacim:= f;
          end;
          '2':begin
                   gotoxy(11,8); ValidaTelefono(telefono); x.tel:=telefono;
          end;
          '3':begin
                  gotoxy(7,9); write('Email: '); readln(x.mail);
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
     Write('Búsqueda por DNI/Apellido y nombre: '); validaBuscado(buscado); clrscr;
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


procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint; var l:T_lista);      {generar infraccion a un conductor}
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
  FechaActual(f);
  seek(Arch_C, pos);
  inf.fecha:=f;
  write(Arch_C, x);

  inf.Id := IntToStr(FileSize(Arch_I) + 1);
  seek(Arch_I, FileSize(Arch_I));
  write(Arch_I, inf);
  Agregar_A_Lista(l,inf);

  writeln;
  writeln('Infracción registrada correctamente');
  end;
  readkey;
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
  Titulos_List_Inf;
  seek(Arch_I, 0);
  while not eof(Arch_I) do
  begin
    read(Arch_I, inf);
    if inf.DNI = dni_bus then
    begin
      infraccion := true;
      Mostrar_Inf_planilla(Inf,Y);
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
  f,mensaje:string;
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
         mensaje:='Ingrese fecha (DD/MM/AAAA): ';
         IngresaFecha(f,mensaje);
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
  write('Desea realizar alguna modificación? S/N: '); readln(op);
  if upcase(op)='S' then
  begin
       write('Ingrese ID de la infracción: ');readln(id_bus);

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



procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt;var l:T_lista);
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
       if x.Hab = 'N' then
       begin
       gotoxy(30,16); clreol; textcolor(blue);  writeln('1: Agregar infracción a un conductor (Inhabilitado)');
       end else
       begin
         textcolor(black);
         gotoxy(30,16);  writeln('1: Agregar infracción a un conductor');
       end;
       textcolor(black);
       gotoxy(30,18);  writeln('2: Modificar infracciones de un conductor');
       gotoxy(30,20); writeln('3: Consultar infracciones de un conductor');
       gotoxy(30,22); writeln('0: Regresar');
       gotoxy(30,24); write('Opción: ');
       gotoxy(38,24); readln(op2);
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
                  Alta_Infraccion(Arch_C, Arch_I, pos,l);
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


procedure rangoEtario(var Arch_C: T_Archivo_C; var Arch_I: T_Archivo_I);
var
  x: T_Dato_Conductor;
  inf: T_Dato_Infraccion;
  edad: integer;
  cont1, cont2, cont3: integer;
  pos_c: longint;
begin
  cont1 := 0; cont2 := 0; cont3 := 0;
  seek(Arch_I, 0);
  while not eof(Arch_I) do
  begin
    read(Arch_I, inf);
    pos_c := 0;
    seek(Arch_C, 0);
    while not eof(Arch_C) do
    begin
      read(Arch_C, x);
      if x.DNI = inf.DNI then
      begin
        edad := edadactual(x.Nacim);

        if (edad >= 18) and (edad <= 30) then
          inc(cont1)
        else if (edad > 30) and (edad <= 50) then
          inc(cont2)
        else if (edad > 50) and (edad <= 110) then
          inc(cont3);

      end;
      inc(pos_c);
    end;
  end;

  writeln('Cantidad de infracciones a menores de 30 años: ', cont1);
  writeln('Cantidad de infracciones entre 31 y 50 años: ', cont2);
  writeln('Cantidad de infracciones a mayores de 50 años: ', cont3);
end;

Procedure EstadisticaFechas(var l:T_lista);
var fecha_desde,fecha_hasta:string;
contador:integer;
p:T_punt_F;
begin
     fecha_desde:=#0;
     fecha_hasta:=#0;
     contador:=0;
     p:=l.cab;
     clrscr;
     IntervaloFechas(fecha_desde,fecha_hasta);
     while p<>nil do
     begin
          if  (p^.info.Fecha < fecha_desde) then
          begin
               p := p^.sig
          end
          else
          if  (p^.info.Fecha >= fecha_desde) and (p^.info.Fecha <= fecha_hasta)then
          begin
          contador:=contador+1;
          p := p^.sig;
          end;
     end;
     Writeln('Total de infracciones entre fechas: ',contador);
end;
end.

