Проявилась ошибка:
```
VCLib.Common.ProcessException: Ошибка работы с базой данных: Ошибка арифметического переполнения при преобразовании numeric к типу данных numeric.
Выполнение данной инструкции было прервано.
(ID:fbf5956a-91ff-438f-93c8-132da524f80c). 
 ---> System.Exception: Ошибка работы с базой данных: Ошибка арифметического переполнения при преобразовании numeric к типу данных numeric.
Выполнение данной инструкции было прервано.
```
Решение:
По ID запроса из текста ошибки (пример: fbf5956a-91ff-438f-93c8-132da524f80c) найти SQL-запрос в логе. 
Например: 
```
declare @type [varchar](max) = null, @ID [uniqueidentifier] = '8bbafdc3-fb5b-4a22-9d86-84af1a9825cf', @a0 [varchar](255) = 'Вакц. полиомиелитная пероральная 1,2,3 типов', @a1 [datetime] = '2018-08-21 00:00:00.000', @a2 [int] = 3800, @a3 [int] = 5655, @a4 [varchar](255) = null, @a5 [uniqueidentifier] = '2f7fac35-3226-40de-b487-5a9e2ba16edd', @a6 [bit] = 0, @a7 [int] = 2, @a8 [varchar](255) = '098', @a9 [int] = 4, @a10 [datetime] = '30.11.2018 0:00:00', @a11 [int] = 37863, @a12 [datetime] = null, @a13 [decimal](7,0) = 1022018

INSERT AKUZ.T_CDA_SECTION_IMM_VAC_CERT_ELEMENT(CdaSectionImmVacCertElementID, VaccineType, IntroductionDate, EhrRusEjqdjjqaqj, EhrRusS0JLHGTLBJ, Comment, CdaSectionImmVacCert, Revaccination, RevaccinationSequenceNumber, PreparationSerial, EhrRusPokazanijaKPrimenenijuIblp, ExpirationDate, Performer, PlannedDate, Dose) SELECT @ID, @a0, @a1, @a2, @a3, @a4, @a5, @a6, @a7, @a8, @a9, @a10, @a11, @a12, @a13
```
Из запроса видно, что вставка происходит из таблицы AKUZ.T_CDA_SECTION_IMM_VAC_CERT_ELEMENT, поле Dose имеет тип  [[Decimal]]  с длиной 7 знаков. При этом в запросе происходит вставка значения превышающая длину типа данных. 