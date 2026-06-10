-- =========================================================
-- Base de datos demo para losdragones
-- Tienda ficticia de dragones coleccionables "Los Dragones"
-- Requisitos: MySQL 8+ o MariaDB 10.5+
-- =========================================================

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS losdragones
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'losdragones_app'@'localhost'
IDENTIFIED BY 'L0sDrag0nesApp!';

GRANT SELECT, INSERT, UPDATE, DELETE
ON losdragones.*
TO 'losdragones_app'@'localhost';

FLUSH PRIVILEGES;

USE losdragones;

CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(30) NULL,
    direccion VARCHAR(255) NULL,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_usuarios_correo (correo),
    UNIQUE KEY uk_usuarios_usuario (usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS categorias (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    slug VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255) NULL,
    UNIQUE KEY uk_categorias_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria_id BIGINT UNSIGNED NULL,
    nombre VARCHAR(120) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    descripcion TEXT NULL,
    precio DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    emoji VARCHAR(16) NOT NULL DEFAULT '🐉',
    imagen VARCHAR(255) NULL,
    color_hex VARCHAR(7) NOT NULL DEFAULT '#C0392B',
    stock INT NOT NULL DEFAULT 0,
    destacado TINYINT(1) NOT NULL DEFAULT 0,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_productos_slug (slug),
    KEY idx_productos_categoria (categoria_id),
    CONSTRAINT fk_productos_categoria FOREIGN KEY (categoria_id)
        REFERENCES categorias (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedidos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    estado ENUM('pendiente', 'pagado', 'enviado', 'cancelado') NOT NULL DEFAULT 'pendiente',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_pedidos_codigo (codigo),
    KEY idx_pedidos_usuario (usuario_id),
    CONSTRAINT fk_pedidos_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedido_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NULL,
    nombre_producto VARCHAR(120) NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    KEY idx_items_pedido (pedido_id),
    KEY idx_items_producto (producto_id),
    CONSTRAINT fk_items_pedido FOREIGN KEY (pedido_id)
        REFERENCES pedidos (id) ON DELETE CASCADE,
    CONSTRAINT fk_items_producto FOREIGN KEY (producto_id)
        REFERENCES productos (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS resenas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    producto_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    calificacion TINYINT UNSIGNED NOT NULL DEFAULT 5,
    comentario VARCHAR(500) NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_resenas_producto (producto_id),
    KEY idx_resenas_usuario (usuario_id),
    UNIQUE KEY uk_resena_usuario_producto (producto_id, usuario_id),
    CONSTRAINT fk_resenas_producto FOREIGN KEY (producto_id)
        REFERENCES productos (id) ON DELETE CASCADE,
    CONSTRAINT fk_resenas_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS articulos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(180) NOT NULL,
    slug VARCHAR(180) NOT NULL,
    resumen VARCHAR(300) NULL,
    contenido TEXT NULL,
    autor VARCHAR(120) NOT NULL DEFAULT 'Equipo Los Dragones',
    emoji VARCHAR(16) NOT NULL DEFAULT '📜',
    fecha_publicacion DATE NOT NULL,
    UNIQUE KEY uk_articulos_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mensajes_contacto (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    asunto VARCHAR(150) NOT NULL,
    mensaje VARCHAR(2000) NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO usuarios (nombre, correo, usuario, password_hash, telefono, direccion, estado)
VALUES
    (
        'Valeria Drakos',
        'valeria@losdragones.com',
        'vdrakos',
        '$2y$12$sgB26XB7./IOSK9MAQKBJ.OwMM8JCTNJMXOAIZB1bTauyQBHsmtBi',
        '+506 8888 1234',
        'Torre del Fuego 88, San José',
        'activo'
    ),
    (
        'Hector Ember',
        'hector@losdragones.com',
        'hember',
        '$2y$12$LQGfWXcUY54iyD.efq6KyuARzBX9hWyeo6oPbdtm6ihbUT3tizfQ6',
        '+506 8777 5678',
        'Valle de Ceniza 45, Heredia',
        'activo'
    )
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    password_hash = VALUES(password_hash);

INSERT INTO categorias (id, nombre, slug, descripcion)
VALUES
    (1, 'Clásicos', 'clasicos', 'Dragones esenciales con siluetas icónicas y gran presencia visual.'),
    (2, 'Legendarios', 'legendarios', 'Ediciones especiales inspiradas en reinos, volcanes y cielos eternos.'),
    (3, 'Packs', 'packs', 'Sets pensados para empezar o expandir una colección.'),
    (4, 'Accesorios', 'accesorios', 'Bases, iluminación y extras para exhibir tus criaturas.')
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion);

INSERT INTO productos (categoria_id, nombre, slug, descripcion, precio, emoji, imagen, color_hex, stock, destacado)
VALUES
    (1, 'Dragon Carmesi', 'dragon-carmesi',
     'Una figura clásica de alas extendidas, pose desafiante y acabado rojo intenso. Perfecta para iniciar cualquier colección.',
     24.99, '🐉', NULL, '#C0392B', 35, 1),
    (1, 'Dragon Esmeralda', 'dragon-esmeralda',
     'Escamas verdes, cuernos curvos y una base rocosa que le da presencia en escritorio o vitrina.',
     26.50, '🐲', NULL, '#2ECC71', 28, 1),
    (2, 'Dragon del Volcan', 'dragon-del-volcan',
     'Una pieza con alas negras y grietas anaranjadas que evocan lava viva. Ideal para exhibiciones dramáticas.',
     39.90, '🌋', NULL, '#E67E22', 18, 1),
    (2, 'Dragon Celestial', 'dragon-celestial',
     'Inspirado en constelaciones y cielos nocturnos, con detalles azules y reflejos metalizados.',
     41.00, '🌌', NULL, '#5DADE2', 14, 1),
    (2, 'Dragon de Hielo', 'dragon-de-hielo',
     'Tonos fríos, cristales translúcidos y postura elegante para colecciones de fantasía invernal.',
     38.75, '❄️', NULL, '#85C1E9', 12, 0),
    (2, 'Dragon Sombra', 'dragon-sombra',
     'Diseño oscuro y minimalista con acabado mate. Una de las piezas favoritas del catálogo nocturno.',
     37.25, '🌑', NULL, '#1A1A2E', 16, 0),
    (3, 'Pack Guardianes del Reino', 'pack-guardianes-del-reino',
     'Set de tres dragones complementarios pensado para exhibiciones grupales con mucha presencia.',
     79.99, '🏰', NULL, '#7D3C98', 10, 1),
    (3, 'Pack Crias Elementales', 'pack-crias-elementales',
     'Cuatro mini dragones inspirados en fuego, aire, agua y tierra. Excelente como regalo.',
     32.00, '🥚', NULL, '#F5B041', 22, 0),
    (4, 'Base Runica LED', 'base-runica-led',
     'Base de exhibicion con luz tenue y grabado runico para resaltar cualquier pieza premium.',
     18.90, '💡', NULL, '#F4D03F', 25, 1),
    (4, 'Pedestal Obsidiana', 'pedestal-obsidiana',
     'Soporte sobrio y pesado para destacar dragones medianos o grandes sin distracciones.',
     16.75, '🪨', NULL, '#566573', 20, 0)
ON DUPLICATE KEY UPDATE
    descripcion = VALUES(descripcion),
    precio = VALUES(precio),
    emoji = VALUES(emoji),
    imagen = VALUES(imagen),
    stock = VALUES(stock),
    destacado = VALUES(destacado);

INSERT INTO resenas (producto_id, usuario_id, calificacion, comentario)
VALUES
    (1, 1, 5, 'Excelente pieza para empezar una colección. Tiene mucha presencia sin ser exagerada.'),
    (3, 2, 5, 'El acabado volcánico está muy bien logrado y la base se siente estable.'),
    (4, 1, 4, 'Muy bonito en persona. Ganaría aún más con una base iluminada.'),
    (9, 2, 5, 'La base LED cambia por completo la exhibición. Muy recomendada.')
ON DUPLICATE KEY UPDATE
    calificacion = VALUES(calificacion),
    comentario = VALUES(comentario);

INSERT INTO articulos (titulo, slug, resumen, contenido, autor, emoji, fecha_publicacion)
VALUES
    ('5 razones para empezar una colección de dragones',
     '5-razones-coleccion-dragones',
     'Diseño, narrativa y presencia visual: por qué los dragones funcionan tan bien como pieza de colección.',
     'Coleccionar dragones tiene algo especial. Primero, cada pieza suele contar una historia propia: volcánica, celestial, ancestral o salvaje. Segundo, su silueta es poderosa y llena muy bien una vitrina o escritorio. Tercero, existen estilos para todos los gustos, desde interpretaciones oscuras hasta propuestas más elegantes y luminosas. Cuarto, combinan muy bien con accesorios de exhibición como bases, luces y fondos temáticos. Y quinto, son piezas que despiertan conversación: incluso alguien que no colecciona suele detenerse a mirarlas. En Los Dragones creemos que una gran figura puede cambiar por completo un espacio.',
     'Valeria Drakos', '🔥', '2026-01-15'),
    ('Como exhibir tus dragones sin recargar el espacio',
     'como-exhibir-tus-dragones',
     'Consejos simples para que tu colección se vea potente, limpia y coherente.',
     'La clave para exhibir dragones está en la composición. Empieza por definir un protagonista y construye alrededor con piezas secundarias de menor escala. Usa alturas distintas mediante pedestales o bases para que la colección tenga ritmo visual. Evita saturar una sola repisa: dejar aire entre figuras hace que cada una respire mejor. Si trabajas con iluminación, elige tonos cálidos para piezas volcánicas y tonos fríos para criaturas celestiales o de hielo. Por último, intenta agrupar por familia visual, color o narrativa. Una colección ordenada se siente mucho más imponente.',
     'Hector Ember', '📚', '2026-02-10'),
    ('Novedad: llega el Dragon del Volcan',
     'novedad-dragon-del-volcan',
     'Una de nuestras figuras más intensas hasta ahora: lava, alas oscuras y una pose lista para atacar.',
     'Estamos presentando una de las piezas más esperadas de la temporada: el Dragon del Volcan. Se trata de una figura con acabado oscuro y grietas anaranjadas que simulan lava viva, pensada para destacar incluso en vitrinas muy cargadas. Su pose tiene mucha energía y funciona especialmente bien sobre bases iluminadas. Forma parte de nuestra línea Legendarios y llega en unidades limitadas. Si buscas una pieza central para tu colección, este lanzamiento apunta exactamente a eso.',
     'Equipo Los Dragones', '🌋', '2026-05-20')
ON DUPLICATE KEY UPDATE
    resumen = VALUES(resumen),
    contenido = VALUES(contenido);-- =========================================================
-- Base de datos demo para losdragones
-- Tienda ficticia de dragones coleccionables "Los Dragones"
-- Requisitos: MySQL 8+ o MariaDB 10.5+
-- =========================================================

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS losdragones
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'losdragones_app'@'localhost'
IDENTIFIED BY 'L0sDrag0nesApp!';

GRANT SELECT, INSERT, UPDATE, DELETE
ON losdragones.*
TO 'losdragones_app'@'localhost';

FLUSH PRIVILEGES;

USE losdragones;

CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(30) NULL,
    direccion VARCHAR(255) NULL,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_usuarios_correo (correo),
    UNIQUE KEY uk_usuarios_usuario (usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS categorias (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    slug VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255) NULL,
    UNIQUE KEY uk_categorias_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS productos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria_id BIGINT UNSIGNED NULL,
    nombre VARCHAR(120) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    descripcion TEXT NULL,
    precio DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    emoji VARCHAR(16) NOT NULL DEFAULT '🐉',
    imagen VARCHAR(255) NULL,
    color_hex VARCHAR(7) NOT NULL DEFAULT '#C0392B',
    stock INT NOT NULL DEFAULT 0,
    destacado TINYINT(1) NOT NULL DEFAULT 0,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_productos_slug (slug),
    KEY idx_productos_categoria (categoria_id),
    CONSTRAINT fk_productos_categoria FOREIGN KEY (categoria_id)
        REFERENCES categorias (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedidos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT UNSIGNED NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    estado ENUM('pendiente', 'pagado', 'enviado', 'cancelado') NOT NULL DEFAULT 'pendiente',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_pedidos_codigo (codigo),
    KEY idx_pedidos_usuario (usuario_id),
    CONSTRAINT fk_pedidos_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedido_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NULL,
    nombre_producto VARCHAR(120) NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    KEY idx_items_pedido (pedido_id),
    KEY idx_items_producto (producto_id),
    CONSTRAINT fk_items_pedido FOREIGN KEY (pedido_id)
        REFERENCES pedidos (id) ON DELETE CASCADE,
    CONSTRAINT fk_items_producto FOREIGN KEY (producto_id)
        REFERENCES productos (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS resenas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    producto_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    calificacion TINYINT UNSIGNED NOT NULL DEFAULT 5,
    comentario VARCHAR(500) NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_resenas_producto (producto_id),
    KEY idx_resenas_usuario (usuario_id),
    UNIQUE KEY uk_resena_usuario_producto (producto_id, usuario_id),
    CONSTRAINT fk_resenas_producto FOREIGN KEY (producto_id)
        REFERENCES productos (id) ON DELETE CASCADE,
    CONSTRAINT fk_resenas_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS articulos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(180) NOT NULL,
    slug VARCHAR(180) NOT NULL,
    resumen VARCHAR(300) NULL,
    contenido TEXT NULL,
    autor VARCHAR(120) NOT NULL DEFAULT 'Equipo Los Dragones',
    emoji VARCHAR(16) NOT NULL DEFAULT '📜',
    fecha_publicacion DATE NOT NULL,
    UNIQUE KEY uk_articulos_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mensajes_contacto (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    asunto VARCHAR(150) NOT NULL,
    mensaje VARCHAR(2000) NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO usuarios (nombre, correo, usuario, password_hash, telefono, direccion, estado)
VALUES
    (
        'Valeria Drakos',
        'valeria@losdragones.com',
        'vdrakos',
        '$2y$12$sgB26XB7./IOSK9MAQKBJ.OwMM8JCTNJMXOAIZB1bTauyQBHsmtBi',
        '+506 8888 1234',
        'Torre del Fuego 88, San José',
        'activo'
    ),
    (
        'Hector Ember',
        'hector@losdragones.com',
        'hember',
        '$2y$12$LQGfWXcUY54iyD.efq6KyuARzBX9hWyeo6oPbdtm6ihbUT3tizfQ6',
        '+506 8777 5678',
        'Cumbre Escarlata 45, Heredia',
        'activo'
    )
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    password_hash = VALUES(password_hash);

INSERT INTO categorias (id, nombre, slug, descripcion)
VALUES
    (1, 'Guardianes', 'guardianes', 'Dragones nobles y protectores, ideales para una colección clásica.'),
    (2, 'Legendarios', 'legendarios', 'Ediciones especiales con diseños épicos y tiradas limitadas.'),
    (3, 'Packs', 'packs', 'Sets temáticos para armar una exhibición completa.'),
    (4, 'Accesorios', 'accesorios', 'Bases, pedestales y extras para resaltar cada criatura.'),
    (5, 'Volcánicos', 'volcanicos', 'Modelos inspirados en lava, fuego y alas forjadas en ceniza.')
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion);

INSERT INTO productos (categoria_id, nombre, slug, descripcion, precio, emoji, imagen, color_hex, stock, destacado)
VALUES
    (1, 'Dragón Guardián Carmesí', 'dragon-guardian-carmesi',
     'Figura clásica de gran porte con alas abiertas, cuernos curvos y acabado en rojo profundo. Ideal para iniciar una colección heroica.',
     24.99, '🐉', NULL, '#C0392B', 25, 1),
    (1, 'Dragón Lunar Plateado', 'dragon-lunar-plateado',
     'Una criatura elegante de tonos fríos, pensada para vitrinas con estética nocturna y fantástica.',
     27.50, '🌙', NULL, '#95A5A6', 18, 1),
    (2, 'Dragón Rey Obsidiana', 'dragon-rey-obsidiana',
     'Edición legendaria en negro mate con detalles dorados y postura de trono. Pieza central para cualquier colección.',
     39.90, '🖤', NULL, '#1A1A2E', 10, 1),
    (2, 'Dragón Tempestad Azul', 'dragon-tempestad-azul',
     'Escamas azules, relámpagos grabados y una silueta dinámica que transmite velocidad y poder aéreo.',
     34.75, '⚡', NULL, '#2980B9', 14, 1),
    (5, 'Dragón Magma Colosal', 'dragon-magma-colosal',
     'Modelo imponente de inspiración volcánica con grietas luminosas y textura de roca fundida.',
     42.00, '🌋', NULL, '#E67E22', 8, 1),
    (5, 'Wyvern de Ceniza', 'wyvern-de-ceniza',
     'Figura estilizada de alas largas y acabado gris oscuro, perfecta para colecciones de tono sombrío.',
     22.40, '🪽', NULL, '#5D6D7E', 21, 0),
    (3, 'Pack Linaje Dracónico', 'pack-linaje-draconico',
     'Set de tres dragones complementarios para montar una escena completa de nido, guardia y vuelo.',
     68.90, '🐲', NULL, '#8E44AD', 6, 1),
    (4, 'Pedestal de Runa Antigua', 'pedestal-runa-antigua',
     'Base de exhibición con grabados rúnicos y acabado piedra, diseñada para realzar figuras medianas y grandes.',
     14.95, '🪨', NULL, '#7F8C8D', 30, 0),
    (4, 'Soporte Aéreo Transparente', 'soporte-aereo-transparente',
     'Accesorio discreto para mostrar dragones en posición de vuelo sin robar protagonismo a la figura.',
     9.80, '✨', NULL, '#D5DBDB', 40, 0),
    (2, 'Dragón Emperador Dorado', 'dragon-emperador-dorado',
     'Acabado dorado envejecido y pose ceremonial. Una de las piezas más llamativas del catálogo.',
     44.50, '👑', NULL, '#D4AC0D', 7, 1)
ON DUPLICATE KEY UPDATE
    descripcion = VALUES(descripcion),
    precio = VALUES(precio),
    emoji = VALUES(emoji),
    imagen = VALUES(imagen),
    stock = VALUES(stock),
    destacado = VALUES(destacado);

INSERT INTO resenas (producto_id, usuario_id, calificacion, comentario)
VALUES
    (1, 1, 5, 'Tiene una presencia brutal en la vitrina. El acabado rojo se ve mejor en persona.'),
    (3, 2, 5, 'La figura más imponente de mi colección. Muy bien resuelta la base.'),
    (4, 1, 4, 'Excelente diseño, aunque me gustaría una versión aún más grande.'),
    (7, 2, 5, 'El pack vale totalmente la pena si quieres montar una escena completa.')
ON DUPLICATE KEY UPDATE
    calificacion = VALUES(calificacion),
    comentario = VALUES(comentario);

INSERT INTO articulos (titulo, slug, resumen, contenido, autor, emoji, fecha_publicacion)
VALUES
    ('Como empezar una coleccion de dragones sin comprar al azar',
     'como-empezar-coleccion-dragones',
     'Una guia practica para construir una coleccion coherente desde la primera pieza.',
     'Empezar una coleccion de dragones puede ser emocionante, pero conviene definir una direccion antes de comprar. Algunas personas prefieren una linea clasica de guardianes y otras apuestan por piezas oscuras, volcanicas o legendarias. Elegir una paleta, una escala y un tipo de pose ayuda a que la vitrina tenga identidad. Tambien es buena idea alternar una pieza protagonista con accesorios o modelos de apoyo. En Los Dragones recomendamos comenzar con una figura que marque el tono del reino y despues sumar variaciones que lo expandan sin perder coherencia.',
     'Valeria Drakos', '🐉', '2026-02-14'),
    ('Cinco claves para exhibir figuras fantasticas con mejor presencia',
     'claves-para-exhibir-figuras-fantasticas',
     'Iluminacion, alturas y composicion para que cada dragon tenga un lugar digno.',
     'La exhibicion cambia por completo la percepcion de una figura. Primero, usa diferentes alturas para evitar una fila plana y sin profundidad. Segundo, deja espacio negativo alrededor de la pieza principal para que respire. Tercero, si el modelo tiene alas abiertas o colas largas, orientalo para aprovechar la silueta. Cuarto, combina bases o pedestales con materiales neutros. Y quinto, trabaja la iluminacion lateral o calida para realzar texturas y relieves. Un buen montaje puede hacer que un dragon mediano se vea monumental.',
     'Equipo Los Dragones', '🔥', '2026-03-10'),
    ('Por que las ediciones legendarias se agotan tan rapido',
     'por-que-las-ediciones-legendarias-se-agotan',
     'Detras de las tiradas cortas, los acabados especiales y la demanda de coleccionistas.',
     'Las ediciones legendarias se producen en cantidades mas pequeñas, suelen incorporar acabados exclusivos y generan mucha expectativa antes de su lanzamiento. Cuando una pieza combina una buena silueta, una paleta potente y un personaje reconocible, se convierte rapido en la favorita del catalogo. Por eso conviene seguir el blog y revisar lanzamientos con anticipacion. Las mejores piezas no solo decoran: definen colecciones enteras.',
     'Hector Ember', '📜', '2026-04-22'),
    ('Novedad: llega la linea volcanica con texturas de magma',
     'novedad-linea-volcanica',
     'Presentamos una nueva familia de criaturas con acabados inspirados en lava y ceniza.',
     'La nueva linea volcanica fue creada para quienes buscan figuras con energia visual inmediata. Cada modelo combina tonos oscuros con grietas anaranjadas y texturas inspiradas en roca fundida. El resultado son piezas dramaticas, perfectas para vitrinas con iluminación cálida o fondos oscuros. Esta familia ya está disponible en catálogo y será una de las más expansivas del año.',
     'Equipo Los Dragones', '🌋', '2026-05-28')
ON DUPLICATE KEY UPDATE
    resumen = VALUES(resumen),
    contenido = VALUES(contenido);