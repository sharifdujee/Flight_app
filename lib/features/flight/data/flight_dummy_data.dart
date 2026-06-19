

// ─── Airline catalogue used for mock route generation ────────────────────────
const airlines = [
  AirlineInfo(
    'Emirates',
    'EK',
    'https://www.gstatic.com/flights/airline_logos/70px/EK.png',
  ),
  AirlineInfo(
    'Qatar Airways',
    'QR',
    'https://www.gstatic.com/flights/airline_logos/70px/QR.png',
  ),
  AirlineInfo(
    'flydubai',
    'FZ',
    'https://www.gstatic.com/flights/airline_logos/70px/FZ.png',
  ),
  AirlineInfo(
    'Turkish Airlines',
    'TK',
    'https://www.gstatic.com/flights/airline_logos/70px/TK.png',
  ),
  AirlineInfo(
    'Lufthansa',
    'LH',
    'https://www.gstatic.com/flights/airline_logos/70px/LH.png',
  ),
  AirlineInfo(
    'British Airways',
    'BA',
    'https://www.gstatic.com/flights/airline_logos/70px/BA.png',
  ),
  AirlineInfo(
    'Singapore Airlines',
    'SQ',
    'https://www.gstatic.com/flights/airline_logos/70px/SQ.png',
  ),
  AirlineInfo(
    'Air France',
    'AF',
    'https://www.gstatic.com/flights/airline_logos/70px/AF.png',
  ),
  AirlineInfo(
    'KLM',
    'KL',
    'https://www.gstatic.com/flights/airline_logos/70px/KL.png',
  ),
  AirlineInfo(
    'Etihad Airways',
    'EY',
    'https://www.gstatic.com/flights/airline_logos/70px/EY.png',
  ),
];

class AirlineInfo {
  final String name;
  final String code;
  final String logo;
  const AirlineInfo(this.name, this.code, this.logo);
}

// ─── Hub airports used for layover generation ─────────────────────────────────
const hubs = [
  ('DXB', 'Dubai International Airport'),
  ('DOH', 'Hamad International Airport'),
  ('IST', 'Istanbul Airport'),
  ('LHR', 'London Heathrow Airport'),
  ('CDG', 'Charles de Gaulle Airport'),
  ('AMS', 'Amsterdam Airport Schiphol'),
  ('FRA', 'Frankfurt Airport'),
  ('SIN', 'Singapore Changi Airport'),
  ('AUH', 'Abu Dhabi International Airport'),
  ('KUL', 'Kuala Lumpur International Airport'),
];