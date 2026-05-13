# Base de conocimiento de fuera de alcance

La base de conocimiento de fuera de alcance almacena registros persistentes de peticiones de features rechazadas para el equipo daredevils. Sirve para dos cosas:

1. **Memoria institucional** — por qué se rechazó una feature, para que el razonamiento no se pierda cuando se cierra la issue
2. **Deduplicación** — cuando llega una nueva issue que coincide con un rechazo previo, se puede recuperar la decisión anterior en lugar de re-debatirla

## Arquitectura: índice en Confluence + detalle en Jira

El sistema tiene dos capas:

### Confluence: el índice

Una única página de Confluence titulada **"Daredevils — Fuera de alcance"** actúa como índice ligero. Contiene una tabla con todos los conceptos rechazados, su label y la issue de referencia donde está la explicación detallada:

```
| Concepto | Label | Issue de referencia |
|----------|-------|---------------------|
| Dark mode / theming | dar-oos-dark-mode | PLATFORM-42 |
| Sistema de plugins | dar-oos-plugin-system | PLATFORM-87 |
```

Esta página es lo único que el agente necesita leer para saber qué se ha rechazado antes. Una sola llamada a Confluence, sin recorrer issues ni comentarios.

### Jira: la fuente de verdad del detalle

La razón completa del rechazo vive en la issue de Jira original, como un comentario estructurado. Esa issue lleva las labels `dar-wontfix`, `dar-enhancement` y la label de concepto `dar-oos-*` correspondiente.

El agente solo lee la issue de referencia si necesita el detalle — por ejemplo, cuando encuentra un match y quiere explicar al mantenedor por qué se rechazó anteriormente.

### Labels de concepto: `dar-oos-*`

Cada concepto rechazado tiene una label con el prefijo `dar-oos-` en kebab-case: `dar-oos-dark-mode`, `dar-oos-plugin-system`, `dar-oos-graphql-api`. El nombre debe ser reconocible sin necesidad de abrir la issue.

Si llegan varias issues pidiendo lo mismo, todas reciben la misma label `dar-oos-*`, lo que permite encontrar todas las solicitudes previas con un JQL directo:

```
project = PLATFORM AND labels = dar-oos-dark-mode
```

## Cuándo consultar

Durante el triaje (Paso 1: Recopilar contexto), lee la página de Confluence "Daredevils — Fuera de alcance" usando `getConfluencePage` o `searchConfluenceUsingCql`. Con la tabla cargada, comprueba si la issue que estás triando coincide con algún concepto.

- La coincidencia es por similitud de concepto, no por palabra clave — "tema nocturno" coincide con "Dark Mode"
- Si hay coincidencia, ve a la issue de referencia a leer la razón, y comunícaselo al mantenedor: "Esto es similar a un rechazo previo en PLATFORM-42 — se rechazó porque [razón]. ¿Sigues pensando lo mismo?"

El mantenedor puede:

- **Confirmar** — la nueva issue recibe las labels `dar-wontfix`, `dar-enhancement` y la `dar-oos-*` correspondiente. Se añade la nueva issue a la tabla de Confluence en la fila existente o como enlace adicional. Se cierra.
- **Reconsiderar** — se procede con el triaje normal. Si el concepto ya no está fuera de alcance, eliminar la fila de la tabla de Confluence y la label `dar-oos-*` de las issues anteriores.
- **Discrepar** — las issues están relacionadas pero son distintas, se procede con el triaje normal.

## Cuándo escribir

Solo cuando una **mejora** (no un bug) se rechaza como `dar-wontfix`. El flujo:

1. El mantenedor decide que una petición de feature está fuera de alcance
2. Lee la tabla de Confluence para comprobar si ya existe el concepto
3. Si ya existe:
   - Aplica las labels `dar-wontfix`, `dar-enhancement` y la `dar-oos-*` existente a la nueva issue
   - Añade la nueva issue a la tabla de Confluence (misma fila, como enlace adicional)
   - Publica un comentario en la nueva issue referenciando la decisión previa
4. Si no existe:
   - Elige un nombre de label `dar-oos-*` descriptivo en kebab-case
   - Aplica las labels `dar-wontfix`, `dar-enhancement` y la nueva `dar-oos-*` a la issue
   - Publica un comentario en la issue con la razón detallada del rechazo
   - Añade una nueva fila a la tabla de Confluence con concepto, label e issue de referencia

## Cómo escribir la razón

La razón (en el comentario de Jira) debe ser sustancial — no "no queremos esto" sino **por qué**. Buenas razones referencian:

- Alcance o filosofía del proyecto ("Este proyecto se centra en X; el theming es responsabilidad del consumidor downstream")
- Restricciones técnicas ("Soportar esto requeriría Y, que entra en conflicto con la arquitectura Z")
- Decisiones estratégicas ("Elegimos usar A en lugar de B porque...")

Evita referenciar circunstancias temporales ("ahora no tenemos tiempo") — eso no es un rechazo real, es un aplazamiento. Un aplazamiento debería quedarse en `dar-needs-triage`, no ir a `dar-wontfix`.
