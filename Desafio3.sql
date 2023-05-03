-- Crear base de datos - Desafio 3 Consultas en Multiples Tablas
CREATE DATABASE desafio3_claudia_leiva_123;

-- Crear tabla Usuarios
CREATE TABLE usuarios (
    id SERIAL,
    email VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    rol VARCHAR
);

-- Insertar datos tabla usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES 
('jorge@mail.com', 'jorge', 'meza', 'administrador'),
('gonzalo@mail.com', 'gonzalo', 'perez', 'usuario'),
('camila@mail.com', 'camila', 'jorquera', 'usuario'),
('rosa@mail.com','rosa', 'malhue', 'usuario'),
('luis@mail.com', 'luis', 'pradenas', 'usuario');

-- Crear tabla posts (articulos)
CREATE TABLE posts (
    id SERIAL,
    titulo VARCHAR(100) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT NOW(),
    destacado BOOLEAN NOT NULL DEFAULT FALSE,
    user_id BIGINT
);

-- Insertar datos tabla posts
INSERT INTO posts (titulo, contenido, fecha_creacion,
fecha_actualizacion, destacado, user_id) VALUES 
('prueba1', 'contenido prueba1', '01/01/2023', '01/02/2023', true, 1),
('prueba2', 'contenido prueba2', '01/03/2023', '01/03/2023', true, 1),
('ejercicios', 'contenido ejercicios', '02/05/2023', '03/04/2023', true, 2),
('ejercicios2', 'contenido ejercicios2', '03/05/2023', '04/04/2023', false, 2),
('random', 'contenido random', '03/06/2023', '04/05/2023', false, null);

-- Crear tabla de comentarios
CREATE TABLE comentarios (
id SERIAL,
contenido TEXT NOT NULL,
fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
user_id BIGINT,
post_id BIGINT
);

-- Insertar datos tabla comentarios
INSERT INTO comentarios (contenido, fecha_creacion, user_id,
post_id) VALUES 
('comentario 1', '03/06/2023', 1, 1),
('comentario 2', '03/06/2023', 2, 1),
('comentario 3', '04/06/2023', 3, 1),
('comentario 4', '04/06/2023', 1, 2);

-- 2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas: nombre e email del usuario junto al título y contenido del post

SELECT usuarios.nombre, usuarios.email, posts.titulo, posts.contenido FROM usuarios INNER JOIN posts ON usuarios.id = posts.user_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente. 

SELECT posts.id, posts.titulo, posts.contenido FROM posts INNER JOIN usuarios ON posts.user_id = usuarios.id WHERE usuarios.rol = 'administrador';  

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id y email del usuario junto con la cantidad de posts de cada usuario

SELECT usuarios.id, usuarios.email, COUNT(posts) FROM posts RIGHT JOIN usuarios ON posts.user_id = usuarios.id GROUP BY usuarios.id, usuarios.email ORDER BY usuarios.id ASC;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT usuarios.email FROM posts JOIN usuarios ON posts.user_id = usuarios.id GROUP BY usuarios.id, usuarios.email ORDER BY COUNT(posts.id) DESC LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario. Utiliza la función de agregado MAX sobre la fecha de creación.

SELECT usuarios.nombre, MAX(posts.fecha_creacion) FROM usuarios INNER JOIN posts ON usuarios.id=posts.user_id GROUP BY usuarios.nombre;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT posts.titulo, posts.contenido FROM posts INNER JOIN comentarios ON posts.id=comentarios.post_id GROUP BY posts.titulo, posts.contenido ORDER BY COUNT(comentarios.post_id) DESC LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT posts.titulo AS titulo_post, posts.contenido AS contenido_post, comentarios.contenido AS contenido_comment, usuarios.email FROM usuarios INNER JOIN comentarios ON usuarios.id=comentarios.user_id INNER JOIN posts ON posts.id=comentarios.post_id;

-- 9. Muestra el contenido del último comentario de cada usuario.

SELECT fecha_creacion, contenido, user_id FROM comentarios WHERE id IN (SELECT MAX(id) FROM comentarios GROUP BY user_id) ORDER BY user_id;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario. Recuerda el Having

SELECT email FROM usuarios LEFT JOIN comentarios ON usuarios.id=comentarios.user_id WHERE comentarios.contenido IS NULL;

\q
