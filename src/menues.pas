unit menues;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,conductores,maneja_archivo,usuario,infracciones,Lista_fecha;

procedure Menu;
procedure Submenu_Listados(var arch_c:t_archivo_c; var arbol_apynom:t_punt;l:T_lista);
procedure submenu_estadisticas(var arch_i:T_Archivo_I;var arch_c:t_archivo_c;var l:T_lista);

implementation

procedure Menu;       {menú principal del programa}
var
   op:char;
   Arch_C: T_Archivo_C;      {archivos}
   arbol_dni,arbol_apynom: t_punt;
   Arch_I: T_Archivo_I;
   l:T_lista;
begin
     Abrircond(arch_c);
     Abririnf(Arch_I);
     textbackground(LightGray); TextColor(black); clrscr;
     Crear_Arboles(Arch_C, Arbol_DNI,arbol_Apynom);
     Crear_Lista_Fecha(l,Arch_I);
Repeat

      gotoxy(30,4);writeln('1. ABMC Conductores');
      gotoxy(30,6);writeln('2. AMC Infracciones');
      gotoxy(30,8);writeln('3. Listados conductores/infracciones');
      gotoxy(30,10); writeln('4. Estadísticas');
      gotoxy(30,12);writeln('0. Salir');
      gotoxy(30,14); write('Opción: ');
      gotoxy(38,14); readln(op); clrscr;

      case op of
           '1':begin
                  ABMC(Arch_c,arbol_dni,arbol_apynom); clrscr;
           end;
           '2':begin
                  AMC (Arch_C, Arch_I,arbol_dni,arbol_apynom,l); clrscr;
           end;
           '3':begin
                  Submenu_Listados(arch_c,arbol_apynom,l); clrscr;
           end;
           '4':begin
                    submenu_estadisticas(arch_i,arch_c,l);
           end;
      end;
until op='0';
close(arch_c);
close(arch_i);
end;

procedure Submenu_Listados(var arch_c:t_archivo_c; var arbol_apynom:t_punt;l:T_lista); {submenú de los listados de un conductores-infracción}
var
   p:T_punt_F;
   op:char;
   fecha_desde,fecha_hasta:string;
begin

     fecha_desde:=#0;                                  //necesito la variable antes para poder detectar si ya se habían ingresado datos en el primer procedimiento
     fecha_hasta:=#0;
Repeat
    p:=l.cab;
    gotoxy(30,4); Writeln('1. Listado ordenado por apellido y nombre');
      gotoxy(30,6); Writeln('2. Infracciones entre 2 fechas');
      gotoxy(30,8); Writeln('3. Infracciones de un conductor entre 2 fechas');
      gotoxy(30,10); Writeln('4. Conductores con 0 scoring');
      gotoxy(30,12); Writeln('0. Regresar');
      gotoxy(30,14); Write('Opción: '); readln(op); clrscr;
case op of
'1':begin
            textcolor(black);
           ListarConductores(arbol_apynom, arch_c);
           clrscr;
end;
'2':begin
          InfraccionesEntreFechas(l,p,fecha_desde,fecha_hasta); clrscr;
         //infracciones entre 2 fechas
end;
'3':begin
          InfraccionesDeConductor(l,p,fecha_desde,fecha_hasta); clrscr;
         //infracciones conductor 2 fechas
end;
'4':begin
          conductores_Scoring(arch_c); clrscr;
end;
end;
until op='0';
end;

procedure submenu_estadisticas(var arch_i:T_Archivo_I;var arch_c:t_archivo_c;var l:T_lista);   {submenú de las estadísticas de un conductor respecto a las infracciones otorgadas}
var
   op:char;
   x:T_Dato_Conductor;
begin
Repeat
     gotoxy(30,4); writeln('1. Infracciones entre fechas');
     gotoxy(30,6); writeln('2. Porcentaje de conductores con reincidencia');
     gotoxy(30,8); writeln('3. Porcentaje de conductores con scoring 0');
     gotoxy(30,10); writeln('4. Porcentaje de apelaciones'); // elegir entre los 3 una estadistica a implementar para el municipio
     gotoxy(30,12); writeln('5. Rango etario con más infracciones');
     gotoxy(30,14); writeln('0. Regresar');
     gotoxy(30,16); write('Opción: '); readln(op); clrscr;
     case op of
     '1':begin
              //infracciones entre 2 fechas
              EstadisticaFechas(l);readkey;clrscr;
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
              //porcentaje de infracciones apeladas
              writeln('Porcentaje de infracciones apeladas: ', porcentaje_infapeladas(Arch_I):0:2, '%'); readkey; clrscr;

     end;
     '5':begin
              //rango etario con mas infracciones
              rangoEtario(arch_c,arch_i); readkey; clrscr;
     end;
     end;
until op='0';
end;

end.
