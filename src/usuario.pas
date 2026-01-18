unit Usuario;
{$codepage utf8}
interface

uses
    crt,Arboles,Conductores,Lista_fecha,Infracciones,Sysutils;

procedure Titulos_List_Cond;
procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
procedure conductores_hab(var arch_c: T_Archivo_C);
procedure conductores_inhab(var arch_c: T_Archivo_C);
procedure  Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure conductores_Scoring(var arch_c:T_Archivo_C);
Procedure InfraccionesDeConductor(l:T_lista;p: T_punt_F; var fecha_desde,fecha_hasta:string);
Procedure InfraccionesEntreFechas(l:T_lista; p: T_punt_F;var fecha_desde,fecha_hasta:string);
procedure Titulos_List_Inf;
procedure Mostrar_Inf_planilla(var inf: T_Dato_Infraccion; Y: byte);
Procedure IngresaFecha(var f: string);
function EsNumero(s: string): boolean;
function ComparadorFecha(sa,sm,sd:word):string;
implementation

procedure Titulos_List_Cond;           {títulos arriba de todo en la pantalla}
begin
  clrscr;
  textcolor(black);
  gotoxy(1,1); Write('APELLIDO Y NOMBRE');
  gotoxy(33,1); Write('DNI');
  gotoxy(45,1); Write('SCORING');
  gotoxy(65,1); Write('HABILITADO');
  gotoxy(85,1); Write('CANT. REINC.');
  gotoxy(105,1); write('TELEFONO');
  textcolor(15);
end;

procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);   {planilla por filas}
begin
     gotoxy(1,Y); write(x.Apynom);
     gotoxy(30,Y); write(x.DNI);
     gotoxy(48,Y);  gotoxy(48,Y); if x.score <= 0 then
     begin
          x.score:=0;
          write(x.score);
          end
        else
          Write(x.score);
     gotoxy(70,Y); Write(x.Hab);
     gotoxy(90,Y); Write(x.Reincidencias);
     gotoxy(105,Y); write(x.Tel);
end;

procedure conductores_hab(var arch_c: T_Archivo_C);       {evalúa si un conductor se halla habilitado}
var
  x: T_Dato_Conductor;
  y: byte;
begin
  y := 2;
  Titulos_List_Cond;
  seek(arch_c, 0);

  while not eof(arch_c) do
  begin
    read(arch_c, x);
    if x.Hab = 'S' then
    begin
      Mostrar_Cond_planilla(x, y);
      inc(y);
    end;
  end;

  readkey;
end;


procedure conductores_inhab(var arch_c: T_Archivo_C);      {evalúa si un conductor se halla inhabilitado}
var
  x: T_Dato_Conductor;
  y: byte;
begin
  y := 2;
  Titulos_List_Cond;
  seek(arch_c, 0);

  while not eof(arch_c) do
  begin
    read(arch_c, x);
    if x.Hab = 'N' then
    begin
      Mostrar_Cond_planilla(x, y);
      inc(y);
    end;
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
Procedure InfraccionesDeConductor(l:T_lista;p: T_punt_F; var fecha_desde,fecha_hasta:string);    //evalua si es el conductor buscado, falta hacer busqueda por nombre
var conductor:string[8];                                                             //relacionando DNI en Arch_C con DNI en Arch_I
    f:string;
    begin
      p:=l.cab;
      conductor:=#0;
      Writeln('Ingrese fecha inicial: ');
      IngresaFecha(f);
      fecha_desde:=f;
      Writeln('Ingrese fecha final: ');
      IngresaFecha(f);
      fecha_hasta:=f;
      Writeln('Ingrese DNI del conductor: '); Readln(conductor);
      while (p <> nil) and (p^.info.DNI <> conductor) do
        p := p^.sig;
      while (p <> nil) and (p^.info.DNI = conductor) do
    begin
        InfraccionesEntreFechas(l,p,fecha_desde,fecha_hasta);                                                     //pasa a evaluar si pertenece al rango de fechas
    end;
    end;

Procedure InfraccionesEntreFechas(l:T_lista; p: T_punt_F;var fecha_desde,fecha_hasta:string);
var inf:T_Dato_Infraccion;
    Y:byte;
    f:string;
begin
  If fecha_desde<>#0 then                 //si no se ingresaron datos en el anterior procedimiento de conductor, significa que esto
  begin                                      //es listado general entre fechas, debe detectar que no haya datos ingresados y permitir
  Writeln('Ingrese fecha inicial: ');        //que ahora se ingresen datos
  IngresaFecha(f);
  fecha_desde:=f;
  Writeln('Ingrese fecha final: ');
  IngresaFecha(f);
  fecha_hasta:=f;
  end;
  clrscr;
  Titulos_List_Inf;
  while (p <> nil) and (p^.info.Fecha < fecha_desde) do
        p := p^.sig;
  while (p <> nil) and (p^.info.Fecha <= fecha_hasta) do
    begin
        Recuperar(l,Inf);
        Mostrar_Inf_planilla(Inf,Y);
        Inc(Y);
        p := p^.sig;
    end;
end;
procedure Titulos_List_Inf;
begin
     clrscr;
     textcolor(black);
     gotoxy(1,1); Write('DNI');
     gotoxy(22,1); Write('FECHA');
     gotoxy(37,1); Write('INFRACCION');
     gotoxy(52,1); Write('DESCUENTO');
     gotoxy(57,1); Write('APELADA');
     textcolor(15);
end;
procedure Mostrar_Inf_planilla(var inf: T_Dato_Infraccion; Y: byte);
begin
      gotoxy(1, y);  write(inf.DNI);
      gotoxy(19, y); write(inf.Fecha);
      gotoxy(39, y); write(inf.Tipo);
      gotoxy(56, y); write(inf.Descontar);
      gotoxy(60, y); write(inf.Apelada);
end;
Procedure IngresaFecha(var f: string);
var d,m,a,comp:string;
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
