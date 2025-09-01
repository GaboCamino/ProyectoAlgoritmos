unit Usuario;
{$codepage utf8}
interface

uses
    crt,Maneja_arboles,Arboles,Conductores;


procedure Titulos_List_Cond;
procedure mostrar_cond (var arch_c:t_archivo_C;raiz:t_punt; pos:cardinal);
procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor);


{
procedure Mostrar_Cond_Score(var Arch_C: T_Archivo_C; raiz: t_punt; var Y: byte);
procedure Inorden_planilla_Score(var arch_C: T_Archivo_C; var raiz: t_punt; var i: byte);
procedure planilla_Cond_Score(var arch_C: T_Archivo_C; arbol: t_punt); }

procedure Listado_Cond_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt);
procedure Inorden_Listado_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt; var Y: byte);
procedure Muestra_Cond_Apynom(var arch_c: T_Archivo_C; raiz: t_punt; var Y: byte);

implementation

procedure mostrar_cond (var arch_c:t_archivo_C;raiz:t_punt; pos:cardinal);
var
   x:T_Dato_Conductor;
begin
     pos:= raiz^.info.pos;
     seek(Arch_C,pos);
     read(Arch_C,x);
     begin
           if x.estado then
           begin
                Mostrar_Cond_planilla(x);
                readkey;
           end;
     end;
end;
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

procedure Mostrar_Cond_planilla(var x: T_Dato_Conductor);
var
   x1,y:byte;
begin
     Titulos_List_Cond;
     begin
     gotoxy(1,3); write(x.Apynom);
     gotoxy(30,3); write(x.DNI);
     gotoxy(48,3); Write(x.score);
     gotoxy(70,3); Write(x.Hab);
     gotoxy(90,3); Write(x.Reincidencias);
     gotoxy(105,3); write(x.Tel);
     inc(Y);
     if(x1=105) then
     begin
          x1:=1;
          if Y = 29 then
          begin
          Y:= 1;
          gotoxy(50,30); writeln('Para ver mas presione cualquier tecla...'); readkey;
          clrscr;
  end;
     end;

end;
end;

procedure Listado_Cond_Apynom(var arch_c: T_Archivo_C; var raiz: t_punt);  {procedure principal de listado}
var Y: byte;
begin
     y:= 2;
     Inorden_Listado_Apynom(arch_c,raiz,Y);
     gotoxy(30,15);writeln('PRESIONE UNA TECLA PARA VOLVER AL MENU'); readkey;
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
     begin
          Mostrar_Cond_planilla(x);
          inc(Y);
          if (Y=29)and((raiz^.sai<>nil)or(raiz^.sad<>nil)) then
          begin
               Y:= 2;
               gotoxy(5,30); writeln('PRESIONE UNA TECLA PARA VER MAS');
               readkey; clrscr;
          end;
     end;
end;


{
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

end.
