import 'package:flutter/foundation.dart';

import 'api/core.dart';
import 'api/model/initial_snapshot.dart';
import 'api/route/events.dart';
import 'credential_fixture.dart' as credentials; // prototyping hack; not in Git

class PerAccountStore extends ChangeNotifier {
  // Load the user's data from storage.  (Once we have such a thing.)
  static Future<PerAccountStore> load() async {
    const account = _fixtureAccount;
    final connection = ApiConnection(auth: account);

    final stopwatch = Stopwatch()..start();
    final initialSnapshot = await registerQueue(connection); // TODO retry
    final t = (stopwatch..stop()).elapsed;
    // TODO log the time better
    if (kDebugMode) print("initial fetch time: ${t.inMilliseconds}ms");

    return PerAccountStore(
      account: account,
      connection: connection,
      initialSnapshot: initialSnapshot,
    );
  }

  final Account account;
  final ApiConnection connection;
  final InitialSnapshot initialSnapshot; // TODO translate to a real model

  PerAccountStore({
    required this.account,
    required this.connection,
    required this.initialSnapshot,
  });
}

/// A scaffolding hack for while prototyping.
///
/// Provide a `credential_fixture.dart` in this directory which has the same
/// information as a .zuliprc file, like the one you can download from the
/// Zulip web UI like so: https://zulip.com/api/api-keys
/// but in the form of Dart globals `const String realm_url = "…";`, etc.
const Account _fixtureAccount = Account(
  realmUrl: credentials.realm_url,
  email: credentials.email,
  apiKey: credentials.api_key,
);

class Account implements Auth {
  const Account(
      {required this.realmUrl, required this.email, required this.apiKey});

  @override
  final String realmUrl;
  @override
  final String email;
  @override
  final String apiKey;
}