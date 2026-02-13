unit Usuario;
{$codepage utf8}
interface

uses
    crt,dos,maneja_arboles,Conductores,Lista_fecha,Infracciones,Sysutils;

procedure Titulos_List_Cond;
procedure conductor_modificado(var arch_c:T_Archivo_C; pos: longint; arbol_dni,arbol_apynom:t_punt; var x: T_Dato_Conductor; Y: byte);
procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
procedure conductores_planilla(var arch_c: T_Archivo_C);
procedure  Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure conductores_Scoring(var arch_c:T_Archivo_C);
Procedure InfraccionesDeConductor(l:T_lista;p: T_punt_F; var fecha_desde,fecha_hasta:string);
Procedure InfraccionesEntreFechas(l:T_lista; p: T_punt_F;var fecha_desde,fecha_hasta:string);
procedure Titulos_List_Inf;
procedure Mostrar_Inf_planilla(var inf: T_Dato_Infraccion; Y: byte);
Procedure IngresaFecha(var f: string;mensaje:string);
function EsNumero(s: string): boolean;
function ComparadorFecha(sa,sm,sd:word):string;
procedure muestraFecha(inf:T_Dato_Infraccion);
Function EsFecha(x:string;long,min,max:integer):boolean;
Procedure RecorrePorFecha(var p: T_punt_F;var fecha_desde,fecha_hasta:string;var inf: T_Dato_Infraccion; var Y: byte);
Procedure IntervaloFechas(var fecha_desde,fecha_hasta:string);
procedure FechaActual(var fecha: string);
function edadactual(fechaNac: string): integer;
implementation

procedure Titulos_List_Cond;           {títulos arriba de todo en la pantalla}
begin
  clrscr;
  textcolor(black);
  gotoxy(1,1); Write('APELLIDO Y NOMBRE');
  gotoxy(28,1); Write('DNI');
  gotoxy(38,1); Write('SCORING');
  gotoxy(53,1); Write('HABILITADO');
  gotoxy(70,1); Write('Fecha HABILITACION.');
  gotoxy(95,1); Write('CANT. REINC.');
  gotoxy(110,1); write('TELEFONO');
end;

procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);   {planilla por filas}
begin
     gotoxy(1,Y); write(x.Apynom);
     gotoxy(25,Y); write(x.DNI);
     gotoxy(40,Y);if x.score <= 0 then
     begin
          x.score:=0;
          write(x.score);
          end
        else
          Write(x.score);
     gotoxy(58,Y);
     if x.hab='N' then
     begin
          clreol; textcolor(blue); Write(x.Hab); //se vuelve azul
          clreol; textcolor(black); //regresa al color pred
     end else
         write(x.hab);
     gotoxy(74,Y); Write(x.Fecha_hab);
     gotoxy(101,Y); Write(x.Reincidencias);
     gotoxy(109,Y); write(x.Tel);
end;

procedure conductores_planilla(var arch_c: T_Archivo_C);       {evalúa si un conductor se halla habilitado}
var
  x: T_Dato_Conductor;
  y: byte;
  raiz:t_punt;
begin
  y := 2;
  Titulos_List_Cond;
  seek(arch_c, 0);
  while not eof(arch_c) do
  begin
       read(arch_c, x);
       Mostrar_Cond_planilla(x, y);
       inc(y);
  end;
  readkey;
end;

procedure Inorden_Listado_apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);   {recorre el arbol y muestra de SAI-Raiz-SAD}
begin
     if raiz <> nil then
     begin
          inorden_listado_apynom(arch_c,raiz^.sai,Y);
          muestra_cond_apynom(arch_c,raiz,Y);                //recursividad aplicada
          inorden_listado_apynom(arch_c,raiz^.sad,Y);
     end;
  end;
procedure conductor_modificado(var arch_c:T_Archivo_C; pos: longint; arbol_dni,arbol_apynom:t_punt; var x: T_Dato_Conductor; Y: byte);
begin
y:=2;

if (pos >= 0) then
     begin
          seek(Arch_C, pos);
          read(Arch_C, x);

writeln('Apellido y nombre: ',x.apynom);
writeln('DNI: ',x.DNI);
if x.score <= 0 then
begin
     x.score:=0;
     writeln('Score: ', x.score);
end else
        Writeln('Score: ',x.score);
writeln('Habilitación: ', x.hab);
writeln('Fecha de habilitación: ',x.Fecha_hab);
writeln('Reincidencias: ',x.Reincidencias);
writeln('Telefóno: ',x.Tel);
writeln('Mail: ',x.Mail);
writeln('Fecha de nacimiento: ',x.Nacim);
writeln('Estado: ', x.Estado);
end else
     writeln('Posición inválida o no encontrada');
end;

procedure Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);   {muestra un unico conductor de la planilla}
var
  pos: cardinal;
  x: T_Dato_Conductor;
begin
  pos := raiz^.info.pos;
  Seek(arch_c, pos);
  Read(arch_c, x);
  Mostrar_Cond_planilla(x, Y);
  inc(Y);
  if (Y = 29) and ((raiz^.sai <> nil) or (raiz^.sad <> nil)) then
  begin
       gotoxy(5, 30); Writeln('PRESIONE UNA TECLA PARA VER MAS');
       readKey; clrScr;
       titulos_List_Cond;
       y:= 2;
  end;
end;


procedure conductores_Scoring(var arch_c:T_Archivo_C);      {evalúa si un conductor tuvo scoring = 0}
var
   y:byte;
    x:T_Dato_Conductor;
begin
     y:=2;
     Titulos_List_Cond;
     seek(arch_c,0);
     while not eof(arch_c) do
     begin
          read(arch_c,x);
          if x.Score=0 then
          Mostrar_Cond_planilla(x,y);
          inc(y);
     end;
     readkey;
end;
Procedure InfraccionesDeConductor(l:T_lista;p: T_punt_F; var fecha_desde,fecha_hasta:string);    //evalua si es el conductor buscado
var conductor:string[8];
    f,mensaje:string;
    inf:T_Dato_Infraccion;
    Y:byte;
begin
      conductor:=#0;
      mensaje:='Ingrese fecha inicial (DD/MM/AAAA): ';
      IngresaFecha(f,mensaje);
      fecha_desde:=f;
      mensaje:='Ingrese fecha final (DD/MM/AAAA): ';
      IngresaFecha(f,mensaje);
      fecha_hasta:=f;
      Writeln('Ingrese DNI del conductor: '); Readln(conductor);
      clrscr;
      Titulos_List_Inf;
      writeln;
      y:=3;
      while p<> nil do
           begin
           if (p^.info.DNI <> conductor) then
           p := p^.sig
           else
           if (p^.info.DNI = conductor) then
           RecorrePorFecha(p,fecha_desde,fecha_hasta,Inf,Y);                                                     //pasa a evaluar si pertenece al rango de fechas
      end;
      readkey;
end;
Procedure IntervaloFechas(var fecha_desde,fecha_hasta:string);
var f,mensaje:string;
begin
  mensaje:='Ingrese fecha inicial (DD/MM/AAAA): ';           //que ahora se ingresen datos
  IngresaFecha(f,mensaje);
  fecha_desde:=f;
  mensaje:='Ingrese fecha final (DD/MM/AAAA): ';
  IngresaFecha(f,mensaje);
  fecha_hasta:=f;
end;

Procedure InfraccionesEntreFechas(l:T_lista; p: T_punt_F;var fecha_desde,fecha_hasta:string);
var inf:T_Dato_Infraccion;
    Y:byte;
begin

  If fecha_desde=#0 then                                     //si no se ingresaron datos en el anterior procedimiento de conductor, significa que esto
  begin                                                      //es listado general entre fechas, debe detectar que no haya datos ingresados y permitir
  IntervaloFechas(fecha_desde,fecha_hasta);
  clrscr;
  Titulos_List_Inf;
  writeln;
  y:=3;
  while p<>nil do
  begin
        RecorrePorFecha(p,fecha_desde,fecha_hasta,Inf,Y);
  end;
readkey;
end;
end;

Procedure RecorrePorFecha(var p: T_punt_F;var fecha_desde,fecha_hasta:string;var inf: T_Dato_Infraccion; var Y: byte);
begin
  if  (p^.info.Fecha < fecha_desde) then
  begin
       p := p^.sig
  end
  else
  if  (p^.info.Fecha >= fecha_desde) and (p^.info.Fecha <= fecha_hasta)then
  begin
        Inf:=p^.info;
        Mostrar_Inf_planilla(Inf,Y);
        Inc(Y);
        p := p^.sig;
    end;
end;
procedure Titulos_List_Inf;
begin
     clrscr;
     textcolor(black);
  gotoxy(1,1);  Write('ID');
  gotoxy(22,1); Write('DNI');
  gotoxy(37,1); Write('FECHA');
  gotoxy(52,1); Write('TIPO DE INFRACCION');
  gotoxy(75,1); Write('DESCUENTO');
  gotoxy(92,1); Write('APELADA');
end;

procedure muestraFecha(inf:T_Dato_Infraccion);
var
  anio:string[4];
  mes,dia:string[2];

begin
     anio:=copy(inf.fecha,1,4);
     mes:=copy(inf.fecha,5,6);
     dia:=copy(inf.fecha,7,8);
     writeln(dia,'/',mes,'/',anio);
end;

procedure Mostrar_Inf_planilla(var inf: T_Dato_Infraccion; Y: byte);
begin
      gotoxy(1, y);  write(inf.ID);
      gotoxy(19, y); write(inf.DNI);
      gotoxy(36, y); muestraFecha(inf);
      gotoxy(62, y); write(inf.Tipo);
      gotoxy(79, y); write(inf.Descontar);
      gotoxy(96, y); write(inf.Apelada);
end;
Procedure IngresaFecha(var f: string;mensaje:string);
var d,m,a,comp:string;
  sd,sm,sa:word;
  opx,opy:byte;
begin
  comp:='1';
  f:='0';
  DecodeDate(Date,sa,sm,sd);
  repeat
     if (StrToInt(f))>(StrToInt(comp)) then
     begin
          clrscr;
          Writeln('Ingrese la fecha actual o una pasada.');
          readkey;
          clrscr;
     end;
     write(mensaje);
     opx:=whereX; opy:=whereY;
           repeat
                 gotoxy(opx,opy); clreol; opx:=whereX; opy:=whereY; readln(d);
           until EsFecha(d,2,1,31);
           gotoxy(opx+2,opy); Write('/');
           opx:=whereX; opy:=whereY;
           repeat
                 gotoxy(opx,opy); clreol; opy:=whereY; opx:=whereX;  readln(m);
           until EsFecha(m,2,1,12);
           gotoxy(opx+2,opy); opx:=whereX;  Write('/');
           opx:=whereX; opy:=whereY;
           repeat
                 gotoxy(opx,opy); clreol;opy:=whereY; opx:=whereX; readln(a);
           until EsFecha(a,4,1900,sa);
     f:= a+m+d;
     comp:=ComparadorFecha(sa,sm,sd);
     until (StrToInt(f))<=(StrToInt(comp));
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
Function EsFecha(x:string;long,min,max:integer):boolean;
begin
if (Length(x) = long) and EsNumero(x) and (StrToInt(x) >= min) and (StrToInt(x) <= max) then
EsFecha:=true
else EsFecha:=false;
end;
procedure FechaActual(var fecha: string);
var
   year, mont, mday, wday: word;
   a, m, d: string;
begin
     getdate(year, mont, mday, wday);

     Str(year, a);

     Str(mont, m);
     if mont < 10 then m := '0' + m;

     Str(mday, d);
     if mday < 10 then d := '0' + d;

     fecha := a + m + d;
end;

function edadactual(fechaNac: string): integer;
var
  year, month, day, wday: word;
  anac, mnac, dnac, edad: integer;
begin
  // Obtengo la fecha actual
  getdate(year, month, day, wday);

  // Extraigo año, mes y día de la fecha de nacimiento
  anac := StrToInt(copy(fechaNac, 1, 4));
  mnac := StrToInt(copy(fechaNac, 5, 2));
  dnac := StrToInt(copy(fechaNac, 7, 2));

  // Calculo la edad
  edad := year - anac;
  if (month < mnac) or ((month = mnac) and (day < dnac)) then
    dec(edad);

  edadactual := edad;
end;

end.
