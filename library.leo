program library_kx0d8ki.aleo;

struct BookInfo:
    title as field;
    author as field;
    isbn as field;


record Book:
    id as field.private;
    info as BookInfo.private;
    available as bool.private;


record User:
    id as address.private;
    name as field.private;

record Borrow:
    user_id as address.private;
    book_id as field.private;

mapping books:
    key as field.public;
    value as BookInfo.public;


mapping book_availability:
    key as field.public;
    value as bool.public;


mapping users:
    key as address.public;
    value as field.public;


mapping borrows:
    key as field.public;
    value as Borrow.public;

function add_book:
    input r0 as BookInfo.public;
    hash.bhp256 r0.isbn into r1 as field;
    cast r1 r0 true as Book.record;
    async add_book r1 into r2;
    output r2 as library_kx0d8ki.aleo/add_book.future;


finalize add_book:
    input r0 as field.public;
    set true into book_availability[r0];


function register_user:
    input r0 as address.public;
    input r1 as field.public;
    cast r0 r1 into r2 as User.record;
    async register_user r0 into r3;
    output r2 as User.record;
    output r3 as library_kx0d8ki.aleo/register_user.future;


finalize register_user:
    input r0 as address.public;
    input r1 as field.public;
    set r1 into users[r0];



function borrow_book:
    input r0 as address.public;
    input r1 as field.public;
    get.or_use book_availability[r1] false into r2;
    assert.eq r2 true;
    cast r0 r1 into r3 as Borrow.record;
    async borrow_book r1 into r4;
    output r3 as Borrow.record;
    output r4 as library_kx0d8ki.aleo/borrow_book.future;


finalize borrow_book:
    input r0 as field.public;
    set false into book_availability[r0];



function return_book:
    input r0 as address.public;
    input r1 as field.public;
    get.or_use borrows[r1] Borrow { user_id: r0, book_id: r1 } into r2;
    assert.eq r2.user_id r0;
    async return_book r1 into r3;
    output r3 as library_kx0d8ki.aleo/return_book.future;


finalize return_book:
    input r0 as field.public;
    set true into book_availability[r0];
}


function check_availability:
    input r0 as field.public;
    get.or_use book_availability[r0] false into r1;
    output r1 as bool.public;
}