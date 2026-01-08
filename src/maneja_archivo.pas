unit maneja_archivo;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,Conductores,Infracciones,usuario;

{ambc}
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);
procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);
procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);
procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:char);
Procedure ABMC (var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);
procedure asignarDescuento(var inf: t_dato_infraccion);
procedure registrarinf(var x: t_dato_conductor; var Inf: t_dato_infraccion);
procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint);
procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt);

implementation
{
function validarDni(x:T_Dato_Conductor):boolean;
begin
     if x.dni in [1..9] then
     begin
          validarDni:=true;
     end else
         validarDni:=false;
end;
}
procedure Ingresa_Cond(var x: T_Dato_Conductor;  buscado: shortstring);
var
   fecha:String[10];
begin
     gotoxy(30,4); write('DNI: ', buscado);
     x.dni:=buscado;
     gotoxy(30,6); write('Apellido y nombre: '); readln(x.apynom);
     gotoxy(30,8); write('Fecha de nacimiento (DD/MM/AAAA): '); readln(x.nacim);
     gotoxy(30,10); write('Telefono: '); readln(x.tel);
     gotoxy(30,12); write('Email: '); readln(x.mail);

     x.Score:= 20;
     x.Hab:= 'S';
 //  x.fecha_hab:=fecha;
     x.Reincidencias:= 0;

end;
procedure Alta_Cond(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt; buscado: shortstring);
var
   x: T_Dato_Conductor;
   x1: t_dato_arbol;
   conf: char;
begin
     ingresa_cond(x,buscado);
     x1.pos:= filesize(Arch_C);
     seek(arch_c,x1.pos);
     write(arch_c,x);
     x1.clave:= x.dni;
     agregar(arbol_dni,x1);
     x1.clave:= x.apynom;
     agregar(arbol_apynom,x1);
     writeln('¡Alta registrada!');

delay(1000);
end;
procedure Baja_Cond(var Arch_C: T_Archivo_C; pos: longint;var x: T_Dato_Conductor;var arbol_dni,arbol_apynom: t_punt);
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
          x.Reincidencias:= x.Reincidencias + 1;
          seek(arch_c,pos);
          write(Arch_C,x);
          writeln('¡Baja registrada!');
     end;
delay(1000);
clrscr;
end;
procedure Consulta_Cond(var Arch_C: T_Archivo_C; pos: longint; var arbol_dni,arbol_apynom: t_punt);
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
procedure Modifica_Cond(var Arch_C: T_Archivo_C; pos: longint;var arbol_dni,arbol_apynom: t_punt);
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
      gotoxy(1,18); Writeln('0. Regresar');
      gotoxy(1,20); write('Que desea modificar? '); readln(op);
      if op in ['1'..'4'] then
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

procedure Actualizar_Cond(var x: t_dato_conductor; var arch_c:t_archivo_c; pos: longint;var arbol_dni,arbol_apynom: t_punt;op:char);
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
     end;
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
    Inf.Descontar := 0;
  end;

end;

procedure registrarinf(var x: t_dato_conductor; var Inf: t_dato_infraccion);
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


  if x.Score <= 0 then
    x.hab :='N'
  else
    x.hab := 'S';

  writeln('Estado del conductor: ');
  if x.hab='S' then
  begin
       writeln(' Conductor Habilitado')
  end else
      writeln('Conductor Inhabilitado');
end;
procedure Alta_Infraccion(var Arch_C: T_Archivo_C; var Arch_I : T_Archivo_I; pos: longint);
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

  write('Ingrese fecha (DD/MM/AAAA): ');
  readln(inf.Fecha);

  seek(Arch_C, pos);
  write(Arch_C, x);

  seek(Arch_I, filesize(Arch_I));
  write(Arch_I, inf);

  writeln;
  writeln('Infracción registrada correctamente');

  delay(1500);
  clrscr;
end;

procedure AMC (var Arch_C: T_Archivo_C;var Arch_I: T_Archivo_I;var arbol_dni,arbol_apynom: t_punt);
var
   buscado:string[50];
   pos:longint;
   op:byte;
begin
     pos:=0;
     Write('Búsqueda por DNI del conductor: '); Readln(Buscado); clrscr;
     Busqueda(arbol_dni, buscado, pos);
     if pos=-1 then                                                           {siempre distinto de -1}
     begin
       writeln('conductor no encontrado');

         end
             else
             begin
         Consulta_Cond(Arch_C,pos,arbol_dni,arbol_apynom); writeln();

          writeln('1: Agregar infraccion');
          writeln('2: Modificar infraccion');
          writeln('3: Consultar infracciones');
          writeln('0: volver');
          readln(op);
          case op of
              1: begin
                  clrscr;
                  Alta_Infraccion(Arch_C, Arch_I, pos);
                  clrscr;
                 end;
           { 2:
            3:}
          end;
             end;

end;


end.



