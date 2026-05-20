# Guía de Mecánicas Reutilizables (Level Design)

Esta guía documenta cómo utilizar las mecánicas programadas en el juego para armar niveles fácilmente sin necesidad de programar.

## 1. Cofre con Recompensas (`CofreItem`)
**Escena:** `scenes/items/objects/chest.tscn`

Para colocar un cofre que suelta un objeto:
1. Arrastra `chest.tscn` a tu nivel.
2. En el **Inspector**, busca la sección `Content` (Contenido) y asigna un recurso de tipo `ItemData`.
   * *Ejemplo: Asigna `res://scripts/items/sword.tres` para que el cofre contenga la espada.*
3. **Eventos Locales**: El cofre tiene una señal llamada `chest_opened()`. Puedes conectarla desde la pestaña **Nodos** a un `Spawner` en tu nivel para hacer aparecer enemigos cuando el jugador lo abra.

## 2. Reja del Calabozo (`DungeonGrate`)
**Escena:** `scenes/levels/dungeon_grate.tscn`

Para colocar una reja que bloquea el paso y desaparece al derrotar a una oleada o grupo de enemigos (emboscada):
1. Arrastra `dungeon_grate.tscn` a tu nivel.
2. Asegúrate de tener colocados uno o más nodos `EnemySpawner` en tu nivel.
3. Selecciona la reja. En el **Inspector**, busca la variable `Spawner Triggers` (un Array). Aumenta su tamaño y asígnale los nodos `EnemySpawner` que deben ser derrotados para abrir la reja.
4. *Mecánica:* La reja contará automáticamente cuántos spawners le has asignado. A medida que los enemigos creados por esos spawners vayan muriendo, llevará la cuenta. La reja desaparecerá y liberará el paso **únicamente cuando todos los enemigos vinculados hayan sido derrotados**. No requiere programación adicional.

## 3. Items y la Interfaz HUD
**Recursos:** `ItemData.gd`

* Cada ítem del juego (Armas, Pociones, Escudos) se crea en la pestaña del sistema de archivos haciendo clic derecho -> "Crear Nuevo Recurso" -> `ItemData`.
* Puedes configurar su nombre, descripción, icono y sonido directamente en el Inspector del recurso.
* Al obtenerlo (ej: desde un cofre), el juego se pausará automáticamente y mostrará la interfaz `ItemPopupUI.tscn` con el sonido asignado.

## 4. Puzzles de Secuencia (`ButtonPuzzleManager`)
**Escena:** `scenes/puzzles/button_puzzle_manager.tscn`

1. Arrastra el manager al nivel.
2. Configura el array `Secuencia Correcta` en el Inspector.
3. Agrega nodos `VentanaInteractiva` como *hijos* del manager. El script se conectará automáticamente a ellos.
4. Asigna la `Escena Premio` (ej: la escena genérica de un cofre) que aparecerá al completar la secuencia.
5. Asigna en `Contenido Premio` un recurso de tipo `ItemData` (ej: espada.tres). El manager inyectará automáticamente este ítem dentro del cofre al ganar el puzzle.
6. Opcional: Asigna nodos en `Spawners Al Abrir`. Cuando el jugador abra el cofre, el manager activará automáticamente esos spawners.

**Comportamiento de las Ventanas:**
* Al presionar una ventana, su cartel (`prompt_sprite`) se oculta y no se puede volver a presionar en el mismo intento.
* Si el jugador falla la secuencia, todas las ventanas se reinician y vuelven a estar disponibles.
* Si la secuencia es correcta, todas las ventanas se desactivan de forma permanente y ya no muestran carteles.

## 5. Spawner de Enemigos (`EnemySpawner`)
**Script:** `scripts/levels/enemy_spawner.gd` (Añádelo a un nodo `Marker2D`)

Este nodo sirve para crear enemigos en una posición específica, con la posibilidad de demorar su aparición de manera inteligente.
1. Crea un nodo `Marker2D` en tu nivel y llámalo `EnemySpawner`.
2. Arrástrale el script `enemy_spawner.gd`.
3. Configura `Enemy Scene` con la escena del enemigo (ej: `rat.tscn`).
4. Configura `Spawn Delay` con los segundos a esperar antes de que aparezca.
   > [!TIP]
   > Este tiempo **se detiene automáticamente** cuando el juego está en pausa (por ejemplo, cuando hay un popup de ítem abierto en pantalla).

---

## 🛠 Ejemplo Práctico: Secuencia "Puzzle -> Cofre (Espada) -> Trampa de Rata"
Si quieres armar la típica emboscada donde al tomar la espada de un cofre (luego de un puzzle) aparece una rata:

1. **Configura el Puzzle y el Cofre**:
   * Coloca tu `ButtonPuzzleManager` y sus ventanas en el nivel.
   * En `Escena Premio` arrastra tu cofre genérico.
   * En `Contenido Premio` arrastra tu recurso `sword.tres`.
2. **Prepara la Trampa (Spawner)**:
   * Crea un nodo `Marker2D` en el lugar donde quieres que aparezca la rata. Asígnale el script `enemy_spawner.gd`.
   * En `Enemy Scene`, arrastra `rat.tscn`.
   * En `Spawn Delay`, ponle `1.0` (o el tiempo que quieras).
3. **Conecta todo**:
   * Selecciona tu `ButtonPuzzleManager`.
   * En la sección del Inspector llamada `Spawners Al Abrir`, aumenta el tamaño del arreglo a 1.
   * Selecciona "Assign" o arrastra tu nodo `EnemySpawner` hacia ese espacio.
   
**Resultado en el juego:** El jugador resuelve el puzzle. Aparece el cofre. El jugador abre el cofre, recibe la espada y el juego se pausa mostrando el cartel de "Has conseguido una Espada". El contador de la trampa *aún no ha empezado*. Cuando el jugador presiona interactuar para cerrar el cartel y equiparse la espada, el juego se reanuda y 1 segundo después... ¡aparece la rata en la ubicación marcada!

## 6. Iluminación y Sombras (Dynamic 2D Lighting)
**Nodos Clave:** `CanvasModulate`, `PointLight2D`, `LightOccluder2D`

El sistema de visión (o "Line of Sight") funciona oscureciendo la pantalla y permitiendo que ciertas entidades la iluminen:

1. **Oscuridad Global:** El nodo `CanvasModulate` en el nivel (ej. `level_1.tscn`) tiñe todo de gris oscuro (`Color(0.12, 0.12, 0.12)`).
2. **Fuentes de Luz:** El jugador tiene un `PointLight2D` configurado con una `GradientTexture2D`. Esto perfora la oscuridad del `CanvasModulate`.
3. **Sombras:** Al activar `shadow_enabled = true` en la luz, los obstáculos en el nivel bloquean la luz.

### Guía Paso a Paso: Configurar Sombras en las Paredes (TileMapLayer) en Godot 4.6

Para que las paredes bloqueen la luz del jugador y proyecten sombras realistas, debes configurar *Light Occluders* en el conjunto de tiles (TileSet):

1. **Abre tu escena del nivel** (ej: `level_1.tscn`) y selecciona el nodo `TileMapWalls` (de tipo `TileMapLayer`).
2. En el panel inferior de Godot, haz clic en la pestaña **TileSet** (asegúrate de no estar en "TileMap").
3. En las opciones de la derecha (Inspector), asegúrate de que tu `TileSet` tenga habilitada una capa de **Occlusion Layer**. 
   * *Si no la tiene:* Haz clic en la propiedad `TileSet`, despliega **Occlusion Layers**, haz clic en "Add Element" (Agregar elemento). Deja el valor de "Light Mask" en 1.
4. Vuelve a la pestaña inferior **TileSet**, haz clic en la sección **Paint** (Pintar) en la barra de herramientas del panel.
5. En el menú desplegable "Paint Properties", selecciona **Occlusion Layer 0**.
6. Abajo, en la cuadrícula de tus texturas, selecciona las paredes que quieres que bloqueen la luz.
7. Haz clic en el Tile en el Tileset. Verás un polígono rojo o morado. Puedes usar las herramientas de la barra del TileSet (añadir puntos, borrar puntos, ajustar el cuadrado) para dibujar exactamente qué parte de ese Tile debe bloquear la luz.
8. Una vez pintados, cualquier luz con `shadow_enabled = true` rebotará contra esas paredes generando una penumbra realista detrás.
