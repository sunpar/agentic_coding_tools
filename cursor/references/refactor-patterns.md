# Refactoring Patterns Reference

Detailed patterns for Python and TypeScript refactoring.

## Python Patterns

### Extract Constant

**Before**:
```python
def calculate_fee(amount):
    return amount * 0.035  # What is 0.035?
```

**After**:
```python
TRANSACTION_FEE_RATE = 0.035

def calculate_fee(amount):
    return amount * TRANSACTION_FEE_RATE
```

### Replace Conditional with Guard Clause

**Before**:
```python
def process_order(order):
    if order is not None:
        if order.is_valid():
            if order.items:
                # actual logic here
                return result
    return None
```

**After**:
```python
def process_order(order):
    if order is None:
        return None
    if not order.is_valid():
        return None
    if not order.items:
        return None
    
    # actual logic here
    return result
```

### Extract Method

**Before**:
```python
def generate_report(data):
    # 50 lines of data validation
    # 30 lines of transformation
    # 40 lines of formatting
    return formatted_report
```

**After**:
```python
def generate_report(data):
    validated = _validate_report_data(data)
    transformed = _transform_for_report(validated)
    return _format_report(transformed)

def _validate_report_data(data): ...
def _transform_for_report(data): ...
def _format_report(data): ...
```

### Replace Dict with Dataclass

**Before**:
```python
def create_user(name, email, age):
    return {"name": name, "email": email, "age": age, "created": datetime.now()}

user = create_user("John", "john@example.com", 30)
print(user["name"])  # No autocomplete, no type checking
```

**After**:
```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    name: str
    email: str
    age: int
    created: datetime = field(default_factory=datetime.now)

user = User("John", "john@example.com", 30)
print(user.name)  # Autocomplete, type checking
```

### Consolidate Conditional Expression

**Before**:
```python
def get_shipping_cost(order):
    if order.is_priority:
        return 0
    if order.total > 100:
        return 0
    if order.customer.is_premium:
        return 0
    return 9.99
```

**After**:
```python
def get_shipping_cost(order):
    if _qualifies_for_free_shipping(order):
        return 0
    return 9.99

def _qualifies_for_free_shipping(order):
    return (
        order.is_priority
        or order.total > 100
        or order.customer.is_premium
    )
```

### Replace Loop with Comprehension

**Before**:
```python
result = []
for item in items:
    if item.is_active:
        result.append(item.name.upper())
```

**After**:
```python
result = [item.name.upper() for item in items if item.is_active]
```

### Use Context Manager

**Before**:
```python
f = open("file.txt")
try:
    data = f.read()
finally:
    f.close()
```

**After**:
```python
with open("file.txt") as f:
    data = f.read()
```

---

## TypeScript/React Patterns

### Extract Custom Hook

**Before**:
```tsx
function UserProfile({ userId }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        setLoading(true);
        fetchUser(userId)
            .then(setUser)
            .catch(setError)
            .finally(() => setLoading(false));
    }, [userId]);

    // ... render logic
}
```

**After**:
```tsx
function useUser(userId: string) {
    const [user, setUser] = useState<User | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    useEffect(() => {
        setLoading(true);
        fetchUser(userId)
            .then(setUser)
            .catch(setError)
            .finally(() => setLoading(false));
    }, [userId]);

    return { user, loading, error };
}

function UserProfile({ userId }) {
    const { user, loading, error } = useUser(userId);
    // ... render logic
}
```

### Replace Inline Conditionals with Early Return

**Before**:
```tsx
function OrderSummary({ order }) {
    return (
        <div>
            {order ? (
                order.items.length > 0 ? (
                    <div>
                        {order.items.map(item => <Item key={item.id} item={item} />)}
                    </div>
                ) : (
                    <EmptyState />
                )
            ) : (
                <Loading />
            )}
        </div>
    );
}
```

**After**:
```tsx
function OrderSummary({ order }) {
    if (!order) {
        return <Loading />;
    }

    if (order.items.length === 0) {
        return <EmptyState />;
    }

    return (
        <div>
            {order.items.map(item => <Item key={item.id} item={item} />)}
        </div>
    );
}
```

### Extract Component

**Before**:
```tsx
function Dashboard() {
    return (
        <div>
            <div className="card">
                <h2>{user.name}</h2>
                <p>{user.email}</p>
                <span className="badge">{user.role}</span>
            </div>
            {/* ... more dashboard content */}
        </div>
    );
}
```

**After**:
```tsx
function UserCard({ user }: { user: User }) {
    return (
        <div className="card">
            <h2>{user.name}</h2>
            <p>{user.email}</p>
            <RoleBadge role={user.role} />
        </div>
    );
}

function Dashboard() {
    return (
        <div>
            <UserCard user={user} />
            {/* ... more dashboard content */}
        </div>
    );
}
```

### Replace any with Proper Types

**Before**:
```tsx
function processData(data: any): any {
    return data.items.map((item: any) => ({
        id: item.id,
        name: item.name,
    }));
}
```

**After**:
```tsx
interface DataItem {
    id: string;
    name: string;
}

interface InputData {
    items: DataItem[];
}

interface OutputItem {
    id: string;
    name: string;
}

function processData(data: InputData): OutputItem[] {
    return data.items.map(item => ({
        id: item.id,
        name: item.name,
    }));
}
```

### Use Object Destructuring

**Before**:
```tsx
function UserDetails(props) {
    return (
        <div>
            <h1>{props.user.name}</h1>
            <p>{props.user.email}</p>
            <span>{props.user.role}</span>
        </div>
    );
}
```

**After**:
```tsx
function UserDetails({ user }: { user: User }) {
    const { name, email, role } = user;
    
    return (
        <div>
            <h1>{name}</h1>
            <p>{email}</p>
            <span>{role}</span>
        </div>
    );
}
```

### Extract Handler Functions

**Before**:
```tsx
function Form() {
    return (
        <form onSubmit={(e) => {
            e.preventDefault();
            validateForm();
            submitData();
            showNotification();
        }}>
            <input onChange={(e) => {
                const value = e.target.value;
                validateField(value);
                updateState(value);
            }} />
        </form>
    );
}
```

**After**:
```tsx
function Form() {
    const handleSubmit = (e: FormEvent) => {
        e.preventDefault();
        validateForm();
        submitData();
        showNotification();
    };

    const handleInputChange = (e: ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        validateField(value);
        updateState(value);
    };

    return (
        <form onSubmit={handleSubmit}>
            <input onChange={handleInputChange} />
        </form>
    );
}
```

---

## Universal Patterns

### Replace Magic String with Constant

**Before**:
```typescript
if (status === "pending_review") { ... }
if (status === "approved") { ... }
if (status === "rejected") { ... }
```

**After**:
```typescript
const OrderStatus = {
    PENDING_REVIEW: "pending_review",
    APPROVED: "approved",
    REJECTED: "rejected",
} as const;

if (status === OrderStatus.PENDING_REVIEW) { ... }
```

### Introduce Explaining Variable

**Before**:
```python
if (user.age >= 18 and user.country in ALLOWED_COUNTRIES 
    and not user.is_banned and user.email_verified):
    allow_access()
```

**After**:
```python
is_adult = user.age >= 18
is_in_allowed_region = user.country in ALLOWED_COUNTRIES
is_account_in_good_standing = not user.is_banned and user.email_verified

if is_adult and is_in_allowed_region and is_account_in_good_standing:
    allow_access()
```

### Remove Dead Code

Look for and remove:
- Commented-out code blocks
- Unused imports
- Unreachable code after returns
- Unused variables
- Unused function parameters
- Functions that are never called
