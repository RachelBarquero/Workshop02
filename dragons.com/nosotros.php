<?php
declare(strict_types=1);

ini_set('display_errors', '1');
error_reporting(E_ALL);

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/includes/layout.php';

$equipo = [
    ['Valeria Drakos', 'Fundadora & Guardiana del Nido', '👩‍💼', 'Convirtió su colección privada de figuras míticas en una tienda para fans de todas las edades.'],
    ['Héctor Ember', 'Director Creativo', '🎨', 'Diseña cada criatura para que tenga presencia, detalle y mucha personalidad.'],
    ['Lucía Storm', 'Curadora de Colecciones', '📚', 'Selecciona líneas exclusivas y ediciones limitadas para coleccionistas exigentes.'],
    ['Mateo Flint', 'Logística', '🚚', 'Se asegura de que cada dragón llegue protegido, puntual y listo para rugir.'],
];

$valores = [
    ['🔥', 'Imaginación', 'Creemos en piezas que despiertan historias, mundos y aventuras.'],
    ['🛡️', 'Calidad', 'Trabajamos con acabados premium y detalles cuidados en cada figura.'],
    ['🌋', 'Pasión', 'Cada colección nace del entusiasmo real por la fantasía y el diseño.'],
    ['🤝', 'Comunidad', 'Queremos reunir a fans, coleccionistas y curiosos en un mismo reino.'],
];

render_header('Nosotros', 'nosotros');
?>
<section class="hero">
    <div class="container hero__inner">
        <div>
            <span class="eyebrow">Nuestra historia</span>
            <h1>Forjamos leyendas para coleccionistas</h1>
            <p>Los Dragones nació en 2018 como una pequeña colección curada de criaturas fantásticas. Hoy reunimos figuras, accesorios y ediciones especiales para quienes quieren llevar un poco de mito y fuego a su espacio.</p>
        </div>
        <div class="hero__art" aria-hidden="true">🏰</div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="grid grid--2">
            <div class="card">
                <h2>Nuestra misión</h2>
                <p>Crear una tienda especializada en dragones coleccionables donde cada pieza se sienta épica, bien presentada y digna de exhibición. Queremos que abrir un pedido se sienta como descubrir un tesoro.</p>
            </div>
            <div class="card">
                <h2>Nuestra visión</h2>
                <p>Ser una referencia para fans de la fantasía en habla hispana, reconocida por su curaduría, la experiencia de compra y una identidad visual que se aleje de lo genérico.</p>
            </div>
        </div>
    </div>
</section>

<section class="section" style="background:#fff;">
    <div class="container">
        <div class="section__head">
            <span class="eyebrow">Lo que nos mueve</span>
            <h2>Nuestros valores</h2>
        </div>
        <div class="grid grid--3">
            <?php foreach ($valores as [$icono, $titulo, $texto]): ?>
                <div class="card feature">
                    <span class="feature__icon"><?= e($icono) ?></span>
                    <h3><?= e($titulo) ?></h3>
                    <p><?= e($texto) ?></p>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="section__head">
            <span class="eyebrow">El clan</span>
            <h2>Conoce al equipo</h2>
        </div>
        <div class="grid grid--3">
            <?php foreach ($equipo as [$nombre, $rol, $emoji, $bio]): ?>
                <div class="card feature">
                    <span class="feature__icon"><?= e($emoji) ?></span>
                    <h3><?= e($nombre) ?></h3>
                    <p class="muted" style="font-weight:700;color:var(--fire-dark);"><?= e($rol) ?></p>
                    <p><?= e($bio) ?></p>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="account-grid">
            <div class="stat text-center"><div class="stat__value">8</div><div class="stat__label">años creando leyendas</div></div>
            <div class="stat text-center"><div class="stat__value">90+</div><div class="stat__label">dragones y criaturas</div></div>
            <div class="stat text-center"><div class="stat__value">18k</div><div class="stat__label">pedidos enviados</div></div>
            <div class="stat text-center"><div class="stat__value">97%</div><div class="stat__label">clientes recurrentes</div></div>
        </div>
    </div>
</section>
<?php
render_footer();<?php
declare(strict_types=1);

ini_set('display_errors', '1');
error_reporting(E_ALL);

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/includes/layout.php';

$equipo = [
    ['Valeria Drake', 'Fundadora y maestra de vuelo', '👩‍🚀', 'Convirtió su colección privada de criaturas míticas en una tienda para otros fanáticos del reino.'],
    ['Iker Ember', 'Director de forja creativa', '🎨', 'Diseña cada línea legendaria con acabados dramáticos y mucho detalle en alas y escamas.'],
    ['Lucía Storm', 'Guardiana de la comunidad', '🤝', 'Se asegura de que cada cliente encuentre el dragón ideal para su colección.'],
    ['Gael Pyre', 'Logística dracónica', '🚚', 'Protege cada envío con embalaje premium para que llegue intacto a su nueva guarida.'],
];

$valores = [
    ['🔥', 'Pasión', 'Creamos piezas que transmiten aventura, carácter y presencia desde el primer vistazo.'],
    ['🛡️', 'Calidad', 'Elegimos materiales duraderos y acabados detallados para coleccionistas exigentes.'],
    ['🌌', 'Imaginación', 'Cada dragón cuenta una historia y abre la puerta a nuevos mundos.'],
    ['🤝', 'Comunidad', 'Queremos que cada cliente se sienta parte de un clan de coleccionistas.'],
];

render_header('Nosotros', 'nosotros');
?>
<section class="hero">
    <div class="container hero__inner">
        <div>
            <span class="eyebrow">Nuestra historia</span>
            <h1>Forjamos criaturas para colecciones memorables</h1>
            <p>Los Dragones nació en 2018 como un proyecto de coleccionistas obsesionados con la fantasía. Hoy seguimos con la misma idea: crear una tienda donde cada pieza se sienta legendaria desde que abres la caja.</p>
        </div>
        <div class="hero__art" aria-hidden="true">🏰</div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="grid grid--2">
            <div class="card">
                <h2>Nuestra misión</h2>
                <p>Llevar figuras y accesorios de dragones con identidad propia a coleccionistas que buscan piezas con diseño, carácter y excelente presentación.</p>
            </div>
            <div class="card">
                <h2>Nuestra visión</h2>
                <p>Ser la tienda de referencia para fans de la fantasía épica en habla hispana, reconocida por su curaduría, calidad y experiencia de compra.</p>
            </div>
        </div>
    </div>
</section>

<section class="section" style="background:#fff;">
    <div class="container">
        <div class="section__head">
            <span class="eyebrow">Lo que nos mueve</span>
            <h2>Nuestros valores</h2>
        </div>
        <div class="grid grid--3">
            <?php foreach ($valores as [$icono, $titulo, $texto]): ?>
                <div class="card feature">
                    <span class="feature__icon"><?= e($icono) ?></span>
                    <h3><?= e($titulo) ?></h3>
                    <p><?= e($texto) ?></p>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="section__head">
            <span class="eyebrow">El clan</span>
            <h2>Conoce al equipo</h2>
        </div>
        <div class="grid grid--3">
            <?php foreach ($equipo as [$nombre, $rol, $emoji, $bio]): ?>
                <div class="card feature">
                    <span class="feature__icon"><?= e($emoji) ?></span>
                    <h3><?= e($nombre) ?></h3>
                    <p class="muted" style="font-weight:700;color:var(--fire-dark);"><?= e($rol) ?></p>
                    <p><?= e($bio) ?></p>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="account-grid">
            <div class="stat text-center"><div class="stat__value">8</div><div class="stat__label">años de historia</div></div>
            <div class="stat text-center"><div class="stat__value">60+</div><div class="stat__label">dragones curados</div></div>
            <div class="stat text-center"><div class="stat__value">18k</div><div class="stat__label">coleccionistas felices</div></div>
            <div class="stat text-center"><div class="stat__value">99%</div><div class="stat__label">clientes recurrentes</div></div>
        </div>
    </div>
</section>
<?php
render_footer();