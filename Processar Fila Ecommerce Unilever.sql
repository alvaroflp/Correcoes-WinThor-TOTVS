--BACKUP PCPEDCTEMP
            create table pcpedctemp_bkp as
             select p.* from pcpedctemp p, (
               select numpedweb, count(*)
                 from pcpedctemp C
                where trunc(data) >= trunc(sysdate - 15)
                  and integradora = 29
                  and IMPORTADO = 'N'
                  group by numpedweb
                  having count(*)= 2 ) a where a.numpedweb = p.numpedweb;
                 
           --BACKUP PCPEDITEMP      
               create table  pcpeditemp_bkp as  
                 select P.* from pcpeditemp p, (
               select numpedweb, count(*)
                 from pcpedctemp C
                where trunc(data) >= trunc(sysdate - 15)
                  and integradora = 29
                  and IMPORTADO = 'N'
                  group by numpedweb
                  having count(*)= 2 ) a where a.numpedweb = p.numpedweb;  

--DELETE ITENS
DECLARE
 vcont NUMBER := 1;

begin

 for dados in (   select p.NUMPEDWEB FRom pcpedctemp p, (
               select numpedweb, count(*)
                 from pcpedctemp C
                where trunc(data) >= trunc(sysdate - 15)
                  and integradora = 29
                  and IMPORTADO = 'N'
                  group by numpedweb
                  having count(*)= 2 ) a where a.numpedweb = p.numpedweb GROUP BY P.NUMPEDWEB)

  loop
   vcont  := 1;
   for dentro in (SELECT numseq
                    FROM PCPEDITEMP A
                   WHERE NUMPEDWEB = dados.numpedweb) loop

     delete from PCPEDITEMP
      where NUMPEDWEB = dados.numpedweb
        and rownum = 1
        and bonific is null
        and numseq = vcont;
     vcont := vcont + 1;
     --exit when (vcont = vmax);
   end loop;

   DBMS_OUTPUT.put_line(vcont || ' registros alterados' || 'NUMPED: ' ||
                        dados.numpedweb);

 end loop;
 end;  

 --VALIDAR QUANTIDADE ITENS (APENAS CONTA OS REGISTROS PARA SABER QUANTOS TEM ANTES E DEPOIS DE EXCLUIR)
    select COUNT(*) FRom pcpedItemp p, (
               select numpedweb, count(*)
                 from pcpedctemp C
                where trunc(data) >= trunc(sysdate - 15)
                  and integradora = 29
                  and IMPORTADO = 'N'
                  group by numpedweb
                  having count(*)= 2 ) a where a.numpedweb = p.numpedweb   and bonific is null ;

--DELETE CABEÇALHO
DECLARE
begin

 for dados in ( select p.NUMPEDWEB FRom pcpedctemp p, (
              select numpedweb, count(*)
                from pcpedctemp C
               where trunc(data) >= trunc(sysdate - 15)
                 and integradora = 29
                 and IMPORTADO = 'N'
                 group by numpedweb
                 having count(*)= 2 ) a where a.numpedweb = p.numpedweb  and condvenda = 1 GROUP BY P.NUMPEDWEB)

LOOP
     delete from PCPEDCTEMP
      where NUMPEDWEB = dados.numpedweb
        and rownum = 1 and codvenda = 1;


   DBMS_OUTPUT.put_line(' registros alterados' || 'NUMPED: ' || dados.numpedweb);

 end loop;
 end;
 
 
 
  --VALIDAR QUANTIDADE ITENS (APENAS CONTA OS REGISTROS PARA SABER QUANTOS TEM ANTES E DEPOIS DE EXCLUIR)  
    select  count(*) FRom pcpedCtemp p, (
               select numpedweb, count(*)
                 from pcpedctemp C
                where trunc(data) >= trunc(sysdate - 15)
                  and integradora = 29
                  and IMPORTADO = 'N'
                group by numpedweb) a where a.numpedweb = p.numpedweb   and condvenda = 1

--CHAMAR PROCEDURE PARA IMPORTAR PEDIDO

DECLARE

begin

 for dados in (select numpedweb, codusur
 from pcpedctemp C
where trunc(data) >= trunc(sysdate - 15)
  and integradora = 29
  and IMPORTADO = 'N')

  loop


 -- Call the procedure
 importarvendascomple.importar_pedido_web(dados.numpedweb, 29, dados.codusur);


DBMS_OUTPUT.put_line( ' registros alterados  ' || 'NUMPED: ' ||
dados.numpedweb);

 end loop;
 end;  
