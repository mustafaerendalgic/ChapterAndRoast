class Product {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? image;
  final bool isFeatured;
  final String? badge;
  
  // New detail fields
  final String? category; // e.g. "PREMIUM ROAST NO. 042"
  final String? quote; // "A liquid sonnet..."
  final String? subTitle; // "Single Origin - 250g"
  final String? provenanceBody; // Detailed description
  final List<String>? flavorNotes; // ["Dark Chocolate", "Toasted Oak"]
  final String? origin; // "Ethiopia"
  final String? roastLevel; // "Dark/Bold"
  final String? process; // "Washed"
  final String? elevation; // "1800m"
  final String? ritualGenre; // "Existential Philosophy"
  final String? ritualVessel; // "Matte Obsidian Stein"
  final bool isHot;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.isFeatured = false,
    this.badge,
    this.category,
    this.quote,
    this.subTitle,
    this.provenanceBody,
    this.flavorNotes,
    this.origin,
    this.roastLevel,
    this.process,
    this.elevation,
    this.ritualGenre,
    this.ritualVessel,
    this.isHot = true,
  });
}
