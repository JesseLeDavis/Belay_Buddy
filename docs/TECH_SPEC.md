# Belay Buddy — Technical Architecture Spec

_Last updated: March 2026 | Flutter 3.24.5 / Dart 3.7_

---

## Table of Contents

1. [Current State Assessment](#1-current-state-assessment)
2. [Architecture Recommendation](#2-architecture-recommendation)
3. [Dependency Injection](#3-dependency-injection)
4. [State Management Deep Dive](#4-state-management-deep-dive)
5. [Data Layer](#5-data-layer)
6. [Navigation](#6-navigation)
7. [Missing Features — Technical Approach](#7-missing-features--technical-approach)
8. [Testing Strategy](#8-testing-strategy)
9. [pubspec.yaml Changes](#9-pubspecyaml-changes)
10. [Migration Plan](#10-migration-plan)

---

## 1. Current State Assessment

### What's Good

**Models are excellent.** All four Freezed models (`AppUser`, `Crag`, `ClimbingPost`, `Message`/`Conversation`) are well-designed. Immutability via Freezed, JSON serialization via `json_serializable`, sensible defaults with `@Default(...)`, and appropriate nullable fields. The `Conversation.isReadByUser` using `Map<String, bool>` is the right Firestore-native approach. No rework needed here.

**FirestoreService is solid raw material.** CRUD coverage is comprehensive. The `sendMessage` method correctly uses a batch write (line 210) to atomically update both the message subcollection and the conversation document. The `getOrCreateConversation` pattern (line 171) with sorted participant IDs prevents duplicate conversations. The bounds-filtered crag query (line 62) correctly acknowledges the Firestore lat/lng limitation and does the longitude filter in memory — well-commented.

**Theme is production-worthy.** The olive/orange/tan palette with Material 3 and both light/dark themes is immediately shippable. `CardTheme` centralized means no per-widget style duplication.

**go_router is already wired.** Shell is there; just needs proper auth guards and additional routes.

**CreatePostScreen demonstrates correct Riverpod usage.** Reading providers at submit time with `ref.read(...)` (line 70, 97) rather than `ref.watch` is exactly right for event handlers.

---

### What's Problematic

**`main.dart` — auth bypass is a landmine (line 28).**
```dart
initialLocation: '/map', // TEMP: Bypass auth to preview UI
```
This is committed code that skips authentication entirely. The `redirect` callback (line 29–32) is a no-op. The `AuthGate` widget (lines 103–140) works correctly via `WidgetsBinding.instance.addPostFrameCallback`, but it's never reachable because `initialLocation` skips it. When real users sign up, they'll hit the map unauthenticated, which will crash any provider that reads `currentUserIdProvider`.

**`currentUserIdProvider` reads FirebaseAuth directly without reactivity.**
```dart
// lib/providers/firestore_providers.dart, line 14
final currentUserIdProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.uid;
});
```
This is a `Provider` (not `StreamProvider`), so it reads the auth state once at creation time and never updates. If a user signs in after the provider is first accessed, any downstream provider that `ref.watch(currentUserIdProvider)` will not rebuild. This causes silent failures — `userPostsProvider` returns an empty stream forever after login.

**`cragProvider` is a `StreamProvider.family` that doesn't actually stream (line 34).**
```dart
final cragProvider = StreamProvider.family<Crag?, String>((ref, cragId) async* {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final crag = await firestoreService.getCrag(cragId);
  yield crag;  // yields once and closes
});
```
This converts a `Future` into a one-shot stream using `async*`. It works but it's semantically wrong — no live updates on crag changes. Should be a `FutureProvider.family` or should call `firestoreService.cragStream(cragId)` if real-time crag updates are desired. Currently `FirestoreService` has no `cragStream` method (it has `cragsStream` for all crags).

**`LoginScreen` calls Firebase directly (line 34, 39).**
```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(...)
await FirebaseAuth.instance.signInWithEmailAndPassword(...)
```
Firebase is accessed as a static singleton from the UI layer. This makes the screen untestable and violates separation of concerns. After successful sign-up, there's no user profile creation in Firestore — `AppUser` documents are never written for new users, so `currentUserProvider` will return `null` indefinitely for fresh signups.

**`MapScreen._signOut()` calls FirebaseAuth directly (line 48).**
Same issue — Firebase coupled into the widget. Sign-out should be a service call, not a UI concern.

**`PostCard` makes N individual Firestore reads per render (line 29).**
```dart
final userAsync = ref.watch(userByIdProvider(post.userId));
```
`userByIdProvider` is a `FutureProvider.family` that issues a Firestore `getUser` read for every card rendered. On a crag with 20 posts, this fires 20 separate reads on every build cycle. It also won't show updated user names. Needs either a cache layer or a batch-fetch provider.

**`FirestoreService` has no error handling.** Every method throws raw Firestore exceptions directly to callers. There's no typed error layer — UI code catches generic `Exception` (e.g., `create_post_screen.dart` line 109: `catch (e)`), which makes distinguishing network errors from permission errors from not-found errors impossible.

**No user profile creation on signup.** `LoginScreen._handleAuth()` signs up via Firebase Auth but never calls `firestoreService.createUser(...)`. Any downstream code expecting a Firestore `AppUser` doc will silently receive `null`.

**`postsAtCragStream` query may fail without a Firestore composite index (line 106–118).**
The query combines `where('cragId', ...)`, `where('expiresAt', isGreaterThan: ...)`, and two `orderBy` clauses. Firestore requires a composite index for this. Without it, the stream will error silently in production with a permission/index error. The index must be created in `firestore.indexes.json`.

**`CragDetailScreen._buildCragDetail` receives `AsyncValue` typed as bare `AsyncValue` (line 38).**
```dart
AsyncValue postsAsync,
```
The type parameter is missing — should be `AsyncValue<List<ClimbingPost>>`. This suppresses type safety on the `.when()` call.

**Navigation is incomplete.** The `MapScreen` bottom nav and FAB all show `SnackBar("...coming soon")` stubs. The `/crag/:id` route exists but `CreatePostScreen` is never registered as a route — it's presumably pushed modally, but there's no route for it.

---

## 2. Architecture Recommendation

### Verdict: Keep Riverpod, Fix the Structure

**Do not migrate to BLoC + GetIt.** Here's the reasoning:

| Consideration | Analysis |
|---|---|
| Team size | Solo developer. BLoC's verbosity (Event, State, Bloc class, bloc_test mocks) multiplies file count 3–4x per feature with minimal benefit for one person. |
| Existing investment | Riverpod providers are partially written and working. The Freezed models are correct regardless of state management choice. Migrating mid-development has high disruption cost for zero user-facing value. |
| Testability | Riverpod 2.x with `ProviderContainer` and `ProviderScope` overrides is fully testable. BLoC does not have a testability advantage here. |
| App complexity | Belay Buddy has 4 core features. BLoC shines when you have complex multi-step state machines with many event types (e.g., a checkout flow). Real-time streams from Firestore map cleanly to Riverpod `StreamProvider`. |
| Reactive streams | `StreamProvider` directly wraps Firestore streams with zero boilerplate. BLoC would require manually adding stream subscriptions in `on<Event>` handlers and calling `emit()`. |

**What to adopt from BLoC thinking:** the repository pattern and clear layer separation. The core problem isn't the state management library — it's missing abstraction layers.

### Target Folder Structure

```
lib/
├── core/
│   ├── errors/
│   │   ├── app_exception.dart       # Typed exception hierarchy
│   │   └── result.dart              # Result<T> type
│   ├── extensions/
│   │   └── firestore_extensions.dart
│   └── constants/
│       ├── firebase_constants.dart  # Collection name constants
│       └── app_constants.dart
│
├── models/                          # Keep as-is (Freezed, perfect)
│   ├── app_user.dart
│   ├── climbing_post.dart
│   ├── crag.dart
│   └── message.dart
│
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart   # Wraps FirebaseAuth
│   │   └── firestore_datasource.dart     # Replaces FirestoreService
│   └── repositories/
│       ├── auth_repository.dart
│       ├── crag_repository.dart
│       ├── post_repository.dart
│       ├── user_repository.dart
│       └── messaging_repository.dart
│
├── providers/                       # Riverpod providers (presentation ↔ domain bridge)
│   ├── auth_providers.dart
│   ├── crag_providers.dart
│   ├── post_providers.dart
│   ├── user_providers.dart
│   ├── messaging_providers.dart
│   └── repository_providers.dart    # GetIt-style wiring via Provider<>
│
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── profile_setup_screen.dart    # NEW
│   ├── home/
│   │   └── map_screen.dart
│   ├── crag/
│   │   ├── crag_detail_screen.dart
│   │   └── create_post_screen.dart
│   ├── messaging/                        # NEW
│   │   ├── conversations_screen.dart
│   │   └── chat_screen.dart
│   └── profile/                          # NEW
│       └── profile_screen.dart
│
├── widgets/
│   ├── post_card.dart
│   ├── crag_marker.dart                  # Custom map marker
│   ├── user_avatar.dart                  # Extracted from PostCard
│   └── error_view.dart
│
├── utils/
│   └── seed_data.dart
│
└── main.dart
```

### Layered Architecture

```
┌─────────────────────────────────────────┐
│  Presentation Layer                     │
│  screens/ + widgets/                    │
│  - ConsumerWidget / ConsumerStateful    │
│  - ref.watch() for streams              │
│  - ref.read() for actions               │
│  - NO direct Firebase access            │
└────────────────┬────────────────────────┘
                 │ watches/reads Riverpod providers
┌────────────────▼────────────────────────┐
│  Providers Layer                        │
│  providers/                             │
│  - StreamProvider wraps repo streams    │
│  - FutureProvider wraps repo futures    │
│  - StateNotifierProvider for mutations  │
│  - Provider<Repository> for DI          │
└────────────────┬────────────────────────┘
                 │ calls repository methods
┌────────────────▼────────────────────────┐
│  Repository Layer (Domain)              │
│  data/repositories/                     │
│  - Interface + implementation           │
│  - Returns Result<T> (not raw throws)   │
│  - Abstracts data source details        │
└────────────────┬────────────────────────┘
                 │ calls datasource methods
┌────────────────▼────────────────────────┐
│  Data Source Layer                      │
│  data/datasources/                      │
│  - AuthRemoteDatasource (FirebaseAuth)  │
│  - FirestoreDatasource (Firestore)      │
│  - Maps Firestore docs → model objects  │
└─────────────────────────────────────────┘
```

---

## 3. Dependency Injection

**Recommendation: Use Riverpod's `Provider<T>` as the service locator.** This is idiomatic Riverpod and avoids adding GetIt as a second DI system. `Provider<T>` is lazy, scoped, overridable in tests, and zero-dependency.

For the data layer, wire dependencies through a dedicated `repository_providers.dart` file:

```dart
// lib/providers/repository_providers.dart

// Data sources
final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(FirebaseAuth.instance);
});

final firestoreDatasourceProvider = Provider<FirestoreDatasource>((ref) {
  return FirestoreDatasource(FirebaseFirestore.instance);
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDatasourceProvider));
});

final cragRepositoryProvider = Provider<CragRepository>((ref) {
  return CragRepositoryImpl(ref.watch(firestoreDatasourceProvider));
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.watch(firestoreDatasourceProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(firestoreDatasourceProvider));
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.watch(firestoreDatasourceProvider));
});
```

**Test overrides** work cleanly:
```dart
// In a test file
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(MockAuthRepository()),
    cragRepositoryProvider.overrideWithValue(MockCragRepository()),
  ],
);
```

No `GetIt.instance.reset()` needed, no global state issues between tests.

**If you do want GetIt** for non-Riverpod code (e.g., Cloud Functions client, analytics), add it as a separate concern wired in `main.dart` before `runApp()`:
```dart
final getIt = GetIt.instance;

Future<void> _setupDependencies() async {
  getIt.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  // etc.
}
```

---

## 4. State Management Deep Dive

### Auth State

Auth needs to be reactive across the entire app. The current `Provider<String?>` is broken.

```dart
// lib/providers/auth_providers.dart

// The primary auth stream — all auth-dependent providers derive from this
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Derived: current UID, null when logged out
final currentUidProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.uid;
});

// Derived: current AppUser profile stream
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(userRepositoryProvider).watchUser(uid);
});

// Auth actions via StateNotifier
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  final AuthRepository _repository;

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.signInWithEmailAndPassword(email, password),
    );
  }

  Future<void> signUp(String email, String password, String displayName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.createUser(email, password, displayName),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.signOut());
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
```

**In the UI, watch `authNotifierProvider` for loading/error:**
```dart
ref.listen<AsyncValue<void>>(authNotifierProvider, (_, state) {
  state.whenOrNull(
    error: (err, _) => showErrorSnackbar(context, err),
  );
});
```

### Map / Crags State

Crags are a static-ish dataset — they change rarely. Stream the full list for the map; don't stream individual crags unless editing.

```dart
// lib/providers/crag_providers.dart

final allCragsProvider = StreamProvider<List<Crag>>((ref) {
  return ref.watch(cragRepositoryProvider).watchAllCrags();
});

// Family for individual crag — Future is correct here (detail view reads once)
final cragByIdProvider = FutureProvider.family<Crag?, String>((ref, id) {
  return ref.watch(cragRepositoryProvider).getCrag(id);
});

// Map camera state — local UI state, no provider needed
// Use a plain ValueNotifier<CameraPosition> inside the map screen's State class
```

**Key decision:** don't put `GoogleMapController` in a provider. It holds a native platform view and must be disposed with its widget. Keep map controller in `ConsumerStatefulWidget` state.

### Posts State

Posts are time-sensitive and user-specific. Real-time streaming is correct.

```dart
// lib/providers/post_providers.dart

// Posts at a crag — real-time, used on CragDetailScreen
final postsAtCragProvider =
    StreamProvider.family<List<ClimbingPost>, String>((ref, cragId) {
  return ref.watch(postRepositoryProvider).watchPostsAtCrag(cragId);
});

// Current user's posts — real-time, used on Profile screen
final myPostsProvider = StreamProvider<List<ClimbingPost>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(postRepositoryProvider).watchUserPosts(uid);
});

// Post mutation — StateNotifier for create/delete with loading state
class PostNotifier extends StateNotifier<AsyncValue<void>> {
  PostNotifier(this._repo, this._uid) : super(const AsyncValue.data(null));

  final PostRepository _repo;
  final String? _uid;

  Future<void> createPost(ClimbingPost post) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.createPost(post));
  }

  Future<void> deletePost(String postId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.deletePost(postId));
  }
}

final postNotifierProvider =
    StateNotifierProvider<PostNotifier, AsyncValue<void>>((ref) {
  return PostNotifier(
    ref.watch(postRepositoryProvider),
    ref.watch(currentUidProvider),
  );
});
```

### Messaging State

Conversations list + message stream are both real-time.

```dart
// lib/providers/messaging_providers.dart

// All conversations for current user — real-time
final myConversationsProvider = StreamProvider<List<Conversation>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(messagingRepositoryProvider).watchUserConversations(uid);
});

// Messages in a conversation — real-time, family by conversationId
final messagesProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
  return ref
      .watch(messagingRepositoryProvider)
      .watchMessages(conversationId);
});

// Unread conversation count — derived from myConversationsProvider
final unreadCountProvider = Provider<int>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return 0;
  return ref.watch(myConversationsProvider).valueOrNull
      ?.where((c) => c.isReadByUser[uid] == false)
      .length ?? 0;
});

// Send message action
class MessagingNotifier extends StateNotifier<AsyncValue<void>> {
  MessagingNotifier(this._repo) : super(const AsyncValue.data(null));
  final MessagingRepository _repo;

  Future<void> sendMessage(String conversationId, Message message) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.sendMessage(conversationId, message),
    );
  }

  Future<String> getOrCreateConversation(
      String currentUid, String otherUid) async {
    return _repo.getOrCreateConversation(currentUid, otherUid);
  }
}

final messagingNotifierProvider =
    StateNotifierProvider<MessagingNotifier, AsyncValue<void>>((ref) {
  return MessagingNotifier(ref.watch(messagingRepositoryProvider));
});
```

### User Profile State

```dart
// User by ID — cache individual profile lookups
// Using keepAlive prevents re-fetching on every PostCard rebuild
final userByIdProvider =
    FutureProvider.family.autoDispose<AppUser?, String>((ref, uid) {
  // keepAlive for 5 minutes to batch reads from PostCard list
  final link = ref.keepAlive();
  Timer(const Duration(minutes: 5), link.close);
  return ref.watch(userRepositoryProvider).getUser(uid);
});
```

---

## 5. Data Layer

### Repository Pattern

Each repository defines an interface (abstract class) and a concrete implementation. This enables mock substitution in tests without a mocking framework.

```dart
// lib/data/repositories/post_repository.dart

abstract class PostRepository {
  Future<Result<String>> createPost(ClimbingPost post);
  Future<Result<void>> deletePost(String postId);
  Future<Result<void>> updatePost(String postId, Map<String, dynamic> data);
  Stream<List<ClimbingPost>> watchPostsAtCrag(String cragId);
  Stream<List<ClimbingPost>> watchUserPosts(String userId);
  Stream<List<ClimbingPost>> watchActivePosts();
}

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._datasource);
  final FirestoreDatasource _datasource;

  @override
  Future<Result<String>> createPost(ClimbingPost post) async {
    try {
      final id = await _datasource.createPost(post);
      return Result.success(id);
    } on FirebaseException catch (e) {
      return Result.failure(AppException.fromFirebase(e));
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()));
    }
  }
  // ...
}
```

### Error Handling Strategy

Use a `Result<T>` type rather than the `Either` from `dartz`. `dartz` is heavy and the functional idioms are unfamiliar to most Flutter developers. A purpose-built `Result` is lighter and clearer:

```dart
// lib/core/errors/result.dart

sealed class Result<T> {
  const Result();

  factory Result.success(T value) = Success<T>;
  factory Result.failure(AppException error) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  AppException? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(AppException error) failure,
  }) =>
      switch (this) {
        Success(:final value) => success(value),
        Failure(:final error) => failure(error),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppException error;
}
```

```dart
// lib/core/errors/app_exception.dart

sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  factory AppException.fromFirebase(FirebaseException e) {
    return switch (e.code) {
      'permission-denied' => const PermissionDeniedException(),
      'not-found' => const NotFoundException(),
      'unavailable' || 'network-request-failed' => const NetworkException(),
      'unauthenticated' => const UnauthenticatedException(),
      _ => UnknownException(e.message ?? e.code),
    };
  }

  factory AppException.unknown(String message) = UnknownException;

  String get userFriendlyMessage => switch (this) {
    PermissionDeniedException() => 'You don\'t have permission to do that.',
    NotFoundException() => 'Not found.',
    NetworkException() => 'No internet connection. Please try again.',
    UnauthenticatedException() => 'Please sign in to continue.',
    UnknownException(:final message) => message,
  };
}

final class PermissionDeniedException extends AppException {
  const PermissionDeniedException() : super('permission-denied');
}
final class NotFoundException extends AppException {
  const NotFoundException() : super('not-found');
}
final class NetworkException extends AppException {
  const NetworkException() : super('network-unavailable');
}
final class UnauthenticatedException extends AppException {
  const UnauthenticatedException() : super('unauthenticated');
}
final class UnknownException extends AppException {
  const UnknownException(super.message);
}
```

**Usage in a provider/notifier:**
```dart
final result = await ref.read(postRepositoryProvider).createPost(post);
result.when(
  success: (_) => context.pop(),
  failure: (e) => showErrorSnackbar(context, e.userFriendlyMessage),
);
```

### Offline Support Considerations

Firestore has built-in offline persistence enabled by default on mobile. No additional setup is required for basic offline read support. However:

1. **Enable persistence explicitly** to guarantee it on all platforms:
   ```dart
   FirebaseFirestore.instance.settings = const Settings(
     persistenceEnabled: true,
     cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
   );
   ```
   Set this in `main()` before `runApp()`.

2. **Streams will emit cached data immediately** while fetching fresh data — this is good UX by default. No spinner flash for returning users.

3. **Writes while offline** are queued by Firestore and committed when connectivity resumes. Your `createPost` and `sendMessage` calls will appear to succeed offline. This is usually desirable behavior for this app.

4. **Caveat: `DateTime.now()` in `postsAtCragStream`** — the `where('expiresAt', isGreaterThan: DateTime.now())` filter is evaluated at query time, not per-document. Cached expired posts will not be re-filtered. Consider adding a client-side filter in the repository layer to hide client-side stale data.

### Model Improvements

The Freezed models are generally well-designed. Specific gaps to address:

**`ClimbingPost` — missing `climbingStyle` field.** The `AppUser` model has `List<ClimbingStyle>` for preferences, but a post can't specify what discipline it's for. Add:
```dart
@Default([ClimbingStyle.all]) List<ClimbingStyle> styles,
```

**`ClimbingPost` — `id` generated client-side with `Uuid().v4()` but then ignored.** `FirestoreService.createPost` uses `_firestore.collection('posts').add(post.toJson())` which generates a new Firestore ID server-side, discarding the client UUID. The returned `docRef.id` is the actual ID. The `id` field in the model is either redundant (if using `add()`) or requires using `set()` with a pre-determined ID. Pick one approach and be consistent. Recommend keeping `Uuid` and using `.doc(post.id).set(...)` so the ID is always known before the write.

**`Crag` — `activeClimbersCount` is denormalized but never updated.** It's stored as an `@Default(0) int` but there's no code that increments it. Either remove it (derive the count from active posts), or add a Cloud Function to maintain it. Leaving it at 0 is misleading.

**`Message` — no support for media messages.** Add an optional `imageUrl` field now — retrofitting Freezed models after the messaging screen is built requires regenerating all `*.freezed.dart` files:
```dart
String? imageUrl,
MessageType @Default(MessageType.text) type,
```

**`AppUser` — `displayName` is `required` but Firebase Auth allows null display names.** Add a fallback in `AuthRepository.signUp` to set `displayName` from the email prefix if not provided.

**`Conversation` — no `postId` reference.** When a user taps "contact" on a post, it's useful to know which post initiated the conversation. Add an optional `relatedPostId` to provide context in the chat header:
```dart
String? relatedPostId,
```

---

## 6. Navigation

### go_router Setup with Auth Guards

Replace the current `_router` in `main.dart` with a properly guarded router:

```dart
// lib/main.dart (router section)

final _router = GoRouter(
  initialLocation: '/map',
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isOnAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/profile-setup';

    if (!isLoggedIn && !isOnAuthRoute) return '/login';
    if (isLoggedIn && state.matchedLocation == '/login') return '/map';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MapScreen(),
          ),
        ),
        GoRoute(
          path: '/crag/:id',
          builder: (context, state) => CragDetailScreen(
            cragId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'create-post',
              builder: (context, state) {
                final crag = state.extra as Crag;
                return CreatePostScreen(crag: crag);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/messages',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ConversationsScreen(),
          ),
          routes: [
            GoRoute(
              path: ':conversationId',
              builder: (context, state) => ChatScreen(
                conversationId: state.pathParameters['conversationId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
  ],
);
```

**`GoRouterRefreshStream` adapter** (go_router doesn't include this but it's a standard pattern):
```dart
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

**`ShellRoute` with `MainShell`** handles the persistent bottom navigation bar:
```dart
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  static const _tabs = ['/map', '/messages', '/profile'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t));

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.clamp(0, 2),
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

### Deep Links

Add to `AndroidManifest.xml` and `Info.plist`:
- Pattern: `belaybuddy://crag/{id}` for direct crag links
- Pattern: `belaybuddy://messages/{conversationId}` for push notification taps

go_router handles deep links via `GoRouter.setInitialRoutePath` or by matching the URI in `initialLocation`. No additional setup needed beyond registering the URI scheme natively.

---

## 7. Missing Features — Technical Approach

### Real-Time Messaging

The data model is already correct (`Conversation` + `Message` subcollection). The `FirestoreService` already has the right methods. What's missing is the UI layer.

**`ConversationsScreen`:** Watch `myConversationsProvider`. For each conversation, show the other participant's name (requires resolving UIDs to display names — use `userByIdProvider` with the keepAlive cache described above). Show unread indicator from `isReadByUser[currentUid] == false`.

**`ChatScreen`:**
- `messagesProvider(conversationId)` drives the message list
- Use `ListView.builder` with `reverse: true` for bottom-up chat layout
- Send button calls `messagingNotifierProvider.notifier.sendMessage(...)`
- On screen open, call `messagingRepository.markAsRead(conversationId, uid)`
- `AutomaticKeepAliveClientMixin` on the `State` to prevent stream cancellation when navigating between tabs

**Initiating a conversation from PostCard:**
```dart
// PostCard.onTap handler
final conversationId = await ref
    .read(messagingNotifierProvider.notifier)
    .getOrCreateConversation(currentUid, post.userId);
context.push('/messages/$conversationId');
```

**Security rules for messages:** Firestore rules must verify `request.auth.uid in resource.data.participantIds` before allowing reads/writes to conversations and their subcollections.

### User Profile Completion Flow

New users created via Firebase Auth have no `AppUser` document. Fix this with a two-step signup flow:

1. `AuthRepository.signUp()` creates the Firebase Auth user AND writes a minimal `AppUser` document to Firestore.
2. After signup, redirect to `ProfileSetupScreen` (not `/map`) where the user sets `displayName`, `bio`, `experienceLevel`, and `climbingStyles`.
3. Use a `profileCompleteProvider` derived from `currentUserProvider`:
   ```dart
   final profileCompleteProvider = Provider<bool>((ref) {
     final user = ref.watch(currentUserProvider).valueOrNull;
     if (user == null) return false;
     return user.displayName.isNotEmpty && user.bio != null;
   });
   ```
4. Add to the router `redirect`: if logged in but `profileComplete == false`, redirect to `/profile-setup`.

### Post Expiry / Cleanup

**Recommendation: Cloud Functions for cleanup.**

Client-side expiry filtering (which the current code does via `where('expiresAt', isGreaterThan: DateTime.now())`) is correct for display purposes but doesn't actually delete expired documents. Over time, the `posts` collection accumulates thousands of stale documents, increasing read costs.

**Cloud Function (Node.js / Firebase Functions v2):**
```javascript
// functions/src/cleanupExpiredPosts.ts
import { onSchedule } from "firebase-functions/v2/scheduler";
import { getFirestore } from "firebase-admin/firestore";

export const cleanupExpiredPosts = onSchedule("every 1 hours", async () => {
  const db = getFirestore();
  const now = new Date();

  const expiredPosts = await db
    .collection("posts")
    .where("expiresAt", "<", now)
    .limit(500)  // batch limit
    .get();

  const batch = db.batch();
  expiredPosts.docs.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();
});
```

The composite index on `(cragId, expiresAt, dateTime)` needed for `postsAtCragStream` also supports this cleanup query.

**Client-side filter as defense-in-depth:** Keep the `where('expiresAt', isGreaterThan: ...)` in the query. The Cloud Function is the authoritative cleanup.

### Push Notifications

Add `firebase_messaging: ^15.x.x` and `flutter_local_notifications: ^17.x.x`.

**Architecture:**
1. Request notification permission on `ProfileSetupScreen` (not on app launch — too aggressive).
2. On permission grant, call `FirebaseMessaging.instance.getToken()` and write the FCM token to `AppUser.fcmToken` in Firestore.
3. Cloud Function sends notifications:
   ```javascript
   // Trigger: on new message in conversations/{id}/messages/{msgId}
   export const onNewMessage = onDocumentCreated(
     "conversations/{convId}/messages/{msgId}",
     async (event) => {
       // Get conversation participants, exclude sender
       // Get FCM tokens for recipients
       // Send via admin.messaging().sendMulticast(...)
     }
   );
   ```
4. Handle foreground notifications with `FirebaseMessaging.onMessage` stream.
5. Handle notification taps with `FirebaseMessaging.onMessageOpenedApp` — navigate to the relevant conversation using `GoRouter`.

**Critical:** Store FCM tokens as a list (`List<String> fcmTokens`) rather than a single string, because users may use multiple devices.

---

## 8. Testing Strategy

### What to Test First (Priority Order)

**1. Repository tests (highest value, lowest friction)**

Repositories are pure Dart logic sitting on top of mockable datasources. These run fast and catch the most bugs.

```dart
// test/data/repositories/post_repository_test.dart

void main() {
  late MockFirestoreDatasource mockDatasource;
  late PostRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockFirestoreDatasource();
    repository = PostRepositoryImpl(mockDatasource);
  });

  group('createPost', () {
    test('returns success with document ID on success', () async {
      when(() => mockDatasource.createPost(any()))
          .thenAnswer((_) async => 'new-doc-id');

      final result = await repository.createPost(fakePost);

      expect(result.isSuccess, true);
      expect(result.valueOrNull, 'new-doc-id');
    });

    test('returns PermissionDeniedException on Firebase permission error', () async {
      when(() => mockDatasource.createPost(any())).thenThrow(
        FirebaseException(plugin: 'firestore', code: 'permission-denied'),
      );

      final result = await repository.createPost(fakePost);

      expect(result.isFailure, true);
      expect(result.errorOrNull, isA<PermissionDeniedException>());
    });
  });
}
```

**2. Notifier / Provider tests**

Use `ProviderContainer` with repository overrides:

```dart
// test/providers/auth_providers_test.dart

void main() {
  test('signIn transitions through loading to success', () async {
    final mockRepo = MockAuthRepository();
    when(() => mockRepo.signInWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    await container.read(authNotifierProvider.notifier).signIn('a@b.com', 'pw');

    expect(
      container.read(authNotifierProvider),
      const AsyncValue<void>.data(null),
    );
  });
}
```

**3. Widget tests for critical screens**

Focus on `LoginScreen`, `CragDetailScreen`, and `PostCard` first.

```dart
// test/screens/login_screen_test.dart

testWidgets('shows error snackbar on sign-in failure', (tester) async {
  final mockNotifier = MockAuthNotifier();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith((_) => mockNotifier),
      ],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );

  await tester.enterText(find.byType(TextFormField).first, 'bad@email.com');
  await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
  await tester.tap(find.byType(FilledButton));
  await tester.pump();

  expect(find.byType(SnackBar), findsOneWidget);
});
```

**4. Integration tests (last, highest friction)**

Use `integration_test` package with Firebase emulator. Test the happy path:
- Sign up → profile setup → create post → view post on crag board.
- Only worth adding once the feature set is stable.

### Mocking Strategy

Use `mocktail` (not `mockito`) — no code generation required:
```yaml
dev_dependencies:
  mocktail: ^1.0.4
```

Create `test/helpers/mocks.dart` with all mock classes centralized:
```dart
class MockAuthRepository extends Mock implements AuthRepository {}
class MockCragRepository extends Mock implements CragRepository {}
class MockPostRepository extends Mock implements PostRepository {}
// etc.
```

---

## 9. pubspec.yaml Changes

### Packages to Add

```yaml
dependencies:
  # Keep all existing dependencies

  # State management additions
  # (no additions — Riverpod already covers it)

  # Messaging / notifications
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^17.2.2

  # Image upload support (already have image_picker, add firebase_storage usage)
  # firebase_storage already in pubspec — no change

  # Loading states & error display
  shimmer: ^3.0.0  # skeleton loading for post lists

  # Time formatting (upgrade from bare intl usage)
  # timeago: ^3.6.1  # optional: "2 minutes ago" formatting

  # Deeplink / URL strategy
  # go_router already handles this — no addition needed

dev_dependencies:
  # Keep all existing

  # Testing
  mocktail: ^1.0.4
  fake_async: ^1.3.1

  # Firebase emulator testing
  # (no package — use firebase_core test config)
```

### Packages to Remove

```yaml
# REMOVE — redundant/unused:
# json_annotation: ^4.9.0
# This is already pulled in transitively by freezed_annotation.
# Listing it explicitly creates version conflict risk.
```

### Packages to Update

```yaml
dependencies:
  freezed: ^2.5.7          # already current
  go_router: ^14.2.3       # already current

  # Note: flutter 3.24.5 (from .fvmrc) is behind the pubspec sdk constraint
  # which says >=3.5.0. The .fvmrc pins 3.24.5 (Flutter 3.x SDK).
  # These are compatible but the fvmrc should be updated to Flutter 3.27.x+
  # to use Dart 3.6+ sealed classes properly (already used in Result type above).
  # Run: fvm use 3.27.3 --force
```

### Complete Recommended pubspec.yaml (dependencies section only)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Firebase
  firebase_core: ^3.3.0
  firebase_auth: ^5.1.4
  cloud_firestore: ^5.4.5
  firebase_storage: ^12.3.6
  firebase_messaging: ^15.1.3

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod: ^2.5.1
  freezed_annotation: ^2.4.4

  # Navigation
  go_router: ^14.2.3

  # Maps
  google_maps_flutter: ^2.9.0
  geolocator: ^13.0.2
  geocoding: ^3.0.0

  # Image
  image_picker: ^1.1.2
  cached_network_image: ^3.4.1

  # UI
  shimmer: ^3.0.0
  flutter_local_notifications: ^17.2.2
  intl: ^0.19.0

  # Utilities
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.12
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.2
  custom_lint: ^0.6.5
  riverpod_lint: ^2.3.13
  mocktail: ^1.0.4
  fake_async: ^1.3.1
```

**Key changes from current:**
- Added `firebase_messaging`, `flutter_local_notifications`, `shimmer`, `mocktail`, `fake_async`
- Removed `json_annotation` (transitively included)
- Moved `freezed` to dev_dependencies (it's a code generator, not a runtime dep)

---

## 10. Migration Plan

The goal is to evolve the architecture without breaking the working map/crag/post flow at any step. Each phase is independently shippable.

### Phase 1 — Critical Bug Fixes (1–2 days)
_No structural changes. Just fix the broken things._

1. **Fix `currentUserIdProvider`** — change from `Provider` to a derived `Provider` that reads from `authStateProvider`:
   ```dart
   final currentUidProvider = Provider<String?>((ref) {
     return ref.watch(authStateProvider).valueOrNull?.uid;
   });
   ```

2. **Fix the router auth bypass** — change `initialLocation` from `/map` to `/` and implement the redirect properly.

3. **Fix `cragProvider`** — rename to `cragByIdProvider`, change to `FutureProvider.family`.

4. **Fix `AsyncValue postsAsync`** parameter in `CragDetailScreen._buildCragDetail` — add type parameter `AsyncValue<List<ClimbingPost>>`.

5. **Fix user creation on signup** — in `LoginScreen._handleAuth`, after `createUserWithEmailAndPassword`, create an `AppUser` document in Firestore.

These fixes require no new packages, no folder restructuring, and no generated file regeneration.

### Phase 2 — Error Handling Layer (2–3 days)
_Add `Result<T>` and `AppException`. Update FirestoreService to return `Result` where appropriate._

1. Create `lib/core/errors/result.dart` and `app_exception.dart`.
2. Update `FirestoreService` write methods (`createPost`, `sendMessage`, `createUser`) to catch `FirebaseException` and return `Result<T>`.
3. Update `CreatePostScreen._submitPost` and `LoginScreen._handleAuth` to use `result.when(...)` instead of bare `catch (e)`.
4. Leave `Stream` methods unchanged — streams handle errors via `StreamProvider`'s error state.

### Phase 3 — Repository Layer (3–4 days)
_Extract repositories on top of the existing `FirestoreService`. Don't delete `FirestoreService` yet — let repositories delegate to it._

1. Create `lib/data/repositories/` with the four repository interfaces.
2. Implement `PostRepositoryImpl`, `CragRepositoryImpl`, `UserRepositoryImpl` delegating to `FirestoreService`.
3. Create `lib/providers/repository_providers.dart`.
4. Update `firestore_providers.dart` to watch repositories instead of `firestoreServiceProvider` directly.
5. Run the app — behavior is identical, internal structure is cleaner.
6. Write repository unit tests at this point (easiest while the layer is fresh).

### Phase 4 — Auth Architecture (1–2 days)
_Extract Firebase Auth calls from the UI into `AuthRepository`._

1. Create `lib/data/datasources/auth_remote_datasource.dart`.
2. Create `lib/data/repositories/auth_repository.dart`.
3. Create `AuthNotifier` as described in Section 4.
4. Update `LoginScreen` to use `authNotifierProvider` — remove direct `FirebaseAuth.instance` calls.
5. Update `MapScreen._signOut` to use `authNotifierProvider`.
6. Add `profileCompleteProvider` and profile-setup redirect.

### Phase 5 — Navigation Overhaul (1 day)
_Replace the ad-hoc router with the ShellRoute-based router described in Section 6._

1. Create `MainShell` widget with the bottom nav.
2. Replace `_router` in `main.dart` with the `ShellRoute` version.
3. Replace all `SnackBar("coming soon")` in `MapScreen` with actual `context.go(...)` calls.
4. Register `CreatePostScreen` as a nested route under `/crag/:id/create-post`.

### Phase 6 — Messaging UI (3–5 days)
_Build the two messaging screens._

1. Create `ConversationsScreen` watching `myConversationsProvider`.
2. Create `ChatScreen` watching `messagesProvider(conversationId)`.
3. Wire `PostCard.onTap` to call `getOrCreateConversation` and navigate.
4. Add `unreadCountProvider` and badge on the messages tab in `MainShell`.

### Phase 7 — Profile Screen + Post Expiry (2–3 days)
_User profile editing and Cloud Functions scaffolding._

1. Create `ProfileScreen` with editable fields.
2. Add profile photo upload via `image_picker` + `firebase_storage`.
3. Initialize Firebase Functions project (`firebase init functions`).
4. Deploy `cleanupExpiredPosts` scheduled function.
5. Create Firestore indexes in `firestore.indexes.json`.

### Phase 8 — Push Notifications (2–3 days)
_Add FCM integration._

1. Add `firebase_messaging` package.
2. Request permission on profile setup completion.
3. Store FCM token in `AppUser`.
4. Deploy `onNewMessage` Cloud Function.
5. Handle foreground/background notification taps with router navigation.

---

## Appendix — Firestore Index Requirements

The following composite indexes must exist in `firestore.indexes.json` to avoid runtime errors:

| Collection | Fields | Query Direction |
|---|---|---|
| `posts` | `cragId` ASC, `expiresAt` ASC, `dateTime` ASC | For `postsAtCragStream` |
| `posts` | `userId` ASC, `dateTime` DESC | For `userPostsStream` |
| `posts` | `expiresAt` ASC | For `activePostsStream` + cleanup |
| `conversations` | `participantIds` ARRAY, `lastMessageTime` DESC | For `userConversationsStream` |

Without these indexes, Firestore streams will return an error with a link to create the index in the Firebase console. Add them proactively.

---

## Appendix — Firestore Security Rules Sketch

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users: read by anyone authenticated, write only by owner
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Crags: read by anyone authenticated, write by authenticated (for now)
    match /crags/{cragId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }

    // Posts: read by anyone authenticated, write by owner
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }

    // Conversations: participants only
    match /conversations/{convId} {
      allow read, update: if request.auth.uid in resource.data.participantIds;
      allow create: if request.auth.uid in request.resource.data.participantIds;

      match /messages/{msgId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/conversations/$(convId)).data.participantIds;
        allow create: if request.auth.uid == request.resource.data.senderId
                      && request.auth.uid in get(/databases/$(database)/documents/conversations/$(convId)).data.participantIds;
      }
    }
  }
}
```
