unit menues;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,conductores,maneja_archivo, usuario, infracciones;

procedure Menu;
procedure Submenu_Listados(var arch_c:T_Archivo_C; var arbol_apynom:t_punt);
procedure submenu_estadisticas(var arch_i:T_Archivo_I;var arch_c:t_archivo_c);

implementation

procedure Menu;       {menú principal del programa}
var
   op:char;
   Arch_C: T_Archivo_C;      {archivos}
   arbol_dni,arbol_apynom: t_punt;
   Arch_I: T_Archivo_I;
begin
     Abrircond(arch_c);
     Abririnf(Arch_I);
     Crear_Arbol_DNI(Arch_C, Arbol_DNI);
     Crear_Arbol_Apynom(Arch_C, Arbol_Apynom);

     textbackground(LightGreen); TextColor(White); clrscr;
Repeat
      gotoxy(30,4);writeln('1. ABMC Conductores');
      gotoxy(30,6);writeln('2. AMC Infracciones');
      gotoxy(30,8);writeln('3. Actualización por infracción');
      gotoxy(30,10);writeln('4. Listados conductores/infracciones');
      gotoxy(30,12); writeln('5. Estadísticas');
      gotoxy(30,14);writeln('0. Salir');
      gotoxy(30,16); write('Opción: ');
      gotoxy(38,16); readln(op); clrscr;

      case op of
           '1':begin
                  ABMC(Arch_c,arbol_dni,arbol_apynom); clrscr;
           end;
           '2':begin
                  AMC (Arch_C, Arch_I,arbol_dni,arbol_apynom); clrscr;
           end;
           '3':begin
                  //Actualización por infracción
           end;
           '4':begin
                    Submenu_Listados(arch_c,arbol_apynom); clrscr;
                    //listado fecha infracciones
                    //por período
                    //por período de un conductor

           end;
           '5':begin
                    //estadisticas
                    submenu_estadisticas(arch_i,arch_c);
           end;

      end;
until op='0';
close(arch_c);
end;

procedure Submenu_Listados(var arch_c:t_archivo_c; var arbol_apynom:t_punt); {submenú de los listados de un conductores-infracción}
var
   op:char;
   x:t_dato_conductor;
begin
Repeat
    gotoxy(30,4); Writeln('1. Conductores habilitados');
    gotoxy(30,6); Writeln('2. Conductores inhabilitados');
    gotoxy(30,8); Writeln('3. Infracciones entre 2 fechas');
    gotoxy(30,10); Writeln('4. Infracciones de un conductor entre 2 fechas');
    gotoxy(30,12); Writeln('5. Conductores con 0 scoring');
    gotoxy(30,14); Writeln('0. Regresar');
    gotoxy(30,16); Write('Opción: '); readln(op); clrscr;
case op of
'1':begin
         conductores_hab(arch_c); clrscr;
end;
'2':begin
         conductores_inhab(arch_c); clrscr;
end;
'3':begin
         //infracciones entre 2 fechas
end;
'4':begin
         //infracciones conductor 2 fechas
end;
'5':begin
         conductores_Scoring(arch_c); clrscr;
end;
end;

until op='0';

end;

procedure submenu_estadisticas(var arch_i:T_Archivo_I;var arch_c:t_archivo_c);   {submenú de las estadísticas de un conductor respecto a las infracciones otorgadas}
var
   op:char;
   x:T_Dato_Conductor;
begin

Repeat
     gotoxy(30,4); writeln('1. Infracciones entre fechas');
     gotoxy(30,6); writeln('2. Porcentaje de conductores con reincidencia');
     gotoxy(30,8); writeln('3. Porcentaje de conductores con scoring 0');
     gotoxy(30,10); writeln('4. Total'); // elegir entre los 3 una estadistica a implementar para el municipio
     gotoxy(30,12); writeln('5. Rango etario con más infracciones');
     gotoxy(30,14); writeln('0. Regresar');
     gotoxy(30,16); write('Opción: '); readln(op); clrscr;
     case op of
     '1':begin
              //infracciones entre 2 fechas
     end;
     '2':begin
              //porcentaje de conductores con reincidencia
              writeln('Porcentaje de conductores con reincidencias: ',conductoresPorcentajeReincidencias(arch_c,x):0:2,'%'); readkey; clrscr;
     end;
     '3':begin
              //porcentaje de conductores con scoring 0
              writeln('Porcentaje de Conductores con score 0: ', conductoresScoreCero(arch_c,x):0:2, '%'); readkey; clrscr;
     end;
     '4':begin
              //total
     end;
     '5':begin
              //rango etario con mas infracciones
              rangoEtario(arch_c, x); readkey; clrscr;
     end;
     end;
until op='0';
end;

end.
