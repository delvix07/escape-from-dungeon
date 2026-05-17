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

Para colocar una reja que desaparece cuando muere un enemigo específico:
1. Arrastra `dungeon_grate.tscn` a tu nivel.
2. En tu nivel, asegúrate de tener colocado al enemigo (ej: `Rat`).
3. Selecciona la reja. En el **Inspector**, busca la variable `Enemy Trigger` y haz clic en "Asignar". Selecciona al enemigo (`Rat`) en la lista de nodos.
4. *Mecánica:* Cuando ese enemigo muera, la reja desaparecerá automáticamente. No se requiere código adicional.

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
4. Asigna la `Escena Premio` (ej: un cofre) que aparecerá al completar la secuencia.
