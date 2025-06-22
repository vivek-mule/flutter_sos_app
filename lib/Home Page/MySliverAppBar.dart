import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('E d MMM').format(DateTime.now()); // Variable to store the formatted date

    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.black.withOpacity(0.9),
      elevation: 0,
      toolbarHeight: 56.0,
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SOS Label
              Text(
                'SOS',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  letterSpacing: 2,
                ),
              ),

              // Calendar Info Box
              _buildCalendarWidget(
                formattedDate,
                Icons.calendar_month_outlined,
                Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // This function builds the calendar widget
  Widget _buildCalendarWidget(String text, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: iconColor, size: 18),
        ],
      ),
    );
  }
}
