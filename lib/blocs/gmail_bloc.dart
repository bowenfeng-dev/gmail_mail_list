import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gmail_mail_list/models/models.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:meta/meta.dart';

abstract class GmailEvent extends Equatable {
  GmailEvent([List props = const []]) : super(props);
}

class FetchThreads extends GmailEvent {
  final Future<GmailApi> gmailApi;
  final String userId;

  Future<UsersThreadsResourceApi> get threadsApi async =>
      (await gmailApi).users.threads;

  FetchThreads({
    @required this.gmailApi,
    @required this.userId,
  }) : super([gmailApi, userId]);
}

abstract class GmailState extends Equatable {
  GmailState([List props = const []]) : super(props);
}

class GmailUninitialized extends GmailState {}

class LoadingGmailThreads extends GmailState {}

class GmailThreadLoaded extends GmailState {
  final List<EmailThread> threads;

  GmailThreadLoaded({this.threads}) : super([threads]);
}

class GmailBloc extends Bloc<GmailEvent, GmailState> {
  @override
  GmailState get initialState => GmailUninitialized();

  @override
  Stream<GmailState> mapEventToState(
      GmailState currentState, GmailEvent event) async* {
    if (event is FetchThreads && currentState is! LoadingGmailThreads) {
      yield LoadingGmailThreads();

      var threadsApi = await event.threadsApi;
      ListThreadsResponse response = await threadsApi.list(
        event.userId,
        labelIds: ["INBOX"],
        maxResults: 20,
      );

      print('Fetched ${response.threads.length} threads. Fetching details...');

      List<Thread> rawThreads = await Future.wait(
        response.threads.map((thread) async =>
            (await threadsApi.get(event.userId, thread.id, format: "full"))
              ..snippet = thread.snippet),
      );

      print('Fetched details for ${rawThreads.length} threads.');

      List<EmailThread> threads =
          rawThreads.map((thread) => EmailThread.fromThread(thread)).toList();

      print('Converted to EmailThread[]: $threads');

      yield GmailThreadLoaded(threads: threads);
    }
  }
}
