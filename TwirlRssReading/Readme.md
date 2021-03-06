##Приветствую)

**Предъявляю вам на ваш суд проект RSS-читалки, по тестовому заданию, которое вы мне дали.
Проект был сделан в близкой к VIPER-архитектуре. Кроме того, вьюшка SelectChannel-экран тоже является специфическим пакетом разных модулей.**

- Все добротно задокументировано (можно пройтись Doxygen-ом, но я конфиг файл с работы забыл себе скинуть)
- На Unit-тесты времени не хватило (пока не привык писать по TDD)
- Используется самописный роутер. К сожалению времени не хватило сделать каждому переходу подкласс (ну хоть так)
- Планировалось создание ItemDetails-экрана (но было решено всю информацию писать на Feeds-экране)
- Имеется 2 ортогональных пакета сервисов (получение информации о каналах, и получение новостей с RSS-канала)
- Не успел сделать нормальные стилизаторы для вьюшек (и фабрику констрейнтов)
- В проекте  есть pch файл HURSSImportRoot.pch (в котором выполняется послеовательное импортирование всего, чего нужно)
- Имеется набор вспомогательных категорий
- Splash-экран выполнен в простом MVC, потому-что там что-либо другое будет избыточно
- Работу с CoreData не оптимизировал (есть еще много тасков с этим)
- Не от всех warning-ов еще избавился
- В проекте используется 5 зависимостей (4 из них подключены через CocoaPods) :
    CZPicker,   URNBAlert,   Masonry,    MWFeedParser,      BLMultiColorLoader

- Из дополнительных заданий не успел сделать задание с разбиением по месяцам
- Не было возможности протестировать на старых устройствах, и устройствах с iOS 7
- Отлажено все было не идеально, могут еще быть в разных местах хитрые баги

##Описание приложения :

Сначала пользователь попадает на Splash-экран (который анимированно улетает за край экрана) - и пользователь попадает к форме выбора канала.

### На SelectChannel-экране содержится основная логика (в частности, с загрузкой экрана) :

- Когда пользователь вводит более менее валидный URL канала (регулярка не идеальна) - ему показывает текстовое поле для ввода названия канала
- Когда пользователь вводит достаточно длинное название канала - ему показывает кнопку "Добавить" (пользователь может сохранить канал)
- Когда пользователь вводит название канала, которое уже есть в базе - ему показывает кнопки "Изменить/Удалить" - пользователь может изменить или удалить канал из локального хранилища
- Когда пользователь успешно выполняет "Добавление/Изменение/Удаление" канала - ему показывает диалог с информацией о совершенном действии
- Когда пользователь нажимает на кнопку "Смотреть" - ему показывает пикер с возможными каналами (имеются зараннее зарезервированные каналы)
- Когда пользователь выбирает канал - интерфейс перестраивается, в соответствии с полученной информацией
- Когда пользователь нажимает "Получить" - специальный сервис пытается получить новости из сети (показывает индикатор)
- Если новости получить удалось - пользователя кидает к следующему экрану (Feeds)
- Если новости получить не удалось - пользователю показывает алерт (в нем 2 или 3 кнопки). Кнопки "Жаль", "Еще раз", "Смотреть сохраненные ранее"
- Соответственно кнопку "Смотреть сохраненные ранее" показывает только в том случае, если ранее были загружен уже список новостей
- При нажатии на кнопку "Еще раз" - система пытается вновь получить данные по сети
- При нажатии на кнопку "Смотреть сохраненные ранее" - система загружает из базы данных полученне ранее новости, и переходит к Feeds-экрану

### На Feeds-экране отображается список новостей :
- Новости отображаются таблично
- В ячейке для каждой новости показывается : заголовок новости, автор новости (если имеется), дата новости, контент новости
- Имеется поддержка для HTML-контента, и даже для картинок!
- При нажатии на новость - выполняется переход в браузере к этой новости
- Здесь показывается бар навигации, поэтому возможен переход назад (к экрану выбора канала)

