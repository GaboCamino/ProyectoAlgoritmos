unit menues;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,conductores,maneja_archivo, usuario;

procedure Menu;
procedure Submenu_Listados;

implementation

procedure Menu;
var
   op:char;
   Arch_C: T_Archivo_C;      {archivos}
   arbol_dni,arbol_apynom: t_punt;
begin
     Abrircond(arch_c);
     Crear_Arbol_DNI(Arch_C, Arbol_DNI);
     Crear_Arbol_Apynom(Arch_C, Arbol_Apynom);

     textbackground(LightGreen); TextColor(White); clrscr;
Repeat
      gotoxy(30,4);writeln('1. ABMC Conductores');
      gotoxy(30,6);writeln('2. AMC Infracciones');
      gotoxy(30,8);writeln('3. Actualización por infracción');
      gotoxy(30,10);writeln('4. Listado de conductores');
      gotoxy(30,12);writeln('0. Salir');
      gotoxy(30,14); write('Opción: ');
      gotoxy(38,14); readln(op); clrscr;

      case op of
           '1':begin
                  ABMC(Arch_c,arbol_dni,arbol_apynom); clrscr;
           end;
           '2':begin
                  //AMC Infracciones
           end;
           '3':begin
                  //Actualización por infracción
           end;
           '4':begin
              Listado_Cond_Apynom(arch_c,arbol_apynom); clrscr;
           end;
      end;
until op='0';
close(arch_c);
end;

procedure Submenu_Listados;
var
   op:char;
begin
Repeat
    gotoxy(30,5); Writeln('1. Conductores');
    gotoxy(25,7); Writeln('2. Conductores inhabilitados');
    gotoxy(25,9); Writeln('3. Infracciones entre 2 fechas');
    gotoxy(20,11); Writeln('4. Infracciones de un conductor entre 2 fechas');
    gotoxy(25,13); Writeln('5. Conductores con 0 scoring');
    gotoxy(35,15); Writeln('0. Regresar');
    gotoxy(35,15); Writeln('Opción: '); readln(op);
until op='0';
end;

end.
