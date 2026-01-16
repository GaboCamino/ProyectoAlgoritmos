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
procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt);
Procedure IngresaFecha(var inf: T_Dato_Infraccion);

{estadisticas}
function conductoresScoreCero(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
function conductoresPorcentajeReincidencias(var arch_c:T_Archivo_C; x:T_Dato_Conductor):real;
procedure rangoEtario(var arch_c:T_Archivo_C; x:T_Dato_Conductor);


{validación}
function esNumerico(x:T_Dato_Conductor):boolean;
function EsNumero(s: string): boolean;
function ComparadorFecha(sa,sm,sd:word):string;
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
    gotoxy(2,13);
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
    1:  inf.descontar := 5;
    2:  inf.descontar := 4;
    3:  inf.descontar := 5;
    4:  inf.descontar := 4;
    5:  inf.descontar := 5;
    6:  inf.descontar := 10;
    7:  inf.descontar := 5;
    8:  inf.descontar := 10;
    9:  inf.descontar := 20;
    10: inf.descontar := 20;

  else
    Inf.Descontar := 0;
  end;

end;

procedure registrarinf(var x: t_dato_conductor; var Inf: t_dato_infraccion);     {registrar infracción a un conductor}
var total:byte;
begin

  writeln('infracciones');
  writeln('1- licencia vencida');
  writeln('2- circular sin RTO');
  writeln('3- circular sin casco');
  writeln('4- sin cinturón');
  writeln('5- no respetar semáforos');
  writeln('6- conducir con impedimientos fisicos y/o bajo de estupefacientes');
  writeln('7- exceso velocidad (menos 30%)');
  writeln('8- exceso velocidad (más 30%)');
  writeln('9- conducir inhabilitado');
  writeln('10- organizar y/o participar en competencias ilegales en via publica');
  writeln('0: volver');
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
  end
  else
  begin
    x.Hab := 'S';
    writeln('Score restante: ', x.Score);
  end;

  writeln('Estado del conductor: ');
  if x.Hab = 'S' then
    writeln('Conductor habilitado')
  else
    writeln('Conductor inhabilitado');
end;

procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint);      {generar infraccion a un conductor}
var
  x: T_Dato_Conductor;
  inf: T_Dato_Infraccion;
begin
  seek(Arch_C, pos);
  read(Arch_C, x);
  clrscr;

  registrarinf(x, inf);

  inf.DNI := x.DNI;
  inf.Apelada := 'N';

 { write('Ingrese fecha (DD/MM/AAAA): ');
  readln(inf.Fecha);} //viejo, lo dejo por las dudas si lo mío no funca
  IngresaFecha(inf);

  seek(Arch_C, pos);
  write(Arch_C, x);

  seek(Arch_I, filesize(Arch_I));
  write(Arch_I, inf);

  writeln;
  writeln('Infracción registrada correctamente');

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
  gotoxy(1,1); Write('DNI');
  gotoxy(22,1); Write('FECHA');
  gotoxy(37,1); Write('INFRACCION');
  gotoxy(52,1); Write('DESCUENTO');
  gotoxy(57,1); Write('APELADA');
  textcolor(15);
  seek(Arch_I, 0);
  while not eof(Arch_I) do
  begin
    read(Arch_I, inf);
    if inf.DNI = dni_bus then
    begin
      infraccion := true;
      gotoxy(1, y);  write(inf.DNI);
      gotoxy(19, y); write(inf.Fecha);
      gotoxy(39, y); write(inf.Tipo);
      gotoxy(56, y); write(inf.Descontar);
      gotoxy(60, y); write(inf.Apelada);
      inc(y);
    end;

 end;

  if not infraccion then
  begin
    writeln;
    writeln('El conductor no posee infracciones registradas.');
  end;

  writeln;
  writeln('Presione una tecla para continuar...');
  readkey;
end;

procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt);      {menú alta-modificacion-consulta del archivo de infracciones}
var
   buscado:string[50];
   pos:longint;
   op:boolean;
   op2:char;
begin
     pos:=0;
     Write('Búsqueda por DNI del conductor: '); Readln(Buscado); clrscr;
     Busqueda(arbol_dni, buscado, pos,op);
     if pos=-1 then                                                           {siempre distinto de -1}
     begin
       writeln('conductor no encontrado');

         end
             else
             begin
         Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom); writeln();

          gotoxy(30,6); writeln('1: Agregar infraccion');
          gotoxy(30,8); writeln('2: Modificar infraccion');
          gotoxy(30,10); writeln('3: Consultar infracciones');
          gotoxy(30,12);writeln('0: Regresar');
          gotoxy(30,14); write('Opción: ');
          gotoxy(38,14); readln(op2);
          case op2 of
              '1': begin
                  clrscr;
                  Alta_Infraccion(Arch_C, Arch_I, pos);
                  clrscr;
                 end;
           { 2:   }
            '3': begin
              clrscr;
                consulta_infracciones(Arch_I,buscado);
               clrscr;
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

{function infraccionMasComun(arch_i:T_Archivo_I; inf:T_Dato_Infraccion);
var
   contador_inf:byte;
begin
     contador_inf:=0;
     seek(arch_i,0);
     while not eof(arch_i) do
     begin
          read(arch_i,inf);
          if inf.Tipo then
     end;

end;      }     //no me dio la cabeza para seguirlo


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

{validaciones}

function esNumerico(x:T_Dato_Conductor):boolean;
var
   i:byte;
   estado:boolean;
begin
     i:=1;
     if (length(x.dni)=7) or (length(x.dni)=8) then        {dni de 7 u 8 digitos}
     begin
          estado:=true;
          for i:=1 to length(x.dni) do                    {hasta la longitud del dni}
          begin
               if not(x.dni[i] in ['0'..'9']) then         {rango numerico del dni}
               begin
                    estado:=false;
               end;
          end;
     end else
         estado:=false;
esNumerico:=estado
end;

Procedure IngresaFecha(var inf: T_Dato_Infraccion);
var d,m,a,comp,f: string;
  sd,sm,sa:word;
begin
  comp:='1';
  f:='0';
  DecodeDate(Date,sa,sm,sd);
  repeat
     Writeln('Ingrese fecha: ');
     if (StrToInt(f))>(StrToInt(comp)) then
     begin
          clrscr;
          Writeln('Ingrese la fecha actual o una pasada.');
          readkey;
     end;
           repeat
                 readln(d);
           until (Length(d) = 2) and EsNumero(d) and (StrToInt(d) >= 1) and (StrToInt(d) <= 31);
     Write('/');
           repeat
                  readln(m);
           until (Length(m) = 2) and EsNumero(m) and (StrToInt(m) >= 1) and (StrToInt(m) <= 12);
     Write('/');
           repeat
                  readln(a);
           until (Length(a) = 4) and EsNumero(a) and (StrToInt(a) >= 1900) and (StrToInt(a) <=sa);
     f:= a+m+d;
     comp:=ComparadorFecha(sa,sm,sd);
     until (StrToInt(f))<=(StrToInt(comp));
     inf.Fecha:=f;
end;

function EsNumero(s: string): boolean;     //vi que hay otro para DNI, luego vemos como unificar
  var
    i: integer;
  begin
    EsNumero := true;
    for i := 1 to Length(s) do
      if not (s[i] in ['0'..'9']) then
      begin
        EsNumero := false;
      end;
  end;
 function ComparadorFecha(sa,sm,sd:word):string;
 begin
 ComparadorFecha:=IntToStr(sa) +
  Copy('0' + IntToStr(sm), Length(IntToStr(sm)), 2) +
  Copy('0' + IntToStr(sd), Length(IntToStr(sd)), 2);
 end;
end.



