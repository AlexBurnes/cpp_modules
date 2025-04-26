C++20 модули: инкапсуляция шаблонных библиотек

Как переход на модули C++20 в шаблонных библиотеках позволяет избежать лишнего экспорта зависимостей. Готовность инструментов сборки: поддержка в компиляторах, системах сборки и пакетных менеджерах C++ для перехода на модули в крупных проектах.



Протекание зависимотей в шаблонных библиотеках.



В проекте возникла необходимость переписать код одной старой библиотеки с использованием шаблоных типов, и она стала header‑only библиотекой. При ее использовании в проекте стало необходимо указывать зависимости библиотеки в самом проект при сборке. Разделить реализацию через pimpl идиому или обьявление абстрактного класса невозможно. Поиск решений привел к исследованию возможности использования С++20 модулей. Модули C++20 предлагают ускоренную сборку, улучшенную организацию кода и более чистую работу с зависимостями. Именно последний аспект интересует для решения задачи и будет рассмотрен в статье. Что касается вопроса ускорения сборки при переходе на модули, подробный анализ этого аспекта представлен в статье "C++20 modules and Boost: an analysis". Мы также проанализируем текущую готовность инструментария для  использования модулей в реальных проектах.

При исследовании нашел свежую статью про модули C++20. Несмотря на то, что Visual Studio 2022 version 17.5 была выпушена в феврале 2023  и в октябре того же года Kitware заявила, что поддержка модулей в CMake вышла из эксперементальной стадии, но внедрение модулей в библиотеки всё ещё на ранней стадии Boost, fmt, Qt, Vulkan-hpp has vulkan.cppm. 

https://en.cppreference.com/w/cpp/language/pimpl
https://anarthal.github.io/cppblog/modules
https://learn.microsoft.com/en-us/cpp/cpp/modules-cpp
https://www.kitware.com/import-cmake-the-experiment-is-over/
https://anarthal.github.io/cppblog/modules3
https://vitaut.net/posts/2023/simple-cxx20-modules/
https://doc.qt.io/qbs/tutorial-10.html
https://github.com/KhronosGroup/Vulkan-Hpp
https://github.com/KhronosGroup/Vulkan-Hpp/blob/main/vulkan/vulkan.cppm
https://en.cppreference.com/w/cpp/compiler_support/20

https://learn.microsoft.com/en-us/cpp/cpp/modules-cpp?view=msvc-170
https://devblogs.microsoft.com/cppblog/cpp20-modules-support-in-msvc/

https://clang.llvm.org/docs/StandardCPlusPlusModules.html
https://bugs.llvm.org/show_bug.cgi?id=35924

https://gcc.gnu.org/wiki/cxx-modules
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=93907

https://reviews.llvm.org/D135507
https://gcc.gnu.org/pipermail/gcc-patches/2021-June/572734.html

https://abseil.io/docs/cpp/guides/logging
https://github.com/ng-log/ng-log

sudo apt install python3 python3-pip
sudo pip3 install conan
# if pip3 will fail to install conan with error: externally-managed-environment
# try install with --break-system-packages

conan profile detect --force
conan install . -of .build -pr default --build missing
cmake -H. -B.build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake --no-warn-unused-cli
make --build .build
.build/example

https://en.cppreference.com/w/cpp/language/modules
https://learn.microsoft.com/en-us/cpp/cpp/modules-cpp

sudo apt install ninja-build
conan install . -of .build -pr default --build missing
cmake -H. -B.build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
sudo apt install clang-19 clang-tools-19
sudo bash update-alternatives-clang.sh 19 1

source .build/conanbuild.sh
cmake -H. -B.build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang


Да и полная поддержка модулей C++20 находится в стадии реализации в основных компиляторах, текущее состояние:

1. MSVC (Microsoft Visual C++)





Статус: Наиболее продвинутая поддержка



Подробности: Реализовано большинство возможностей, включая import std;



Ссылки:





Документация Microsoft



Блог о модулях MSVC

2. Clang





Статус: Экспериментальная поддержка (требует флагов)



Флаги: -std=c++20 -fmodules -fbuiltin-module-map



Проблемы: Частичная поддержка, особенно для import std;



Ссылки:





Официальная документация



Bugzilla: Полная поддержка модулей

3. GCC





Статус: Базовая поддержка (неполная)



Флаги: -std=c++20 -fmodules-ts



Проблемы: Нет поддержки import std;, ограниченная функциональность



Ссылки:





GCC Modules Status



Bugzilla: Модули в GCC

Критические PR и Issues:





Clang: D135507 (реализация import std;)



GCC: P1103R3 (модули стандартной библиотеки)

Попробуем передалать шаблонную библиотеку и собрать проект с помощью СMake, первый этап, и cделать из нее conan библиотеку и подключить ее к проекту, второй этап.

Примерный код библиотеки, полнолстью упрощен для помимания проблемы с зависимостью:



Шаблонный класс prefix имеет зависимость от библиотеки fmt. Тип логгер, это любой логгер с интерфейсом ostream вывода в лог, подобный интерфейс реализован в Abseil logging и ng-log. Для примера упрощен до следующего класса:



 Код исполняемого файла:



В коде приложения библиотека fmt не используется, но при сборке в СMakeLists.txt  нужно указать при линковке основного приложения:



Для подключения библиотеки будем использовать пакетный менеджер библиотек С++ сonan. Нужно установить на хост:



Создадим conanfile.txt в корне проекта:



Подключение библиотек и генерация cmake toolchain модулей:

conan install . -of .build -pr default --build missing











make --build .build





Запускаем собранное приложение

.build/example





Все собралось, работает, проблем кажется нет. Но на самом деле в приложении мы получили автоматом возможност использовать fmt::print в коде, хотя в приложении мы подключили <format> и не добавляли fmt библиотеку в линковку и не включали в main.cpp заголовок fmt/core.h! Это и есть проблема, что у нас завиcимость 'утекает' в код использующий prefix библиотеку. 

Переписываем библиотеки на модули. Грамматика модулей описана в стандарте и в cтатье про модули C++20 упомянутой в начале.

prefix.mpp



logger.mpp:



main.cpp:



Для кода с модулями поменял расширение на .mpp,это не принципиально, можно оставить hpp, или сделать .cpp, можно увидеть в статьях .ixx, и рекомендациях .cppm. Это такой же спор, как для C++ компилируемых файлов используют .cc, .c++, .cpp, .c, а для файлов заголовков .hh, ,h++, .hpp, .h Как в проекте договоритесь, такое расширение и будет. Я для С++ проектов использую .cpp, .hpp, и соотвественно .mpp.

Изменений  в коде класс prefix немного:





CMakeList.txt теперь выглядит так, добавили указание собирать библитеки prefix и logger как модули:



Обращаем внимание что fmt библиотека в CMakeList.txt подключена к библиотеке prefix c опцией PRIVATE, что не экспортирует fmt при подлючении prefix библиотеки в приложение.

Пробуем собирать и получаем следующую ошибку





Для сборки нужно использовать генератор make файлов ninja. Ninja — это минималистичная система сборки, разработанная для максимального ускорения компиляции C/C++ проектов. Так же одна из ее возможностей это Поддержка сложных зависимостей - корректно обрабатывае - зависимости между файлами (*.h → *.cpp) и модули C++20 (.cppm → .o).  

sudo apt install ninja-build

Для cmake нужно указать какой генертор использовать -GNinja, для conan нужно в профиле добавить настройку tools.cmake.cmaketoolchain:generator=Ninja.

conan install . -of .build -pr default --build missing





Запускаем сборку



И получаем очередную ошибку:





gcc 13.3.0 не может собрать данный код, пробуем clang, для этого ставим clang-19 и clang-tools-19



Cрипт update-alternatives-clang.sh:



Cледующая проблема с которой можно столкнуться это версии cmake и ninja ниже требуемых для поддержки модулей. Для cmake-3.28, для ninja 1.11. Не обязательно собирать эти версии вручную из исходных кодов можно воспользоваться возможность conan ставить кроме библиотек нужной версии в свой каталог еще и утилиты для сборки и использовать их. В conanfile.txt указываем нужные модули и их версии в разделе [tools_require]:



При запуске conan для установки библиотек их сборки и геренации cmake модулей, сonan генерирует файл conanbuild.sh с переменными окружения необходимые для сборки проекта. 







Проект успешно собрался. Запускаем 





Так как в main.cpp закомментирована строка с fmt::format мы не видим строки вывода. Расскоментируем строку в main.cpp и пробуем скомпилировать код:







Как видим зависимость бибилотеки fmt не подключилась автоматически из модуля prefix, и теперь для приложения ее явно нужно указывать для target example fmt::fmt и заголовок в main.cpp <fmt/core.h>

Как видно основная связка интсрументов сборки компилятор clang, CMake, ninja и conan используемых в компании для сборки проектов работает. 

Попробуем собрать приложение в СI в github actions. Добавим yml файл для СI:

Второй этап это создание библиотеки модуля как conan пакета.