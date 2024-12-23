class Event {
  Request? request;
  int? count;
  List<Item>? item;

  Event({this.request, this.count, this.item});

  Event.fromJson(Map<String, dynamic> json) {
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    count = json['count'];
    if (json['item'] != null) {
      item = <Item>[];
      json['item'].forEach((v) {
        item!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (request != null) {
      data['request'] = request!.toJson();
    }
    data['count'] = count;
    if (item != null) {
      data['item'] = item!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Request {
  String? venue;
  String? ids;
  String? type;
  String? city;
  int? edate;
  int? page;
  String? keywords;
  int? sdate;
  String? category;
  String? cityDisplay;
  int? rows;

  Request(
      {this.venue,
      this.ids,
      this.type,
      this.city,
      this.edate,
      this.page,
      this.keywords,
      this.sdate,
      this.category,
      this.cityDisplay,
      this.rows});

  Request.fromJson(Map<String, dynamic> json) {
    venue = json['venue'];
    ids = json['ids'];
    type = json['type'];
    city = json['city'];
    edate = json['edate'];
    page = json['page'];
    keywords = json['keywords'];
    sdate = json['sdate'];
    category = json['category'];
    cityDisplay = json['city_display'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['venue'] = venue;
    data['ids'] = ids;
    data['type'] = type;
    data['city'] = city;
    data['edate'] = edate;
    data['page'] = page;
    data['keywords'] = keywords;
    data['sdate'] = sdate;
    data['category'] = category;
    data['city_display'] = cityDisplay;
    data['rows'] = rows;
    return data;
  }
}

class Item {
  String? eventId;
  String? eventname;
  String? eventnameRaw;
  String? ownerId;
  String? thumbUrl;
  String? thumbUrlLarge;
  int? startTime;
  String? startTimeDisplay;
  int? endTime;
  String? endTimeDisplay;
  String? location;
  Venue? venue;
  String? label;
  int? featured;
  String? eventUrl;
  String? shareUrl;
  String? bannerUrl;
  double? score;
  List<String>? categories;
  List<String>? tags;
  Tickets? tickets;
  List? customParams;

  Item(
      {this.eventId,
      this.eventname,
      this.eventnameRaw,
      this.ownerId,
      this.thumbUrl,
      this.thumbUrlLarge,
      this.startTime,
      this.startTimeDisplay,
      this.endTime,
      this.endTimeDisplay,
      this.location,
      this.venue,
      this.label,
      this.featured,
      this.eventUrl,
      this.shareUrl,
      this.bannerUrl,
      this.score,
      this.categories,
      this.tags,
      this.tickets,
      this.customParams});

  Item.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventname = json['eventname'];
    eventnameRaw = json['eventname_raw'];
    ownerId = json['owner_id'];
    thumbUrl = json['thumb_url'];
    thumbUrlLarge = json['thumb_url_large'];
    // Convert to int if the value is not null
    startTime = json['start_time'] != null ? json['start_time'].toInt() : null;
    startTimeDisplay = json['start_time_display'];
    // Convert to int if the value is not null
    endTime = json['end_time'] != null ? json['end_time'].toInt() : null;
    endTimeDisplay = json['end_time_display'];
    location = json['location'];
    venue = json['venue'] != null ? Venue.fromJson(json['venue']) : null;
    label = json['label'];
    featured = json['featured'];
    eventUrl = json['event_url'];
    shareUrl = json['share_url'];
    bannerUrl = json['banner_url'];
    score = json['score']?.toDouble(); // Convert to double
    categories = json['categories']?.cast<String>();
    tags = json['tags']?.cast<String>();
    tickets =
        json['tickets'] != null ? Tickets.fromJson(json['tickets']) : null;
    if (json['custom_params'] != null) {
      customParams = <Null>[];
      json['custom_params'].forEach((v) {
        // customParams!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_id'] = eventId;
    data['eventname'] = eventname;
    data['eventname_raw'] = eventnameRaw;
    data['owner_id'] = ownerId;
    data['thumb_url'] = thumbUrl;
    data['thumb_url_large'] = thumbUrlLarge;
    data['start_time'] = startTime;
    data['start_time_display'] = startTimeDisplay;
    data['end_time'] = endTime;
    data['end_time_display'] = endTimeDisplay;
    data['location'] = location;
    if (venue != null) {
      data['venue'] = venue!.toJson();
    }
    data['label'] = label;
    data['featured'] = featured;
    data['event_url'] = eventUrl;
    data['share_url'] = shareUrl;
    data['banner_url'] = bannerUrl;
    data['score'] = score;
    data['categories'] = categories;
    data['tags'] = tags;
    if (tickets != null) {
      data['tickets'] = tickets!.toJson();
    }
    if (customParams != null) {
      // data['custom_params'] =
      // this.customParams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Venue {
  String? street;
  String? city;
  String? state;
  String? country;
  double? latitude;
  double? longitude;
  String? fullAddress;

  Venue(
      {this.street,
      this.city,
      this.state,
      this.country,
      this.latitude,
      this.longitude,
      this.fullAddress});

  Venue.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];

    // Handle both int and double values for latitude and longitude
    latitude = json['latitude'] is int
        ? (json['latitude'] as int).toDouble()
        : json['latitude'];
    longitude = json['longitude'] is int
        ? (json['longitude'] as int).toDouble()
        : json['longitude'];

    fullAddress = json['full_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['full_address'] = fullAddress;
    return data;
  }
}

class Tickets {
  bool? hasTickets;
  String? ticketUrl;
  String? ticketCurrency;
  int? minTicketPrice;
  int? maxTicketPrice;

  Tickets(
      {this.hasTickets,
      this.ticketUrl,
      this.ticketCurrency,
      this.minTicketPrice,
      this.maxTicketPrice});

  Tickets.fromJson(Map<String, dynamic> json) {
    hasTickets = json['has_tickets'];
    ticketUrl = json['ticket_url'];
    ticketCurrency = json['ticket_currency'];
    minTicketPrice = json['min_ticket_price'];
    maxTicketPrice = json['max_ticket_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['has_tickets'] = hasTickets;
    data['ticket_url'] = ticketUrl;
    data['ticket_currency'] = ticketCurrency;
    data['min_ticket_price'] = minTicketPrice;
    data['max_ticket_price'] = maxTicketPrice;
    return data;
  }
}
