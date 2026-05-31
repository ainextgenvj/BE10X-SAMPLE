USE [HERCULES]
GO
/****** Object:  StoredProcedure [dbo].[AGEING_AK]    Script Date: 31-05-2026 12:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[AGEING_AK]
as
BEGIN
Select * Into #OUT_AGEING from (


select sale_type,'>55 DAYS ' AS 'CAPPING',sy_obj_name,bill_no,bill_date,custcode,net_amt,bal_amt from HERCULESTD17..bill with(index(IX_BILL_cust_bill_date)) where agentcode='3' and bal_amt>0 and bill_date>55 and sale_type='REAGENTS' and ISCANCELLED=0
union all
select sale_type,'>120 DAYS ' AS 'CAPPING',sy_obj_name,bill_no,bill_date,custcode,net_amt,bal_amt from HERCULESTD17..bill with(index(IX_BILL_cust_bill_date)) where agentcode='3' and bal_amt>0 and bill_date>120 and sale_type='INSTRUMENTS' and ISCANCELLED=0
union all
select sale_type,'' AS 'CAPPING' ,sy_obj_name,bill_no,bill_date,custcode,net_amt,bal_amt from HERCULESTD17..bill with(index(IX_BILL_cust_bill_date)) where agentcode='3' and bal_amt>0 and bill_date>90 and sale_type not in ('REAGENTS','INSTRUMENTS') and ISCANCELLED=0
) CC


SELECT  CS.SALE_TYPE,CS.CAPPING,CS.SY_OBJ_NAME,CS.BILL_NO,CS.BILL_DATE,CS.CUSTCODE,AG.TERNAME,C.NAME,CS.NET_AMT,CS.BAL_AMT FROM #OUT_AGEING CS
INNER JOIN HERCULESTD17..CUSTOMER C
ON CS.CUSTCODE=C.CUSTCODE
INNER JOIN HERCULESTD17..AG_CUST AG
ON CS.CUSTCODE=AG.CUSTCODE AND AG.AGENTCODE=3

END

