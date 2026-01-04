unit menues;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,conductores,maneja_archivo, usuario;

procedure Menu;
procedure Submenu_Listados(var arch_c:T_Archivo_C; var arbol_apynom:t_punt);

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
      gotoxy(30,10);writeln('4. Listados conductores/infracciones');
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
                    Submenu_Listados(arch_c,arbol_apynom); clrscr;
                    //listado fecha infracciones
                    //por período
                    //por período de un conductor

           end;
           '5':begin
                    //estadisticas
           end;

      end;
until op='0';
close(arch_c);
end;

procedure Submenu_Listados(var arch_c:t_archivo_c; var arbol_apynom:t_punt);
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
         list_cond_hab(arch_c,arbol_apynom,x); clrscr;
end;
'2':begin
         list_cond_inhab(arch_c,arbol_apynom,x); clrscr;
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


end.
