import 'models.dart';

/// Static roster data from [jnvk_web/index.html] (Batch 2k10 + LE).
class BatchData {
  BatchData._();

  /// App branding (Navodaya Vidyalaya Samiti emblem — splash & in-app; launcher uses [app_icon.png] via flutter_launcher_icons).
  static const String appLogoAsset = 'assets/img/app_logo.png';

  static const String aboutGroupPhotoAsset = 'assets/img/batch2k10.jpg';

  /// Bundled Navodaya anthem for the “Humi Navodaya Hon!” section.
  static const String navodayaAnthemAsset = 'assets/audio/navodaya_anthem.mp3';

  static const String aboutTitle = 'Batch 2k10';
  /// Short label for navigation, hero chip, and section context.
  static const String batchIdentityShort = 'Batch 2k10 + LE';
  static const String aboutSubtitle =
      'Some of us graduated from JNV in 2015; others in 2017. Lateral-entry students joined us along the way.';
  static const String aboutBody =
      'We are Batch 2k10 of Jawahar Navodaya Vidyalaya (JNV) Kaimur, Bihar. We were at Navodaya from 2010 to 2017. '
      'After leaving Navodaya, each of us pursued higher education or another path that suited our goals. Many of us are still '
      'studying; others have started their careers. What unites us is this: we still miss one another and the '
      'memories we made at Navodaya. We seize every chance to meet and stay in touch, and we hope to remain '
      'connected in the years ahead.';

  static const String ctaTitle = 'Humi Navodaya Hon!';
  static const String ctaBody =
      'This was our Navodaya anthem, and it holds a special place in our hearts. Whenever we hear it, we are '
      'carried back to our days at Navodaya and the memories we share.';

  static const List<String> galleryImages = [
    'assets/img/gallery/g1.jpg',
    'assets/img/gallery/g2.jpg',
    'assets/img/gallery/g10.jpg',
    'assets/img/gallery/g4.jpg',
    'assets/img/gallery/g8.jpg',
    'assets/img/gallery/g9.jpg',
  ];

  static const List<HouseRoster> houses = [
    HouseRoster(
      house: House.arawali,
      boysByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Amit Kumar',
          'Harish Patel',
          'Kundan Kumar',
          'Mahashiv Kumar',
          'Pradeep Kumar',
          'Vicky Kumar',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Akash Kumar 1',
          'Akash Kumar 2',
          'Anish Kumar',
          'Arvind Kumar',
          'Alok Kumar',
          'Deepak Kumar',
          'Diyam Kumar',
          'Rajnish Kumar',
          'Ravi Kumar Sharma',
          'Vivekanand Singh',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Ranjeet Bharti',
          'Shwetank Salabh',
        ]),
      ],
      girlsByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Mahima Kumari',
          'Savitri Kumari',
          'Kalpana Sharma',
          'Hewanti Kumari',
          'Khushi Kumari',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Neha Kumari',
          'Annu Gupta',
          'Pratima Kumari',
          'Gunjan Kumari',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Aishwarya Kumari',
          'Sakshi Kumari',
          'Smriti Kumari',
          'Sajia Monir',
        ]),
      ],
    ),
    HouseRoster(
      house: House.shivalik,
      boysByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Rajan Singh',
          'Amjad Alam',
          'Vikash Kumar',
          'Vikash Jaiswal',
          'Anil Kumar',
          'Shailendra Kumar',
          'Sandeep Kumar',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Prince Kumar',
          'Ravindra Kumar',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Shubham Kumar',
          'Amber Singh',
        ]),
      ],
      girlsByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Priti Kumari 1',
          'Suruchi Singh',
          'Priyanka Kumari',
          'Ragini Kumari',
          'Swati Singh',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Lata Bharti',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Radhika Kumari',
          'Riya Kumari',
        ]),
      ],
    ),
    HouseRoster(
      house: House.nilgiri,
      boysByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Adarsh Tripathi',
          'Ankit Kumar',
          'Mahesh Kumar',
          'Dharmendra Kumar',
          'Sanjay Kumar',
          'Vikash Kumar',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Pradeep Kumar',
          'Harendra Kumar',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Ankit Ranjan',
          'Baliram Patel',
          'Divya Mohan',
        ]),
      ],
      girlsByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Jyoti Kumari',
          'Shweta Kumari(A)',
          'Asmita Kumari',
          'Shabnam Nisha',
          'Kritika Raj',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Alka Yadav',
          'Naj Praveen',
          'Shailvi Kumari',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Manisha Patel',
          'Akanksha Priya',
          'Nistha Kumari',
          'Harshita Kumari',
        ]),
      ],
    ),
    HouseRoster(
      house: House.udaygiri,
      boysByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Ranjan Kumar',
          'Ravi Prakash',
          'Ravindra Nath Tagore',
          'Shyam Bihari Singh',
          'Rishabh Kumar',
        ]),
        CohortNames(label: '2010-2017', names: [
          'Atul Kumar',
          'Prabhat Trivedi',
        ]),
        CohortNames(label: 'Lateral Entry', names: [
          'Harshvardhan Singh',
          'Vikash Kumar',
          'Ashutosh Kumar',
        ]),
      ],
      girlsByCohort: [
        CohortNames(label: '2010-2015', names: [
          'Priti Kumari 2',
          'Varsha Kumari',
          'Shweta Kumari(B)',
          'Shaumya Singh',
        ]),
        CohortNames(label: '2010-2017', names: []),
        CohortNames(label: 'Lateral Entry', names: [
          'Sweety Kumari',
        ]),
      ],
    ),
  ];

  static HouseRoster? rosterFor(House house) {
    for (final r in houses) {
      if (r.house == house) return r;
    }
    return null;
  }
}
