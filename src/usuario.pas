unit Usuario;
{$codepage utf8}
interface

uses
    crt,Maneja_arboles,Arboles,Conductores;

procedure mostrar_cond (var arch_c:t_archivo_C;raiz:t_punt);
procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor);


{
procedure Mostrar_Cond_Score(var Arch_C: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure Inorden_planilla_Score(var arch_C: T_Archivo_C; var raiz: t_punt; var i: byte);
procedure planilla_Cond_Score(var arch_C: T_Archivo_C; arbol: t_punt); }

procedure Listado_Cond_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt);
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
procedure Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure Muestra_Cond_List(var Y: byte; x: T_Dato_Conductor);
procedure Titulos_List_Cond;
implementation


procedure mostrar_cond (var arch_c:t_archivo_C;raiz:t_punt);
var
   pos:cardinal;
   x:T_Dato_Conductor;
   y:byte;
begin
     pos:= raiz^.info.pos;
     seek(Arch_C,pos);
     read(Arch_C,x);
          if x.estado then
             Mostrar_Cond_planilla(x);

end;

procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor);
var
   y:byte;
begin
     gotoxy(30,5); write(x.Apynom);
     gotoxy(48,7); write(x.DNI);
     gotoxy(65,9); Write(x.score);
     gotoxy(81,11); Write(x.Hab);
     gotoxy(99,13); Write(x.Reincidencias);
     gotoxy(110,15); write(x.Tel) ;
     inc(Y);
  if Y = 29 then
  begin
       Y:= 1;
       gotoxy(50,30); writeln('Para ver mas presione cualquier tecla...'); readkey;
    clrscr;
  end;
end;{

procedure Mostrar_Cond_Score(var Arch_C: T_Archivo_C; raiz: t_punt; var Y: byte);
var
   pos: cardinal;
   x: T_Dato_Conductor;
begin
     pos:= raiz^.info.pos;
     seek(Arch_C,pos);
     read(Arch_C,x);
  if x.score = 0 then
  begin
       Mostrar_Cond_planilla(x);
  end;
end;

procedure Inorden_planilla_Score(var arch_C: T_Archivo_C; var raiz: t_punt; var i: byte);
begin
  if raiz <> nil then
  begin
    inorden_planilla_score(arch_c,raiz^.sai,i);
    mostrar_cond_score(arch_c,raiz,i);
    inorden_planilla_score(arch_c,raiz^.sad,i);
  end;
end;

procedure planilla_Cond_Score(var arch_C: T_Archivo_C; arbol: t_punt);
var
   i: byte;
begin
     i:= 2;
     Titulos_Cond;
     Inorden_planilla_Score(arch_c,arbol,i);
writeln('PRESIONE UNA TECLA PARA VOLVER AL MENU');
end;
               }
procedure Listado_Cond_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt);  {procedure principal de listado}
var Y: byte;
begin
  Y:= 2;
    Titulos_List_Cond;
  Inorden_Listado_Apynom(arch_c,raiz,Y);
  writeln('PRESIONE UNA TECLA PARA VOLVER AL MENU');
  readkey;
end;
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
begin
  if raiz <> nil then
  begin
    inorden_listado_apynom(arch_c,raiz^.sai,Y);
    muestra_cond_apynom(arch_c,raiz,Y);
    inorden_listado_apynom(arch_c,raiz^.sad,Y);
  end;
end;
procedure Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte); { #note : abre y cierra COND } { #note : TRUE = conductores dados de alta, FALSE = conductores dados de baja }
var pos: cardinal; x: T_Dato_Conductor;
begin
  pos:= raiz^.info.pos;
  seek(arch_c,pos);
  read(arch_c,x);
    if x.estado then
      Muestra_Cond_List(Y,x);
      inc(Y);
       if (Y=29)and((raiz^.sai<>nil)or(raiz^.sad<>nil)) then
          begin
            Y:= 2;
            gotoxy(5,30); writeln('PRESIONE UNA TECLA PARA VER MAS');
            readkey;
            clrscr;
          end;
end;
procedure Muestra_Cond_List(var Y: byte; x: T_Dato_Conductor);
begin
  gotoxy(5,Y);
  write(x.apynom);
  gotoxy(48,Y);
  write(x.dni);
  gotoxy(65,Y);
  Write(x.score);
  gotoxy(81,Y);
  Write(x.hab);
  gotoxy(99,Y);
  Write(x.reincidencias);
  gotoxy(110,Y);
  write(x.Tel) ;
end;
procedure Titulos_List_Cond;           {títulos arriba de todo en la pantalla}
begin
  clrscr;
  textcolor(1);
  gotoxy(12,1);
  Write('APELLIDO Y NOMBRE');
  gotoxy(50,1);
  Write('DNI');
  gotoxy(62,1);
  Write('SCORING');
  gotoxy(77,1);
  Write('HABILITADO');
  gotoxy(94,1);
  Write('CANT. REINC.');
  gotoxy(110,1);
  write('TELEFONO');
  textcolor(15);
end;
end.
