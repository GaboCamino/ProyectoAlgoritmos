unit maneja_archivo;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,Conductores,Infracciones,usuario;

{ambc}
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);
procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);
procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);
procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:byte);
Procedure ABMC (var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);

implementation


procedure Ingresa_Cond(var x: T_Dato_Conductor;  buscado: shortstring);
var
   fecha:String;
begin
     gotoxy(30,4); write('DNI: ', buscado);
     x.dni:=buscado;
     gotoxy(30,6); write('Apellido y nombre: '); readln(x.apynom);
     gotoxy(30,8); write('Fecha de nacimiento (DD/MM/AAAA): '); readln(x.nacim);
     gotoxy(30,10); write('Telefono: '); readln(x.tel);
     gotoxy(30,12); write('Email: '); readln(x.mail);

     x.Score:= 20;
     x.Hab:= 'S';
 //    x.fecha_hab:=fecha;
     x.Reincidencias:= 0;
     x.estado:= true;
end;

procedure Alta_Cond(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt; buscado: shortstring);
var
   x: T_Dato_Conductor;
   x1: t_dato_arbol;
   conf: char;
begin
     ingresa_cond(x,buscado);
     write('Confirmar Alta? S/N: '); readln(conf); clrscr;
     if conf='s' then
     begin
          x1.pos:= filesize(Arch_C);
          seek(arch_c,filesize(Arch_C));
          write(arch_c,x);
          x1.clave:= x.dni;
          agregar(arbol_dni,x1);
          x1.clave:= x.apynom;
          agregar(arbol_apynom,x1);
     end;
writeln('¡Alta registrada!'); readkey;
end;


procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);
var
   conf: char;
begin
     Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom);
while not(eof(arch_c)) do
begin
     write('Confirmar baja? S/N: '); readln(conf);
     if conf='S' then
     begin
          x.estado:= false;
          x.Hab:='N';
          write(Arch_C,x);
     end;
end;
writeln('¡Baja registrada!'); readkey;
end;

procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);
var
  x: T_Dato_Conductor;
begin
  if (pos >= 0) and (pos < FileSize(Arch_C)) then
  begin
    seek(Arch_C, pos);
    read(Arch_C, x);
    Mostrar_Cond_planilla(x);  // mostrar un solo registro
  end
  else
    writeln('Posición inválida o no encontrada');
end;


procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);
var
   x: T_Dato_Conductor;
   conf: char;
   op:byte;
begin
conf:=#0;
Writeln('se encontró'); readkey;
Repeat

      Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom); writeln();
      gotoxy(30,10); writeln('1. Fecha de nacimiento (DD/MM/AAAA)');
      gotoxy(30,12); writeln('2. Telefóno');
      gotoxy(30,14); writeln('3. Dirección de mail');
      gotoxy(30,16); writeln('4. Dar de baja');
      gotoxy(30,18); Writeln('5. Regresar');
      gotoxy(30,20); write('Que desea modificar?: '); readln(op); clrscr;
      seek(arch_c,0);

      read(Arch_C,x);
      Actualizar_cond(x,arch_c,pos,arbol_dni,arbol_apynom,op);
      writeln('Confirmar modificación? S/N: '); readln(conf);
      if upcase(conf)='S' then
      writeln('Modificación registrada'); readkey;
      begin
           seek(Arch_c, Filesize(Arch_C)-1);
           write(Arch_C,x);
      end;
until op=5;
end;
   //hola manola
procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:byte);
begin
     case op of
          1:begin
                 gotoxy(30,10); write('Fecha de nacimiento (DD/MM/AAAA): '); readln(x.Nacim);
          end;
          2:begin
                 gotoxy(30,12); write('Telefono: '); readln(x.tel);
          end;
          3:begin
                 gotoxy(30,14); write('Email: '); readln(x.mail);
          end;
          4:begin
                 Baja_Cond(Arch_C, pos,x,arbol_dni,arbol_apynom);
          end;
     end;
      Mostrar_Cond(arch_c,arbol_dni);
end;


Procedure ABMC (var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);
var
   buscado:string[50];
   pos:longint;
begin
     pos:=0;
     Write('Búsqueda por DNI del conductor: '); Readln(Buscado); clrscr;
     Busqueda(arbol_dni, buscado, pos);
     if pos=-1 then                                                           {siempre distinto de -1}
     begin
          Alta_Cond(Arch_C,arbol_dni,arbol_apynom, buscado)
     end else
         begin
              Modifica_Cond(Arch_C, pos,arbol_dni,arbol_apynom)
         end;
end;

end.



