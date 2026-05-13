---
name: dar-agent
description: Ejecutar tareas de Jira que estén listas para agente autónomo (label dar-ready-for-agent) en el proyecto PLATFORM del equipo daredevils. Usa esta skill cuando el usuario pida ejecutar una tarea, implementar una issue, trabajar en lo que haya pendiente para agente, o diga cosas como "ejecuta lo que haya ready-for-agent", "implementa PLATFORM-XXXX", "coge la siguiente tarea", "ponte a currar". También se activa si el usuario pregunta "qué puedo implementar" o "hay algo listo para agente".
---

# Daredevils Agent Executor

Implementar issues del proyecto PLATFORM (equipo: daredevils) que tengan la label `dar-ready-for-agent`. El agente trabaja de forma autónoma en un monorepo con acceso completo a terminal, git y herramientas de desarrollo.

## Contexto

- **Atlassian Cloud ID:** `2e3f60f0-6b80-4388-93bd-d94c92c7d19d`
- **Proyecto:** PLATFORM (key: `PLATFORM`)
- **Campo de equipo:** `cf[11052]` (valor: `daredevils`)
- **Repositorio:** Monorepo, directorio de trabajo: `idealista.com.static`
- **Convención de ramas:** `feature/PLATFORM-XXXX-descripcion-corta`
- **Entorno de ejecución:** Siempre en un **worktree de git** y un **sandbox de Claude Code** (una issue = un worktree = un sandbox aislado)

## Invocación

El mantenedor puede pedir:

- "Ejecuta la siguiente tarea ready-for-agent"
- "Implementa PLATFORM-12974"
- "¿Qué hay listo para implementar?"
- "Ponte con lo siguiente"

## Seleccionar las issues

### Si el mantenedor indica una issue concreta

Léela con `getJiraIssue`. Comprueba que tiene la label `dar-ready-for-agent`. Si no la tiene, avisa al mantenedor y no procedas — una issue sin esa label no ha pasado el triaje y no tiene brief de agente.

Ejecuta solo esa issue.

### Si el mantenedor NO indica una issue concreta

Busca **todas** las issues ready-for-agent con JQL:

```
project = PLATFORM AND cf[11052] = daredevils AND labels = dar-ready-for-agent ORDER BY priority DESC, created ASC
```

Ejecuta el flujo completo para **cada una de ellas**, una por una. Cada issue se implementa en su propio worktree y sandbox aislado (ver paso 3). Cuando termines una, pasa a la siguiente sin esperar confirmación.

## Flujo de ejecución

### 1. Leer el brief de agente

Lee la issue completa incluyendo comentarios. Localiza el comentario que contiene el **brief de agente** (empieza con el disclaimer "*Esto fue generado por IA durante el triaje.*" y tiene la sección "Brief de agente"). Ese comentario es tu contrato — es lo que define qué hay que hacer, el comportamiento deseado, las interfaces clave, los criterios de aceptación y los límites de alcance.

Si no hay brief de agente, **para y avisa al mantenedor**. No intentes implementar una issue sin brief — vuelve al flujo de triaje.

### 2. Explorar el código

Antes de tocar nada, entiende el terreno:

- Lee los criterios de aceptación del brief — son tu definición de "terminado"
- Busca las interfaces, tipos y funciones mencionadas en el brief
- Entiende la estructura del monorepo relevante para esta issue
- Identifica los tests existentes relacionados
- Lee los límites de alcance — lo que NO debes tocar

**No asumas la estructura del código por el brief.** El brief describe comportamientos e interfaces, no ubicaciones. Explora el repo tú mismo.

### 3. Entorno de trabajo

El agente se ejecuta dentro de un worktree temporal y un sandbox de Claude Code, lanzados por el script `dar-agent.sh`. El worktree ya está creado y apuntando a main cuando la skill arranca — no es necesario crear ramas ni worktrees manualmente.

El agente debe:

1. Crear la rama de feature desde el worktree temporal:

```bash
git checkout -b feature/PLATFORM-XXXX-descripcion-corta
```

2. Trabajar siempre dentro del directorio `idealista.com.static` del worktree.

La descripción corta debe ser en kebab-case, derivada del resumen del brief. Ejemplo: `feature/PLATFORM-12974-fix-css-minification`.

### 4. Implementar

Trabaja de forma iterativa:

- Haz cambios pequeños y coherentes
- Ejecuta los tests existentes frecuentemente para no romper nada
- Si el brief menciona edge cases, asegúrate de cubrirlos
- Si necesitas crear tests nuevos, hazlo — los criterios de aceptación del brief suelen implicar qué debe testearse
- Haz commits atómicos con mensajes descriptivos que referencien la issue:

```
fix(platform): minificar CSS en producción

Añade cssnano al pipeline de optimización de webpack para proyectos React.
El CSS de desarrollo sigue sin minificar para facilitar el debug.

Refs: PLATFORM-12974
```

### 5. Verificar los criterios de aceptación

Antes de dar por terminado, repasa **cada criterio de aceptación** del brief uno por uno:

- [ ] ¿Se cumple? ¿Cómo lo verifico?
- [ ] ¿Hay test que lo cubra?
- [ ] ¿He tocado algo fuera de alcance?

Si algún criterio no se puede cumplir por razones técnicas que no estaban en el brief, **no sigas inventando** — documéntalo y repórtalo al mantenedor.

### 6. Ejecutar los checks

Desde el directorio `idealista.com.static` del worktree, ejecuta los checks en este orden:

```bash
# Instalar dependencias
make deps

# Checks de código (linting, formato)
make check

# Verificación de tipos (precommit)
make typecheck-precommit

# Tests
make test
```

**Los cuatro deben pasar.** Si alguno falla:

- Si el fallo es por tu cambio → arréglalo antes de continuar
- Si el fallo es preexistente (ya fallaba en main) → documéntalo en la PR pero no lo arregles (fuera de alcance)

### 7. Crear la PR

Haz push de la rama y crea la PR:

```bash
git push origin feature/PLATFORM-XXXX-descripcion-corta
```

La PR debe incluir:

**Título:** `[PLATFORM-XXXX] Descripción concisa del cambio`

**Cuerpo:**

```markdown
## Qué hace esta PR

Descripción breve de los cambios realizados y por qué.

## Issue de referencia

PLATFORM-XXXX

## Criterios de aceptación verificados

- [x] Criterio 1 — cómo se verificó
- [x] Criterio 2 — cómo se verificó
- [x] Criterio 3 — cómo se verificó

## Notas para el reviewer

Cualquier decisión de implementación que merezca explicación,
trade-offs elegidos, o cosas que el reviewer debería mirar con atención.
```

Asigna la PR al mantenedor como reviewer.

### 8. Actualizar Jira

Una vez creada la PR:

1. **Añade un comentario** en la issue de Jira con el enlace a la PR y un resumen de lo implementado:

```
> *Esto fue generado por IA durante la implementación.*

## Implementación completada

**PR:** [enlace a la PR]
**Rama:** feature/PLATFORM-XXXX-descripcion-corta

**Resumen de cambios:**
- Cambio 1
- Cambio 2

**Criterios de aceptación:**
- [x] Criterio 1
- [x] Criterio 2

**Decisiones de implementación:**
- Decisión relevante y por qué se tomó
```

2. **Actualiza las labels:** elimina `dar-ready-for-agent` y añade `dar-in-review`. Recuerda preservar las demás labels existentes.

3. **Transiciona la issue** al estado **"Pendiente de aprobación"** (consulta las transiciones con `getTransitionsForJiraIssue` para obtener el ID correcto antes de transicionar).

El worktree temporal se limpia automáticamente al salir del sandbox (gestionado por `dar-agent.sh`).

## Cuándo parar y preguntar

El agente **debe detenerse** y consultar al mantenedor si:

- **No hay brief de agente** en la issue
- **El brief es ambiguo** — hay varias formas de interpretar un criterio de aceptación
- **El cambio afecta a algo fuera de alcance** — el brief dice que no lo toques pero parece necesario
- **Los tests existentes fallan** por razones no relacionadas con tu cambio
- **Necesitas acceso externo** — APIs, credenciales, servicios que no están en el repo
- **El cambio es significativamente mayor** de lo que sugiere el brief — probablemente falte contexto
- **Hay un conflicto de arquitectura** — lo que pide el brief choca con cómo está construido el código actualmente

En cualquiera de estos casos, explica el problema al mantenedor con contexto suficiente para que pueda tomar una decisión. No adivines ni inventes soluciones que se salgan del brief.

## Lo que el agente NO debe hacer

- **No refactorizar código adyacente** que funciona, aunque "se pueda mejorar"
- **No actualizar dependencias** salvo que el brief lo pida explícitamente
- **No cambiar configuración de CI/CD, linters o formatters**
- **No crear issues nuevas** — si detecta problemas, los reporta al mantenedor
- **No modificar el brief de agente** — es un contrato, no un borrador
- **No hacer force push** a la rama una vez creada la PR
