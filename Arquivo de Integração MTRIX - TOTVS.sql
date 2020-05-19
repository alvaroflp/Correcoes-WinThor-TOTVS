/*nomeclatura do arquivo = txt */
select 'ID1FVENDA' || '' || to_char(systimestamp, 'ddmmyyyyhh24missff')
  from dual;
/*cabeçalho do arquivo de integração Mtrix*/
SELECT 'HID1FVENDA07723218000113' || '' || to_char(sysdate, 'yyyymmdd') as CABECALHO
  from dual;
/*identificação da força de vendas*/
select 'V' || '' || '46389383000566' || '' || '3' || '' ||
       RPAD(LPAD(PCUSUARI.CODUSUR, 4, 0), 20, ' ') || '' || CASE
         WHEN PCUSUARI.CPF IS NOT NULL THEN
          LPAD(REPLACE(REPLACE(PCUSUARI.CPF, '.', ''), '-', ''), 14, ' ')
         ELSE
          LPAD(REPLACE(REPLACE(PCUSUARI.CGC, '.', ''), '-', ''), 14, ' ')
       END || '' || LPAD(PCUSUARI.NOME, 80, ' ') || '' ||
       LPAD(PCUSUARI.CODSUPERVISOR, 20, ' ')
  from pcusuari
 where pcusuari.dttermino is null
   and pcusuari.dtexclusao is null
   and pcusuari.codusur in (select pcpedc.codusur
                              from pcpedc
                             where data between '&dtini' and '&dtfim'
                               and posicao = 'F'
                               and numped in (select numped 
                                               from pcpedi 
                                              where codprod in (select codprod 
                                                                  from pcprodut 
                                                                 where codfornec in (1930))))
 order by codusur;