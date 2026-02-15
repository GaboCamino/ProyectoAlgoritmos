unit Validaciones;

interface

uses
  crt,sysutils,dos;
Procedure ValidaNombre(var op:boolean; buscado: shortstring);
Procedure IngresaFecha(var f: string;mensaje:string);
function EsNumero(s: string): boolean;
function ComparadorFecha(sa,sm,sd:word):string;
Function EsFecha(x:string;long,min,max:integer):boolean;
procedure FechaActual(var fecha: string);
Procedure ValidaTelefono(var telefono:string);
implementation

Procedure ValidaNombre(var op:boolean; buscado: shortstring);
var i:byte;
begin
for i := 1 to length(buscado) do
     begin
          if not (buscado[i] in ['a'..'z','A'..'Z',' ']) then
               op := false;
     end;
end;
Procedure IngresaFecha(var f: string;mensaje:string);
var d,m,a,comp:string;
  sd,sm,sa:word;
  opx,opy:byte;
begin
  comp:='1';
  f:='0';
  DecodeDate(Date,sa,sm,sd);
  repeat
     if (StrToInt(f))>(StrToInt(comp)) then
     begin
          clrscr;
          Writeln('Ingrese la fecha actual o una pasada.');
          readkey;
          clrscr;
     end;
     write(mensaje);
     opx:=whereX; opy:=whereY;
           repeat
                 gotoxy(opx,opy); clreol; opx:=whereX; opy:=whereY; readln(d);
           until EsFecha(d,2,1,31);
           gotoxy(opx+2,opy); Write('/');
           opx:=whereX; opy:=whereY;
           repeat
                 gotoxy(opx,opy); clreol; opy:=whereY; opx:=whereX;  readln(m);
           until EsFecha(m,2,1,12);
           gotoxy(opx+2,opy); opx:=whereX;  Write('/');
           opx:=whereX; opy:=whereY;
           repeat
                 gotoxy(opx,opy); clreol;opy:=whereY; opx:=whereX; readln(a);
           until EsFecha(a,4,1900,sa);
     f:= a+m+d;
     comp:=ComparadorFecha(sa,sm,sd);
     until (StrToInt(f))<=(StrToInt(comp));
end;
Procedure ValidaTelefono(var telefono:string);
var opx,opy:byte;
begin
opx:=whereX; opy:=whereY;
       repeat
       gotoxy(opx,opy); clreol; opx:=whereX; opy:=whereY; readln(telefono);
       until EsNumero(telefono);
end;
function EsNumero(s: string): boolean;     //vi que hay otro para DNI, luego vemos como unificar
  var
    i: integer;
  begin
    EsNumero := true;
    for i := 1 to Length(s) do
      if not (s[i] in ['0'..'9']) then
      begin
        EsNumero := false;
      end;
  end;
 function ComparadorFecha(sa,sm,sd:word):string;
 begin
 ComparadorFecha:=IntToStr(sa) +
  Copy('0' + IntToStr(sm), Length(IntToStr(sm)), 2) +
  Copy('0' + IntToStr(sd), Length(IntToStr(sd)), 2);
 end;
Function EsFecha(x:string;long,min,max:integer):boolean;
begin
if (Length(x) = long) and EsNumero(x) and (StrToInt(x) >= min) and (StrToInt(x) <= max) then
EsFecha:=true
else EsFecha:=false;
end;
procedure FechaActual(var fecha: string);
var
   year, mont, mday, wday: word;
   a, m, d: string;
begin
     getdate(year, mont, mday, wday);

     Str(year, a);

     Str(mont, m);
     if mont < 10 then m := '0' + m;

     Str(mday, d);
     if mday < 10 then d := '0' + d;

     fecha := a + m + d;
end;
end.

