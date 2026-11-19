--------------------------------------------------------
-- Archivo creado  - miércoles-noviembre-18-2026   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_DAT_486
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "RCVRY"."PROC_DAT_486" 
AS 
BEGIN 
update RPT_LOG_CYBER_REG set status=1,activado=sysdate where id_proc=49;
INSERT INTO rpt_log_cyber VALUES(49,1,SYSDATE,'PRODUCCION','EJECUTANDO DAT DE BANJIO 486');
COMMIT;

update RPT_LOG_CYBER_REG set ETAPA='EJECUTANDO DAT DE BANJJIO 486' where id_proc=49;
INSERT INTO rpt_log_cyber VALUES(49,2,SYSDATE,'PRODUCCION','TRUNCANDO TABLAS');
update RPT_LOG_CYBER_REG set ETAPA='TRUNCANDO TABLAS' where id_proc=49;
commit;

execute immediate 'truncate table rpt_dat_486_1';

INSERT INTO rpt_log_cyber VALUES(49,3,SYSDATE,'PRODUCCION','INSERTANDO INFORMACION EN LA TABLA');
update RPT_LOG_CYBER_REG set ETAPA='INSERTANDO INFORMACION EN LA TABLA' where id_proc=49;
commit;

Insert Into Rpt_Dat_486_1 (Grupo,Folio,Cuenta,Nombre,Calle,Col,Del_Muni,Estado,Cp,Cliente,Fe_Asig,Estatus,Sdo_Act,Capital,Tipo,Fe_Castigo,Fe_Pp,Nva,Ult_Visita,Ult_Carta,Ult_Sms,Ult_Disca,
Ult_Mail,Etiqueta1,Segmento,Etiqueta2,Saldo_Ven,Saldo1,Saldo2,Saldo3,Ult_Herra,Etiqueta3,Cuenta2,Etiqueta_5,Cont_Blas,Etiqueta_6,Ctn_Ls,Ctn_Le,etiqueta9,PVS,etiqueta10,etiqueta11,etiqueta12) 
select dmacctg,u1folio,dmacct,dmname,dmaddr1, dmaddr2, dmcity, dmstate,dmzip,dmcompany,u1asigdte,dmacrc2,dmcurbal,dmamtdlq,u1estrateg1 AS Tipo,u1estrateg4 as etiqueta4,'' as fe_pp,dmptscor,
'' as ULT_VISITA,'' as ULT_CARTA,'' as ULT_SMS,'' as ULT_DISCA,'' as ULT_MAIL,dmphone AS ETIQUETA1,U1PROGRAMA AS SEGMENTO,U1email AS ETIQUETA2,dmamtdlq AS SALDO_VEN,
u1actasig AS SALDO1,u1vdoasig AS SALDO2,u1minasig AS SALDO3,'' as ult_herra,dmbphone AS etiqueta3,dmssnum as cuenta2,DMP2 as etiqueta_5,'' as CoNT_BLAS,u1ext2 as ETIQUETA_6,'' as ctn_ls,
'' as ctn_le,dmcphone as etiqueta9,u1arcod1 AS PVS,u1arcod2 as etiqueta10,u1estrateg2 as etiqueta11,u1arcod3 as etiqueta12
from delqmst,uda1 where dmacctg='1' and dmcompany='486' and dmstatus is null and dmacct=u1acct;
commit;

--------AABPY
--------AABPY 03/09/2024 SE QUITA EXCLUSIONES POR SOLICITUD DE ARACELI RODRIGUEZ
--DELETE FROM RPT_DAT_486_1 WHERE CUENTA in (SELECT cta FROM tbl_excl_marcador where GPO='1' and CTE='486' AND FECHA>=(SYSDATE));
--commit;
------------------------------


INSERT INTO rpt_log_cyber VALUES(49,4,SYSDATE,'PRODUCCION','COMPLETANDO DATOS');
update RPT_LOG_CYBER_REG set ETAPA='COMPLETANDO DATOS' where id_proc=49;
commit;

Update rpt_dat_486_1 Ft Set (ft.fe_ult_sr)  = (Select max(ct.acactdte) From ACTFIL Ct Where ct.acacctg='1' and ct.acacct=Ft.cuenta AND ct.acseqnum='0'  AND substr(ct.accidnam,1,1) in ('1','a'));
Update rpt_dat_486_1 Ft Set (ft.fe_ult_cr)  = (Select max(ct.acactdte) From ACTFIL Ct Where ct.acacctg='1'  and ct.acacct=Ft.cuenta AND ct.acseqnum='0' AND substr(ct.accidnam,1,1) in ('z','Z'));
commit;

Begin
for i in (select a.acacct,a.acactdte,a.acaccode,a.acrccode from actfil a, rpt_dat_486_1 b where a.acacctg='1' and a.acacct=b.cuenta and a.acactdte=b.fe_ult_sr and b.fe_ult_sr is not null and a.acseqnum='0' AND substr(a.accidnam,1,1) in ('1','a'))
Loop
update rpt_dat_486_1 set ult_ca_sr=i.acaccode, ult_cr_sr=i.acrccode where cuenta=i.acacct and fe_ult_sr=i.acactdte;
end loop;
End;
commit;

Update Rpt_Dat_486_1 Set Aban_Sr=Trunc(Sysdate)-Trunc(Fe_Ult_Sr), Aban_Cr=Trunc(Sysdate)-Trunc(Fe_Ult_Cr);
commit;

Update Rpt_Dat_486_1 ft Set (ft.ULT_VISITA) = (Select max(ct.acactdte)  From actfil ct Where ct.acacctg='1' and ft.cuenta = ct.acacct  AND ct.acseqnum='0' and  ct.ACACCODE='GD' );
Update Rpt_Dat_486_1 ft Set (ft.ULT_CARTA) = (Select max(ct.acactdte)  From actfil ct Where ct.acacctg='1'  and ft.cuenta = ct.acacct AND ct.acseqnum='0' and   ct.ACACCODE='HR' AND ct.acrccode='CA');
Update Rpt_Dat_486_1 ft Set (ft.ULT_SMS) = (Select max(ct.acactdte)  From actfil ct Where ct.acacctg='1' and ft.cuenta = ct.acacct AND ct.acseqnum='0' and  ct.ACACCODE='HR' AND ct.acrccode='SM');
Update Rpt_Dat_486_1 ft Set (ft.ULT_DISCA) = (Select max(ct.acactdte)  From actfil ct Where ct.acacctg='1' and ft.cuenta = ct.acacct  AND ct.acseqnum='0' and ct.ACACCODE='HR' AND ct.acrccode='MV');
Update Rpt_Dat_486_1 ft Set (ft.ULT_MAIL) = (Select max(ct.acactdte)  From actfil ct Where ct.acacctg='1' and ft.cuenta = ct.acacct AND ct.acseqnum='0' and ct.ACACCODE='HR' AND ct.acrccode='EM');
Update Rpt_Dat_486_1 ft Set (ft.ult_herra) = (Select max(ct.acactdte)  From actfil ct Where ct.acacctg='1' and ft.cuenta = ct.acacct AND ct.acseqnum='0'  and ct.ACACCODE='HR' );
commit;

---*** REQ 2021-016604)               CONTADOR DE VISITAS Y CARTAS
-------REQ 2021-024592    08/03/2021   REINICIO DE CONTADORES
-------REQ 2021-031141    25/03/2021   REINICIO DE CONTADORES  CADA 01 DE MES
--UPDATE Rpt_Dat_486_1 FT SET (FT.cont_visita) = (SELECT COUNT(CT.ACACCT) AS TOTAL FROM ACTFIL CT WHERE CT.ACACCTG='1' AND CT.ACACCODE||CT.ACRCCODE IN ('HRVI')AND ACACCT=CUENTA AND  To_Char(acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(acactdte,'YYYY')>=To_Char(Sysdate,'YYYY') );
--COMMIT;
UPDATE Rpt_Dat_486_1 FT SET (FT.cont_visita) = (SELECT COUNT(CT.ACACCT) AS TOTAL FROM ACTFIL CT WHERE CT.ACACCTG='1'AND CT.ACACCT=FT.CUENTA and CT.acseqnum='0' AND CT.ACACCODE IN ('GD') AND  To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY') );
COMMIT;
--CONTADOR MAIL
UPDATE Rpt_Dat_486_1 FT SET (FT.cont_mail) = (SELECT COUNT(CT.ACACCT) AS TOTAL FROM ACTFIL CT  WHERE CT.ACACCTG='1'AND CT.ACACCT=FT.CUENTA AND CT.acseqnum='0' AND CT.ACACCODE||CT.ACRCCODE IN ('HREM') and To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY') );
--CONTADOR--CARTAS
UPDATE Rpt_Dat_486_1 FT SET (FT.CoNT_CARTA) = (SELECT COUNT(CT.ACACCT) AS TOTAL FROM ACTFIL CT WHERE CT.ACACCTG='1' AND CT.ACACCT=FT.CUENTA AND CT.acseqnum='0' AND  CT.ACACCODE||CT.ACRCCODE IN ('HRCA')  AND To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY') );
--CONTADOR--BLASTER
UPDATE Rpt_Dat_486_1 FT SET (FT.CoNT_DIS) = (SELECT COUNT(CT.ACACCT) AS TOTAL FROM ACTFIL CT WHERE CT.ACACCTG='1' AND CT.ACACCT=FT.CUENTA AND CT.acseqnum='0' AND  CT.ACACCODE||CT.ACRCCODE IN ('HRMV') and To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY') );
--CONTADOR--SMS
UPDATE Rpt_Dat_486_1 FT SET (FT.CoNT_SMS) = (SELECT COUNT(CT.ACACCT) AS TOTAL FROM ACTFIL CT WHERE CT.ACACCTG='1' AND CT.ACACCT=FT.CUENTA AND CT.acseqnum='0' AND  CT.ACACCODE||CT.ACRCCODE IN ('HRSM') and To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY'));

Update Rpt_Dat_486_1 Ft Set (FT.ctn_ls) = (Select Count(CT.Acacct) As Total From Actfil CT Where CT.Acacctg='1' And CT.Acacct=FT.Cuenta  AND CT.acseqnum='0' And CT.Acaccode In ('LS') And  To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY'));

Update Rpt_Dat_486_1 Ft Set (FT.Ctn_Le) = (Select Count(CT.Acacct) As Total From Actfil CT Where CT.Acacctg='1' And CT.Acacct=FT.Cuenta  AND CT.acseqnum='0' And CT.Acaccode In ('LE') And  To_Char(CT.acactdte,'MM')>=To_Char(Sysdate,'MM') And To_Char(CT.acactdte,'YYYY')>=To_Char(Sysdate,'YYYY'));
COMMIT;

---------------------------trunc(acactdte) >trunc(fe_asig)

Begin
for i in (select a.adacct,a.adaddr1 from address a, rpt_dat_486_1 b where a.adacctg='1' and a.adacct=b.cuenta and a.adtype='3' and a.adstatus='A')
Loop
update rpt_dat_486_1 set mail=i.adaddr1||'; '||rtrim(mail) where cuenta=i.adacct;
end loop;
end;
commit;

Update rpt_dat_486_1 ft Set (ft.fe_pp)  = (Select max(ct.ppentry) From ptpsched ct Where ct.ppacctg='1' and ct.ppacct=ft.cuenta );
commit;

INSERT INTO rpt_log_cyber VALUES(49,5,SYSDATE,'PRODUCCION','INSERTANDO TELEFONOS');
update RPT_LOG_CYBER_REG set ETAPA='INSERTANDO TELEFONOS' where id_proc=49;
Commit;

Begin
for i in (select phacct,phareacode,phphone from phone,rpt_dat_486_1 where phacctg='1' and phacct=cuenta and phtype='1' and phstatus='A')
Loop
update rpt_dat_486_1 set tel1=i.phareacode||i.phphone where i.phacct=cuenta;
end loop;
end;
commit;

Begin
for i in (select phacct,phareacode,phphone from phone,rpt_dat_486_1 where phacctg='1' and phacct=cuenta and phtype='2' and phstatus='A')
Loop
update rpt_dat_486_1 set tel2=i.phareacode||i.phphone where i.phacct=cuenta;
end loop;
end;
Commit;

Begin
for i in (select phacct,phareacode,phphone from phone,rpt_dat_486_1 where phacctg='1' and phacct=cuenta and phtype='5' and phstatus='A')
Loop
update rpt_dat_486_1 set tel3=i.phareacode||i.phphone where i.phacct=cuenta;
end loop;
end;
commit;


UPDATE Rpt_Dat_486_1 SET fe_castigo=RTRIM(REPLACE(fe_castigo,'FE_CAS=',''));
UPDATE Rpt_Dat_486_1 SET seg_ciclo=(select u1estrateg2 from uda1 where u1acctg='1' and  u1acct=cuenta);
UPDATE Rpt_Dat_486_1 SET clasifica=(select u1estrateg3 from uda1 where u1acctg='1' and u1acct=cuenta);
Update Rpt_Dat_486_1 Set Pag_Min=(Select U1pagmin From Uda1 Where u1acctg='1' and U1acct=Cuenta);
Commit;


Update Rpt_Dat_486_1 Set sub_pro=(Select dmp1  From DELQMST Where DMACCTG='1' AND DMacct=Cuenta);
Update Rpt_Dat_486_1 Set LEYENDA=(Select u1producto  From uda1 Where u1acctg='1' and  u1acct=Cuenta);
Commit;


INSERT INTO rpt_log_cyber VALUES(49,6,SYSDATE,'PRODUCCION','FINALIZANDO DAT 486 EN ORACLE');
update RPT_LOG_CYBER_REG set ETAPA='FINALIZANDO DAT 486 EN ORACLE' where id_proc=49;
commit;

INSERT INTO rpt_log_cyber VALUES(49,7,SYSDATE,'PRODUCCION','EJECUTA EL DAT 486 EN EL 50.2' );
Update Rpt_Log_Cyber_Reg Set Etapa='EJECUTA EL DAT 486 EN EL 50.2' Where Id_Proc=49;
commit;


END proc_dat_486;

/

  GRANT EXECUTE ON "RCVRY"."PROC_DAT_486" TO "AABPY";
