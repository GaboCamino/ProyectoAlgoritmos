unit manejo_lista;
interface
uses
    crt,lista,conductores;

procedure conductores_hab(var arch_c:t_archivo_c;var l:t_lista;var x:t_dato_conductor;var a:t_dato_lista);
procedure conductores_inhab(var arch_c:t_archivo_c;var l:t_lista; var x:t_dato_conductor;var a:t_dato_lista);
implementation

procedure conductores_hab(var arch_c:t_archivo_c;var l:t_lista; var x:t_dato_conductor;var a:t_dato_lista);
begin
     seek(arch_c,0);
     while not eof(arch_c) do
     begin
          read(arch_c,x);
          if x.Hab='S' then
          begin
               a.Hab:=x.hab;
               a.Apynom:=x.apynom;
               a.DNI:=x.dni;
               a.Fecha_hab:=x.Fecha_hab;
               a.Mail:=x.mail;
               a.Nacim:=x.nacim;
               a.Reincidencias:=x.reincidencias;
               a.Score:=x.score;
               a.Tel:=x.tel;
          end;
     end;
     agregar(l,a);
end;


procedure conductores_inhab(var arch_c:t_archivo_c;var l:t_lista; var x:t_dato_conductor;var a:t_dato_lista);
begin
     seek(arch_c,0);
     while not eof(arch_c) do
     begin
          read(arch_c,x);
          if x.Hab='N' then
          begin
               a.Hab:=x.hab;
               a.Apynom:=x.apynom;
               a.DNI:=x.dni;
               a.Fecha_hab:=x.Fecha_hab;
               a.Mail:=x.mail;
               a.Nacim:=x.nacim;
               a.Reincidencias:=x.reincidencias;
               a.Score:=x.score;
               a.Tel:=x.tel;
          end;
     end;
     agregar(l,a);
end;
end.

