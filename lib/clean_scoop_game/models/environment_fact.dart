import 'dart:math';

enum EnvironmentFact {
  none,
  plastic,
  paper,
  organic,
  glass;

  static final _random = Random();

  String get description {
    final randInt = _random.nextInt(10) + 1;

    switch (this) {
      case EnvironmentFact.none:
        return '';
      case EnvironmentFact.plastic:
        return plasticFacts[randInt] ?? '';
      case EnvironmentFact.paper:
        return paperFacts[randInt] ?? '';
      case EnvironmentFact.organic:
        return organicFacts[randInt] ?? '';
      case EnvironmentFact.glass:
        return glassFacts[randInt] ?? '';
    }
  }

  static const plasticFacts = {
    1: "Recycling a plastic bottle conserves approximately 12,000 BTUs (British thermal units) of heat energy.",
    2: "Recycling reduces the need for extracting and processing raw materials, thereby saving natural resources like oil.",
    3: "Using recycled materials for production uses up to 75% less energy compared to new plastic from raw materials.",
    4: "Recycling plastic bottles helps to reduce greenhouse gas emissions that contribute to global warming.",
    5: "By recycling, fewer plastic bottles end up in landfills, thus reducing pollution and the release of harmful chemicals into the soil and groundwater.",
    6: "The recycling process of plastics results in less air and water pollution compared to manufacturing new plastics and incinerating waste.",
    7: "Plastic in the oceans contributes to the death of around 100,000 marine animals annually, which recycling can help prevent.",
    8: "Recycling helps to minimize the use of landfill space, which is increasingly becoming scarce and expensive.",
    9: "Reducing the need for new plastic by recycling lowers the demand for oil, a non-renewable resource.",
    10: "Plastics make up 85% of marine waste and can cause significant ecosystem damage, recycling helps reduce this impact."
  };

  static const paperFacts = {
    1: "Recycling paper reduces the initial need for wood raw materials, which means less tree cutting.",
    2: "Using recycled paper fibers is less energy-intensive than producing new paper from virgin wood pulp.",
    3: "Recycled paper production uses considerably less water compared to virgin paper production.",
    4: "Paper recycling helps in reducing greenhouse gas emissions compared to producing new paper.",
    5: "When paper is recycled, it helps in decreasing the amount of paper waste in landfills.",
    6: "Recycling paper prevents the emissions of air pollutants that are typical in paper production from virgin materials.",
    7: "Paper recycling can lead to a reduction in energy consumption in the paper production process.",
    8: "The process of recycling paper generates less water pollution compared to the processing of virgin materials.",
    9: "The recycling of paper reduces the operational and capital costs per unit of paper, making it economically beneficial.",
    10: "Recycling 5g of paper can contribute to the savings of energy that would otherwise be spent on production, and transportation of new paper."
  };

  static const organicFacts = {
    1: "Composting organic waste helps to reduce methane emissions, a potent greenhouse gas, by breaking down the material in an aerobic process instead of anaerobic decomposition in landfills.",
    2: "The composting process can sequester carbon from the atmosphere and store it in the ground, contributing to the reduction of global warming effects.",
    3: "Through composting, organic waste can transform into nutrient-rich soil, improving soil health and reducing the need for chemical fertilizers.",
    4: "Diverting organic waste to composting can decrease landfill sizes, saving land and reducing the ecological footprint of waste management.",
    5: "Compost adds vital nutrients to the soil, promoting healthy plant growth and higher crop yields, which benefits both home gardeners and farmers.",
    6: "Utilizing compost can aid in soil moisture retention, reducing the need for frequent watering and conserving water resources.",
    7: "Composting at home or locally reduces the distance that waste must travel, cutting down on transportation emissions associated with waste disposal.",
    8: "When done properly, composting can prevent the leaching of organic waste into waterways, protecting aquatic ecosystems from pollution.",
    9: "Implementing composting programs can result in significant cost savings for households and communities by reducing waste disposal fees.",
    10: "Composting creates jobs in the green sector, supporting the economy while promoting sustainable practices."
  };

  static const glassFacts = {
    1: "Recycling glass reduces the need for raw materials like sand, soda ash, limestone, and feldspar, conserving over a ton of natural resources for every ton of glass recycled.",
    2: "Using recycled glass in manufacturing consumes less energy, with energy costs dropping about 2-3% for every 10% of recycled glass (cullet) used.",
    3: "For every six tons of recycled container glass used, a ton of carbon dioxide, a greenhouse gas, is reduced, enhancing the efforts to combat climate change.",
    4: "Including recycled glass in production can extend the life of glass furnaces since it requires lower temperatures to melt the glass.",
    5: "Recycling glass leads to a reduction in CO2 emissions; for every 10% increase in cullet usage, particulates emissions decrease by 8%, nitrogen oxides by 4%, and sulfur oxides by 10%.",
    6: "The glass recycling process is a closed-loop system, meaning it creates no additional waste or by-products.",
    7: "Glass can be recycled endlessly without loss in quality or purity, ensuring ongoing sustainability of the material.",
    8: "Recycling glass contributes to lowering air pollution by 20% and water pollution by 50% compared to producing new glass from raw materials.",
    9: "Using recycled glass in production helps decrease the price of glass products by reducing operating costs.",
    10: "Recycled glass cullet melts at a lower temperature than raw materials, leading to savings on the energy required for melting the glass."
  };
}
