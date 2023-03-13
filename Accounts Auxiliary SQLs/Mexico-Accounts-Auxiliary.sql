SELECT 
   NumCta saw_0,
   DesCta saw_1,
   SaldoIni saw_2,
   SaldoFin saw_3,
   Fecha saw_4,
   NumUnIdenPol saw_5,
   Concepto saw_6,
   Debe saw_7,
   Haber saw_8,
   Accounting_Period saw_9,
   Ledger saw_10,
   Legal_Entity saw_11
 FROM (SELECT
   "General Ledger - Transactional Balances Real Time"."Account"."General Ledger Code Combination Identifier" bal_ccid,
   "General Ledger - Transactional Balances Real Time"."Ledger"."Ledger Name" Ledger,
   "General Ledger - Transactional Balances Real Time"."Time"."Fiscal Period"  Accounting_Period,
   "General Ledger - Transactional Balances Real Time"."Natural Account Segment"."Account Code" NumCta,
   "General Ledger - Transactional Balances Real Time"."Natural Account Segment"."Account Description" DesCta,
   "General Ledger - Transactional Balances Real Time"."- Balance"."Beginning Balance" SaldoIni,
   "General Ledger - Transactional Balances Real Time"."- Balance"."Ending Balance" SaldoFin,
   "General Ledger - Transactional Balances Real Time"."- Balance"."Period Net Activity" bal_periodbal
FROM "General Ledger - Transactional Balances Real Time" 
where "General Ledger - Transactional Balances Real Time"."Ledger"."Ledger Name"  in ('@{p_ledger}') 
and "General Ledger - Transactional Balances Real Time"."Time"."Fiscal Period" in ('@{p_period}')
and "General Ledger - Transactional Balances Real Time"."- Balance"."Ending Balance" != 0
/*and "General Ledger - Transactional Balances Real Time"."Natural Account Segment"."Account Code" in ('@{p_account}')*/
) balances full outer join (SELECT
   "General Ledger - Journals Real Time"."- Header Details"."Header Default Effective Date" Fecha,
   "General Ledger - Journals Real Time"."- Account"."General Ledger Code Combination Identifier" jrnl_ccid,
   CONCAT(REPLACE("General Ledger - Journals Real Time"."- Header Details"."Header Name",' ',''),CONCAT(REPLACE(CAST("General Ledger - Journals Real Time"."- Header Details"."Header Key" AS CHAR),' ',''),CONCAT(REPLACE("General Ledger - Journals Real Time"."- Batch Details"."Batch Name",' ',''),REPLACE("General Ledger - Journals Real Time"."- Header Details"."Header Description",' ','')))) jrnl_header_desc,
   CONCAT(SUBSTRING(REPLACE("General Ledger - Journals Real Time"."- Header Details"."Header Name",' ','') FROM 1 FOR (50 - CHAR_LENGTH(REPLACE(CAST("General Ledger - Journals Real Time"."- Header Details"."Header Key" AS CHAR),' ','')))),REPLACE(CAST("General Ledger - Journals Real Time"."- Header Details"."Header Key" AS CHAR),' ','')) NumUnIdenPol,
   "General Ledger - Journals Real Time"."- Ledger"."Ledger Name" jrnl_ledger,
   "General Ledger - Journals Real Time"."Time"."Fiscal Period"  jrnl_period,
   "General Ledger - Journals Real Time"."- Line Details"."Line Description" Concepto,
   "General Ledger - Journals Real Time"."- Line Details"."Line Number" jrnl_line_number,
   "General Ledger - Journals Real Time"."- Lines"."Journal Line Accounted Amount Debit" Debe,
   "General Ledger - Journals Real Time"."- Lines"."Journal Line Accounted Amount Credit" Haber,
   "General Ledger - Journals Real Time"."- Header Details"."Journal Legal Entity" Legal_Entity
FROM "General Ledger - Journals Real Time" 
where 
"General Ledger - Journals Real Time"."- Ledger"."Ledger Name" in ('@{p_ledger}') 
and "General Ledger - Journals Real Time"."Time"."Fiscal Period" in ('@{p_period}') 
and ("General Ledger - Journals Real Time"."- Lines"."Journal Line Accounted Amount Debit" != 0 or 
   "General Ledger - Journals Real Time"."- Lines"."Journal Line Accounted Amount Credit" != 0)
/* and "General Ledger - Journals Real Time"."- Natural Account Segment"."Natural Account Segment Code" in ('@{p_account}') */
and "General Ledger - Journals Real Time"."Posting Status"."Posting Status Code" = 'P') journals on journals.jrnl_ledger = balances.Ledger 
and balances.bal_ccid = journals.jrnl_ccid 
and journals.jrnl_period = balances.Accounting_Period
 ORDER BY saw_0, saw_1, saw_4, saw_5, saw_6, saw_9, saw_10, saw_11
