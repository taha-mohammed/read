import 'package:flutter/material.dart';
import 'package:read/data/info/bloc/info_bloc.dart';
import 'package:read/data/info/bloc/info_event.dart';
import 'package:read/data/info/bloc/info_state.dart';
import 'package:read/data/info/info_repository.dart';

import '../../data/book/book.dart';
import '../../data/info/info.dart';

class InfoScreen extends StatefulWidget {
  final InfoRepository repository;
  final Book book;

  const InfoScreen({Key? key, required this.repository, required this.book})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoState();
}

class _InfoState extends State<InfoScreen> {
  late InfoBloc infoBloc;
  final searchController = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Information');

  void showInputDialog(Info? data) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext _) {
        String infoText = "";
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: data == null
              ? const Text('Add a new information')
              : const Text('Edit the information'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: data?.infoText,
                autofocus: true,
                keyboardType: TextInputType.text,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Information',
                  labelText: 'Information',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Information Text should not be empty!';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  infoText = value!;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState?.save();
                if (data == null) {
                  infoBloc.add(InfoEventAdd(
                      info: Info(
                          infoText: infoText, bookTitle: widget.book.title)));
                } else {
                  infoBloc.add(InfoEventUpdate(
                      info: Info(
                          id: data.id,
                          infoText: infoText,
                          bookTitle: widget.book.title)));
                }
                refreshData();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void refreshData() {
    infoBloc
        .add(InfoEventGet(searchController.text, bookTitle: widget.book.title));
  }

  @override
  void initState() {
    super.initState();
    infoBloc = InfoBloc(widget.repository);
    infoBloc.add(InfoEventGetAll(bookTitle: widget.book.title));
    searchController.addListener(refreshData);
  }

  @override
  void dispose() {
    searchController.dispose();
    infoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'search....',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    searchController.clear();
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Information');
                  }
                });
              },
              icon: customIcon)
        ],
      ),
      body: StreamBuilder(
          stream: infoBloc.stream,
          builder: (context, AsyncSnapshot<InfoState> state) {
            List<Info> infoList;
            if (state.data is InfoStateLoaded) {
              infoList = (state.data as InfoStateLoaded).data;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: infoList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(
                      infoList[index].infoText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            infoBloc
                                .add(InfoEventDelete(id: infoList[index].id!));
                            refreshData();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showInputDialog(infoList[index]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext _) {
                          return InfoDialog(info: infoList[index]);
                        },
                      );
                    },
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInputDialog(null);
        },
        tooltip: 'Add New Info',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class InfoDialog extends StatelessWidget {

  final Info info;

  const InfoDialog({
    Key? key,
    required this.info
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(info.infoText),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
