import 'package:flutter/material.dart';
import 'package:project_1/blocs/journal_edit_bloc.dart';
import 'package:project_1/blocs/journal_edit_bloc_provider.dart';
import 'package:project_1/classes/MoodIcons.dart';
import 'package:project_1/classes/FormatDates.dart';

class EditEntry extends StatefulWidget {
  const EditEntry({super.key});

  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {

  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;
  @override
  void initState()
  {
    super.initState();
    _formatDates=FormatDates();
    _moodIcons=MoodIcons();
    _noteController=TextEditingController();
    _noteController.text="";
  }
  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    _journalEditBloc=journalEditBlocProvider.of(context)!.journalEditBloc!;
  }
  @override
  void dispose()
  {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  Future<String> _selectDate(String selectedDate)async
  {
    DateTime _initialDate=DateTime.parse(selectedDate);
    final DateTime? _pickedDate=await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if(_pickedDate!=null)
      {
        selectedDate=DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          _pickedDate.hour,
          _pickedDate.minute,
          _pickedDate.second,
        ).toString();
      }
    return selectedDate;
  }

  void _addOrUpdateJournal()
  {
    _journalEditBloc.saveJournalChanged.add('Save');
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry",style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue.shade300,Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(stream: _journalEditBloc.dateEdit,
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      if(!snapshot.hasData)
                        {
                          return Container();
                        }
                      return TextButton(
                          onPressed: ()async{
                            FocusScope.of(context).requestFocus(FocusNode());
                            String _pickedDate=await _selectDate(snapshot.data);
                            _journalEditBloc.dateEditChanged.add(_pickedDate);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today,
                              size: 20,
                              color: Colors.black,
                              ),
                              SizedBox(width: 16.0),
                              Text(_formatDates.DateFormatShortMonthYear(snapshot.data),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),

                            ],
                          )
                      );
                    }),
                // StreamBuilder(
                //     stream:_journalEditBloc.moodEdit,
                //     builder: (BuildContext context, AsyncSnapshot snapshot)
                //     {
                //       if(!snapshot.hasData)
                //         {
                //           return Container();
                //         }
                //       int moodIndex = _moodIcons
                //           .getMoodList()
                //           .indexWhere((icon) => icon.title == snapshot.data);
                //
                //       // Handle the case when no matching mood icon is found
                //       if (moodIndex == -1) {
                //         // Set a default mood icon (optional)
                //         moodIndex = 0;
                //       }
                //       return DropdownButtonHideUnderline(
                //           child: DropdownButton<MoodIcons>(
                //               value: _moodIcons.getMoodList()[
                //                 moodIndex
                //               ],
                //               onChanged: (selected){
                //                 _journalEditBloc.moodEditChanged.add(selected!.title!);
                //               },
                //               items: _moodIcons?.getMoodList().map((MoodIcons selected){
                //                 return DropdownMenuItem<MoodIcons>(
                //                   value: selected,
                //                     child: Row(
                //                       children: <Widget>[
                //                         Transform(transform: Matrix4.identity()..rotateZ(_moodIcons.getMoodRotation(selected.title??'')??0),
                //                         alignment: Alignment.center,
                //                           child: Icon(_moodIcons.getMoodIcon(selected.title)),
                //                         ),
                //                         SizedBox(width: 10,),
                //                         Text(selected.title!),
                //                       ],
                //                     )
                //                 );
                //               }).toList(),
                //               ),
                //
                //       );
                //
                //     }
                // ),
                StreamBuilder(
                  stream: _journalEditBloc.moodEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty) {
                      return Container();
                    }

                    // Find the matching mood icon, or use the default first icon
                    int moodIndex = _moodIcons
                        .getMoodList()
                        .indexWhere((icon) => icon.title == snapshot.data);

                    // If no matching mood icon is found, use the first icon as a default
                    MoodIcons selectedMoodIcon = (moodIndex == -1)
                        ? _moodIcons.getMoodList().first
                        : _moodIcons.getMoodList()[moodIndex];

                    // Get mood rotation, fallback to 0 if not found
                    double rotation = _moodIcons.getRotationByTitle(selectedMoodIcon.title ?? '') ?? 0;

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<MoodIcons>(
                        value: selectedMoodIcon,
                        onChanged: (MoodIcons? selected) {
                          if (selected != null) {
                            _journalEditBloc.moodEditChanged.add(selected.title!);
                          }
                        },
                        items: _moodIcons.getMoodList().map((MoodIcons selected) {
                          return DropdownMenuItem<MoodIcons>(
                            value: selected,
                            child: Row(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.identity()..rotateZ(rotation),
                                  alignment: Alignment.center,
                                  child: Icon(_moodIcons.getIconByTitle(selected.title??'')),
                                ),
                                SizedBox(width: 10),
                                Text(selected.title!),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                    stream:_journalEditBloc.noteEdit,
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      if(!snapshot.hasData)
                        {
                          return Container();
                        }
                      _noteController.value=_noteController.value.copyWith(text: snapshot.data);
                      return TextField(
                        controller: _noteController,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Note',
                          icon: Icon(Icons.subject)
                        ),
                        maxLines: null,
                        onChanged: (note)=> _journalEditBloc.noteEditChanged.add(note),
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        child: Text('Cancel'),
                      onPressed: (){
                          Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10.0,),
                    TextButton(
                        child: Text("Save"),
                      onPressed: (){
                          _addOrUpdateJournal();
                      },
                    )
                  ],
                )
              ],
            ),
          ),
      ),
    );
  }
}
