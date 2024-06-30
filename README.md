Програма " library" написана для управління бібліотекою книг на Aleo.Вона дозволяє додавати нові книги, оновлювати інформацію про книги, позичати книги і повертати їх, а ще програма забезпечує збереження конфіденційності інформації про користувачів та їхні дії завдяки використанню нульових знань(тобто Zero-Knowlegde ).

program library_kx0d8ki.aleo;

// Структура для зберігання інформації про книгу.
struct BookInfo:
    title as field;
    author as field;
    isbn as field;

//Запис про книгу
record Book:
    id as field.private;
    info as BookInfo.private;
    available as bool.private;

// Запис про користувача

record User:
    id as address.private;
    name as field.private;

// Запис про абонемент
record Borrow:
    user_id as address.private;
    book_id as field.private;

// Мапінг для зберігання книг.
mapping books:
    key as field.public;
    value as BookInfo.public;

// Мапінг для зберігання статусу доступності книг.
mapping book_availability:
    key as field.public;
    value as bool.public;

//Мапінг для зберігання користувачів
mapping users:
    key as address.public;
    value as field.public;

//Мапінг для зберігання абонементів.
mapping borrows:
    key as field.public;
    value as Borrow.public;


//Функція для додавання нової книги.
function add_book:
    input r0 as BookInfo.public;
    hash.bhp256 r0.isbn into r1 as field;
    cast r1 r0 true as Book.record;
    async add_book r1 into r2;
    output r2 as library_kx0d8ki.aleo/add_book.future;

// Фіналізація для додавання нової книги

finalize add_book:
    input r0 as field.public;
    set true into book_availability[r0];


// Функція для реєстрації нового користувача.

function register_user:
    input r0 as address.public;
    input r1 as field.public;
    cast r0 r1 into r2 as User.record;
    async register_user r0 into r3;
    output r2 as User.record;
    output r3 as library_kx0d8ki.aleo/register_user.future;

// Фіналізація для реєстрації нового користувача.
finalize register_user:
    input r0 as address.public;
    input r1 as field.public;
    set r1 into users[r0];


// Функція для взяття книги на абонемент.
function borrow_book:
    input r0 as address.public;
    input r1 as field.public;
    get.or_use book_availability[r1] false into r2;
    assert.eq r2 true;
    cast r0 r1 into r3 as Borrow.record;
    async borrow_book r1 into r4;
    output r3 as Borrow.record;
    output r4 as library_kx0d8ki.aleo/borrow_book.future;

//Фіналізація для взяття книги на абонемент

finalize borrow_book:
    input r0 as field.public;
    set false into book_availability[r0];


//Функція для повернення книги
function return_book:
    input r0 as address.public;
    input r1 as field.public;
    get.or_use borrows[r1] Borrow { user_id: r0, book_id: r1 } into r2;
    assert.eq r2.user_id r0;
    async return_book r1 into r3;
    output r3 as library_kx0d8ki.aleo/return_book.future;

// Фіналізація для повернення книги.
finalize return_book:
    input r0 as field.public;
    set true into book_availability[r0];
    
}

// Функція для перевірки статусу книги.
function check_availability:
    input r0 as field.public;
    get.or_use book_availability[r0] false into r1;
    output r1 as bool.public;
}


======================

Офіційний сайт https://www.aleo.org/
Leo: https://leo-lang.org/
Discord https://discord.gg/aleohq
Twitter https://twitter.com/AleoHQ
GitHub https://github.com/AleoHQ
