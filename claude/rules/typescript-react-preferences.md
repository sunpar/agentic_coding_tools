---
description: TypeScript/React standards — typing, component patterns, hooks, state management
globs: "**/*.ts,**/*.tsx"
alwaysApply: false
---

# TypeScript / React Preferences

## TypeScript typing
- Strict mode enabled. NEVER weaken `tsconfig.json` compiler options.
- NEVER use `any`. Use `unknown` for external data, specific interfaces for known shapes, generics for varying types, `Record<string, unknown>` at integration boundaries.
- `interface` for extendable object shapes; `type` for unions, intersections, and aliases.
- Annotate all exported function signatures. Let inference handle local variables.
- Prefer named object parameters over positional args for functions with >2 params.
- Make nullability explicit: `T | null` or `T | undefined`.
- Use discriminated unions for multi-state values (idle/loading/success/error), not boolean flags.

## Components — functional only
- NEVER use class components or lifecycle methods. Always functional components + hooks.
- Skip `React.FC`; type props explicitly via `interface` + destructured function params.
- **Max 250 lines per file.** When exceeded, split into sub-components, `use*.ts` hooks, `*.utils.ts`, or `*.types.ts`.

## Presentational vs. logic separation
- **Presentational** (`components/`): receive all data/callbacks via props, no business logic, no data fetching, no state subscriptions. Pure functions of their props.
- **Logic/containers** (`pages/`, `containers/`, `*.container.tsx`): fetch data via React Query, subscribe to state, compose presentational components, handle side effects.

## Hooks
- `useState` for simple local state; `useReducer` for complex local transitions.
- `useMemo`/`useCallback` only with a measured performance need — not preemptively.
- `useEffect` should be rare — most side effects belong in event handlers or React Query mutations.
- Extract reusable stateful logic into `use*` custom hooks (one concern per hook).

## State management — decision tree
1. **Server data?** -> React Query (TanStack Query v5). Type all queries and mutations. Use query key factories. Set `staleTime` >= 5s. Use optimistic updates for instant-feel mutations.
2. **Shared UI state (theme, auth, locale)?** -> Context API. One small typed context per concern. Always provide a guard hook that throws if used outside its provider.
3. **Local to one component?** -> `useState` / `useReducer`.
4. **Complex client workflow (undo/redo, offline drafts, multi-step forms)?** -> MobX State Tree. Keep models flat and small, type with `Instance<typeof Model>`, wrap consumers in `observer`.
5. IMPORTANT: React Query owns server data. NEVER duplicate server data into MST or Context.
