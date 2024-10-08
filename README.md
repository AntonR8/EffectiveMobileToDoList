Приложение разработано в рамках выполнения тестового задания для Effective Mobile
Приложение представляет из себя список задач, скачанных по предложенной ссылке.
![IMG_0284](https://github.com/user-attachments/assets/de79c4ce-4194-4129-84a2-77c7f0bb1483)

Приложение позволяет редактировать задачи, добавлять новые и удалять задачи. Удаление реализовано свайпом справа. Приложение также позволяет отмечать выполнение задачи или отменять выполнение - эта функция реализована с помощью свайпа слева:
![IMG_0304](https://github.com/user-attachments/assets/9ba94f63-2dd3-4479-9ce5-75b59ca625dc)

Загрузка списка задач, а также выполнения всех операций над задачами реализовано в фоновых потоках. Обновление интерфейса выполняется в главном потоке.
Хранение данных реализовано с помощью фреймворка Core Data
Архитектура приложения реализована с помощью паттерна Viper

![IMG_0307](https://github.com/user-attachments/assets/ff0ca3f2-cb34-41e0-9929-5ee0b659af8c)


Дополнительно реализовано:
- горизонтальный режим, 
- адаптивность к светлой и темной теме
- автоматическое появление курсора в нужном месте при редактировании записи
- автоматическое появление экранной клавиатуры при редактировании записи
- появление односекундной заставки, для эстетичности и закрытия возможной задержки времени при загрузке данных
- анимации
