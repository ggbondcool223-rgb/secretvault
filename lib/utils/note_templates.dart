import 'package:secret_vault/models/note_template.dart';

class NoteTemplates {
  static const List<NoteTemplate> templates = [

    NoteTemplate(
      id: 'daily_diary',
      name: 'Daily Diary',
      icon: '📔',
      category: 'Diary',
      title: 'Diary - [Date]',
      content: '''Weather: ☀️

Today's Mood: 😊

What Happened Today:
- 

Thoughts & Reflections:


Gratitude:
- 

Tomorrow's Plan:
- ''',
    ),

    NoteTemplate(
      id: 'dream_diary',
      name: 'Dream Journal',
      icon: '🌙',
      category: 'Diary',
      title: 'Dream - [Date]',
      content: '''Dream Theme:

Dream Content:


Emotions Felt:


Possible Meanings:


Notes:''',
    ),


    NoteTemplate(
      id: 'meeting_notes',
      name: 'Meeting Notes',
      icon: '📋',
      category: 'Work',
      title: 'Meeting - [Topic]',
      content: '''Meeting Date: 
Participants: 

Agenda:
1. 
2. 
3. 

Discussion Points:
-

Decisions Made:
-

Action Items:
[ ] 
[ ] 

Next Steps:''',
    ),

    NoteTemplate(
      id: 'project_plan',
      name: 'Project Plan',
      icon: '🎯',
      category: 'Work',
      title: 'Project: [Name]',
      content: '''Project Goal:


Timeline:
Start Date: 
End Date: 

Milestones:
[ ] 
[ ] 
[ ] 

Resources Needed:
- 

Risks & Challenges:
- 

Success Criteria:
- ''',
    ),


    NoteTemplate(
      id: 'study_notes',
      name: 'Study Notes',
      icon: '📚',
      category: 'Learning',
      title: '[Subject] - [Topic]',
      content: '''Topic: 

Key Concepts:
1. 
2. 
3. 

Detailed Notes:


Examples:


Questions:
- 

Summary:


Review Date: ''',
    ),

    NoteTemplate(
      id: 'book_review',
      name: 'Book Review',
      icon: '📖',
      category: 'Learning',
      title: 'Book: [Title]',
      content: '''Book Title: 
Author: 
Started: 
Finished: 

Rating: ⭐⭐⭐⭐⭐

Main Ideas:
-

Favorite Quotes:
"  "

Key Takeaways:
1. 
2. 
3. 

My Thoughts:


Would I Recommend?: ''',
    ),


    NoteTemplate(
      id: 'todo_list',
      name: 'To-Do List',
      icon: '✅',
      category: 'Life',
      title: 'To-Do - [Date]',
      content: '''Priority: High
[ ] 
[ ] 

Priority: Medium
[ ] 
[ ] 

Priority: Low
[ ] 
[ ] 

Notes:''',
    ),

    NoteTemplate(
      id: 'travel_plan',
      name: 'Travel Plan',
      icon: '✈️',
      category: 'Life',
      title: 'Trip to [Destination]',
      content: '''Destination: 
Dates: 
Budget: 

Itinerary:
Day 1:
- 

Day 2:
- 

Packing List:
[ ] 
[ ] 

Bookings:
- Flight: 
- Hotel: 

Emergency Contacts:


Notes & Tips:''',
    ),

    NoteTemplate(
      id: 'recipe',
      name: 'Recipe',
      icon: '🍳',
      category: 'Life',
      title: 'Recipe: [Dish Name]',
      content: '''Dish Name: 
Servings: 
Prep Time: 
Cook Time: 

Ingredients:
- 
- 
- 

Instructions:
1. 
2. 
3. 

Notes & Tips:


Rating: ⭐⭐⭐⭐⭐''',
    ),


    NoteTemplate(
      id: 'goal_setting',
      name: 'Goal Setting',
      icon: '🎯',
      category: 'Growth',
      title: 'Goal: [Title]',
      content: '''Goal: 

Why This Matters:


Timeline:
Start: 
Target: 

Action Steps:
1. 
2. 
3. 

Metrics of Success:
- 

Obstacles & Solutions:
- 

Progress Updates:
[ ] 
[ ] ''',
    ),

    NoteTemplate(
      id: 'reflection',
      name: 'Weekly Reflection',
      icon: '💭',
      category: 'Growth',
      title: 'Reflection - Week of [Date]',
      content: '''This Week's Highlights:
1. 
2. 
3. 

Challenges Faced:
- 

Lessons Learned:
- 

What Went Well:
- 

What Could Be Better:
- 

Next Week's Focus:
1. 
2. ''',
    ),


    NoteTemplate(
      id: 'blank',
      name: 'Blank Note',
      icon: '📝',
      category: 'Basic',
      title: 'Untitled Note',
      content: '',
    ),
  ];

  static List<String> get categories {
    return templates.map((t) => t.category).toSet().toList();
  }

  static List<NoteTemplate> getTemplatesByCategory(String category) {
    return templates.where((t) => t.category == category).toList();
  }

  static NoteTemplate? getTemplateById(String id) {
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
