# Cómo escribir briefs de agente

Un brief de agente es un comentario estructurado que se publica en una issue de Jira cuando pasa a `dar-ready-for-agent`. Es la especificación autoritativa con la que trabajará un agente autónomo (AFK). La descripción original de la issue y los comentarios son contexto — el brief del agente es el contrato.

## Principios

### Durabilidad sobre precisión

La issue puede estar en `dar-ready-for-agent` durante días o semanas. El código cambiará mientras tanto. Escribe el brief de forma que siga siendo útil aunque se renombren, muevan o refactoricen archivos.

- **Sí:** describir interfaces, tipos y contratos de comportamiento
- **Sí:** nombrar tipos específicos, firmas de funciones o formas de configuración que el agente deba buscar o modificar
- **No:** referenciar rutas de archivos — quedan obsoletas
- **No:** referenciar números de línea
- **No:** asumir que la estructura de implementación actual se mantendrá igual

### Comportamental, no procedimental

Describe **qué** debe hacer el sistema, no **cómo** implementarlo. El agente explorará el código desde cero y tomará sus propias decisiones de implementación.

- **Bien:** "El `DeliveryShim` debería aceptar un config opcional `hydrationMode`"
- **Mal:** "Abre src/shim/config.ts y añade hydrationMode en la línea 42"

### Criterios de aceptación completos

El agente necesita saber cuándo ha terminado. Todo brief de agente debe tener criterios de aceptación concretos y verificables. Cada criterio debe poder verificarse de forma independiente.

### Límites de alcance explícitos

Indica qué queda fuera de alcance. Esto evita que el agente se pase de rosca o haga suposiciones sobre features adyacentes.

## Plantilla

Publica esto como comentario en Jira:

```
> *Esto fue generado por IA durante el triaje.*

## Brief de agente

**Categoría:** dar-bug / dar-enhancement
**Resumen:** descripción en una línea de lo que hay que hacer

**Comportamiento actual:**
Describir qué pasa ahora. Para bugs, el comportamiento roto.
Para mejoras, el status quo sobre el que se construye.

**Comportamiento deseado:**
Describir qué debería pasar tras el trabajo del agente.
Ser específico con edge cases y condiciones de error.

**Interfaces clave:**
- `NombreDeTipo` — qué necesita cambiar y por qué
- `nombreDeFuncion()` — qué devuelve actualmente vs qué debería devolver
- Forma del config — opciones de configuración nuevas si las hay

**Criterios de aceptación:**
- [ ] Criterio específico y verificable 1
- [ ] Criterio específico y verificable 2
- [ ] Criterio específico y verificable 3

**Fuera de alcance:**
- Cosa que NO debe cambiarse o abordarse en esta issue
- Feature adyacente que parece relacionada pero es independiente
```

## Ejemplos

### Buen brief de agente (bug)

```
> *Esto fue generado por IA durante el triaje.*

## Brief de agente

**Categoría:** dar-bug
**Resumen:** El CSS de los proyectos React no se minifica en el bundle de producción

**Comportamiento actual:**
Los bundles CSS generados por building-config para proyectos React
se sirven sin minificar en producción. Esto afecta a Core Web Vitals
(LCP, FCP) al aumentar innecesariamente el tamaño de transferencia.

**Comportamiento deseado:**
El CSS de producción debe estar minificado. El pipeline de build
debe aplicar cssnano o equivalente en el paso de optimización.

**Interfaces clave:**
- Configuración de webpack/build — el plugin de optimización CSS
  debe estar activo en modo producción
- El output CSS no debe contener whitespace innecesario, comentarios,
  ni propiedades duplicadas

**Criterios de aceptación:**
- [ ] El CSS de producción está minificado (sin comentarios, whitespace mínimo)
- [ ] El CSS de desarrollo sigue sin minificar (legible para debug)
- [ ] Los source maps CSS siguen funcionando correctamente
- [ ] No hay regresiones visuales en los componentes afectados

**Fuera de alcance:**
- Migrar de building-config a otra herramienta
- Optimización de JS bundles (solo CSS)
- Cambios en el pipeline de Less/SASS
```

### Mal brief de agente

```
## Brief de agente

**Resumen:** Arreglar el CSS

**Qué hacer:**
El CSS no va bien. Mira el archivo de webpack y arréglalo.
El loader en la línea 150 tiene el problema.

**Archivos a cambiar:**
- building-config/webpack.prod.js (línea 150)
```

Esto está mal porque: no tiene categoría, descripción vaga ("el CSS no va bien"), referencia rutas de archivos y números de línea que quedarán obsoletos, no hay criterios de aceptación, no hay límites de alcance, no describe comportamiento actual vs deseado.
