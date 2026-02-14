---
description: TypeScript and React standards — typing, component architecture, hooks, state management
globs: "**/*.ts,**/*.tsx"
alwaysApply: false
---

# TypeScript and React Preferences

## TypeScript Typing Standards

### Strict Mode, No Exceptions
- TypeScript **strict mode** must be enabled. Never weaken `tsconfig.json` compiler options.
- **Never use `any`**. If you reach for `any`, stop and use one of these instead:
  - `unknown` — for values from external sources that require runtime validation.
  - A specific type or interface — for known shapes.
  - A generic type parameter — when the type varies by call site.
  - `Record<string, unknown>` — for truly dynamic objects at integration boundaries.
- If `any` is genuinely unavoidable, add a `// eslint-disable-next-line` comment with a justification.

### Type Declarations
- Use **`interface`** for object shapes that may be extended or implemented.
- Use **`type`** for unions, intersections, mapped types, and aliases.
- Export types that are part of the public API. Keep internal types unexported.
- Use **discriminated unions** for state machines and multi-state values:
  ```typescript
  type RequestState<T> =
    | { status: 'idle' }
    | { status: 'loading' }
    | { status: 'success'; data: T }
    | { status: 'error'; error: Error };
  ```

### Function Signatures
- **Annotate all exported function signatures** — parameters and return types.
- Allow type inference for local variables and internal implementation details.
- Prefer **named object parameters** over positional arguments for functions with more than two parameters:
  ```typescript
  // Prefer this
  function createUser({ name, email, role }: CreateUserParams): User { ... }
  // Over this
  function createUser(name: string, email: string, role: Role): User { ... }
  ```
- Make **nullability explicit**: use `T | null` or `T | undefined`, never rely on implicit absence.

## React Component Architecture

### Functional Components Only
- **Always use functional components**. Never use class components.
- **Always use hooks**. Never use lifecycle methods (`componentDidMount`, `shouldComponentUpdate`, etc.).
- Do not use `React.FC` unless the project already uses it consistently. Prefer explicit props typing:
  ```typescript
  interface UserCardProps {
    user: User;
    onSelect?: (userId: string) => void;
  }

  function UserCard({ user, onSelect }: UserCardProps) {
    // ...
  }
  ```

### Presentational vs. Logic Components
Separate **what things look like** from **what things do**.

**Presentational components** (`components/`):
- Receive all data and callbacks via props.
- Contain no business logic, no data fetching, no direct state management subscriptions.
- Are pure functions of their props — given the same props, they render the same output.
- Are highly reusable and easy to test.
  ```typescript
  interface TransactionRowProps {
    transaction: Transaction;
    onApprove: (id: string) => void;
  }

  function TransactionRow({ transaction, onApprove }: TransactionRowProps) {
    return (
      <tr>
        <td>{transaction.date}</td>
        <td>{transaction.description}</td>
        <td>{formatCurrency(transaction.amount)}</td>
        <td>
          <Button onClick={() => onApprove(transaction.id)}>Approve</Button>
        </td>
      </tr>
    );
  }
  ```

**Logic components / containers** (`pages/`, `containers/`, or colocated `*.container.tsx`):
- Fetch data (via React Query hooks).
- Subscribe to state (via MobX `observer`, context consumers).
- Compose presentational components and wire them together.
- Handle side effects and user interactions.
  ```typescript
  function TransactionsPage() {
    const { data: transactions, isLoading } = useTransactions();
    const approveMutation = useApproveMutation();

    if (isLoading) return <Skeleton />;

    return (
      <TransactionTable
        transactions={transactions ?? []}
        onApprove={(id) => approveMutation.mutate(id)}
      />
    );
  }
  ```

### File Size Limits
- **Maximum 250 lines per file**. If a component file exceeds this, split it:
  - Extract sub-components into their own files.
  - Move hooks into a colocated `use*.ts` file.
  - Move utility functions into a `*.utils.ts` file.
  - Move types into a `*.types.ts` file.
- This limit applies to all `.ts` and `.tsx` files — not just components.

## Hooks

### Prefer Hooks for Everything
- **`useState`** for simple local UI state (toggle, input value, open/close).
- **`useReducer`** when local state has complex transitions or multiple related values.
- **`useMemo`** and **`useCallback`** only when there is a measured performance need or referential stability requirement (e.g., dependency of another hook). Do not sprinkle them everywhere preemptively.
- **`useEffect`** should be rare. Most side effects belong in event handlers or React Query. If you write a `useEffect`, ask: "Could this be an event handler instead?"

### Custom Hooks
- Extract reusable stateful logic into custom hooks named `use*`.
- Keep custom hooks focused — one concern per hook.
- Place custom hooks in `src/hooks/` for shared hooks or colocated next to the component for single-use hooks.

## State Management

### React Query (TanStack Query v5) — Server State
React Query is the **primary** tool for all server-originated data.
- Every API call should go through a `useQuery` or `useMutation` hook.
- **Type your queries**:
  ```typescript
  const { data, error } = useQuery<Transaction[], ApiError>({
    queryKey: ['transactions', accountId],
    queryFn: () => fetchTransactions(accountId),
  });
  ```
- Define **typed query key factories**:
  ```typescript
  const transactionKeys = {
    all: ['transactions'] as const,
    byAccount: (id: string) => ['transactions', id] as const,
  };
  ```
- Use `staleTime` >= 5000ms to avoid excessive refetching.
- Use **optimistic updates** for mutations that should feel instant.
- Place query hooks in `src/hooks/` or colocated `useQueries.ts` files.
- Never duplicate server data into MobX State Tree or other client state.

### Context API — Shared UI State
- Use React Context for **cross-cutting UI concerns**: theme, locale, auth session, toast notifications.
- Keep contexts small and focused. One context per concern.
- Always provide a **typed context** with a sensible default or a guard hook:
  ```typescript
  const AuthContext = createContext<AuthState | null>(null);

  function useAuth(): AuthState {
    const ctx = useContext(AuthContext);
    if (!ctx) throw new Error('useAuth must be used within AuthProvider');
    return ctx;
  }
  ```
- Do not store server-fetched data in Context — that belongs in React Query.

### MobX State Tree (MST) — Complex Client State (Limited Use)
- Use MST **only** for complex client-side state that React Query and Context cannot handle cleanly: multi-step workflows, undo/redo, offline drafts, or cross-component form state.
- MST should **not** own server data. Server data lives in React Query's cache.
- Keep MST models small and well-typed:
  ```typescript
  const UiStore = types
    .model('UiStore', {
      sidebarOpen: types.optional(types.boolean, true),
      activeTab: types.optional(types.string, 'overview'),
    })
    .actions((self) => ({
      toggleSidebar() {
        self.sidebarOpen = !self.sidebarOpen;
      },
      setActiveTab(tab: string) {
        self.activeTab = tab;
      },
    }));
  ```
- Use `Instance<typeof ModelName>` for typing MST instances in components.
- Wrap consuming components in `observer` from `mobx-react-lite`.
- Avoid deep MST model hierarchies. Prefer flat stores with references.

### State Decision Tree
1. **Is it server data?** -> React Query.
2. **Is it shared UI state (theme, auth, locale)?** -> Context API.
3. **Is it local to one component?** -> `useState` / `useReducer`.
4. **Is it complex client workflow state?** -> MobX State Tree.
5. **If in doubt** -> Start with React Query or local state. Promote to Context or MST only when needed.
