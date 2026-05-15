![[Pasted image 20260422160207.png]]

**проблема**: слетела сортировка


Решение:
> Появилось поле ордер для сортировки. Для установки нужной сортировки нужно проставить номера атрибутам например:
>
update vclib.t_enums
set [Order]='1'
where enumid=11801
>
update vclib.t_enums
set [Order]='2'
where enumid=11802
После изменений в БД рефрешнуть VCLib.BaseEnumHolder, перезайти в клиент

