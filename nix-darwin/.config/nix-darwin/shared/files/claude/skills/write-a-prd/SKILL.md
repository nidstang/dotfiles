---
name: write-a-prd
description: Crea un PRD del plan. Úsalo cuando el usuario quiera redactar un PRD, crear un documento de requisitos de producto o planificar una nueva funcionalidad.
---

Esta skill se activará cuando el usuario quiera crear un PRD a partir de un plan que habéis ido trabajando juntos.

Debes de seguir ete template:

<prd-template>

## Problema

El problema al que se enfrenta el usuario, desde su perspectiva.

## Solución

La solución al problema, desde la perspectiva del usuario.

## Historias de usuario

Una lista LARGA y numerada de historias de usuario. Cada historia debe seguir el formato:

1. Como <actor>, quiero <funcionalidad>, para <beneficio>

<user-story-example>
1. Como cliente de banca móvil, quiero ver el saldo de mis cuentas, para poder tomar decisiones más informadas sobre mis gastos
</user-story-example>

Esta lista debe ser muy extensa y cubrir todos los aspectos de la funcionalidad.

## Decisiones de implementación

Una lista de decisiones tomadas durante la implementación. Puede incluir:

- Los módulos que se construirán o modificarán  
- Las interfaces de esos módulos que se modificarán  
- Aclaraciones técnicas del desarrollador  
- Decisiones arquitectónicas  
- Cambios en el esquema  
- Contratos de API  
- Interacciones específicas  

NO incluyas rutas de archivos específicas ni fragmentos de código, ya que pueden quedar obsoletos rápidamente.

## Decisiones de testing

Una lista de decisiones sobre testing. Incluye:

- Qué define un buen test (probar comportamiento externo, no detalles de implementación)  
- Qué módulos serán testeados  
- Referencias existentes (tests similares en el código base)  

## Fuera de alcance

Descripción de lo que queda fuera del alcance de este PRD.

## Notas adicionales

Cualquier nota adicional sobre la funcionalidad.

</prd-template>
