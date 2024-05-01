import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Help',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCreatorCard(
                'Bibin Biju',
                'assets/creator1.jpg',
                'https://www.linkedin.com/in/bibin-biju-77305b202',
                'https://github.com/bibinbiju111',
                'bibinbiju2024@cs.sjcetpalai.ac.in',
              ),
              SizedBox(height: 20),
              _buildCreatorCard(
                'Leon Jose Mathew',
                'assets/creator2.jpg',
                'www.linkedin.com/in/leon-jose-mathew',
                'https://github.com/Leon-jose-mathew',
                'leonjosemathew2024@cs.sjcetpalai.ac.in',
              ),
              SizedBox(height: 20),
              _buildCreatorCard(
                'Liss Maria John',
                'assets/creator3.jpg',
                'https://www.linkedin.com/in/lissmariajohn',
                'https://github.com/lissmariajohn',
                'lissmariyajohn2024@cs.sjcetpalai.ac.in',
              ),
              SizedBox(height: 20),
              _buildCreatorCard(
                'Nikhil Jose',
                'assets/creator4.jpg',
                'https://www.linkedin.com/in/nikhil-jose-b92208201',
                'https://github.com/nikhiljose-123',
                'nikhiljose2024@cs.sjcetpalai.ac.in',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorCard(String name, String imagePath, String linkedIn, String github, String email) {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            _buildDetailText('LinkedIn:', linkedIn),
            _buildDetailText('GitHub:', github),
            _buildDetailText('Email:', email),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              detail,
              style: TextStyle(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
