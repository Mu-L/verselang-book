# Unreleased Features

Features documented in the book but marked as not yet released.

- [ ] **`first` expressions** — `docs/07_control.md:800`
- [ ] **`first` (failure context)** — `docs/08_failure.md:122`
- [ ] **Live Variables** — `docs/15_live_variables.md:3` (entire chapter)
- [ ] **Sticky Events** — `docs/14_concurrency.md:1583`
- [ ] **Subscribable Events** — `docs/14_concurrency.md:1626`
- [ ] **Nested Functions** — `docs/06_functions.md:1205`
- [ ] **Automatic Qualification** — `docs/16_modules.md:952`
- [ ] **`<predicts>` effect** — `docs/13_effects.md:425`

---

# ~~`<castable>` vs Dynamic Cast: Documentation Discrepancy~~ ✅ COMPLETED

**Status:** Fixed and documented

The book previously implied that casting a non-`<castable>` object would fail, but tests showed that dynamic casting works on all classes/interfaces. The documentation has been updated to clearly distinguish the two separate systems.

## What Was Fixed

### Updated Documentation Files:

1. **`docs/10_classes_interfaces.md`** (Castable section, lines 3169-3465)
   - ✅ Added section explaining dynamic casting works WITHOUT `<castable>`
   - ✅ Added section explaining when `<castable>` IS needed (for `castable_subtype`)
   - ✅ Added example showing cast without `<castable>` (snippet 114a)
   - ✅ Added example showing `castable_subtype` usage (snippet 114b)
   - ✅ Added comparison table showing the two systems
   - ✅ Enhanced parametric casting restrictions section with clear examples

2. **`docs/11_types.md`** (Class and Interface Casting section, lines 278-290)
   - ✅ Updated introduction to clarify `<castable>` not required for basic casting
   - ✅ Updated `castable_subtype` section to explain it's only for type constraints

### The Two Systems (Now Clearly Documented):

| Feature | Requires `<castable>`? | Checked when? | Example |
|---------|---------------------|--------------|---------|
| `Type[instance]` dynamic cast | **No** | Runtime | `derived[base_ref]` |
| `Type(value)` infallible cast | **No** | Compile time | `base(derived_value)` |
| `castable_subtype(Type)` constraint | **Yes** | Compile time | `Func(T:castable_subtype(base))` |

### Key Points Now Documented:

- ✅ All classes/interfaces support dynamic casting regardless of `<castable>`
- ✅ `<castable>` only required for `castable_subtype` type constraints
- ✅ `castable_subtype` enables types as first-class values (pass as parameters, store in variables)
- ✅ Parametric types cannot be `<castable>` (error 3678)
- ✅ Cannot cast to parametric types (error 3502)
- ✅ Concrete instantiations of parametric types CAN be cast targets

### Tests:
- ✅ All documentation snippets tested and passing
- ✅ New test created: `Tests/FlowControl/BreakNotAllowedInConcurrentArms.versetest`

**Note:** Item 4 "Document the FN 37.00 version gate" was intentionally skipped per user request.

---

# Documentation Coverage TODO

Gaps identified by comparing new/changed test files against docs/.

## Significant Gaps

### Bitwise operations (BitAnd, BitOr, BitXor, BitNot)
- **Test**: Tests/Math/Bitwise.versetest
- [ ] BitAnd, BitOr, BitXor, BitNot intrinsic functions are completely undocumented
- Available at FN 42.00+
- Operate on int, reject float/NaN
- Support bignum (beyond 2^64) on Verse VM

### Union type former
- **Test**: Tests/Union.versetest
- [ ] `union` type with named variants, variant construction (`u.Variant(value)`), case matching, exhaustiveness checking, recursive unions, void variants
- Currently `epic_internal` only (not available to creator packages)
- 776 lines of tests, no docs coverage

### `<final>` on interface and struct members
- **Test**: Tests/Attributes/final.versetest
- [ ] Docs cover `<final>` on classes but not on interface or struct members
- `<final>` rejected on interface/struct types (3596) but allowed on their members
- `<final>` interface members must supply a body/value (3673)
- Finality propagates through interface inheritance chains
- `<final>` on interface field blocks archetype override

### concrete_subtype and castable_concrete_subtype
- **Test**: Tests/Castable.versetest
- [ ] Only `castable_subtype` is documented
- `concrete_subtype` (FN 37.00+) and `castable_concrete_subtype` (FN 40.00+) are undocumented
- Below their introduction version they silently downgrade to plain `subtype`

## Moderate Gaps

### Effects on interfaces
- **Test**: Tests/Effects.versetest
- [ ] Interfaces accept `<computes>`, `<reads>`, `<allocates>`, `<writes>`, `<transacts>`
- Interfaces reject `<suspends>` and `<decides>` (same as classes/structs)
- Effect inheritance: subtypes can widen but not narrow effects across interface edges
- Docs cover effects on classes but not explicitly on interfaces

### @deprecated details
- **Test**: Tests/Attributes/deprecated.versetest
- [ ] `@deprecated{Message := "..."}` form with custom messages is undocumented
- `DiscontinuedAtFNVersion` field (warning below cutoff, hard error at/above) is undocumented
- @deprecated on modules is undocumented

### @experimental module propagation
- **Test**: Tests/Attributes/experimental.versetest
- [ ] @experimental on a module propagates to all members transitively
- Does NOT propagate up to enclosing module
- Using/importing an experimental module counts as use of experimental

### Join() for localized messages
- **Test**: Tests/LocalizationJoin.versetest
- [ ] `Join(Items:[]message, Separator:message):message` function is undocumented

## Minor Gaps

### `<abstract>` rejected on interfaces and structs
- **Test**: Tests/Attributes/abstract.versetest
- [ ] Docs imply abstract is for classes but don't explicitly state it's invalid on interfaces/structs (error 3596)

### `<concrete>` rejected on interfaces
- **Test**: Tests/Attributes/concrete.versetest
- [ ] `<concrete>` on interfaces gives error 3596
- Cross-module concrete inheritance from abstract base is now valid (was error 3632)

### Default values waive constructor-accessibility requirement
- **Test**: Tests/Classes/AccessSpecifiers.versetest
- [ ] A protected/private member with a default value doesn't need to be as accessible as the constructor

### Delegating constructors capturing Self
- **Test**: Tests/Classes/Constructor.versetest
- [ ] Delegating constructor calls that reference Self implicitly and explicitly

### Qualified method override with multiple interfaces
- **Test**: Tests/Classes/QualifiedMethodInheritance.versetest
- [ ] Override one of two same-named interface methods; the other retains its default via qualified call

### int as subtype of rational
- **Test**: Tests/IntAsRational.versetest
- [ ] int flows into rational; Floor/Ceil on integer-valued rationals return the integer; equality works

### `<override>` required when redeclaring inherited data members
- **Test**: Tests/InterfaceWithFields.versetest
- [ ] Both interface->interface and class->interface redeclaration require `<override>` (error 3532)

### Mutable fields in parametric interfaces
- **Test**: Tests/ParametricFunctions.versetest
- [ ] var fields in parametric interfaces now valid at FN 40.00+

### JSON serialization format change for optionals
- **Test**: Tests/PersonaJson.versetest
- [ ] Optional types now use `"nullable":true` instead of `any_of` with `BOOLEAN`

### `<localizes>` messages in interfaces
- **Test**: Tests/Localization.versetest
- [ ] Interface fields can now use `<localizes>`

### String interpolation with custom operator+
- **Test**: Tests/StringInterpolationPlus.versetest
- [ ] When ToString returns a non-string type and operator+ is defined, string interpolation calls ToString then operator+

## No Gap (internal tooling, bug fixes, cosmetic changes)

These tests don't require documentation updates:

- Tests/Attributes/available.versetest - internal @available version gating
- Tests/Attributes/export_metadata.versetest - internal publishing metadata
- Tests/Bugs/FORT-779858 - crash fix regression test
- Tests/Bugs/FORT-793952 - case-insensitive name collision (known issue)
- Tests/Bugs/SOL-5386 - copyright only
- Tests/CanCallerAccessEpicInternal/* - internal Epic API
- Tests/Coroutines/Concurrency.versetest - autortfm-retry guard
- Tests/Coroutines/SpawnAndTask.versetest - autortfm-retry guard
- Tests/DebugStackTrace/* - internal debugging intrinsic
- Tests/DigestGeneration.versetest - cosmetic comment additions
- Tests/LengthOptimizationSafety.versetest - internal codegen test
- Tests/NativeDeepMutability.versetest - .Length on native fields
- Tests/PersistentJsonSnapshot.versetest - idempotency test
- Tests/PersistentJsonSnapshotMacro.versetest - test infrastructure macro
- Tests/PrintScriptCallstack.versetest - internal debugging
- Tests/Subtype.versetest - cosmetic formatting
- Tests/Versions/FN40.00/* - version-gated enforcement
- Tests/generators.versetest - FN version downgrade behavior
- Tests/Interfaces/AccessSpecifiers.versetest - re-enabled tests, epic_internal rules
