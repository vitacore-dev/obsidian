
```
Sc create "AIS LPU Update Server Postgres" binPath= "\"C:\Program Files (x86)\Vitacore\AIS LPU Update Server Postgres\AKUZ.UpdateServer.exe\"" DisplayName= "AIS LPU Update Server Postgres" type= own start= auto

Sc description "AIS LPU Update Server Postgres" "Сервер клиентских обновлений AIS LPU Postgres"

Sc create "AIS LPU Server Postgres" binPath= "\"C:\Program Files (x86)\Vitacore\AIS LPU Server Postgres\AKUZ.Service.exe\"" DisplayName= "AIS LPU Server Postgres" type= own start= auto

Sc description "AIS LPU Server Postgres" "Сервер приложений AIS LPU Postgres"

```