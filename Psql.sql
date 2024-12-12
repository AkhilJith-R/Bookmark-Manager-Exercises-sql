-- Database: Bookmark_Manager_Exercise

-- DROP DATABASE IF EXISTS "Bookmark_Manager_Exercise";

CREATE DATABASE "Bookmark_Manager_Exercise"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;








CREATE TABLE users ( 
	id INT PRIMARY KEY, 
	name VARCHAR(100), 
	email VARCHAR(100) 
	);

	INSERT INTO users (id, name, email) 
	VALUES (1, 'Alice', 'alice@example.com'), 
		   (2, 'Bob', 'bob@example.com'), 
		   (3, 'Charlie', 'charlie@example.com');

SELECT * FROM users;

CREATE TABLE collections ( 
	id INT PRIMARY KEY, 
	name VARCHAR(100), 
	owner_id INT, 
	FOREIGN KEY (owner_id) REFERENCES users(id) 
	);

INSERT INTO collections (id, name, owner_id) 
VALUES (1, 'Development Resources', 1), 
		(2, 'Design Inspiration', 2);
	

SELECT * FROM collections;

CREATE TABLE bookmarks ( id INT PRIMARY KEY, 
	title VARCHAR(100), 
	url VARCHAR(100), 
	tags VARCHAR(100), 
	collection_id INT, 
	creator_id INT, 
	created_at DATE, 
	FOREIGN KEY (collection_id) REFERENCES collections(id), 
	FOREIGN KEY (creator_id) REFERENCES users(id) 
	);

	INSERT INTO bookmarks (id, title, url, tags, collection_id, creator_id, created_at)
	VALUES (1, 'JavaScript', 'https://javascript.com', 'JavaScript, Web Development', 1, 1, '2024-11-12'), 
		   (2, 'CSS ', 'https://css.com', 'CSS, Web Design', 1, 1, '2024-11-15'),
		   (3, 'REACT', 'https://react.com', 'Frame,work', 2, 2, '2024-12-01'),
		   (4, 'Development Resources','developmentResources.com','resource,development',2,2,'2024-12-05');
		   

SELECT * FROM bookmarks;

CREATE TABLE shares (
	share_id SERIAL PRIMARY KEY,
	collection_id INT references collections(id) NOT NULL,
	shared_with_user_id INT references users(id) NOT NULL,
	share_date date NOT NULL
);

INSERT INTO shares 
VALUES (1, 1, 2, '2024-12-05'),
	   (2, 2, 3, '2024-12-06');


SELECT * FROM shares;


--Answer -1
SELECT title, url, tags
FROM bookmarks
WHERE title = 'Development Resources';


--Answer -2
SELECT tags, COUNT(tags) AS usage_count
FROM bookmarks
GROUP BY tags
ORDER BY usage_count DESC
LIMIT 10;


--Answer-3
SELECT c.name AS collection_name, u.email AS owner_email, COUNT(b.id) AS bookmark_count, COUNT(s.user_id) AS share_count
FROM collections c
JOIN users u ON c.owner_id = u.id
JOIN bookmarks b ON c.id = b.collection_id
JOIN shares s ON c.id = s.collection_id
WHERE s.collection_id IS NOT NULL
GROUP BY c.name, u.email
HAVING COUNT(s.user_id) > 0;

--Answer-4
SELECT u.name
FROM users u
INNER JOIN bookmarks b
	ON b.id = u.id
LEFT JOIN shares s
	ON s.shared_with_user_id = u.id
WHERE s.share_date > current_date - interval '30 days'
OR b.created_at > current_date - interval '30 days'
GROUP BY u.name







