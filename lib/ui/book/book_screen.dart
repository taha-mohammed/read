import 'package:flutter/material.dart';
import 'package:read/data/book/bloc/book_bloc.dart';
import 'package:read/data/book/bloc/book_event.dart';
import 'package:read/data/book/bloc/book_state.dart';
import 'package:read/data/book/book_repository.dart';
import 'package:read/data/info/info_database.dart';
import 'package:read/ui/info/info_screen.dart';

import '../../data/book/book.dart';

class BookScreen extends StatefulWidget {
  final BookRepository repository;

  const BookScreen({Key? key, required this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookState();
}

class _BookState extends State<BookScreen> {
  late BookBloc bookBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Books');

  void showInputDialog(Book? data) {
    String title = "";
    String author = "";
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: data == null
              ? const Text('Add a new book')
              : const Text('Edit the book'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: data?.title,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      labelText: 'Title',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      title = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: data?.author,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Author',
                      labelText: 'Author',
                    ),
                    validator: (String? value) {
                      return null;
                    },
                    onSaved: (String? value) {
                      author = value!;
                    },
                  ),
                ],
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
              child: const Text('OK'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState?.save();
                if (data == null) {
                  bookBloc.add(
                      BookEventAdd(book: Book(title: title, author: author)));
                } else {
                  bookBloc.add(BookEventUpdate(
                      book: Book(id: data.id, title: title, author: author)));
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
    bookBloc.add(BookEventGet(searchController.text));
  }

  @override
  void initState() {
    super.initState();
    bookBloc = BookBloc(widget.repository);
    bookBloc.add(BookEventGetAll());
    searchController.addListener(refreshData);
  }

  @override
  void dispose() {
    searchController.dispose();
    bookBloc.close();
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
                    customSearchBar = const Text('Books');
                  }
                });
              },
              icon: customIcon)
        ],
      ),
      body: StreamBuilder(
          stream: bookBloc.stream,
          builder: (context, AsyncSnapshot<BookState> state) {
            List<Book> bookList;
            if (state.data is BookStateLoaded) {
              bookList = (state.data as BookStateLoaded).data;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: bookList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    key: Key("list_item_$index"),
                    title: Text(bookList[index].title),
                    subtitle: Text(bookList[index].author),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            bookBloc
                                .add(BookEventDelete(id: bookList[index].id!));
                            refreshData();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showInputDialog(bookList[index]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoScreen(
                                    repository: InfoDatabase(),
                                    book: bookList[index],
                                  )));
                    },
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInputDialog(null);
        },
        tooltip: 'Add New Book',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
