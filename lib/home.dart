import 'package:flutter/material.dart';
import 'package:project_1/blocs/HomeBlocProvider.dart';
import 'package:project_1/blocs/HomeBloc.dart';
import 'package:project_1/blocs/AuthenticationBloc.dart';
import 'package:project_1/blocs/AuthenticBlocProvider.dart';
import 'package:project_1/blocs/journal_edit_bloc.dart';
import 'package:project_1/blocs/journal_edit_bloc_provider.dart';
import 'package:project_1/classes/FormatDates.dart';
import 'package:project_1/classes/MoodIcons.dart';
import 'package:project_1/models/modal.dart';
import 'package:project_1/pages/edit_entry.dart';
import 'package:project_1/services/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthenticatonBloc _authenticatonBloc;
  late HomeBloc _homeBloc;
  late String _uid;
  late MoodIcons _moodIcons;
  final FormatDates _formatDates = FormatDates();

  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _authenticatonBloc =
        AuthenticationBlocProvider.of(context)!.authenticatonBloc;
    _homeBloc = HomeBlocProvider.of(context)!.homeBloc;
    _uid = HomeBlocProvider.of(context)!.uid;
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  Future<void> _addOrEditJournal(add, journal) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                journalEditBlocProvider(
                    journalEditBloc: JournalEditBloc(
                        add, journal, DbFireStoreService()),
                    child: EditEntry(),
                ),
            fullscreenDialog: true
        )
    );

  }
    Future<bool> _confirmDeleteJournal() async
    {
      return await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Delete Journal"),
              content: Text("Are you sure you would like to Delete ?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("CANCEL")
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    }, child: Text("DELETE")
                )
              ],
            );
          }
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Container()),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )

          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _authenticatonBloc.logoutUser.add(true);
              },
              icon: Icon(Icons.exit_to_app_outlined, color: Colors.black,))
        ],
      ),
      body: StreamBuilder(
          stream: _homeBloc.listJournal,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.blue,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeperated(snapshot);
            }
            else {
              return Center(
                child: Container(
                  child: Text("Add Journal", style: TextStyle(fontSize: 50),),
                ),
              );
            }
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          tooltip: "Journals",
          onPressed: () async {
            _addOrEditJournal(true, Journal(uid: _uid));
          },
          backgroundColor: Colors.blue.shade200,
          shape: CircleBorder(
            side: BorderSide.none,
          ),
          child: Icon(
            Icons.add,
            size: 35,
            color: Colors.black,
          ),
          splashColor: Colors.blue.shade50,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        padding: EdgeInsets.all(0),
        height: 50,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
        ),
      ),
    );
  }

  Widget _buildListViewSeperated(snapshot) {
    return ListView.separated(

      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        String _titleDate = _formatDates.DateFormatShortMonthYear(
            snapshot.data[index].date);
        String _subTitle = snapshot.data[index].mood + "\n" +
            snapshot.data[index].note;
        return Dismissible(
            key: Key(snapshot.data[index].documentID),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding:EdgeInsets.all(10),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              ),
            ),
            secondaryBackground: Container(
              color:Colors.red,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              ),
            ),
            child: ListTile(
              leading: Column(
                children: <Widget>[
                  Text(_formatDates.DayNumber(snapshot.data[index].date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  Text(_formatDates.DayName(snapshot.data[index].date)),
                ],
              ),
              trailing: Transform(
                transform: Matrix4.identity()..rotateZ(_moodIcons.getRotationByTitle(snapshot.data[index].mood)??0),
                alignment: Alignment.center,
                child: Icon(_moodIcons.getIconByTitle(snapshot.data[index].mood),
                  color: _moodIcons.getColorByTitle(snapshot.data[index].mood),
                  size: 42,
                ),
              ),
              title: Text(_titleDate,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_subTitle),
              onTap: (){
                _addOrEditJournal(false, snapshot.data[index]);
              },
            ),
          confirmDismiss: (direction)async{
              bool confirmDelete=await _confirmDeleteJournal();
              if(confirmDelete)
                {
                  _homeBloc.deleteJournal.add(snapshot.data[index]);
                }
          },
        );
      },
      separatorBuilder: (context ,index)
      {
        return Divider(
          color: Colors.grey,
        );
      },
    );
  }
}


