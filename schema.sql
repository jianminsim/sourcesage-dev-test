drop table if exists questions;
create table questions (
	id integer primary key autoincrement,
	author text not null,
	text text not null
);
drop table if exists answers;
create table answers (
	id integer primary key autoincrement,
	qn integer not null,
	written_by text not null,
	text text not null
);
