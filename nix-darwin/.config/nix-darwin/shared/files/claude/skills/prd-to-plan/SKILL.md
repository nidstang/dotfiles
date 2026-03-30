---
name: prd-to-plan
description: Convierte un PRD en un plan de implementación por fases usando “tracer bullets” (cortes verticales), guardado como un archivo Markdown local en ./plans/. Úsalo cuando el usuario quiera desglosar un PRD, crear un plan de implementación, planificar fases a partir de un PRD, o mencione “tracer bullets”.
---

# PRD a Plan

Divide un PRD en un plan de implementación por fases usando cortes verticales (tracer bullets). El resultado es un archivo Markdown en `./plans/`.

## Proceso

### 1. Confirmar que el PRD está en el contexto

El PRD debería estar ya en la conversación. Si no lo está, pide al usuario que lo pegue o que te indique el archivo.

### 2. Explorar el código base

Si aún no has explorado el código base, hazlo para entender la arquitectura actual, los patrones existentes y las capas de integración.

### 3. Identificar decisiones arquitectónicas duraderas

Antes de dividir en fases, identifica decisiones de alto nivel que probablemente no cambien durante la implementación:

- Estructura de rutas / patrones de URL  
- Forma del esquema de base de datos  
- Modelos de datos clave  
- Enfoque de autenticación / autorización  
- Límites con servicios de terceros  

Estas decisiones van en el encabezado del plan para que cada fase pueda referenciarlas.

### 4. Definir cortes verticales

Divide el PRD en fases tipo **tracer bullet**. Cada fase es un corte vertical fino que atraviesa TODAS las capas de integración de extremo a extremo, NO un corte horizontal de una sola capa.

<vertical-slice-rules>
- Cada corte entrega un camino estrecho pero COMPLETO a través de todas las capas (esquema, API, UI, tests)  
- Un corte completado debe ser demostrable o verificable por sí mismo  
- Prefiere muchos cortes finos en lugar de pocos cortes grandes  
- NO incluyas nombres específicos de archivos, funciones o detalles de implementación que probablemente cambien en fases posteriores  
- SÍ incluye decisiones duraderas: rutas, forma del esquema, nombres de modelos  
</vertical-slice-rules>

### 5. Validar con el usuario

Presenta la propuesta como una lista numerada. Para cada fase muestra:

- **Título**: nombre corto y descriptivo  
- **Historias de usuario cubiertas**: qué historias del PRD aborda  

Pregunta al usuario:

- ¿El nivel de granularidad es adecuado? (demasiado general / demasiado detallado)  
- ¿Alguna fase debería dividirse o combinarse?  

Itera hasta que el usuario apruebe la división.

### 6. Escribir el archivo del plan

Crea `./plans/` si no existe. Escribe el plan como un archivo Markdown nombrado según la funcionalidad (por ejemplo: `./plans/user-onboarding.md`). Usa la siguiente plantilla.

<plan-template>
# Plan: <Nombre de la funcionalidad>

> PRD fuente: <identificador breve o enlace>

## Decisiones arquitectónicas

Decisiones duraderas que aplican a todas las fases:

- **Rutas**: ...
- **Esquema**: ...
- **Modelos clave**: ...
- (añade o elimina secciones según sea necesario)

---

## Fase 1: <Título>

**Historias de usuario**: <lista del PRD>

### Qué construir

Descripción concisa de este corte vertical. Describe el comportamiento de extremo a extremo, no la implementación por capas.

### Criterios de aceptación

- [ ] Criterio 1  
- [ ] Criterio 2  
- [ ] Criterio 3  

---

## Fase 2: <Título>

**Historias de usuario**: <lista del PRD>

### Qué construir

...

### Criterios de aceptación

- [ ] ...

<!-- Repetir para cada fase -->
</plan-template>
