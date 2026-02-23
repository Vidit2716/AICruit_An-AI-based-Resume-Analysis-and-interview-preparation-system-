class TopicModel {
  final String id;
  final String topicName;
  final List<String> subTopics;
  final String imageUrl;

  TopicModel({
    required this.id,
    required this.topicName,
    required this.subTopics,
    required this.imageUrl,
  });

  static List<TopicModel> topicsList = [
    TopicModel(
      id: '1',
      topicName: 'Data Structures and Algorithms (DSA)',
      subTopics: [
        'Arrays and Strings',
        'Linked Lists (Singly, Doubly)',
        'Stacks and Queues',
        'Trees (Binary, AVL, B-trees)',
        'Graphs (BFS, DFS)',
        'Sorting and Searching Algorithms',
        'Dynamic Programming',
        'Recursion',
        'Hashing and Hash Maps',
        'Greedy Algorithms'
      ],
      imageUrl: 'assets/topics/1.png',
    ),
    TopicModel(
      id: '2',
      topicName: 'Flutter',
      subTopics: [
        'State Management (Provider, BloC, Riverpod)',
        'Widgets (Stateless, Stateful)',
        'Navigation and Routing (Navigator 2.0, named routes)',
        'Animations and Transitions',
        'Working with Firebase (Authentication, Firestore, Realtime Database)',
        'Flutter Architecture (MVVM, MVC)',
        'Networking (HTTP, REST API integration)',
        'Local Storage (Hive, Shared Preferences)',
        'Testing (Unit, Widget, Integration Testing)'
      ],
      imageUrl: 'assets/topics/2.png',
    ),
    TopicModel(
      id: '3',
      topicName: 'React Native',
      subTopics: [
        'Components (Functional, Class-based)',
        'State Management (Redux, Context API)',
        'Navigation (React Navigation)',
        'Hooks (useState, useEffect, custom hooks)',
        'Animations (Animated API, Reanimated)',
        'Networking (Axios, Fetch API)',
        'Firebase Integration',
        'Styling (Styled Components, Flexbox)',
        'Testing (Jest, Enzyme)',
        'Handling Forms (Formik, Yup)'
      ],
      imageUrl: 'assets/topics/3.png',
    ),
    TopicModel(
      id: '4',
      topicName: 'JavaScript',
      subTopics: [
        'ES6+ Features (Arrow functions, Promises, async/await)',
        'Event Handling and DOM Manipulation',
        'Closures, Hoisting, and Scope',
        'Callbacks, Promises, and Async/Await',
        'JavaScript Design Patterns',
        'Object-Oriented JavaScript',
        'Functional Programming',
        'Memory Management and Performance Optimization',
        'Modules and Bundling (Webpack, Babel)'
      ],
      imageUrl: 'assets/topics/4.png',
    ),
    TopicModel(
      id: '5',
      topicName: 'SQL/Database',
      subTopics: [
        'SQL Queries (SELECT, INSERT, UPDATE, DELETE)',
        'Joins (INNER, LEFT, RIGHT, FULL)',
        'Indexing and Query Optimization',
        'Stored Procedures and Functions',
        'ACID Properties',
        'Normalization and Denormalization',
        'Transactions and Locks',
        'Views and Triggers'
      ],
      imageUrl: 'assets/topics/5.png',
    ),
    TopicModel(
      id: '6',
      topicName: 'Python',
      subTopics: [
        'OOP in Python (Classes, Inheritance, Polymorphism)',
        'Data Structures (Lists, Tuples, Sets, Dictionaries)',
        'File Handling',
        'Exception Handling',
        'Libraries (NumPy, Pandas, Matplotlib)',
        'Web Development (Django, Flask)',
        'Testing (unittest, pytest)',
        'Decorators and Generators'
      ],
      imageUrl: 'assets/topics/6.png',
    ),
  ];
}
