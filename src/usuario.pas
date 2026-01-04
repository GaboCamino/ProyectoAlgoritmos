unit Usuario;
{$codepage utf8}
interface

uses
    crt,Maneja_arboles,Arboles,Conductores,infracciones;

procedure Titulos_List_Cond;
procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
procedure conductores_hab(var arch_c: T_Archivo_C; var raiz: t_punt;var x:t_dato_conductor);
procedure conductores_inhab(var arch_c: T_Archivo_C; var raiz: t_punt;var x:t_dato_conductor);
procedure Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure registrarinf(var x: t_dato_conductor);
procedure asignarDescuento(var inf: t_dato_infraccion);
procedure conductores_Scoring(var arch_c:T_Archivo_C);

implementation

procedure Titulos_List_Cond;           {títulos arriba de todo en la pantalla}
begin
  clrscr;
  textcolor(black);
  gotoxy(1,1); Write('APELLIDO Y NOMBRE');
  gotoxy(30,1); Write('DNI');
  gotoxy(45,1); Write('SCORING');
  gotoxy(65,1); Write('HABILITADO');
  gotoxy(85,1); Write('CANT. REINC.');
  gotoxy(105,1); write('TELEFONO');
  textcolor(15);
end;

procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);
begin
     gotoxy(1,Y); write(x.Apynom);
     gotoxy(30,Y); write(x.DNI);
     gotoxy(48,Y); Write(x.score);
     gotoxy(70,Y); Write(x.Hab);
     gotoxy(90,Y); Write(x.Reincidencias);
     gotoxy(105,Y); write(x.Tel);
end;

procedure conductores_hab(var arch_c: T_Archivo_C; var raiz: t_punt;var x:t_dato_conductor);
var
   y:byte;
begin
  y:=2;
  Titulos_List_Cond;
  seek(arch_c,0);
  Inorden_Listado_Apynom(arch_c,raiz,y);    //no filtra con el x.hab='S'
  while not eof(arch_c) do
  begin
       read(arch_c,x);
  end;
  readkey;
end;

procedure conductores_inhab(var arch_c: T_Archivo_C; var raiz: t_punt;var x:t_dato_conductor);
var
   y:byte;
begin
  y:=2;
  Titulos_List_Cond;
  seek(arch_c,0);
  Inorden_Listado_Apynom(arch_c,raiz,y);         //no filtra con el x.hab='N'
  while not eof(arch_c) do
  begin
       read(arch_c,x);
       end;
readkey;
end;

procedure Inorden_Listado_apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
begin
  if raiz <> nil then
  begin
    inorden_listado_apynom(arch_c,raiz^.sai,Y);
    muestra_cond_apynom(arch_c,raiz,Y);                //recursividad aplicada
    inorden_listado_apynom(arch_c,raiz^.sad,Y);
  end;
end;


procedure Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);
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


procedure conductores_Scoring(var arch_c:T_Archivo_C);
var
   y:byte;
    x:T_Dato_Conductor;
begin
     y:=2;
     Titulos_List_Cond;;
     while not eof(arch_c) do
     begin
          read(arch_c,x);
          if x.Score=0 then
          Mostrar_Cond_planilla(x,y);
     end;
     readkey;
end;


procedure asignarDescuento(var inf: t_dato_infraccion);
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
    Inf.Descontar := 1;
  end;

end;

procedure registrarinf(var x: t_dato_conductor);
var
  Inf: t_dato_infraccion;
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
  write('Ingrese el número de infracción: ');
  readln(Inf.Tipo);

  AsignarDescuento(Inf);

  x.Score := x.Score - Inf.Descontar;

  writeln;
  writeln('infraccion penalizada por : ', inf.descontar, ' puntos.');
  writeln('Score actual: ', x.Score);


  if x.Score < 1 then
    x.hab :='N'
  else
    x.hab := 'S';

  writeln('Estado del conductor: ');
  if x.hab='S' then
  begin
       writeln('→ HABILITADO')
  end else
      writeln('→ INHABILITADO');
end;


end.
