unit menues;
{$codepage utf8}
interface
uses
    crt,Maneja_arboles,arboles,conductores,infracciones,maneja_archivo, usuario;

{titulos}

procedure Menu();
procedure Submenu_Listados(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);

implementation

procedure Menu();
var
   op:byte;
   Arch_C: T_Archivo_C; Arch_I:T_Archivo_I;      {archivos}
   arbol_dni,arbol_apynom: t_punt;
begin
     AbrirCond(arch_c);
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
           1:begin
                  ABMC(Arch_c,arbol_dni,arbol_apynom); clrscr;
           end;
           2:begin

           end;
           3:begin

           end;
          4: begin
             Submenu_Listados(Arch_C,arbol_dni,arbol_apynom);
              end;

           5:begin

           end;
      end;
      clrscr;
until op=0;
close(arch_c);
end;

procedure Submenu_Listados(var Arch_C: T_Archivo_C; var arbol_dni,arbol_apynom: t_punt);
var
   op:byte;
begin

Repeat
    gotoxy(10,5); Writeln('1. Conductores');
    gotoxy(10,7); Writeln('2. Conductores inhabilitados');
    gotoxy(10,9); Writeln('3. Infracciones entre 2 fechas');
    gotoxy(10,11); Writeln('4. Infracciones de un conductor entre 2 fechas');
    gotoxy(10,13); Writeln('5. Conductores con 0 scoring');
    gotoxy(10,15); Writeln('0. Regresar');
    gotoxy(10,15); Writeln('Opción: '); readln(op);
    case op of
         1:begin
            clrscr;
         Listado_Cond_Apynom(Arch_C,arbol_apynom);clrscr;
         end;
         2: begin
          clrscr;

          //Cond_In;
          clrscr;
         end;
         3: begin   clrscr;
           //inf_entre_fechas;
           clrscr;
          end;
         4: begin
           clrscr;
           //inf_cond_fechas;
          clrscr;
         end;
         5: begin
           clrscr;
          //Cond_sinpuntos;
           clrscr;
         end;
    end;
until op=0;
end;



end.
