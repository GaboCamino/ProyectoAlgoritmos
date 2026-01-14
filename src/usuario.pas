unit Usuario;
{$codepage utf8}
interface

uses
    crt,Maneja_arboles,Arboles,Conductores,infracciones;

procedure Titulos_List_Cond;
procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
procedure conductores_hab(var arch_c: T_Archivo_C);
procedure conductores_inhab(var arch_c: T_Archivo_C);
procedure  Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure conductores_Scoring(var arch_c:T_Archivo_C);


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

procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor; Y: byte);
begin
     gotoxy(1,Y); write(x.Apynom);
     gotoxy(30,Y); write(x.DNI);
     gotoxy(48,Y); Write(x.score);
     gotoxy(70,Y); Write(x.Hab);
     gotoxy(90,Y); Write(x.Reincidencias);
     gotoxy(105,Y); write(x.Tel);
end;

procedure conductores_hab(var arch_c: T_Archivo_C);
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


procedure conductores_inhab(var arch_c: T_Archivo_C);
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
          inc(y);
     end;
     readkey;
end;





end.
