unit Maneja_arboles;
interface

uses
  crt, Conductores, Arboles;

procedure crear_arbol(var raiz: t_punt);
procedure agregar(var raiz: t_punt; x:t_dato_arbol);

function preorden(var raiz: t_punt; buscado:string): t_punt;                     {ordena}
procedure Busqueda(arbol: t_punt; buscado: string; var pos: longint);            {buscado}

procedure Crear_Arbol_DNI(var Arch_C: T_Archivo_C; var arbol: t_punt);
procedure Crear_Arbol_Apynom(var Arch_C: T_Archivo_C; var arbol: t_punt);

procedure Transf_Dato_DNI(var Arch_C: T_Archivo_C; var x: t_dato_arbol);
procedure Transf_Dato_Apynom(var Arch_C: T_Archivo_C; var x: t_dato_arbol);

implementation

procedure crear_arbol(var raiz: t_punt);
begin
     raiz:= nil;
end;

procedure agregar(var raiz: t_punt; x: t_dato_arbol);
begin
  if raiz = nil then
  begin
    new(raiz);
    raiz^.info:= x;
    raiz^.sai:= nil;
    raiz^.sad:= nil;
  end
  else
    if raiz^.info.clave > x.clave then
      agregar(raiz^.sai,x)
    else
      agregar(raiz^.sad,x)
end;
function preorden(var raiz:t_punt; buscado:string): t_punt;
begin
  if (raiz=nil) then
  begin
       preorden:=nil
  end else
    if (raiz^.info.clave = buscado) then
    begin
         preorden:=raiz
    end else
      if raiz^.info.clave > buscado then
      begin
           preorden:=preorden(raiz^.sai,buscado)
           end else
           begin
          preorden:=preorden(raiz^.sad,buscado)
          end;
end;

procedure Transf_Dato_DNI(var Arch_C: T_Archivo_C; var x: t_dato_arbol);
var
   x1: T_Dato_Conductor;
begin
  read(Arch_C,x1);
  x.clave:= x1.DNI;
  x.pos:= filepos(Arch_C) - 1;
end;

procedure Crear_Arbol_DNI(var Arch_C: T_Archivo_C; var arbol: t_punt);
var
   x: t_dato_arbol;
begin
     crear_arbol(arbol);
     seek(arch_c,0);
     while filepos(Arch_C) < filesize(Arch_C) do
     begin
          transf_dato_DNI(Arch_C,x);
          agregar(arbol,x)
     end;
end;

procedure Transf_Dato_Apynom(var Arch_C: T_Archivo_C; var x: t_dato_arbol);
var
   x1: T_Dato_Conductor;
begin
     read(Arch_C,x1);
     x.clave:= x1.apynom;
     x.pos:= filepos(Arch_C) - 1;
end;

procedure Crear_Arbol_Apynom(var Arch_C: T_Archivo_C; var arbol: t_punt);
var
   x: t_dato_arbol;
begin
     crear_arbol(arbol);
     seek(arch_c,0);
while filepos(Arch_C) < filesize(Arch_C) do
begin
     transf_dato_apynom(Arch_C,x);
     agregar(arbol,x)
end;
end;

procedure Busqueda(arbol: t_punt; buscado: string; var pos: longint);
var aux: t_punt;
begin
     aux:= preorden(arbol,buscado);
     if aux = nil then
     Begin
        pos:= -1
       end else
       begin
            pos:= aux^.info.pos;
       end;
end;

end.

