
create database salesmanagement;
use salesmanagement;


create table products(
    id_product varchar(10) primary key,
    name_product varchar(255) not null,
    made_from varchar(255) not null,
    price decimal(18,2) not null check (price >= 0),
    stock int not null check (stock >= 0)
);

create table customers(
    id_customer varchar(10) primary key,
    name_customer varchar(255) not null,
    email varchar(255) not null unique,
    phone varchar(10),
    address text
);

create table orders(
    id_order varchar(10) primary key,
    id_customer varchar(10) not null,
    created_at timestamp default current_timestamp,
    total decimal(18,2) default 0 check (total >= 0),
    foreign key (id_customer) references customers(id_customer)
);

create table order_detail(
    id_order varchar(10),
    id_product varchar(10),
    quantity int not null check (quantity > 0),
    price_at_purchase decimal(18,2) not null check (price_at_purchase >= 0),
    primary key (id_order, id_product),
    foreign key (id_order) references orders(id_order),
    foreign key (id_product) references products(id_product)
);

alter table orders 
add column note text;

alter table products 
rename column made_from to nha_san_xuat;

insert into products values 
('P001', 'MacBook Air M2', 'Apple', 28000000, 10),
('P002', 'Chuột Logitech G502', 'Logitech', 1200000, 50),
('P003', 'Bàn phím Akko 3087', 'Akko', 1500000, 20),
('P004', 'Màn hình Dell U2422H', 'Dell', 6500000, 15),
('P005', 'iPad Pro M2', 'Apple', 22000000, 8);

insert into customers values
('C001', 'Nguyễn Văn A', 'a@gmail.com', '0901234567', 'TP.HCM'),
('C002', 'Trần Thị B', 'b@gmail.com', null, 'Hà Nội'),
('C003', 'Lê Văn C', 'c@gmail.com', '0988888888', 'Đà Nẵng'),
('C004', 'Phạm Thị D', 'd@gmail.com', '0977777777', 'Cần Thơ'),
('C005', 'Hoàng Văn E', 'e@gmail.com', null, 'Hải Phòng');

insert into orders (id_order, id_customer, total, note) values 
('DH001', 'C001', 28000000, 'Giao hỏa tốc'),
('DH002', 'C002', 1200000, null),
('DH003', 'C003', 29500000, 'Khách quen'),
('DH004', 'C004', 1500000, null),
('DH005', 'C005', 22000000, 'Hàng dễ vỡ');

insert into order_detail values 
('DH001', 'P001', 1, 28000000),
('DH002', 'P002', 1, 1200000),
('DH003', 'P001', 1, 28000000),
('DH003', 'P003', 1, 1500000),
('DH005', 'P005', 1, 22000000);

update products 
set price = price * 1.1 
where nha_san_xuat = 'Apple';

delete from customers 
where phone is null;

select * from products
where price between 10000000 and 20000000;

select name_product
from products
where id_product in (
    select id_product
    from order_detail
    where id_order = 'DH001'
);

select * from customers 
where id_customer in (
    select id_customer 
    from orders 
    where id_order in (
        select id_order 
        from order_detail 
        where id_product in (
            select id_product 
            from products 
            where name_product = 'MacBook Air M2'
        )
    )
);

drop table order_detail;
drop table orders;