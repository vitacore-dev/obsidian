
В доп. параметрах - удаление зарегистрированного документа из Акуз на сущности card_note
![[Pasted image 20260525132021.png|697]]

```
begin(obj,p)  
  @obj := {.};  
  @p := new Process("Delete", @obj);  
  @p->{Parameters}["ForceDelete"] := True;  
  @p->Run()[@p];  
  
end
```

![[Pasted image 20260525132341.png]]Удаляем из Акуз с сущности card_note правой кнопкой мыши действие-card_note_test_delete 
![[Pasted image 20260525132506.png]]
Далее удаляем этот документ и из СДВ 
![[Pasted image 20260525132816.png]]