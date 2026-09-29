package com.example.data.repository

data class LocalizedRecipeDetail(
    val title: String,
    val ingredientsMetric: String,
    val ingredientsImperial: String,
    val instructions: String,
    val chefTips: String,
    val upcyclingBenefit: String
)

object RecipeTranslations {
    private val translations = mapOf(
        "SALMONE_CBT" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Fileto di Salmone CBT con Crema all'Albicocca",
                ingredientsMetric = "• 200g Filetto di salmone fresco (pelle intatta)\n• 80g Albicocche fresche denocciolate\n• 10ml Olio extravergine d'oliva\n• 2g Scorza d'arancia biologica (scarto da spremuta)\n• 1 Rametto di rosmarino\n• Sale e pepe q.b.",
                ingredientsImperial = "• 7.0 oz Fresh salmon fillet (skin-on)\n• 2.8 oz Fresh pitted apricots\n• 2 tsp Extra virgin olive oil\n• 0.07 oz Organic orange peel (leftover from juice)\n• 1 Rosemary sprig\n• Salt and pepper to taste",
                instructions = "1. Condire il salmone con un filo d'olio, sale e pepe.\n2. Inserire il filetto nel sacchetto per sottovuoto alimentare insieme al rosmarino.\n3. Sigillare con l'apposita macchina regolando al massimo vuoto.\n4. Cuocere in bagno termostatico CBT a 52°C per 40 minuti.\n5. Frullare le albicocche con la scorza d'arancia e un goccio d'acqua calda fino a ottenere una crema liscia.\n6. Estrarre il salmone, scottare velocemente la pelle in padella bollente (reazione di Maillard) per 1 minuto per renderla croccante.\n7. Servire il salmone sopra la crema di albicocche calda.",
                chefTips = "Il sottovuoto a 52°C cuoce le proteine in modo perfetto, mantenendo l'albumina all'interno per una succosità incomparabile. La reazione di Maillard deve essere brevissima per non cuocere l'interno della polpa.",
                upcyclingBenefit = "L'upcycling delle bucce d'arancia e delle albicocche mature riduce lo spreco idrico di 120 litri ed evita emissioni di CO2."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "CBT Salmon Fillet with Apricot Cream",
                ingredientsMetric = "• 200g Fresh salmon fillet (skin-on)\n• 80g Fresh pitted apricots\n• 10ml Extra virgin olive oil\n• 2g Organic orange peel (leftover from juice)\n• 1 Rosemary sprig\n• Salt and pepper to taste",
                ingredientsImperial = "• 7.0 oz Fresh salmon fillet (skin-on)\n• 2.8 oz Fresh pitted apricots\n• 2 tsp Extra virgin olive oil\n• 0.07 oz Organic orange peel (leftover from juice)\n• 1 Rosemary sprig\n• Salt and pepper to taste",
                instructions = "1. Season salmon with oil, salt, and pepper.\n2. Place fillet into a food-grade vacuum bag with rosemary.\n3. Vacuum seal using a chamber sealer or external suction sealer.\n4. Cook in a sous-vide water bath at 125°F (52°C) for 40 minutes.\n5. Blend pitted apricots with orange peel and a splash of warm water until velvety.\n6. Remove salmon, sear the skin side in a scorching hot pan (Maillard reaction) for 1 minute for extreme crispness.\n7. Serve salmon over the warm apricot cream.",
                chefTips = "Vacuum cooking at 52°C cooks proteins perfectly, holding albumin inside for unparalleled juiciness. Searing must be extremely short so as not to cook the inside.",
                upcyclingBenefit = "Upcycling orange peels and overripe apricots saves 120 liters of virtual water and prevents CO2 emissions."
            ),
            "ES" to LocalizedRecipeDetail(
                title = "Filete de Salmón al Vacío con Crema de Albaricoque",
                ingredientsMetric = "• 200g de filete de salmón fresco (con piel)\n• 80g de albaricoques frescos deshuesados\n• 10ml de aceite de oliva virgen extra\n• 2g de ralladura de naranja ecológica (sobra de zumo)\n• 1 rama de romero\n• Sal y pimienta al gusto",
                ingredientsImperial = "• 7.0 oz de filete de salmón fresco (con piel)\n• 2.8 oz de albaricoques frescos deshuesados\n• 2 cucharaditas de aceite de oliva virgen extra\n• 0.07 oz de ralladura de naranja ecológica (sobra de zumo)\n• 1 rama de romero\n• Sal y pimienta al gusto",
                instructions = "1. Sazonar el salmón con un hilo de aceite, sal y pimienta.\n2. Introducir el filete en la bolsa de vacío para alimentos junto con el romero.\n3. Sellar al vacío al máximo con la máquina.\n4. Cocinar en un baño de agua termostático (Sous-Vide) a 52°C durante 40 minutos.\n5. Triturar los albaricoques con la ralladura de naranja y un chorrito de agua caliente hasta obtener una crema suave.\n6. Retirar el salmón, dorar rápidamente la piel en una sartén muy caliente (reacción de Maillard) durante 1 minuto para que quede crujiente.\n7. Servir el salmón sobre la crema templada de albaricoque.",
                chefTips = "La cocción al vacío a 52°C cocina las proteínas de manera perfecta, manteniendo la albúmina en el interior para una jugosidad incomparable. El marcado debe ser muy breve para no cocinar el interior del filete.",
                upcyclingBenefit = "El upcycling de las pieles de naranja y los albaricoques maduros reduce la huella hídrica en 120 litros y evita emisiones de CO2."
            ),
            "FR" to LocalizedRecipeDetail(
                title = "Filet de Saumon Sous-Vide à la Crème d'Abricot",
                ingredientsMetric = "• 200g de filet de saumon frais (avec peau)\n• 80g d'abricots frais dénoyautés\n• 10ml d'huile d'olive vierge extra\n• 2g de zeste d'orange biologique (reste de jus pressé)\n• 1 brin de romarin\n• Sel et poivre",
                ingredientsImperial = "• 7.0 oz de filet de saumon frais (avec peau)\n• 2.8 oz d'abricots frais dénoyautés\n• 2 cuillères à café d'huile d'olive vierge extra\n• 0.07 oz de zeste d'orange biologique (reste de jus pressé)\n• 1 brin de romarin\n• Sel et poivre",
                instructions = "1. Assaisonner le saumon avec un filet d'huile, du sel y du poivre.\n2. Placer le filet dans un sac sous-vide alimentaire avec le romarin.\n3. Sceller sous-vide au maximum avec la machine.\n4. Cuire au bain-marie sous-vide à 52°C pendant 40 minutes.\n5. Mixer les abricots avec le zeste d'orange et un filet d'eau chaude jusqu'à obtenir une crème lisse.\n6. Retirer le saumon, saisir rapidement le côté peau dans une poêle brûlante (réaction de Maillard) pendant 1 minute pour la rendre croustillante.\n7. Servir el saumon sur la crème d'abricot tiède.",
                chefTips = "La cuisson sous-vide à 52°C cuit parfaitement les protéines, gardant l'albumine à l'intérieur pour un moelleux incomparable. Le saisissage doit être très court pour ne pas cuire l'intérieur.",
                upcyclingBenefit = "L'upcycling des zestes d'orange et des abricots mûrs réduit l'empreinte eau de 120 litres et évite des émissions de CO2."
            ),
            "DE" to LocalizedRecipeDetail(
                title = "Sous-Vide Lachsfilet mit Aprikosencreme",
                ingredientsMetric = "• 200g frisches Lachsfilet (mit Haut)\n• 80g frische, entsteinte Aprikosen\n• 10ml extra natives Olivenöl\n• 2g Bio-Orangenschale (Reste vom Auspressen)\n• 1 Zweig Rosmarin\n• Salz und Pfeffer nach Geschmack",
                ingredientsImperial = "• 7.0 oz frisches Lachsfilet (mit Haut)\n• 2.8 oz frische, entsteinte Aprikosen\n• 2 TL extra natives Olivenöl\n• 0.07 oz Bio-Orangenschale (Reste vom Auspressen)\n• 1 Zweig Rosmarin\n• Salz und Pfeffer nach Geschmack",
                instructions = "1. Den Lachs mit etwas Öl, Salz und Pfeffer würzen.\n2. Das Filet zusammen mit dem Rosmarin in einen Vakuumbeutel geben.\n3. Mit dem Vakuumiergerät bei maximalem Vakuum versiegeln.\n4. Im Sous-Vide-Wasserbad bei 52°C für 40 Minuten garen.\n5. Die Aprikosen mit der Orangenschale und einem Schuss warmem Wasser zu einer glatten Creme pürieren.\n6. Den Lachs entnehmen, die Hautseite in einer sehr heißen Pfanne kurz anbraten (Maillard-Reaktion), um sie für 1 Minute knusprig zu machen.\n7. Den Lachs auf der warmen Aprikosencreme servieren.",
                chefTips = "Das Vakuumgaren bei 52°C gart die Proteine perfekt und hält das Albumin im Inneren für unvergleichliche Saftigkeit. Das Anbraten muss sehr kurz sein, um das Innere nicht zu übergaren.",
                upcyclingBenefit = "Das Upcycling von Orangenschalen und überreifen Aprikosen spart 120 Liter virtuelles Wasser und vermeidet CO2-Emissionen."
            )
        ),
        "CHIPS_BUCCE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Chips Croccanti di Bucce di Patata",
                ingredientsMetric = "• 150g Bucce di patate biologiche (lavate accuratamente)\n• 15ml Olio di semi o d'oliva\n• 1g Rosmarino tritato fine\n• 3g Sale marino grosso o di Cipro",
                ingredientsImperial = "• 5.3 oz Organic potato peels (well-washed)\n• 1 tbsp Seed or olive oil\n• 0.03 oz Finely minced rosemary\n• 0.1 oz Sea salt or Cyprus flake salt",
                instructions = "1. Lavare benissimo le patate prima di sbucciarle. Lasciare riposare le bucce in acqua fredda per 10 minuti per eliminare l'amido in eccesso.\n2. Asciugare le bucce perfettamente con un canovaccio pulito.\n3. Condire le bucce in una ciotola con olio, sale e rosmarino tritato.\n4. Disporre in un unico strato sul cestello della friggitrice ad aria o su una teglia da forno.\n5. Cuocere a 200°C per 12-15 minuti, scuotendo a metà cottura, finché non saranno dorate e super croccanti.\n6. Servir calde come snack anti-spreco.",
                chefTips = "L'umidità è il nemico della croccantezza. Più asciutte saranno le bucce prima della cottura, più risulteranno croccanti. Potete spolverare con lievito alimentare in scaglie per un sapore 'formaggioso' vegano.",
                upcyclingBenefit = "Il recupero delle bucce di patata evita scarti organici umidi, risparmiando 50 litri d'acqua dolce per porzione."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Crispy Potato Peel Chips",
                ingredientsMetric = "• 150g Organic potato peels (well-washed)\n• 15ml Seed or olive oil\n• 1g Finely minced rosemary\n• 3g Sea salt or Cyprus flake salt",
                ingredientsImperial = "• 5.3 oz Organic potato peels (well-washed)\n• 1 tbsp Seed or olive oil\n• 0.03 oz Finely minced rosemary\n• 0.1 oz Sea salt or Cyprus flake salt",
                instructions = "1. Wash potatoes thoroughly before peeling. Soak the peels in cold water for 10 minutes to remove excess starch.\n2. Dry the peels completely using a clean kitchen towel.\n3. Toss the peels in a bowl with oil, salt, and minced rosemary.\n4. Spread them in a single layer in an air fryer basket or baking sheet.\n5. Air fry or bake at 390°F (200°C) for 12-15 minutes, shaking halfway, until golden and extremely crispy.\n6. Serve hot as an ultimate zero-waste snack.",
                chefTips = "Moisture is the enemy of crispiness. The drier the peels are before cooking, the crunchier they will be. You can dust with nutritional yeast flakes for a vegan 'cheesy' flavor.",
                upcyclingBenefit = "Recovering potato peels avoids wet organic waste, saving 50 liters of fresh water per serving."
            ),
            "ES" to LocalizedRecipeDetail(
                title = "Chips Crujientes de Piel de Patata",
                ingredientsMetric = "• 150g de pieles de patatas ecológicas (lavadas meticulosamente)\n• 15ml de aceite de semillas o de oliva\n• 1g de romero picado fino\n• 3g de sal marina gorda o escamas de Chipre",
                ingredientsImperial = "• 5.3 oz de pieles de patatas ecológicas (lavadas meticulosamente)\n• 1 cucharada de aceite de semillas o de oliva\n• 0.03 oz de romero picado fino\n• 0.1 oz de sal marina gorda o escamas de Chipre",
                instructions = "1. Lavar muy bien las patatas antes de pelarlas. Dejar reposar las pieles en agua fría durante 10 minutos para eliminar el exceso de almidón.\n2. Secar las pieles perfectamente con un paño limpio.\n3. Condimentar las pieles en un bol con aceite, sal y romero picado.\n4. Extender en una sola capa en la cesta de la freidora de aire o en una bandeja de horno.\n5. Cocinar a 200°C durante 12-15 minutos, sacudiendo a mitad de la cocción, hasta que estén doradas y super crujientes.\n6. Servir calientes como snack anti-desperdicio.",
                chefTips = "La humedad es el enemigo de la textura crujiente. Cuanto más secas estén las pieles antes de cocinarlas, más crujientes quedarán. Puedes espolvorear levadura nutricional en escamas para un toque vegano con sabor a queso.",
                upcyclingBenefit = "El aprovechamiento de las pieles de patata evita residuos orgánicos húmedos, ahorrando 50 litros de agua dulce por porción."
            ),
            "FR" to LocalizedRecipeDetail(
                title = "Chips Croustillantes de Pelures de Pommes de Terre",
                ingredientsMetric = "• 150g de pelures de pommes de terre biologiques (soigneusement lavées)\n• 15ml d'huile de graines ou d'olive\n• 1g de romarin finement haché\n• 3g de gros sel marin ou de sel de Chypre",
                ingredientsImperial = "• 5.3 oz de pelures de pommes de terre biologiques (soigneusement lavées)\n• 1 cuillère à soupe d'huile de graines ou d'olive\n• 0.03 oz de romarin finement haché\n• 0.1 oz de gros sel marin ou de sel de Chypre",
                instructions = "1. Laver très soigneusement les pommes de terre avant de les peler. Laisser reposer les pelures dans l'eau froide pendant 10 minutes pour éliminer l'excès d'amidon.\n2. Sécher parfaitement les pelures avec un torchon propre.\n3. Assaisonner les pelures dans un bol avec l'huile, le sel et le romarin haché.\n4. Disposer en une seule couche dans le panier de la friteuse sans huile ou sur une plaque de cuisson.\n5. Cuire à 200°C pendant 12-15 minutes, en remuant à mi-cuisson, jusqu'à ce qu'elles soient dorées et ultra croustillantes.\n6. Servir chaud comme en-cas anti-gaspillage.",
                chefTips = "L'humidité est l'ennemi du croustillant. Plus les pelures seront sèches avant la cuisson, plus elles seront croustillantes. Vous pouvez saupoudrer de levure nutritionnelle en paillettes pour un goût fromager vegan.",
                upcyclingBenefit = "Récupérer les pelures de pommes de terre évite les déchets organiques humides, économisant 50 litres d'eau douce par portion."
            ),
            "DE" to LocalizedRecipeDetail(
                title = "Knusprige Kartoffelschalen-Chips",
                ingredientsMetric = "• 150g Bio-Kartoffelschalen (gründlich gewaschen)\n• 15ml Pflanzen- oder Olivenöl\n• 1g fein gehackter Rosmarin\n• 3g grobes Meersalz oder Zypern-Salzflocken",
                ingredientsImperial = "• 5.3 oz Bio-Kartoffelschalen (gründlich gewaschen)\n• 1 EL Pflanzen- oder Olivenöl\n• 0.03 oz fein gehackter Rosmarin\n• 0.1 oz grobes Meersalz oder Zypern-Salzflocken",
                instructions = "1. Kartoffeln vor dem Schälen sehr gründlich waschen. Die Schalen 10 Minuten in kaltem Wasser einweichen, um überschüssige Stärke zu entfernen.\n2. Die Schalen mit einem sauberen Tuch perfekt abtrocknen.\n3. Die Schalen in einer Schüssel mit Öl, Salz und gehacktem Rosmarin mischen.\n4. In einer einzigen Schicht im Korb der Heißluftfritteuse oder auf einem Backblech verteilen.\n5. Bei 200°C für 12-15 Minuten garen, dabei zur Hälfte der Zeit schütteln, bis sie goldbraun und super knusprig sind.\n6. Heiß als Anti-Verschwendungs-Snack servieren.",
                chefTips = "Feuchtigkeit ist der Feind der Knusprigkeit. Je trockener die Schalen vor dem Garen sind, desto knuspriger werden sie. Für ein veganes Käsestroma können Sie Nährhefeflocken darüber streuen.",
                upcyclingBenefit = "Die Verwertung von Kartoffelschalen vermeidet nassen organischen Abfall und spart 50 Liter Süßwasser pro Portion."
            )
        ),
        "PAPPA_POMODORO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Pappa al Pomodoro Gourmet con Pane Raffermo",
                ingredientsMetric = "• 300g Pane raffermo toscano o casereccio\n• 500g Passata di pomodoro dolce o pelati\n• 2 Spicchi d'aglio fresco\n• 50ml Olio extravergine d'oliva di alta qualità\n• 10 Foglie di basilico fresco\n• 400ml Brodo vegetale caldo",
                ingredientsImperial = "• 10.5 oz Stale rustic country bread\n• 17.6 oz Sweet tomato purée or peeled tomatoes\n• 2 Fresh garlic cloves\n• 3.5 tbsp High-quality extra virgin olive oil\n• 10 Fresh basil leaves\n• 1.7 cups Hot vegetable broth",
                instructions = "1. Strofinare le fette di pane raffermo con l'aglio fresco, poi tagliarle a cubetti.\n2. In una pentola di ghisa, scaldare metà dell'olio con l'aglio rimasto leggermente schiacciato.\n3. Aggiungere il pomodoro e cuocere a fuoco medio per 10 minuti.\n4. Unire il pane a cubetti e versare il brodo vegetale caldo fino a coprire.\n5. Cuocere a fuoco lento per 20 minuti mescolando spesso per 'rompere' il pane fino a ottenere una pappa densa.\n6. Spegnere il fuoco, aggiungere il basilico spezzato a mano e lasciare riposare coperto per 15 informazioni.\n7. Servire tiepida con un generoso giro d'olio a crudo.",
                chefTips = "La pappa al pomodoro deve cuocere lentamente. L'uso della ghisa distribuisce il calore in modo uniforme, caramellando delicatamente gli zuccheri del pomodoro sul fondo della pentola per un aroma inimitabile.",
                upcyclingBenefit = "Upcycling 300g di pane raffermo salva 250 litri d'acqua virtuale e riduce le emissioni dei rifiuti domestici."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Gourmet Tuscan Stale Bread Soup",
                ingredientsMetric = "• 300g Stale rustic country bread\n• 500g Sweet tomato purée or peeled tomatoes\n• 2 Fresh garlic cloves\n• 50ml High-quality extra virgin olive oil\n• 10 Fresh basil leaves\n• 400ml Hot vegetable broth",
                ingredientsImperial = "• 10.5 oz Stale rustic country bread\n• 17.6 oz Sweet tomato purée or peeled tomatoes\n• 2 Fresh garlic cloves\n• 3.5 tbsp High-quality extra virgin olive oil\n• 10 Fresh basil leaves\n• 1.7 cups Hot vegetable broth",
                instructions = "1. Rub slices of stale bread with fresh garlic, then cut into small cubes.\n2. In a Dutch oven or heavy cast-iron pot, heat half of the olive oil with the remaining garlic clove (crushed).\n3. Add the tomatoes and cook over medium heat for 10 minutes.\n4. Stir in the bread cubes and pour in hot vegetable broth to cover.\n5. Simmer over low heat for 20 minutes, stirring frequently to break down the bread into a thick porridge.\n6. Remove from heat, stir in hand-torn basil leaves, cover and rest for 15 minutes.\n7. Serve warm topped with a generous drizzle of raw premium olive oil.",
                chefTips = "Tuscan stale bread soup must simmer slowly. Cast-iron distributes heat evenly, gently caramelizing tomato sugars on the bottom for an inimitable flavor.",
                upcyclingBenefit = "Upcycling 300g of stale bread saves 250 liters of virtual water and reduces household waste emissions."
            ),
            "ES" to LocalizedRecipeDetail(
                title = "Sopa de Pan Duro y Tomates Toscana",
                ingredientsMetric = "• 300g de pan duro toscano o rústico\n• 500g de puré de tomate dulce o tomates pelados\n• 2 dientes de ajo fresco\n• 50ml de aceite de oliva virgen extra de alta calidad\n• 10 hojas de albahaca fresca\n• 400ml de caldo de verduras caliente",
                ingredientsImperial = "• 10.5 oz de pan duro rústico\n• 17.6 oz de puré de tomate dulce o tomates pelados\n• 2 dientes de ajo fresco\n• 3.5 cucharadas de aceite de oliva virgen extra de alta calidad\n• 10 hojas de albahaca fresca\n• 1.7 tazas de caldo de verduras caliente",
                instructions = "1. Frota las rebanadas de pan duro con el ajo fresco y luego córtalas en dados pequeños.\n2. En una olla de hierro fundido, calienta la mitad del aceite con el diente de ajo restante ligeramente aplastado.\n3. Añade el tomate y cocina a fuego medio durante 10 minutos.\n4. Incorpora los dados de pan y añade el caldo de verduras caliente hasta cubrir.\n5. Cocina a fuego lento durante 20 minutos mezclando a menudo para deshacer el pan hasta conseguir una sopa espesa.\n6. Apaga el fuego, añade la albahaca picada a mano y deja reposar tapado durante 15 minutos.\n7. Servir templada con un chorro generoso de aceite en crudo.",
                chefTips = "La pappa al pomodoro debe cocinarse lentamente. El hierro fundido distribuye el calor uniformemente, caramelizando los azúcares naturales del tomate para un aroma insuperable.",
                upcyclingBenefit = "El upcycling de 300g de pan duro ahorra 250 litros de agua virtual y evita las emisiones de los vertederos."
            ),
            "FR" to LocalizedRecipeDetail(
                title = "Soupe de Pain Rassis et Tomate Toscane",
                ingredientsMetric = "• 300g de pain rassis toscan ou de campagne\n• 500g de coulis de tomate douce ou tomates pelées\n• 2 gousses d'ail frais\n• 50ml d'huile d'olive vierge extra de haute qualité\n• 10 feuilles de basilic frais\n• 400ml de bouillon de légumes chaud",
                ingredientsImperial = "• 10.5 oz de pain rassis de campagne\n• 17.6 oz de coulis de tomate douce ou tomates pelées\n• 2 gousses d'ail frais\n• 3.5 cuillères à soupe d'huile d'olive de haute qualité\n• 10 feuilles de basilic frais\n• 1.7 tasses de bouillon de légumes chaud",
                instructions = "1. Frotter les tranches de pain rassis avec l'ail frais, puis les couper en petits dés.\n2. Dans une cocotte en fonte, faire chauffer la moitié de l'huile avec la gousse d'ail restante légèrement écrasée.\n3. Ajouter la tomate et cuire à feu moyen pendant 10 minutes.\n4. Ajouter les dés de pain et verser le bouillon de légumes chaud pour couvrir.\n5. Mijoter à feu doux pendant 20 minutes en remuant souvent pour écraser le pain jusqu'à obtention d'une consistance épaisse.\n6. Retirer du feu, ajouter les feuilles de basilic déchirées à la main, couvrir et laisser reposer pendant 15 minutes.\n7. Servir tiède avec un généreux filet d'huile d'olive crue.",
                chefTips = "La pappa al pomodoro doit cuire lentement. La fonte répartit uniformément la chaleur, caramélisant doucement les sucres de la tomate pour un goût incomparable.",
                upcyclingBenefit = "Valoriser 300g de pain rassis permet d'économiser 250 litres d'eau virtuelle et de réduire les déchets ménagers."
            ),
            "DE" to LocalizedRecipeDetail(
                title = "Toskanische Tomatensuppe mit Altbrot",
                ingredientsMetric = "• 300g toskanisches Altbrot oder Landbrot\n• 500g süßes Tomatenpüree oder geschälte Tomaten\n• 2 frische Knoblauchzehen\n• 50ml hochwertiges extra natives Olivenöl\n• 10 frische Basilikumblätter\n• 400ml heiße Gemüsebrühe",
                ingredientsImperial = "• 10.5 oz rustikales Landbrot (altbacken)\n• 17.6 oz süßes Tomatenpüree oder geschälte Tomaten\n• 2 frische Knoblauchzehen\n• 3.5 EL hochwertiges Olivenöl\n• 10 frische Basilikumblätter\n• 1.7 Tassen heiße Gemüsebrühe",
                instructions = "1. Die Altbrotscheiben mit frischem Knoblauch einreiben, dann in kleine Würfel schneiden.\n2. In einem gusseisernen Topf die Hälfte des Öls mit der restlichen, leicht zerdrückten Knoblauchzehe erhitzen.\n3. Die Tomaten hinzufügen und bei mittlerer Hitze 10 Minuten garen.\n4. Die Brotwürfel hinzugeben und mit heißer Gemüsebrühe aufgießen, bis alles bedeckt ist.\n5. Bei schwacher Hitze 20 Minuten köcheln lassen, dabei häufig umrühren, um das Brot zu einer dicken Suppe zu zerdrücken.\n6. Vom Herd nehmen, handzerrissenen Basilikum untermischen, abdecken und 15 Minuten ruhen lassen.\n7. Lauwarm mit einem großzügigen Schuss rohem Olivenöl servieren.",
                chefTips = "Die Tomaten-Brot-Suppe muss langsam köcheln. Gusseisen verteilt die Wärme gleichmäßig und karamellisiert den Tomatenzucker sanft am Topfboden für ein unnachahmliches Aroma.",
                upcyclingBenefit = "Das Upcycling von 300g Altbrot spart 250 Liter virtuelles Wasser und verringert den Hausmüll."
            )
        ),
        "RISOTTO_MIDOLLO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Risotto allo Zafferano con Midollo e Polvere di Gambi",
                ingredientsMetric = "• 320g Riso Carnaroli superfino\n• 1 Bustina di zafferano in pistilli\n• 50g Midollo di bue fresco\n• 80g Burro gelato tagliato a cubetti\n• 60g Parmigiano Reggiano 30 mesi grattugiato\n• 100ml Vino bianco secco\n• 1.2L Brodo di carne leggero\n• 5g Polvere di gambi (sedano/prezzemolo essiccati)",
                ingredientsImperial = "• 11.3 oz Premium Carnaroli rice\n• 1 pinch Saffron threads\n• 1.8 oz Fresh beef bone marrow\n• 2.8 oz Ice-cold cubed butter\n• 2.1 oz Grated Parmigiano Reggiano (30-month aged)\n• 3.4 fl oz Dry white wine\n• 5 cups Light beef stock\n• 0.17 oz Stem powder (dehydrated celery/parsley stalks)",
                instructions = "1. In un tegame ampio, sciogliere il midollo a fuoco lento, quindi unire il riso e tostarlo per 3 minuti finché i chicchi non saranno lucidi e caldi.\n2. Sfumare con il vino bianco e far evaporare completamente.\n3. Iniziare ad aggiungere il brodo bollente un mestolo alla volta, mescolando dolcemente.\n4. A metà cottura (circa 9 minuti), aggiungere i pistilli di zafferano precedentemente infusi in mezzo bicchiere di brodo caldo.\n5. Continuare ad aggiungere brodo fino a raggiungere la cottura al dente (circa 16-18 minuti).\n6. Togliere dal fuoco. Unire il burro gelato e il Parmigiano. Coprire e lasciar riposare per 2 minuti.\n7. Mantecare energicamente facendo oscillare il tegame 'all'onda'.\n8. Impiattare piatto e spolverare la superficie con la polvere aromatica di gambi per un tocco erbaceo e colorato.",
                chefTips = "Il burro per la mantecatura deve essere freddissimo, quasi congelato. Lo shock termico tra il riso bollente e il grasso freddo crea un'emulsione perfetta, lucida e vellutata, senza pari.",
                upcyclingBenefit = "L'utilizzo dei gambi di sedano o prezzemolo, spesso gettati, estrae nutrienti essenziali e azzera gli sprechi vegetali in cucina."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Premium Saffron Risotto with Marrow and Stem Dust",
                ingredientsMetric = "• 320g Premium Carnaroli rice\n• 1 pinch Saffron threads\n• 50g Fresh beef bone marrow\n• 80g Ice-cold cubed butter\n• 60g Grated Parmigiano Reggiano (30-month aged)\n• 100ml Dry white wine\n• 1.2L Light beef stock\n• 5g Stem powder (dehydrated celery/parsley stalks)",
                ingredientsImperial = "• 11.3 oz Premium Carnaroli rice\n• 1 pinch Saffron threads\n• 1.8 oz Fresh beef bone marrow\n• 2.8 oz Ice-cold cubed butter\n• 2.1 oz Grated Parmigiano Reggiano (30-month aged)\n• 3.4 fl oz Dry white wine\n• 5 cups Light beef stock\n• 0.17 oz Stem powder (dehydrated celery/parsley stalks)",
                instructions = "1. In a wide pan, melt beef marrow over low heat, add rice and toast for 3 minutes until translucent and hot.\n2. Deglaze with white wine and let it evaporate fully.\n3. Add boiling stock one ladle at a time, stirring gently.\n4. At the halfway point (about 9 minutes), pour in the saffron threads previously infused in a half-cup of warm broth.\n5. Continue adding broth until rice is cooked perfectly al dente (approx. 16-18 minutes).\n6. Remove from heat. Drop in ice-cold butter cubes and Parmigiano. Cover and let rest for 2 minutes.\n7. Cream vigorously ('mantecatura') by shaking the pan to create 'all'onda' wave-like movement.\n8. Plate flat and dust with aromatic vegetable stem powder for a beautiful green herbal finish.",
                chefTips = "Butter for the mantecatura cream must be extremely cold, almost frozen. The thermal shock between the boiling hot rice and cold fat creates a perfect emulsion, glossy and velvety.",
                upcyclingBenefit = "Using celery or parsley stems, which are often discarded, extracts essential nutrients and completely eliminates kitchen green waste."
            ),
            "ES" to LocalizedRecipeDetail(
                title = "Risotto de Azafrán con Tuétano y Polvo de Tallos",
                ingredientsMetric = "• 320g de arroz Carnaroli superfino\n• 1 sobre de azafrán en hebras\n• 50g de tuétano de buey fresco\n• 80g de mantequilla helada en dados\n• 60g de queso Parmigiano Reggiano (curado 30 meses) rallado\n• 100ml de vino blanco seco\n• 1.2L de caldo de carne ligero\n• 5g de polvo de tallos (apio/perejil deshidratados)",
                ingredientsImperial = "• 11.3 oz de arroz Carnaroli premium\n• 1 pizca de azafrán en hebras\n• 1.8 oz de tuétano de buey fresco\n• 2.8 oz de mantequilla helada en dados\n• 2.1 oz de queso Parmigiano Reggiano (curado 30 meses) rallado\n• 3.4 fl oz de vino blanco seco\n• 5 tazas de caldo de carne ligero\n• 0.17 oz de polvo de tallos (apio/perejil deshidratados)",
                instructions = "1. En una cazuela amplia, derretir el tuétano a fuego lento, añadir el arroz y tostarlo durante 3 minutos hasta que los granos estén brillantes y calientes.\n2. Bañar con el vino blanco y dejar evaporar por completo.\n3. Añadir el caldo hirviendo cucharón a cucharón, removiendo suavemente.\n4. A mitad de la cocción (unos 9 minutos), verter las hebras de azafrán previamente infundidas en medio vaso de caldo caliente.\n5. Continuar agregando caldo hasta alcanzar la cocción al dente (aprox. 16-18 minutos).\n6. Retirar del fuego. Añadir los dados de mantequilla congelada y el Parmigiano. Tapar y dejar reposar 2 minutos.\n7. Mantecar enérgicamente agitando la cazuela para crear el efecto de ola 'all'onda'.\n8. Emplatar plano y espolvorear la superficie con el polvo aromático de tallos para un toque herbal verde.",
                chefTips = "La mantequilla para mantecar debe estar muy fría, casi congelada. El choque térmico entre el arroz hirviendo y la grasa fría crea una emulsión perfecta, brillante y vellutada sin parangón.",
                upcyclingBenefit = "El uso de tallos de apio o perejil, que a menudo se desechan, extrae nutrientes esenciales y reduce a cero los desperdicios vegetales en la cocina."
            ),
            "FR" to LocalizedRecipeDetail(
                title = "Risotto au Safran avec Moelle et Poudre de Tiges",
                ingredientsMetric = "• 320g de riz Carnaroli superfin\n• 1 sachet de safran en filaments\n• 50g de moelle de bœuf fraîche\n• 80g de beurre glacé coupé en dés\n• 60g de Parmigiano Reggiano (affiné 30 mois) râpé\n• 100ml de vin blanc sec\n• 1.2L de bouillon de viande léger\n• 5g de poudre de tiges (céleri/persil déshydratés)",
                ingredientsImperial = "• 11.3 oz de riz Carnaroli de qualité supérieure\n• 1 pincée de filaments de safran\n• 1.8 oz de moelle de bœuf fraîche\n• 2.8 oz de beurre glacé en dés\n• 2.1 oz de Parmigiano Reggiano râpé (affiné 30 mois)\n• 3.4 fl oz de vin blanc sec\n• 5 tasses de bouillon léger\n• 0.17 oz de poudre de tiges (céleri/persil déshydratés)",
                instructions = "1. Dans une large casserole, faire fondre la moelle à feu doux, ajouter le riz et le torréfier 3 minutes jusqu'à ce que les grains soient translucides.\n2. Déglacer avec le vin blanc et laisser évaporer entièrement.\n3. Ajouter le bouillon bouillant une louche à la fois, en remuant doucement.\n4. À mi-cuisson (environ 9 minutes), verser le safran préalablement infusé dans une demi-tasse de bouillon chaud.\n5. Continuer d'ajouter le bouillon jusqu'à ce que le riz soit al dente (environ 16-18 minutes).\n6. Retirer du feu. Ajouter les dés de beurre glacé et le Parmigiano. Couvrir et laisser reposer 2 minutes.\n7. Émulsionner énergiquement ('mantecatura') en secouant la casserole pour créer le mouvement de vague 'all'onda'.\n8. Dresser sur une assiette plate et saupoudrer de poudre aromatique de tiges pour une finition herbacée verte.",
                chefTips = "Le beurre pour l'émulsion finale doit être extrêmement froid, presque congelé. Le choc thermique entre le riz bouillant et le gras froid crée une émulsion parfaite, brillante et veloutée.",
                upcyclingBenefit = "L'utilisation de tiges de céleri ou de persil, souvent jetées, permet d'extraire des nutriments essentiels et d'éviter le gaspillage végétal."
            ),
            "DE" to LocalizedRecipeDetail(
                title = "Safran-Risotto mit Knochenmark und Stängelpulver",
                ingredientsMetric = "• 320g Carnaroli-Reis (superfein)\n• 1 Briefchen Safranfäden\n• 50g frisches Rindermark\n• 80g eiskalte, gewürfelte Butter\n• 60g geriebener Parmigiano Reggiano (30 Monate gereift)\n• 100ml trockener Weißwein\n• 1.2L leichte Fleischbrühe\n• 5g Stängelpulver (getrocknete Sellerie-/Petersilienstängel)",
                ingredientsImperial = "• 11.3 oz Premium-Carnaroli-Reis\n• 1 Prise Safranfäden\n• 1.8 oz frisches Rindermark\n• 2.8 oz eiskalte Butterwürfel\n• 2.1 oz geriebener Parmigiano Reggiano (30 Monate gereift)\n• 3.4 fl oz trockener Weißwein\n• 5 Tassen leichte Fleischbrühe\n• 0.17 oz Stängelpulver (getrocknete Sellerie-/Petersilienstängel)",
                instructions = "1. In einem breiten Topf das Knochenmark bei schwacher Hitze schmelzen, den Reis hinzugeben und 3 Minuten anrösten, bis die Körner glänzen.\n2. Mit Weißwein ablöschen und vollständig verdampfen lassen.\n3. Kochende Brühe schöpfkellenweise hinzugeben und sanft umrühren.\n4. Nach der Hälfte der Kochzeit (ca. 9 Minuten) die zuvor in einer halben Tasse warmer Brühe gezogenen Safranfäden hinzugeben.\n5. Weiter Brühe hinzugeben, bis der Reis al dente gegart ist (ca. 16-18 Minuten).\n6. Vom Herd nehmen. Eiskalte Butterwürfel und Parmigiano einrühren. Abdecken und 2 Minuten ruhen lassen.\n7. Energisch cremig rühren ('mantecatura'), indem der Topf geschüttelt wird, um die wellenartige Bewegung 'all'onda' zu erzeugen.\n8. Auf einem flachen Teller anrichten und die Oberfläche mit dem aromatischen Gemüse-Stängelpulver bestreuen.",
                chefTips = "Die Butter zum Binden muss eiskalt, fast gefroren sein. Der Temperaturschock zwischen dem heißen Reis und dem kalten Fett erzeugt eine perfekte, glänzende und cremige Emulsion.",
                upcyclingBenefit = "Die Verwendung von Sellerie- oder Petersilienstängeln, die oft weggeworfen werden, schöpft wertvolle Nährstoffe aus und vermeidet Gemüseabfälle."
            )
        ),
        "MOUSSE_CIOCCOLATO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Mousse di Cioccolato con Scorze d'Arancia Candite",
                ingredientsMetric = "• 2 Avocado molto maturi (polpa morbida)\n• 100g Cioccolato fondente (70% cacao) fuso\n• 40g Cacao amaro in polvere\n• 60ml Sciroppo d'acero o miele\n• 50ml Latte di mandorla o avena\n• 30g Scorze d'arancia candite (scarti caramellati)",
                ingredientsImperial = "• 2 Very ripe avocados (soft flesh)\n• 3.5 oz Melted dark chocolate (70% cocoa)\n• 1.4 oz Unsweetened cocoa powder\n• 4 tbsp Maple syrup or honey\n• 3.4 tbsp Almond or oat milk\n• 1 oz Candied orange peels (upcycled and caramelized)",
                instructions = "1. Estrarre la polpa degli avocado maturi e metterla in un frullatore.\n2. Aggiungere il cioccolato fondente fuso, il cacao in polvere, lo sciroppo d'acero e il latte vegetale.\n3. Frullare ad alta velocità fino a ottenere una crema liscia, vellutata e priva di grumi.\n4. Dividere la mousse in bicchieri monoporzione.\n5. Decorare ogni porzione con pezzetti di scorze d'arancia candite tritate.\n6. Riporre in frigorifero per almeno 1 ora prima di servire per far rassodare la mousse.",
                chefTips = "L'avocado maturo ha un sapore neutro se abbinato al cacao amaro e funge da base grassa ideale. Potete aggiungere un pizzico di peperoncino di Cayenna per scaldare la combinazione cacao-arancia.",
                upcyclingBenefit = "Il recupero e canditura delle scorze d'arancia evita lo spreco di oli essenziali presenti nella buccia degli agrumi."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Avocado Chocolate Mousse with Candied Orange Peels",
                ingredientsMetric = "• 2 Very ripe avocados (soft flesh)\n• 100g Melted dark chocolate (70% cocoa)\n• 40g Unsweetened cocoa powder\n• 60ml Maple syrup or honey\n• 50ml Almond or oat milk\n• 30g Candied orange peels (upcycled and caramelized)",
                ingredientsImperial = "• 2 Very ripe avocados (soft flesh)\n• 3.5 oz Melted dark chocolate (70% cocoa)\n• 1.4 oz Unsweetened cocoa powder\n• 4 tbsp Maple syrup or honey\n• 3.4 tbsp Almond or oat milk\n• 1 oz Candied orange peels (upcycled and caramelized)",
                instructions = "1. Scoop out flesh from ripe avocados and place into a high-powered blender.\n2. Add melted dark chocolate, cocoa powder, maple syrup, and plant milk.\n3. Blend on high speed until completely smooth, glossy, and velvety.\n4. Spoon mousse into single-serving glasses.\n5. Garnish with chopped candied orange peels.\n6. Refrigerate for at least 1 hour to allow the mousse to firm up before enjoying.",
                chefTips = "Ripe avocado has a neutral taste when paired with unsweetened cocoa and acts as an ideal fat base. You can add a pinch of cayenne pepper to warm the cocoa-orange combination.",
                upcyclingBenefit = "Recovering and candying orange peels avoids wasting essential oils present in citrus peels."
            ),
            "ES" to LocalizedRecipeDetail(
                title = "Mousse de Chocolate y Aguacate con Piel de Naranja Confitada",
                ingredientsMetric = "• 2 aguacates muy maduros (pulpa blanda)\n• 100g de chocolate negro (70% cacao) fundido\n• 40g de cacao amargo en polvo\n• 60ml de sirope de arce o miel\n• 50ml de leche de almendras o avena\n• 30g de pieles de naranja confitadas (sobras caramelizadas)",
                ingredientsImperial = "• 2 aguacates muy maduros (pulpa blanda)\n• 3.5 oz de chocolate negro (70% cacao) fundido\n• 1.4 oz de cacao amargo en polvo\n• 4 cucharadas de sirope de arce o miel\n• 3.4 cucharadas de leche de almendras o avena\n• 1 oz de pieles de naranja confitadas (sobras caramelizadas)",
                instructions = "1. Extrae la pulpa de los aguacates maduros y colócala en una batidora.\n2. Añade el chocolate negro fundido, el cacao en polvo, el sirope de arce y la leche vegetal.\n3. Batir a alta velocidad hasta obtener una crema suave, vellutada y sin grumos.\n4. Divide la mousse en vasos individuales.\n5. Decora cada porción con trozos de piel de naranja confitada picada fina.\n6. Guardar en el frigorífico al menos 1 hora antes de servir para que la mousse tome consistencia.",
                chefTips = "El aguacate maduro tiene un sabor neutro si se combina con cacao amargo y sirve como la base grasa perfecta. Puedes añadir una pizca de pimienta de Cayena para dar calidez a la combinación cacao-naranja.",
                upcyclingBenefit = "El aprovechamiento y confitado de las pieles de naranja evita el desperdicio de los aceites esenciales presentes en la piel de los cítricos."
            ),
            "FR" to LocalizedRecipeDetail(
                title = "Mousse au Chocolat à l'Avocat et Écorces d'Orange Confites",
                ingredientsMetric = "• 2 avocats très mûrs (chair tendre)\n• 100g de chocolat noir (70% de cacao) fondu\n• 40g de cacao amer en poudre\n• 60ml de sirop d'érable ou de miel\n• 50ml de lait d'amande ou d'avoine\n• 30g d'écorces d'orange confites (restes caramélisés)",
                ingredientsImperial = "• 2 avocats très mûrs (chair tendre)\n• 3.5 oz de chocolat noir fondu (70% de cacao)\n• 1.4 oz de cacao amer en poudre\n• 4 cuillères à soupe de sirop d'érable ou de miel\n• 3.4 cuillères à soupe de lait d'amande ou d'avoine\n• 1 oz d'écorces d'orange confites (restes caramélisés)",
                instructions = "1. Extraire la chair des avocats mûrs et la placer dans un mixeur.\n2. Ajouter le chocolat noir fondu, le cacao en poudre, le sirop d'érable et le lait végétal.\n3. Mixer à grande vitesse jusqu'à obtenir une crème lisse, veloutée et homogène.\n4. Répartir la mousse dans des verres individuels.\n5. Décorer chaque portion de petits morceaux d'écorces d'orange confites finement hachées.\n6. Réfrigérer au moins 1 heure avant de servir pour laisser la mousse se raffermir.",
                chefTips = "L'avocat mûr a un goût neutre lorsqu'il est associé au cacao amer et sert de base grasse idéale. Vous pouvez ajouter une pincée de piment de Cayenne pour réchauffer le mariage cacao-orange.",
                upcyclingBenefit = "La récupération et le confisage des écorces d'orange évite le gaspillage des huiles essentielles présentes dans la peau des agrumes."
            ),
            "DE" to LocalizedRecipeDetail(
                title = "Avocado-Schokoladenmousse mit kandierten Orangenschalen",
                ingredientsMetric = "• 2 sehr reife Avocados (weiches Fruchtfleisch)\n• 100g geschmolzene dunkle Schokolade (70% Kakao)\n• 40g ungesüßtes Kakaopulver\n• 60ml Ahornsirup oder Honig\n• 50ml Mandel- oder Hafermilch\n• 30g kandierte Orangenschalen (karamellisierte Reste)",
                ingredientsImperial = "• 2 sehr reife Avocados (weiches Fruchtfleisch)\n• 3.5 oz geschmolzene dunkle Schokolade (70% Kakao)\n• 1.4 oz ungesüßtes Kakaopulver\n• 4 EL Ahornsirup oder Honig\n• 3.4 EL Mandel- oder Hafermilch\n• 1 oz kandierte Orangenschalen (karamellisierte Reste)",
                instructions = "1. Das Fruchtfleisch der reifen Avocados herauslöffeln und in einen Mixer geben.\n2. Geschmolzene dunkle Schokolade, Kakaopulver, Ahornsirup und Pflanzenmilch hinzufügen.\n3. Auf hoher Stufe mixen, bis eine völlig glatte, glänzende und cremige Mousse entsteht.\n4. Die Mousse auf Portionsgläser verteilen.\n5. Jede Portion mit fein gehackten kandierten Orangenschalen dekorieren.\n6. Vor dem Servieren mindestens 1 Stunde in den Kühlschrank stellen, damit die Mousse fest wird.",
                chefTips = "Reife Avocado hat in Kombination mit ungesüßtem Kakao einen wissenschaftlich belegten, neutralen Geschmack und dient als ideale Fettbasis. Eine Prise Cayennepfeffer verleiht der Kakao-Orangen-Kombination eine angenehme Schärfe.",
                upcyclingBenefit = "Die Verwertung und das Kandieren von Orangenschalen verhindert die Verschwendung der wertvollen ätherischen Öle in der Zitrusschale."
            )
        ),
        "ACQUA_DI_POMODORO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Consommé di Acqua di Pomodoro Chiarificata",
                ingredientsMetric = "• 1kg Pomodori maturi assortiti\n• 10g Sale fino\n• 5 Foglie di basilico fresco\n• 15ml Olio al basilico per finitura\n• Scorze di limone biologico",
                ingredientsImperial = "• 2.2 lb Assorted ripe tomatoes\n• 2 tsp Fine salt\n• 5 Fresh basil leaves\n• 1 tbsp Basil oil for garnish\n• Organic lemon peels",
                instructions = "1. Frullare grossolanamente i pomodori con sale e scorze di limone.\n2. Trasferire il composto in una stamigna di cotone pulita sospesa sopra una ciotola.\n3. Lasciar gocciolare spontaneamente in frigorifero per 12 ore senza premere per non intorbidire l'acqua.\n4. Raccogliere l'acqua limpida estratta dal pomodoro.\n5. Servire fredda o tiepida guarnendo con gocce di olio al basilico e foglie di basilico fresco.",
                chefTips = "La chiarificazione naturale per gravità preserva gli aromi volatili e i profumi freschi del pomodoro che andrebbero persi con la cottura. Non pressare mai la stamigna se vuoi un consommé cristallino.",
                upcyclingBenefit = "Recupera l'acqua naturale del pomodoro che solitamente viene persa o scartata durante la preparazione di salse, risparmiando 80 litri d'acqua virtuale."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Clarified Tomato Water Consommé",
                ingredientsMetric = "• 1kg Assorted ripe tomatoes\n• 10g Fine salt\n• 5 Fresh basil leaves\n• 15ml Basil oil for garnish\n• Organic lemon peels",
                ingredientsImperial = "• 2.2 lb Assorted ripe tomatoes\n• 2 tsp Fine salt\n• 5 Fresh basil leaves\n• 1 tbsp Basil oil for garnish\n• Organic lemon peels",
                instructions = "1. Roughly blend tomatoes with salt and lemon peels.\n2. Transfer mixture into a clean cheesecloth suspended over a bowl.\n3. Let drip slowly in the refrigerator for 12 hours without pressing to keep the liquid crystal clear.\n4. Collect the transparent, highly aromatic tomato water.\n5. Serve cold or warm, finished with drops of basil oil and fresh basil leaves.",
                chefTips = "Natural clarification by gravity preserves volatile aromas and fresh tomato scents that would be lost with cooking. Never press the cheesecloth if you want a crystal clear consommé.",
                upcyclingBenefit = "Recovers the natural water from tomatoes which is usually lost during sauce preparations, saving 80 liters of virtual water."
            )
        ),
        "VELLUTATA_ASPARAGI" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Vellutata Silenziosa di Gambi e Bucce d'Asparago",
                ingredientsMetric = "• 300g Gambi e bucce legnose di asparago\n• 1 Patata media sbucciata e affettata\n• 1 Porro (parte verde e bianca)\n• 20ml Olio extravergine d'oliva\n• 600ml Acqua bollente o brodo vegetale\n• Crostini di pane raffermo",
                ingredientsImperial = "• 10.5 oz Asparagus woody stems and fibrous peels\n• 1 Medium potato (peeled and sliced)\n• 1 Leek (white and green parts)\n• 4 tsp Extra virgin olive oil\n• 2.5 cups Boiling water or light vegetable broth\n• Stale bread croutons",
                instructions = "1. Tagliare i gambi d'asparago e il porro a rondelle sottili.\n2. In una casseruola, stufare il porro con l'olio d'oliva per 3 minuti.\n3. Aggiungere la patata, i gambi e le bucce d'asparago, e cuocere per 2 minuti.\n4. Coprire con l'acqua bollente e cuocere per 20 minuti finché tutto non sarà tenero.\n5. Frullare alla massima potenza con un frullatore a immersione.\n6. Passare la crema al setaccio fine per rimuovere ogni fibra residua dell'asparago.\n7. Servire bollente con crostini tostati e un filo d'olio a crudo.",
                chefTips = "I gambi d'asparago contengono molto sapore ma sono legnosi. Passare la vellutata al setaccio a maglia finissima trasforma una zuppa fibrosa in una seta gourmet degna di un ristorante stellato.",
                upcyclingBenefit = "Valorizza il 40% del peso dell'asparago che solitamente viene scartato perché troppo coriaceo, azzerando gli sprechi vegetali."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Velvety Asparagus Stem and Peel Soup",
                ingredientsMetric = "• 300g Asparagus woody stems and fibrous peels\n• 1 Medium potato (peeled and sliced)\n• 1 Leek (white and green parts)\n• 20ml Extra virgin olive oil\n• 600ml Boiling water or light vegetable broth\n• Stale bread croutons",
                ingredientsImperial = "• 10.5 oz Asparagus woody stems and fibrous peels\n• 1 Medium potato (peeled and sliced)\n• 1 Leek (white and green parts)\n• 4 tsp Extra virgin olive oil\n• 2.5 cups Boiling water or light vegetable broth\n• Stale bread croutons",
                instructions = "1. Slice asparagus stems and leek into thin rings.\n2. In a saucepan, sweat leek with olive oil for 3 minutes.\n3. Add potato slices, asparagus stems and peels, and cook for 2 minutes.\n4. Cover with boiling water and simmer for 20 minutes until completely tender.\n5. Blend on high speed using an immersion blender.\n6. Pass through a fine mesh sieve (chinois) to extract a silky, fiber-free soup.\n7. Serve steaming hot with crispy bread croutons and a drizzle of raw olive oil.",
                chefTips = "Asparagus stems contain lots of flavor but are woody. Passing the soup through an ultra-fine sieve transforms a fibrous broth into a gourmet silk worthy of a Michelin star.",
                upcyclingBenefit = "Utilizes 40% of the asparagus weight usually discarded due to being too woody, completely neutralizing seasonal vegetable waste."
            )
        ),
        "PESTO_FOGLIE_RAVANELLO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Pesto Sostenibile di Foglie di Ravanello e Mandorle",
                ingredientsMetric = "• 100g Foglie fresche di ravanello (lavate bene)\n• 40g Mandorle pelate intere\n• 1 Spicchio d'aglio privato dell'anima\n• 50ml Olio extravergine d'oliva\n• 20g Lievito alimentare in scaglie\n• Un pizzico di sale marino",
                ingredientsImperial = "• 3.5 oz Fresh radish greens (thoroughly washed)\n• 1.4 oz Whole blanched almonds\n• 1 Garlic clove (germ removed)\n• 3.5 tbsp Extra virgin olive oil\n• 3 tbsp Nutritional yeast flakes\n• A pinch of sea salt",
                instructions = "1. Tostare le mandorle in padella per 2 minuti finché non saranno dorate, poi lasciarle raffreddare.\n2. Inserire l'aglio, il sale e le mandorle in un frullatore o mortaio e tritare grossolanamente.\n3. Aggiungere le foglie di ravanello asciutte e il lievito alimentare in scaglie.\n4. Frullare a impulsi versando l'olio d'oliva a filo per non surriscaldare le foglie.\n5. Ottenere un pesto denso, granuloso e dal colore verde acceso.\n6. Utilizzare per condire gnocchi, pasta o spalmare su bruschette croccanti.",
                chefTips = "Le foglie di ravanello hanno un delizioso retrogusto leggermente piccante e pungente, che ricorda la rucola. Lavale con acqua fredda e ghiaccio per rendere il colore verde ancora più brillante prima di frullare.",
                upcyclingBenefit = "Recupera le foglie di ravanello fresche, che racchiudono eccellenti proprietà nutrizionali e vengono quasi sempre buttate."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Zero-Waste Radish Green and Roasted Almond Pesto",
                ingredientsMetric = "• 100g Fresh radish greens (thoroughly washed)\n• 40g Whole blanched almonds\n• 1 Garlic clove (germ removed)\n• 50ml Extra virgin olive oil\n• 20g Nutritional yeast flakes\n• A pinch of sea salt",
                ingredientsImperial = "• 3.5 oz Fresh radish greens (thoroughly washed)\n• 1.4 oz Whole blanched almonds\n• 1 Garlic clove (germ removed)\n• 3.5 tbsp Extra virgin olive oil\n• 3 tbsp Nutritional yeast flakes\n• A pinch of sea salt",
                instructions = "1. Toast almonds in a dry pan for 2 minutes until golden, then let cool.\n2. Place garlic, salt, and toasted almonds in a food processor or mortar and pulse.\n3. Add dry radish greens and nutritional yeast.\n4. Blend in short pulses while slowly drizzling olive oil to prevent the leaves from heating and turning dark.\n5. Process until you reach a dense, rustic texture with a vibrant green color.\n6. Toss with pasta, gnocchi, or spread over toasted crusty bread.",
                chefTips = "Radish leaves have a delightful slightly spicy, peppery flavor similar to arugula. Ice-bathe the greens first to secure a brilliantly bright emerald green pesto.",
                upcyclingBenefit = "Saves fresh radish greens, which hold excellent nutrients and are almost always binned unnecessarily."
            )
        ),
        "DADO_VEGETALE_SCARTI" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Dado Concentrato agli Scarti di Verdure",
                ingredientsMetric = "• 400g Scarti vegetali puliti (estremità di carote, bucce di cipolla, foglie di sedano, gambi di prezzemolo)\n• 100g Sale marino grosso\n• 1 Cucchiaio d'olio extravergine d'oliva\n• 1 Rametto di rosmarino",
                ingredientsImperial = "• 14.1 oz Clean vegetable scraps (carrot ends, onion skins, celery leaves, parsley stems)\n• 3.5 oz Coarse sea salt\n• 1 tbsp Extra virgin olive oil\n• 1 Rosemary sprig",
                instructions = "1. Raccogliere e lavare benissimo gli scarti vegetali accumulati.\n2. Tritare finemente tutti gli scarti vegetali al mixer.\n3. In una pentola, unire le verdure tritate, il sale marino grosso e l'olio d'oliva.\n4. Cuocere a fuoco lento per circa 40-45 minuti senza aggiungere acqua. Le verdure rilasceranno i propri liquidi e si ridurranno in una pasta densa.\n5. Frullare nuovamente fino a ottenere un composto liscio e omogeneo.\n6. Trasferire in un vasetto sterilizzato. Conservare in frigorifero o congelare in cubetti.",
                chefTips = "Questo dado è puro umami naturale concentrato. Grazie all'alto contenuto di sale, non congela del tutto, rimanendo morbido e facilmente dosabile col cucchiaio anche da freezer.",
                upcyclingBenefit = "Trasforma scarti insignificanti in una risorsa fondamentale che arricchirà ogni tua zuppa o risotto, evitando l'acquisto di dadi ricchi di glutammato."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Zero-Waste Vegetable Bouillon Paste",
                ingredientsMetric = "• 400g Clean vegetable scraps (carrot ends, onion skins, celery leaves, parsley stems)\n• 100g Coarse sea salt\n• 1 tbsp Extra virgin olive oil\n• 1 Rosemary sprig",
                ingredientsImperial = "• 14.1 oz Clean vegetable scraps (carrot ends, onion skins, celery leaves, parsley stems)\n• 3.5 oz Coarse sea salt\n• 1 tbsp Extra virgin olive oil\n• 1 Rosemary sprig",
                instructions = "1. Gather and thoroughly wash accumulated kitchen vegetable scraps.\n2. Finely chop all scraps in a food processor.\n3. In a pot, combine the minced vegetables, coarse salt, and olive oil.\n4. Cook over very low heat for 40-45 minutes without adding any water. The vegetables will release their juices and cook down.\n5. Blend with an immersion blender until a smooth, thick paste forms.\n6. Spoon into a sterilized glass jar. Store in the fridge or freeze in ice cube trays.",
                chefTips = "This bouillon is pure natural umami. Due to its high salt content, it doesn't freeze solid, remaining soft and spoonable directly from the freezer.",
                upcyclingBenefit = "Turns everyday organic waste into a fundamental cooking staple, replacing MSG-heavy industrial bouillon cubes."
            )
        ),
        "GUANCE_BRASATE_BAROLO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Guancia di Vitello Brasata al Barolo",
                ingredientsMetric = "• 600g Guancia di vitello pulita\n• 500ml Vino Barolo o rosso corposo\n• 1 Carota, 1 costa di sedano, 1 cipolla\n• 20g Burro e 20ml Olio extravergine\n• 1 Chiodo di garofano e 1 stecca di cannella\n• Sale e pepe nero q.b.",
                ingredientsImperial = "• 1.3 lb Trimmed beef cheek\n• 2.1 cups Barolo or full-bodied red wine\n• 1 Carrot, 1 celery stalk, 1 onion\n• 1.5 tbsp Butter & 4 tsp Olive oil\n• 1 Whole clove & 1 cinnamon stick\n• Salt and black pepper to taste",
                instructions = "1. In una casseruola pesante (ottima la ghisa), scaldare burro e olio.\n2. Rosolare la guancia a fuoco vivo su tutti i lati per sigillare i succhi, poi toglierla e tenerla in caldo.\n3. Nella stessa casseruola, aggiungere le verdure tritate e le spezie, lasciando appassire per 5 minuti.\n4. Rimettere la carne, sfumare con il Barolo ed evaporare l'alcol.\n5. Coprire con il coperchio e cuocere a fuoco bassissimo per 3 ore, girandola di tanto in tanto, finché la carne non si taglia con un cucchiaio.\n6. Estrarre la carne, frullare il fondo di cottura rimosse le spezie fino a ottenere una salsa lucida e densa.\n7. Servire la guancia calda nappata con la sua salsa al Barolo.",
                chefTips = "La guancia è un taglio ricco di tessuto connettivo. La cottura lenta trasforma il collagene duro in gelatina solubile, rendendo la carne così tenera che si scioglierà letteralmente in bocca.",
                upcyclingBenefit = "Valorizza i tagli 'poveri' o meno nobili della macelleria tradizionale (quinto quarto) elevandoli ad alta cucina gourmet con tecniche di cottura lente."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Barolo-Braised Beef Cheek",
                ingredientsMetric = "• 600g Trimmed beef cheek\n• 500ml Barolo or full-bodied red wine\n• 1 Carrot, 1 celery stalk, 1 onion\n• 20g Butter & 20ml Extra virgin olive oil\n• 1 Whole clove & 1 cinnamon stick\n• Salt and black pepper to taste",
                ingredientsImperial = "• 1.3 lb Trimmed beef cheek\n• 2.1 cups Barolo or full-bodied red wine\n• 1 Carrot, 1 celery stalk, 1 onion\n• 1.5 tbsp Butter & 4 tsp Olive oil\n• 1 Whole clove & 1 cinnamon stick\n• Salt and black pepper to taste",
                instructions = "1. In a heavy-bottomed pot (preferably cast iron), heat butter and olive oil.\n2. Sear the beef cheek over high heat on all sides until a deep brown crust forms, then remove and set aside.\n3. In the same pot, add the chopped carrot, celery, onion, and spices, sweating for 5 minutes.\n4. Return the meat, pour in the Barolo wine and let the alcohol evaporate.\n5. Cover with a tight-fitting lid and simmer over very low heat for 3 hours, turning occasionally, until spoon-tender.\n6. Remove meat, discard whole spices, and blend the sauce until silky and glossy.\n7. Serve the cheek hot, napped generously with the Barolo reduction.",
                chefTips = "Beef cheek is loaded with connective tissue. Slow braising converts tough collagen into soluble gelatin, transforming the beef into meltingly tender morsels.",
                upcyclingBenefit = "Elevates traditional underappreciated cuts (offal/cheeks) to world-class fine dining standards using classical French-Italian braising mechanics."
            )
        ),
        "FOCACCIA_LIEVITO_MADRE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Focaccia Barese con Esubero di Lievito",
                ingredientsMetric = "• 150g Esubero di lievito madre (non rinfrescato)\n• 300g Farina di semola rimacinata\n• 200ml Acqua tiepida\n• 150g Pomodorini ciliegino\n• 30ml Olio extravergine d'oliva\n• 5g Sale marino e origano",
                ingredientsImperial = "• 5.3 oz Sourdough discard (unfed)\n• 10.5 oz Re-milled semolina flour\n• 0.8 cup Warm water\n• 5.3 oz Cherry tomatoes\n• 2 tbsp Extra virgin olive oil\n• 1 tsp Sea salt and oregano",
                instructions = "1. In una ciotola capiente, sciogliere l'esubero di lievito madre nell'acqua tiepida.\n2. Aggiungere la semola e iniziare a impastare. Unire 10ml di olio d'oliva e il sale, impastando per 10 minuti fino a ottenere un panetto liscio.\n3. Trasferire l'impasto in una teglia rotonda generosamente oliata.\n4. Lasciar lievitare coperto a temperatura ambiente per 4 ore.\n5. Affondare le dita nell'impasto creando delle fossette, poi disporre i pomodorini spaccati a metà facendoli penetrare bene.\n6. Cospargere con sale, origano e l'olio d'oliva rimasto.\n7. Cuocere in forno caldissimo a 220°C per 20 minuti finché la base non sarà dorata e croccante.",
                chefTips = "L'esubero di lievito madre conferisce alla focaccia una complessità aromatica e un'acidità piacevole, che bilancia perfettamente la dolcezza del pomodorino caramellato al forno.",
                upcyclingBenefit = "Recupera il lievito madre in eccesso che solitamente viene gettato durante i rinfreschi periodici obbligatori."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Bari Focaccia with Sourdough Discard",
                ingredientsMetric = "• 150g Sourdough discard (unfed)\n• 300g Re-milled semolina flour\n• 200ml Warm water\n• 150g Cherry tomatoes\n• 30ml Extra virgin olive oil\n• 5g Sea salt and oregano",
                ingredientsImperial = "• 5.3 oz Sourdough discard (unfed)\n• 10.5 oz Re-milled semolina flour\n• 0.8 cup Warm water\n• 5.3 oz Cherry tomatoes\n• 2 tbsp Extra virgin olive oil\n• 1 tsp Sea salt and oregano",
                instructions = "1. In a large bowl, dissolve the sourdough discard in warm water.\n2. Add semolina flour and begin mixing. Incorporate 10ml of olive oil and salt, kneading for 10 minutes until smooth.\n3. Place the dough into a baking pan generously coated with olive oil.\n4. Cover and let rise at room temperature for 4 hours.\n5. Press your fingers deep into the dough to create traditional dimples, then press cherry tomato halves firmly into the dough.\n6. Season with coarse salt, dried oregano, and remaining olive oil.\n7. Bake in a preheated oven at 430°F (220°C) for 20 minutes until the bottom is beautifully golden and crispy.",
                chefTips = "Sourdough discard imparts a deep lactic acidity and complex aroma to the focaccia, balancing the naturally sweet baked cherry tomatoes.",
                upcyclingBenefit = "Upcycles sourdough discard that bakers typically throw away during daily maintenance cycles."
            )
        ),
        "MAIONESE_AQUAFABA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Maionese Vegana all'Aquafaba",
                ingredientsMetric = "• 50ml Aquafaba (liquido freddo di cottura dei ceci)\n• 150ml Olio di girasole freddo\n• 5ml Succo di limone fresco o aceto di mele\n• 2g Senape fine\n• Un pizzico di sale e curcuma",
                ingredientsImperial = "• 3.4 tbsp Aquafaba (chilled liquid from cooked chickpeas)\n• 0.6 cup Chilled sunflower oil\n• 1 tsp Fresh lemon juice or apple cider vinegar\n• 0.5 tsp Fine mustard\n• A pinch of salt and turmeric",
                instructions = "1. Versare l'aquafaba fredda di frigorifero, il succo di limone, la senape e un pizzico di sale nel bicchiere alto di un frullatore a immersione.\n2. Inserire il frullatore appoggiandolo saldamente sul fondo e iniziare a frullare alla massima velocità.\n3. Iniziare a versare l'olio di girasole a filo molto lentamente mentre il composto inizia a montare.\n4. Quando la base inizia a emulsionare, sollevare e abbassare lentamente il frullatore per incorporare tutto l'olio.\n5. In meno di 2 minuti si otterrà una maionese bianchissima, lucida e dalla consistenza soda e vellutata.\n6. Trasferire in frigorifero per 15 minuti prima di servire affinché si rassodi ulteriormente.",
                chefTips = "L'aquafaba monta grazie alle proteine vegetali solubili rilasciate dai ceci durante la bollitura, che replicano perfettamente l'albumina dell'uovo. Per una maionese perfetta, assicuratevi che sia ben fredda.",
                upcyclingBenefit = "Recupera il liquido viscoso dei legumi cotti, solitamente riversato nello scarico del lavandino, creando un condimento pregiatissimo a costo zero."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Silky Aquafaba Vegan Mayonnaise",
                ingredientsMetric = "• 50ml Aquafaba (chilled liquid from cooked chickpeas)\n• 150ml Chilled sunflower oil\n• 5ml Fresh lemon juice or apple cider vinegar\n• 2g Fine mustard\n• A pinch of salt and turmeric",
                ingredientsImperial = "• 3.4 tbsp Aquafaba (chilled liquid from cooked chickpeas)\n• 0.6 cup Chilled sunflower oil\n• 1 tsp Fresh lemon juice or apple cider vinegar\n• 0.5 tsp Fine mustard\n• A pinch of salt and turmeric",
                instructions = "1. Pour the cold aquafaba, lemon juice, mustard, and a pinch of salt into a tall immersion blender beaker.\n2. Place the hand blender flat on the bottom of the cup and turn it on high speed.\n3. Begin slowly drizzling in the oil in a thin, steady stream while keeping the blender on the bottom.\n4. As the emulsion forms, gently lift and lower the blender to incorporate the rest of the oil.\n5. In under 2 minutes, you will get a shiny, snow-white mayonnaise with a firm, velvety texture.\n6. Keep in the refrigerator for 15 minutes before serving to firm up.",
                chefTips = "Aquafaba whips because water-soluble starches and proteins mimic egg white properties perfectly. Temperature is critical—ensure the legume liquid is cold.",
                upcyclingBenefit = "Transforms chickpea cooking water—usually poured down the drain—into a glossy, egg-free mayonnaise at virtually zero cost."
            )
        ),
        "FRITTATA_PASTA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Frittata di Spaghetti Gourmet",
                ingredientsMetric = "• 250g Spaghetti avanzati (già conditi)\n• 4 Uova biologiche grandi\n• 50g Scamorza affumicata a cubetti\n• 30g Parmigiano grattugiato\n• 15ml Olio extravergine d'oliva\n• Sale, pepe e basilico fresco q.b.",
                ingredientsImperial = "• 8.8 oz Leftover spaghetti (tomato-sauced or plain)\n• 4 Large organic eggs\n• 1.8 oz Cubed smoked scamorza cheese\n• 1 oz Grated Parmigiano Reggiano\n• 1 tbsp Extra virgin olive oil\n• Salt, pepper, and fresh basil to taste",
                instructions = "1. In una ciotola capiente, sbattere le uova con il Parmigiano, sale, pepe e basilico spezzettato.\n2. Unire gli spaghetti avanzati e i cubetti di scamorza affumicata, amalgamando molto bene il composto.\n3. Scaldare l'olio d'oliva in una padella antiaderente da 22-24cm.\n4. Versare il composto di pasta e uova nella padella ben calda, livellando con una forchetta.\n5. Cuocere a fuoco medio-basso per 8-10 minuti coperto, finché la base non sarà dorata e l'uovo inizierà a rapprendersi anche in superficie.\n6. Girare la frittata aiutandosi con un coperchio o un piatto piatto.\n7. Cuocere l'altro lato scoperto per altri 5 minuti fino a renderlo croccante.",
                chefTips = "La chiave di volta per una frittata perfetta è la crosta esterna croccante contrapposta a un interno morbido e filante. Cuocere a fuoco dolce per non bruciare la base prima che l'interno sia cotto.",
                upcyclingBenefit = "Consente l'upcycling e nobilitazione della pasta del giorno prima, trasformando un avanzo casalingo in una golosa pietanza ricca e croccante."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Gourmet Leftover Spaghetti Frittata",
                ingredientsMetric = "• 250g Leftover spaghetti\n• 4 Large organic eggs\n• 50g Cubed smoked scamorza cheese\n• 30g Grated Parmigiano Reggiano\n• 15ml Extra virgin olive oil\n• Salt, pepper, and fresh basil to taste",
                ingredientsImperial = "• 8.8 oz Leftover spaghetti\n• 4 Large organic eggs\n• 1.8 oz Cubed smoked scamorza cheese\n• 1 oz Grated Parmigiano Reggiano\n• 1 tbsp Extra virgin olive oil\n• Salt, pepper, and fresh basil to taste",
                instructions = "1. In a large bowl, whisk the eggs with Parmigiano cheese, salt, black pepper, and torn basil.\n2. Add the leftover spaghetti and smoked scamorza cheese cubes, mixing until thoroughly combined.\n3. Heat extra virgin olive oil in a non-stick skillet over medium heat.\n4. Pour the spaghetti and egg mixture into the hot pan, flattening it with a fork.\n5. Cook covered over medium-low heat for 8-10 minutes until the bottom is deeply golden and the top starts to set.\n6. Slide or flip the frittata carefully using a flat lid or plate.\n7. Cook uncovered on the other side for 5 minutes until crispy and golden.",
                chefTips = "The golden rule is contrast: a highly crunchy exterior meets a stringy, soft center. Low heat prevents the bottom from burning before setting.",
                upcyclingBenefit = "Enables easy upcycling of yesterday's cooked pasta, repurposing simple household leftovers into a golden, delicious meal."
            )
        ),
        "BUCCE_MELA_TATIN" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Tarte Tatin di Bucce di Mela",
                ingredientsMetric = "• 250g Bucce e torsoli di mele biologiche (senza semi)\n• 1 Rotolo di pasta sfoglia pronta\n• 80g Zucchero di canna grezzo\n• 40g Burro\n• 1 Cucchiaino di cannella in polvere\n• Succo di mezzo limone",
                ingredientsImperial = "• 8.8 oz Organic apple peels and trimmed cores (seeds removed)\n• 1 Roll of ready-made puff pastry\n• 0.4 cup Raw brown sugar\n• 3 tbsp Butter\n• 1 tsp Ground cinnamon\n• Juice of half lemon",
                instructions = "1. Irrorare le bucce e i torsoli (senza semi) con succo di limone e cannella.\n2. In una padella che possa andare in forno, sciogliere il burro con lo zucchero fino a ottenere un caramello ambrato.\n3. Disporre le bucce e i pezzetti di torsoli nel caramello ben caldo, premendoli per compattarli.\n4. Cuocere sul fuoco per 5 minuti per ammorbidire e caramellare la frutta.\n5. Togliere dal fuoco e coprire la frutta con il disco di pasta sfoglia, rimboccando i bordi verso l'interno.\n6. Bucare la sfoglia con una forchetta e infornare a 200°C per 25 minuti finché la pasta sfoglia non sarà gonfia e dorata.\n7. Lasciar intiepidire 10 minuti, poi capovolgere con un movimento deciso su un piatto da portata.",
                chefTips = "Le bucce di mela contengono un'altissima concentrazione di pectina e aromi. Caramellate lentamente, si addensano ricreando la consistenza morbida e confettata della classica Tatin, con un aroma ancora più intenso.",
                upcyclingBenefit = "Utilizza le bucce e i cuori di mela residui da torte o merende, recuperando fibre, vitamine e pectina naturale, e riducendo il rifiuto organico casalingo."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Apple Peel Tarte Tatin",
                ingredientsMetric = "• 250g Organic apple peels and trimmed cores (seeds removed)\n• 1 Roll of ready-made puff pastry\n• 80g Raw brown sugar\n• 40g Butter\n• 1 tsp Ground cinnamon\n• Juice of half lemon",
                ingredientsImperial = "• 8.8 oz Organic apple peels and trimmed cores (seeds removed)\n• 1 Roll of ready-made puff pastry\n• 0.4 cup Raw brown sugar\n• 3 tbsp Butter\n• 1 tsp Ground cinnamon\n• Juice of half lemon",
                instructions = "1. Toss apple peels and core pieces (ensure seeds are discarded) with lemon juice and cinnamon.\n2. In an oven-safe skillet or baking pan, melt butter and brown sugar until they form an amber caramel.\n3. Arrange the peels and core pieces in the warm caramel, packing them tightly.\n4. Cook over medium heat for 5 minutes to soften and coat with caramel.\n5. Remove from heat and cover the caramelized fruit with the puff pastry sheet, tucking edges inside the pan.\n6. Prick the pastry with a fork and bake at 390°F (200°C) for 25 minutes until puffed and golden brown.\n7. Let cool for 10 minutes, then carefully flip with a swift motion onto a serving plate.",
                chefTips = "Apple skins pack an enormous punch of pectin and natural flavor. When slow-cooked in butter-sugar caramel, they soften into a beautiful marmalade-like consistency.",
                upcyclingBenefit = "Uses left-over peels and apple cores from baking, capturing high-quality fiber, vitamins, and natural pectin."
            )
        ),
        "ELISIR_AGRUMI" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Elisir di Agrumi, Zenzero e Miele",
                ingredientsMetric = "• 150g Bucce di agrumi assortiti biologici\n• 20g Radice di zenzero fresca a fettine\n• 80g Miele d'api biologico o sciroppo d'acero\n• 800ml Acqua minerale naturale\n• Foglie di menta per servire",
                ingredientsImperial = "• 5.3 oz Clean assorted organic citrus peels\n• 0.7 oz Sliced fresh ginger root\n• 4 tbsp Organic honey or maple syrup\n• 3.3 cups Flat mineral water\n• Mint leaves for serving",
                instructions = "1. Lavare benissimo gli agrumi prima di sbucciarli. Tagliare le bucce a striscioline eliminando l'eccesso di albedo bianco se troppo amaro.\n2. In un pentolino, unire le bucce d'agrumi, lo zenzero affettato e l'acqua.\n3. Portare a ebollizione e lasciar sobbollire a fuoco basso per 15 minuti.\n4. Spegnere il fuoco, aggiungere il miele mescolando fino a scioglierlo completamente.\n5. Lasciare in infusione coperto fino a raffreddamento spontaneo.\n6. Filtrare il liquido strizzando bene le bucce per estrarre tutti gli oli essenziali.\n7. Servire freddissimo con cubetti di ghiaccio e foglie di menta fresca.",
                chefTips = "Le bucce degli agrumi rilasciano oli essenziali volatili profumatissimi. L'infusione coperta è fondamentale per trattenere questi profumi nel liquido invece di farli evaporare.",
                upcyclingBenefit = "Offre un delizioso recupero delle scorze di agrumi spremuti a colazione o usati in cucina, ricchissime di oli essenziali e antiossidanti."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Citrus Peel and Ginger Cold Elixir",
                ingredientsMetric = "• 150g Clean assorted organic citrus peels\n• 20g Sliced fresh ginger root\n• 80g Organic honey or maple syrup\n• 800ml Flat mineral water\n• Mint leaves for serving",
                ingredientsImperial = "• 5.3 oz Clean assorted organic citrus peels\n• 0.7 oz Sliced fresh ginger root\n• 4 tbsp Organic honey or maple syrup\n• 3.3 cups Flat mineral water\n• Mint leaves for serving",
                instructions = "1. Wash citrus fruits thoroughly before peeling. Slice the rinds into thin strips, scraping off excess bitter white pith if needed.\n2. In a saucepan, combine citrus peels, sliced ginger, and water.\n3. Bring to a boil and simmer gently over low heat for 15 minutes.\n4. Turn off the heat, add honey, and stir until completely dissolved.\n5. Let infuse covered until it cools down to room temperature.\n6. Strain the liquid, pressing the peels firmly to extract every drop of essential oils.\n7. Serve chilled with ice cubes and fresh mint leaves.",
                chefTips = "Citrus peel contains highly volatile aromatic essential oils. Infusing under a closed lid is mandatory to entrap these magnificent aromatics within the liquid.",
                upcyclingBenefit = "Provides a refreshing recovery for spent breakfast citrus peels, preserving precious essential oils and immune-boosting bioflavonoids."
            )
        ),
        "CARBONARA_CBT" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Carbonara Sottovuoto CBT ad Alta Precisione",
                ingredientsMetric = "• 320g Rigatoni di grano duro\n• 4 Tuorli d'uovo freschi\n• 150g Guanciale di Amatrice pepato\n• 80g Pecorino Romano DOP grattugiato\n• Pepe nero selvatico in grani q.b.",
                ingredientsImperial = "• 11.3 oz Rigatoni pasta\n• 4 Fresh egg yolks\n• 5.3 oz Cured pork cheek (guanciale)\n• 2.8 oz Grated Pecorino Romano cheese\n• Cracked wild black peppercorns",
                instructions = "1. Confezionare i tuorli d'uovo sottovuoto e cuocerli in bagno CBT a 64°C per 20 minuti per una consistenza perfettamente vellutata e pastorizzata.\n2. Tagliare il guanciale a listarelle e rosolarlo a fuoco lento finché non è croccante. Filtrare e conservare il grasso liquido.\n3. Cuocere la pasta in acqua bollente leggermente salata.\n4. Scolare la pasta al dente e versarla in una ciotola con il guanciale, il grasso liquido caldo, il Pecorino Romano e tanto pepe nero tostato in padella.\n5. Unire i tuorli pastorizzati CBT e mantecare energicamente fino a creare una crema setosa ed emulsione stabile senza grumi d'uovo.",
                chefTips = "La cottura dei tuorli a 64°C coagula dolcemente le proteine senza indurirle, garantendo la consistenza di una maionese calda che non diventerà mai una frittata.",
                upcyclingBenefit = "Il grasso del guanciale viene filtrato ed utilizzato interamente come grasso emulsionante naturale, evitando sprechi e oli raffinati aggiunti."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "High-Precision Sous-Vide Carbonara",
                ingredientsMetric = "• 320g Rigatoni pasta\n• 4 Fresh egg yolks\n• 150g Cured pork cheek (guanciale)\n• 80g Grated Pecorino Romano cheese\n• Cracked wild black peppercorns",
                ingredientsImperial = "• 11.3 oz Rigatoni pasta\n• 4 Fresh egg yolks\n• 5.3 oz Cured pork cheek (guanciale)\n• 2.8 oz Grated Pecorino Romano cheese\n• Cracked wild black peppercorns",
                instructions = "1. Vacuum-pack egg yolks and cook sous-vide at 64°C (147°F) for 20 minutes for a beautifully pasteurized, velvet creaminess.\n2. Slice guanciale into strips and render over low heat until crispy. Strain and reserve the liquid fat.\n3. Boil rigatoni in lightly salted water.\n4. Drain pasta al dente, combine in a bowl with crispy guanciale, warm fat, Pecorino, and plenty of pan-toasted black pepper.\n5. Whisk in the pasteurized egg yolks rapidly to form a stable, perfectly glossy emulsified sauce without any scrambled eggs.",
                chefTips = "Cooking yolks at 64°C gently gels the proteins, creating a warm mayonnaise texture that never turns into scrambled eggs when tossed.",
                upcyclingBenefit = "Using 100% of the rendered pork fat as the primary emulsion base reduces waste and delivers unparalleled traditional flavor."
            )
        ),
        "LASAGNA_REGGIANA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Lasagna Classica Reggiana con Croste di Parmigiano nel Ragù",
                ingredientsMetric = "• 300g Sfoglia all'uovo fresca\n• 500g Ragù classico alla Bolognese\n• 50g Croste di Parmigiano Reggiano ben pulite\n• 500ml Besciamella setosa\n• 100g Parmigiano Reggiano grattugiato\n• Burro q.b.",
                ingredientsImperial = "• 10.5 oz Fresh egg pasta sheets\n• 1.1 lb Bolognese Meat Ragù\n• 1.8 oz Cleaned Parmigiano Reggiano rinds\n• 2.1 cups Silky béchamel sauce\n• 3.5 oz Grated Parmigiano Reggiano\n• Butter as needed",
                instructions = "1. Preparare il ragù classico aggiungendo le croste di Parmigiano grattate ed immerse nel sugo a sobbollire per 3 ore.\n2. Lessare la sfoglia all'uovo per 1 minuto in acqua salata, poi raffreddarla in acqua ghiacciata.\n3. Spalmare un velo di besciamella sul fondo della teglia.\n4. Stratificare sfoglia, ragù, besciamella e una spolverata generosa di Parmigiano Reggiano.\n5. Ripetere per almeno 5 strati, terminando con ragù, besciamella e fiocchetti di burro.\n6. Infornare a 180°C per 35 minuti, finché non si forma una crosticina dorata e croccante sui bordi.",
                chefTips = "Le croste di Parmigiano nel ragù rilasciano acido glutammico, un potenziatore naturale di umami che rende la carne straordinariamente saporita e profumata.",
                upcyclingBenefit = "Recupera le croste di formaggio solitamente scartate, che fondendosi parzialmente regalano bocconi filanti e saporiti nel ragù."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Traditional Lasagna with Parmigiano Rind Ragù",
                ingredientsMetric = "• 300g Fresh egg pasta sheets\n• 500g Classic Bolognese Meat Ragù\n• 50g Cleaned Parmigiano Reggiano rinds\n• 500ml Silky béchamel sauce\n• 100g Grated Parmigiano Reggiano\n• Butter as needed",
                ingredientsImperial = "• 10.5 oz Fresh egg pasta sheets\n• 1.1 lb Bolognese Meat Ragù\n• 1.8 oz Cleaned Parmigiano Reggiano rinds\n• 2.1 cups Silky béchamel sauce\n• 3.5 oz Grated Parmigiano Reggiano\n• Butter as needed",
                instructions = "1. Simmer your Bolognese ragù for 3 hours with cleaned Parmigiano rinds submerged inside.\n2. Blanch pasta sheets for 1 minute in salted water, then shock in ice water.\n3. Spread a thin layer of béchamel on the bottom of a baking dish.\n4. Alternate layers of pasta, meat ragù, warm béchamel, and grated Parmigiano Reggiano.\n5. Repeat for at least 5 layers, finishing with ragù, béchamel, and small butter dots.\n6. Bake at 350°F (180°C) for 35 minutes until bubbling and crispy-golden on the edges.",
                chefTips = "Parmigiano rinds release natural glutamic acid into the simmering sauce, acting as an organic umami booster that elevates beef and pork notes.",
                upcyclingBenefit = "Upcycles hard cheese rinds, which soften beautifully in the sauce and become edible, chewy treats."
            )
        ),
        "CACCIUCCO_LIVORNESE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Cacciucco alla Livornese con Fumet di Lische e Scarti",
                ingredientsMetric = "• 1kg Pesce misto (polpo, seppia, gallinella, scorfano, triglie)\n• 400g Teste, lische e carapaci per il brodo\n• 400g Pelati schiacciati\n• 1 Bicchiere di vino rosso corposo\n• Pepe, aglio, peperoncino e pane raffermo sfregato con aglio",
                ingredientsImperial = "• 2.2 lb Mixed seafood (octopus, cuttlefish, red gurnard, rockfish)\n• 14.1 oz Fish heads, bones, and shrimp shells\n• 14.1 oz Crushed peeled tomatoes\n• 1 cup Robust red wine\n• Pepper, garlic, chili, and garlic-rubbed stale bread",
                instructions = "1. Tostare gli scarti di pesce (teste, lische, gusci) in pentola con olio e sfumare con vino rosso. Coprire d'acqua e sobbollire per 45 minuti per estrarre un fumet concentrato.\n2. In un tegame capiente, soffriggere aglio, peperoncino e salvia. Cuocere prima il polpo e le seppie a pezzetti sfumando col vino.\n3. Aggiungere i pelati e il fumet filtrato, cuocendo per 30 minuti.\n4. Unire i pesci a carne tenera (scorfano, gallinella) e infine i crostacei.\n5. Servire caldissimo sopra fette di pane raffermo tostato e sfregato d'aglio fresco.",
                chefTips = "Il vero cacciucco esige il vino rosso, non il bianco! Questo contrasta la grassezza e il sapore intenso del pesce di scoglio. Filtrare benissimo il fumet schiacciando le teste per estrarre i succhi.",
                upcyclingBenefit = "Usa teste e lische per un brodo ricchissimo, raddoppiando l'efficienza d'acquisto e riducendo l'impatto ecologico dello scarto ittico."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Classic Tuscan Fish Stew (Cacciucco)",
                ingredientsMetric = "• 1kg Mixed seafood (octopus, cuttlefish, rockfish, gurnard, shrimp)\n• 400g Fish heads, bones, and shells\n• 400g Crushed peeled tomatoes\n• 1 cup Red wine\n• Garlic, chili, sage, and garlic-rubbed stale bread slices",
                ingredientsImperial = "• 2.2 lb Mixed seafood (octopus, cuttlefish, rockfish, gurnard, shrimp)\n• 14.1 oz Fish heads, bones, and shells\n• 14.1 oz Crushed peeled tomatoes\n• 1 cup Red wine\n• Garlic, chili, sage, and garlic-rubbed stale bread slices",
                instructions = "1. Brown fish heads, bones, and shells in olive oil, deglaze with red wine, cover with water, and simmer 45 minutes to obtain a rich fish fumet.\n2. In a large clay or heavy pot, sauté garlic, chili, and sage. Add chopped octopus and cuttlefish and splash with red wine.\n3. Add tomatoes and the strained fish fumet, cooking for 30 minutes.\n4. Gently submerge the tender fish fillets and shellfish in the bubbling stew.\n5. Serve piping hot over thick slices of garlic-rubbed toasted stale bread.",
                chefTips = "Cacciucco uniquely demands robust red wine rather than white to balance the oily richness of rockfish. Squeeze the fish heads during straining to catch all the savory juices.",
                upcyclingBenefit = "Transforms absolute seafood scraps (heads, bones) into a gelatinous and flavorful broth, avoiding trash bin odors and saving high-quality proteins."
            )
        ),
        "RISOTTO_NERO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Risotto al Nero di Seppia Sostenibile",
                ingredientsMetric = "• 320g Riso Carnaroli superfino\n• 300g Seppia fresca con la sua sacca d'inchiostro\n• 1 Cipolla dorata piccola tritata\n• 100ml Vino bianco secco\n• 1L Brodo leggero ricavato dalle ali e testa della seppia\n• 40g Burro gelato",
                ingredientsImperial = "• 11.3 oz Carnaroli rice\n• 10.5 oz Fresh cuttlefish with its ink sac\n• 1 Small onion, minced\n• 3.4 fl oz Dry white wine\n• 4 cups Light broth from cuttlefish trimmings\n• 3 tbsp Ice-cold butter",
                instructions = "1. Pulire la seppia estraendo delicatamente la sacca nera del nero e tenendola da parte in umido.\n2. Bollire ali, testa e scarti di seppia per fare un brodo concentrato.\n3. Rosolare la cipolla in olio d'oliva, unire il riso e tostare. Sfumare col vino bianco.\n4. Aggiungere la seppia tagliata a cubetti piccolissimi e iniziare a bagnare col brodo bollente.\n5. A metà cottura, rompere la sacca del nero di seppia direttamente nel riso, mescolando bene per tingerlo di nero profondo.\n6. Mantecare fuori dal fuoco con burro gelato ed eventualmente un filo d'olio d'oliva.",
                chefTips = "L'inchiostro di seppia fresco ha un sapore marino iodato dolce inimitabile, nettamente superiore a quello pastorizzato in barattolo. Mantieni la temperatura controllata per non cuocere troppo la seppia.",
                upcyclingBenefit = "Utilizza l'inchiostro naturale e le parti meno nobili della seppia per un primo piatto drammatico ed elegante ad altissimo impatto visivo."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Zero-Waste Squid Ink Risotto",
                ingredientsMetric = "• 320g Carnaroli rice\n• 300g Fresh squid or cuttlefish with its ink sac\n• 1 Small yellow onion, minced\n• 100ml Dry white wine\n• 1L Broth made from squid wings and head\n• 40g Ice-cold butter",
                ingredientsImperial = "• 11.3 oz Carnaroli rice\n• 10.5 oz Fresh squid or cuttlefish with its ink sac\n• 1 Small yellow onion, minced\n• 3.4 fl oz Dry white wine\n• 4 cups Broth made from squid wings and head\n• 3 tbsp Ice-cold butter",
                instructions = "1. Clean cuttlefish carefully, extracting the black ink sac and storing it wet.\n2. Boil the cuttlefish trimmings (wings, head) in water for 30 minutes to make a light broth.\n3. Sauté minced onion in olive oil, add rice, toast, and deglaze with white wine.\n4. Add finely chopped cuttlefish meat and cook, adding hot broth ladle by ladle.\n5. Halfway through, dissolve the fresh squid ink directly into the rice, turning it deep black.\n6. Remove from heat and beat in ice-cold butter for a rich wave-like creaminess.",
                chefTips = "Fresh squid ink carries an earthy, sweet-saline ocean flavor that synthetic bottled inks cannot replicate. Keep cuttlefish pieces tiny so they cook instantly.",
                upcyclingBenefit = "Upcycles the organic ink gland and fish trimmings into a dramatic culinary masterpiece of rich, velvety textures."
            )
        ),
        "PARMIGIANA_SCOMPOSTA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Parmigiana di Melanzane Scomposta con Chips di Buccia",
                ingredientsMetric = "• 2 Melanzane grandi sode\n• 300g Pomodori ramati freschi\n• 150g Mozzarella di bufala campana\n• 50g Parmigiano grattugiato\n• Olio di semi per friggere le bucce\n• Basilico fresco",
                ingredientsImperial = "• 2 Large firm eggplants\n• 10.5 oz Ripe vine tomatoes\n• 5.3 oz Buffalo mozzarella\n• 1.8 oz Grated Parmigiano cheese\n• Frying oil for the skins\n• Fresh basil",
                instructions = "1. Sbucciare le melanzane ricavando strisce lunghe di buccia. Tagliare la polpa a cubetti e cuocerla a vapore.\n2. Friggere le bucce di melanzane in olio bollente a 170°C finché non diventano croccanti come patatine. Scolarle su carta.\n3. Schiacciare la polpa di melanzana cotta a vapore con olio, sale e basilico fino a farne una crema densa.\n4. Preparare un sugo ristretto di pomodoro.\n5. Impiattare a strati: crema di melanzana tiepida, salsa al pomodoro calda, mozzarella di bufala a cubetti e cospargere di Parmigiano.\n6. Completare posizionando le bucce fritte croccanti in cima per un contrasto di consistenze.",
                chefTips = "La frittura rende le bucce di melanzana croccantissime ed elimina il tipico sapore amaro. Asciugale perfettamente prima di friggerle per massimizzare il crunch.",
                upcyclingBenefit = "Utilizza l'intera melanzana comprese le bucce (solitamente buttate), riducendo gli sprechi alimentari e migliorando l'aspetto estetico del piatto."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Deconstructed Eggplant Parmigiana with Crispy Skins",
                ingredientsMetric = "• 2 Large firm eggplants\n• 300g Ripe vine tomatoes\n• 150g Buffalo mozzarella\n• 50g Grated Parmigiano Reggiano\n• Frying oil for the skins\n• Fresh basil",
                ingredientsImperial = "• 2 Large firm eggplants\n• 10.5 oz Ripe vine tomatoes\n• 5.3 oz Buffalo mozzarella\n• 1.8 oz Grated Parmigiano Reggiano\n• Frying oil for the skins\n• Fresh basil",
                instructions = "1. Peel eggplants to obtain long strips of skin. Dice the flesh and steam until tender.\n2. Fry eggplant skins in hot oil (170°C/340°F) until extremely crispy and chip-like. Drain on paper towels.\n3. Mash the steamed eggplant flesh with olive oil, salt, and basil into a thick purée.\n4. Cook down a simple, highly concentrated tomato sauce.\n5. Layer on a plate: warm eggplant mash, rich tomato sauce, fresh buffalo mozzarella cubes, and Parmigiano.\n6. Top with the crispy fried eggplant skins to add an incredible visual and textural crunch.",
                chefTips = "Frying eggplant skin breaks down tough fibers and converts bitterness into an addictive nutty finish. Ensure they are dry before oil immersion.",
                upcyclingBenefit = "Employs 100% of the eggplant, using skins to elevate a traditional home-style bake into an avant-garde restaurant plate."
            )
        ),
        "PASSATELLI_BRODO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Passatelli Romagnoli Classici in Brodo di Cappone",
                ingredientsMetric = "• 150g Pane raffermo macinato finissimo\n• 150g Parmigiano Reggiano grattugiato\n• 3 Uova medie biologiche\n• Scorza grattugiata di mezzo limone\n• Un pizzico abbondante di noce moscata\n• 1.5L Brodo di carne o cappone saporito",
                ingredientsImperial = "• 5.3 oz Very finely ground stale breadcrumbs\n• 5.3 oz Grated Parmigiano Reggiano\n• 3 Medium organic eggs\n• Grated zest of half lemon\n• A generous pinch of ground nutmeg\n• 6 cups Rich chicken or capon broth",
                instructions = "1. In una ciotola, mescolare il pane raffermo grattugiato fine con il Parmigiano, la scorza di limone e la noce moscata.\n2. Aggiungere le uova e impastare vigorosamente fino a ottenere un panetto compatto e sodo.\n3. Far riposare l'impasto avvolto in pellicola per 30 minuti.\n4. Portare a bollore il brodo saporito.\n5. Schiacciare l'impasto direttamente nel brodo bollente usando uno schiacciapatate a fori larghi, tagliando i passatelli a una lunghezza di 4-5cm.\n6. Cuocere per circa 2 minuti finché non affiorano in superficie. Servire caldi con il loro brodo.",
                chefTips = "La consistenza dell'impasto è fondamentale: se troppo morbido i passatelli si sfalderanno nel brodo; se troppo duro risulteranno gommosi. Aggiungi un cucchiaio di brodo se è troppo asciutto.",
                upcyclingBenefit = "Una delle massime espressioni storiche della cucina di recupero contadina romagnola, riciclando pane raffermo e rimasugli di formaggio duro."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Emilian Passatelli Soup with Stale Bread",
                ingredientsMetric = "• 150g Finely ground stale breadcrumbs\n• 150g Grated Parmigiano Reggiano\n• 3 Medium organic eggs\n• Grated zest of half lemon\n• A generous pinch of ground nutmeg\n• 1.5L Savory chicken or capon broth",
                ingredientsImperial = "• 5.3 oz Finely ground stale breadcrumbs\n• 5.3 oz Grated Parmigiano Reggiano\n• 3 Medium organic eggs\n• Grated zest of half lemon\n• A generous pinch of ground nutmeg\n• 6 cups Savory chicken or capon broth",
                instructions = "1. In a bowl, combine dry fine breadcrumbs, Parmigiano, grated lemon zest, and ground nutmeg.\n2. Add the eggs and knead with your hands until a compact, pliable, and firm dough forms.\n3. Wrap the dough in plastic wrap and let rest for 30 minutes.\n4. Bring your rich meat broth to a gentle simmer.\n5. Push dough through a large-holed potato ricer directly into the simmering broth, cutting them at about 1.5-inch lengths.\n6. Cook for 2 minutes until they float to the surface. Serve immediately in bowls with broth.",
                chefTips = "Precision is key: if the dough is too soft, passatelli dissolve; if too dry, they become rubbery. Adjust with a teaspoon of broth or extra breadcrumbs as needed.",
                upcyclingBenefit = "An ancient, highly-prized peasant soup that elevates common stale bread crumbs and leftover cheese ends into high-comfort food."
            )
        ),
        "ARANCINI_AVANZATO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Arancini Siciliani di Risotto Avanzato",
                ingredientsMetric = "• 400g Risotto allo zafferano avanzato freddo\n• 80g Caciocavallo o mozzarella ben sgocciolata\n• 50g Piselli cotti\n• 100g Farina 00 e 150ml Acqua (per la pastella)\n• 150g Pangrattato (da pane raffermo)\n• Olio di semi di girasole per friggere",
                ingredientsImperial = "• 14.1 oz Leftover cold saffron risotto\n• 2.8 oz Caciocavallo or firm dry mozzarella\n• 1.7 oz Cooked peas\n• 0.8 cup All-purpose flour and 0.6 cup Water (for batter)\n• 5.3 oz Stale bread crumbs\n• Sunflower oil for deep frying",
                instructions = "1. Prendere una manciata di risotto freddo sul palmo della mano bagnato, schiacciarlo e inserire al centro un cubetto di formaggio e qualche pisello.\n2. Richiudere il riso modellando una palla compatta e liscia.\n3. Preparare la pastella mescolando farina e acqua con una frusta finché non ci sono grumi (consistenza liquida ma coprente).\n4. Tuffare l'arancina prima nella pastella e poi rotolarla accuratamente nel pangrattato.\n5. Friggere in abbondante olio caldo a 180°C fino a perfetta doratura (circa 4-5 minuti).\n6. Sgocciolare su carta assorbente e gustare caldi col formaggio filante.",
                chefTips = "Il riso deve essere freddo di frigorifero, altrimenti i chicchi non si compatteranno e l'arancino si aprirà in frittura. La pastella protegge il riso e crea una camicia croccante impenetrabile.",
                upcyclingBenefit = "Nobilità gli avanzi di risotto dello zafferano o al sugo, trasformandoli in un iconico street food siciliano amato in tutto il mondo."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Crispy Sicilian Arancini from Leftover Risotto",
                ingredientsMetric = "• 400g Leftover cold saffron risotto\n• 80g Mozzarella or Caciocavallo cheese (dry)\n• 50g Cooked green peas\n• 100g Flour and 150ml Water (for glue batter)\n• 150g Stale bread crumbs\n• Sunflower oil for deep-frying",
                ingredientsImperial = "• 14.1 oz Leftover cold saffron risotto\n• 2.8 oz Mozzarella or Caciocavallo cheese (dry)\n• 1.7 oz Cooked green peas\n• 0.8 cup Flour and 0.6 cup Water (for glue batter)\n• 5.3 oz Stale bread crumbs\n• Sunflower oil for deep-frying",
                instructions = "1. Scoop a handful of cold risotto onto your wet palm, flatten it, and place cheese cubes and a few peas in the center.\n2. Fold the rice over the filling, shaping it into a tight, compact ball.\n3. Whisk flour and water to create a smooth, runny batter (called 'lega').\n4. Dip the rice ball into the batter to coat, then roll immediately in breadcrumbs.\n5. Deep-fry in hot oil at 350°F (180°C) until deep gold and super crispy (4-5 minutes).\n6. Drain on paper towels and serve warm for a stringy cheese core.",
                chefTips = "Risotto must be absolutely fridge-cold. Otherwise, the starch won't hold together and the balls will explode in the oil. The batter barrier is key to crunch.",
                upcyclingBenefit = "Gives a second, highly desirable life to leftover risotto, replicating a Sicilian street classic with zero waste."
            )
        ),
        "PANZANELLA_ESTIVA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Panzanella Croccante Toscana con Aceto e Verdure",
                ingredientsMetric = "• 250g Pane toscano raffermo\n• 300g Pomodori da insalata maturi\n• 1 Cetriolo sbucciato\n• 1 Cipolla rossa piccola\n• 30ml Aceto di vino rosso\n• Olio d'oliva extravergine, sale e basilico fresco",
                ingredientsImperial = "• 8.8 oz Stale rustic unsalted Tuscan bread\n• 10.5 oz Ripe heirloom salad tomatoes\n• 1 Cucumber, peeled\n• 1 Small red onion\n• 2 tbsp Red wine vinegar\n• Extra virgin olive oil, salt, and fresh basil",
                instructions = "1. Tagliare la cipolla a fette sottili e lasciarla a bagno con acqua e un cucchiaio d'aceto per 20 minuti per addolcirla.\n2. Bagnare il pane raffermo con acqua e aceto senza inzupparlo troppo; strizzarlo bene con le mani e sbriciolarlo grossolanamente in una ciotola.\n3. Tagliare a pezzetti i pomodori e il cetriolo.\n4. Unire le verdure, la cipolla sgocciolata e le foglie di basilico spezzettate al pane.\n5. Condire abbondantemente con sale e olio extravergine d'oliva di ottima qualità.\n6. Lasciar riposare in frigorifero per 1 ora prima di servire affinché i sapori si fondano.",
                chefTips = "Il vero pane toscano è sciapo (senza sale). Questo permette al pane di assorbire l'acidità dell'aceto e il succo dei pomodori creando un perfetto bilanciamento salino ed aromatico.",
                upcyclingBenefit = "Recupera il pane raffermo estivo senza accendere il forno, sfruttando l'idratazione naturale delle verdure estive fresche."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Tuscan Summer Panzanella Salad",
                ingredientsMetric = "• 250g Stale unsalted crusty bread\n• 300g Ripe juicy tomatoes\n• 1 Cucumber, peeled and sliced\n• 1 Small red onion\n• 30ml Red wine vinegar\n• Extra virgin olive oil, salt, and fresh basil leaves",
                ingredientsImperial = "• 8.8 oz Stale unsalted crusty bread\n• 10.5 oz Ripe juicy tomatoes\n• 1 Cucumber, peeled and sliced\n• 1 Small red onion\n• 2 tbsp Red wine vinegar\n• Extra virgin olive oil, salt, and fresh basil leaves",
                instructions = "1. Slice onion thinly and soak in cold water with 1 tbsp vinegar for 20 minutes to mellow its bite.\n2. Sprinkle stale bread with water and vinegar (do not drench), let soften, then squeeze well with your hands and tear into bite-sized chunks in a bowl.\n3. Dice tomatoes and cucumber.\n4. Add tomatoes, cucumber, drained onions, and lots of torn basil to the bread bowl.\n5. Drizzle generously with high-grade extra virgin olive oil and season with salt.\n6. Let rest in the fridge for at least 1 hour before serving to mingle juices.",
                chefTips = "Traditional unsalted Tuscan bread is ideal as it absorbs vinegar and rich tomato water like a sponge without turning mushy. Serve cool, not ice-cold.",
                upcyclingBenefit = "An exquisite summer recovery meal that transforms dry rock-hard bread into a refreshing, bright, and deeply satisfying salad."
            )
        ),
        "POLPETTE_PANE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Polpette di Pane e Mortadella di Recupero",
                ingredientsMetric = "• 250g Pane raffermo (senza crosta)\n• 150ml Latte per bagnare il pane\n• 100g Mortadella sminuzzata finemente\n• 1 Uovo biologico grande\n• 40g Parmigiano Reggiano grattugiato\n• Sale, pepe, prezzemolo e pangrattato q.b.\n• Olio per friggere",
                ingredientsImperial = "• 8.8 oz Stale bread (crust removed)\n• 0.6 cup Milk to soften\n• 3.5 oz Finely minced mortadella ham\n• 1 Large organic egg\n• 1.4 oz Grated Parmigiano Reggiano\n• Salt, pepper, parsley, and breadcrumbs\n• Frying oil",
                instructions = "1. Ammollare la mollica di pane raffermo nel latte per 10 minuti, poi strizzarla benissimo con le mani per eliminare il liquido in eccesso.\n2. In una ciotola, unire il pane ammollato, la mortadella sminuzzata, l'uovo, il Parmigiano, sale, pepe e prezzemolo tritato.\n3. Impastare fino a ottenere un composto omogeneo e modellare delle polpettine sferiche grandi come noci.\n4. Passare le polpette nel pangrattato finissimo.\n5. Friggere in olio ben caldo a 170°C finché non saranno uniformemente dorate e croccanti (circa 3 minuti).\n6. Servire calde.",
                chefTips = "La mortadella tritata apporta un sapore speziato intenso e una parte grassa ricca. Potete cuocerle anche al forno a 190°C spruzzate d'olio per una versione più leggera ma ugualmente croccante.",
                upcyclingBenefit = "Recupera sia il pane secco che gli avanzi o ritagli di salumi che altrimenti andrebbero sprecati, creando un finger food irresistibile."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Stale Bread and Mortadella Croquettes",
                ingredientsMetric = "• 250g Stale breadcrumb (crusts removed)\n• 150ml Milk to soak\n• 100g Finely minced Mortadella sausage\n• 1 Large organic egg\n• 40g Grated Parmigiano Reggiano\n• Salt, pepper, parsley, and breadcrumbs\n• Oil for frying",
                ingredientsImperial = "• 8.8 oz Stale breadcrumb (crusts removed)\n• 0.6 cup Milk to soak\n• 3.5 oz Finely minced Mortadella sausage\n• 1 Large organic egg\n• 1.4 oz Grated Parmigiano Reggiano\n• Salt, pepper, parsley, and breadcrumbs\n• Oil for frying",
                instructions = "1. Soak stale bread in milk for 10 minutes, then squeeze very hard with your hands to drain excess moisture.\n2. In a bowl, mix the damp bread, finely minced mortadella, egg, Parmigiano, salt, pepper, and chopped parsley.\n3. Knead until smooth, then shape into walnut-sized balls.\n4. Roll each ball in fine breadcrumbs for a dry crisp finish.\n5. Fry in hot oil at 340°F (170°C) until deep gold and crunchy (approx. 3 minutes).\n6. Drain and serve hot.",
                chefTips = "Mortadella brings pre-seasoned spices and rich fats. If baking, bake at 375°F (190°C) sprayed with oil for a lighter but crunchy version.",
                upcyclingBenefit = "Taps into dry bread crumbs and charcuterie off-cuts, transforming remnants into highly addictive, spicy appetizers."
            )
        ),
        "BRODO_PARMIGIANO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Brodo d'Oro di Croste di Parmigiano Reggiano",
                ingredientsMetric = "• 200g Croste di Parmigiano Reggiano DOP\n• 1 Carota, 1 costa di sedano, 1 cipolla bruciata\n• 1 Rametto di timo fresco\n• 1.5L Acqua fredda",
                ingredientsImperial = "• 7 oz Hard Parmigiano Reggiano rinds\n• 1 Carrot, 1 celery stalk, 1 charred onion\n• 1 Fresh thyme sprig\n• 6 cups Cold water",
                instructions = "1. Pulire accuratamente le croste di Parmigiano raschiando la superficie esterna con un coltellino per rimuovere sporco o scritte d'inchiostro.\n2. In una pentola capiente, unire le verdure tagliate a metà, il timo, le croste di Parmigiano pulite e coprire con l'acqua fredda.\n3. Portare lentamente a ebollizione, poi abbassare al minimo e cuocere coperto a fuoco lento per 1.5 ore.\n4. Le croste si ammorbidiranno e rilasceranno tutta la gelatina e l'umami nell'acqua, creando un brodo dorato.\n5. Filtrare il brodo con un colino fine. Servire caldissimo con pasta fresca, tortellini, o usarlo come base eccezionale per risotti.",
                chefTips = "Non buttare le croste ammorbidite rimaste nel colino! Sono calde, gommose ed incredibilmente saporite. Tagliatele a cubetti e gustatele subito o grigliatele in forno per uno snack pazzesco.",
                upcyclingBenefit = "Estrae il 100% dei composti dell'umami dalle croste di formaggio duro che sono solitamente scartate, creando un brodo saporito a costo zero."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Golden Parmigiano Reggiano Rind Broth",
                ingredientsMetric = "• 200g Aged Parmigiano Reggiano rinds\n• 1 Carrot, 1 celery stalk, 1 charred onion\n• 1 Thyme sprig\n• 1.5L Cold water",
                ingredientsImperial = "• 7 oz Aged Parmigiano Reggiano rinds\n• 1 Carrot, 1 celery stalk, 1 charred onion\n• 1 Thyme sprig\n• 6 cups Cold water",
                instructions = "1. Clean Parmigiano rinds thoroughly by scraping the outer skin with a small knife to remove dirt or wax print.\n2. In a stockpot, combine halved vegetables, thyme, clean cheese rinds, and cold water.\n3. Bring slowly to a boil, then reduce heat to minimum and simmer covered for 1.5 hours.\n4. The rinds will soften, releasing natural gelatin and rich glutamates into the liquid.\n5. Strain through a fine-mesh sieve. Use this amber, savory broth for cooking gourmet risotto, ramen, or tortellini.",
                chefTips = "Do not discard the softened sticky rinds left in the sieve! They are intensely savory and chewy. Slice them and sear in a dry non-stick pan until crispy for an epic chef's treat.",
                upcyclingBenefit = "Extracts deep, natural cheese umami from hard skins that are almost universally discarded, creating a culinary building block out of trash."
            )
        ),
        "GNOCCHI_PANE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Gnocchetti di Pane Raffermo al Burro e Salvia",
                ingredientsMetric = "• 200g Pane raffermo (tagliato a cubetti piccoli)\n• 150ml Latte tiepido\n• 1 Uovo biologico grande\n• 50g Farina 00\n• 40g Parmigiano Reggiano grattugiato\n• 50g Burro di malga e foglie di salvia per condire",
                ingredientsImperial = "• 7 oz Stale bread (diced into small cubes)\n• 0.6 cup Warm milk\n• 1 Large organic egg\n• 0.4 cup All-purpose flour\n• 1.4 oz Grated Parmigiano Reggiano\n• 3.5 tbsp Farmhouse butter and sage leaves",
                instructions = "1. Mettere il pane raffermo a cubetti in una ciotola e bagnarlo con il latte tiepido, lasciandolo riposare per 20 minuti finché non si è ammorbidito.\n2. Schiacciare il pane con le dita, unire l'uovo, il Parmigiano, un pizzico di sale e pepe e infine la farina per compattare.\n3. Lavorare l'impasto brevemente e modellare delle piccole polpettine rotonde (gnocchetti) bagnandovi le mani di tanto in tanto.\n4. Lessare gli gnocchi in acqua bollente salata: scolarli delicatamente 2 minuti dopo che sono saliti a galla.\n5. Saltare in padella con il burro fuso spumeggiante e le foglie di salvia fresca finché non sono lucidi.",
                chefTips = "Per una consistenza perfetta, non lavorare troppo l'impasto dopo aver aggiunto la farina per evitare lo sviluppo del glutine, che li renderebbe duri. Il latte tiepido aiuta ad ammorbidire la crosta del pane.",
                upcyclingBenefit = "Ottimo recupero di pagnotte rafferme, trasformandole in deliziosi gnocchetti saporiti ed economici che piacciono a tutta la famiglia."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Rustic Bread Gnocchi with Sage Butter",
                ingredientsMetric = "• 200g Stale bread (cut into small cubes)\n• 150ml Warm milk\n• 1 Large organic egg\n• 50g All-purpose flour\n• 40g Grated Parmigiano Reggiano\n• 50g High-quality butter and fresh sage leaves",
                ingredientsImperial = "• 7 oz Stale bread (cut into small cubes)\n• 0.6 cup Warm milk\n• 1 Large organic egg\n• 0.4 cup All-purpose flour\n• 1.4 oz Grated Parmigiano Reggiano\n• 3.5 tbsp High-quality butter and fresh sage leaves",
                instructions = "1. Place diced stale bread in a bowl, pour warm milk over it, and let rest for 20 minutes until soft.\n2. Mash the bread with your fingers, mix in the egg, Parmigiano, salt, pepper, and flour to bind.\n3. Knead briefly until cohesive, then roll into small marble-sized round gnocchi with wet hands.\n4. Cook in boiling salted water. Slotted-spoon them out 2 minutes after they rise to a float.\n5. Toss gently in a skillet with melted foaming butter and fresh sage leaves until glazed.",
                chefTips = "Avoid overworking the dough once flour is added, or they will turn gummy. Warm milk is superior to cold water as it softens stubborn bread crusts faster.",
                upcyclingBenefit = "Rescues leftover hard bread loaves, transforming them into pillowy gnocchi with a comforting Alpine-Italian flavor profile."
            )
        ),
        "SOUPE_OIGNONS" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Soupe d'Oignons con Baguette Rafferma",
                ingredientsMetric = "• 500g Cipolle bionde affettate sottili\n• 30g Burro e 10ml Olio d'oliva\n• 1 Cucchiaio di farina\n• 800ml Brodo vegetale saporito\n• 100g Pane tipo baguette raffermo a fette\n• 100g Formaggio Gruyère o Emmental grattugiato",
                ingredientsImperial = "• 1.1 lb Yellow onions, thinly sliced\n• 2 tbsp Butter and 2 tsp Olive oil\n• 1 tbsp Flour\n• 3.3 cups Rich vegetable stock\n• 3.5 oz Stale baguette slices\n• 3.5 oz Grated Gruyère or Swiss cheese",
                instructions = "1. In una casseruola pesante, sciogliere il burro con l'olio e aggiungere le cipolle. Cuocere a fuoco lentissimo per 30 minuti mescolando spesso, finché non saranno scure, caramellate e dolcissime.\n2. Spolverare con la farina e tostare per 1 minuto.\n3. Sfumare con un goccio di vino bianco secco (facoltativo) e aggiungere il brodo bollente. Sobbollire coperto per 25 minuti.\n4. Tostare le fette di baguette rafferma.\n5. Versare la zuppa in ciotole adatte al forno, adagiarvi sopra il pane tostato e coprire generosamente con il formaggio grattugiato.\n6. Gratinare sotto il grill del forno a 220°C per 5 minuti finché il formaggio non fa le bolle ed è dorato.",
                chefTips = "La pazienza è il segreto della zuppa di cipolle: non affrettare la caramellizzazione alzando la fiamma. Le cipolle devono caramellare dolcemente nei propri zuccheri naturali.",
                upcyclingBenefit = "Ricetta iconica della cucina bistrot parigina che trasforma ingredienti umili ed economici (cipolle, pane secco) in pura poesia invernale calda e filante."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Classic French Onion Soup with Stale Baguette",
                ingredientsMetric = "• 500g Yellow onions, thinly sliced\n• 30g Butter and 10ml Olive oil\n• 1 tbsp Flour\n• 800ml Hot vegetable stock\n• 100g Stale baguette slices\n• 100g Grated Gruyère or Swiss cheese",
                ingredientsImperial = "• 1.1 lb Yellow onions, thinly sliced\n• 2 tbsp Butter and 2 tsp Olive oil\n• 1 tbsp Flour\n• 3.3 cups Hot vegetable stock\n• 3.5 oz Stale baguette slices\n• 3.5 oz Grated Gruyère or Swiss cheese",
                instructions = "1. Melt butter and oil in a heavy pot, add onions, and cook over very low heat for 30 minutes, stirring occasionally, until deeply brown, sweet, and caramelized.\n2. Sprinkle flour over the onions and stir for 1 minute.\n3. Pour in hot stock (and dry white wine if desired). Simmer covered for 25 minutes.\n4. Toast the stale baguette slices until hard and dry.\n5. Ladle soup into oven-safe bowls, place toasted baguette slices on top, and blanket with grated cheese.\n6. Broil in a preheated oven at 430°F (220°C) for 5 minutes until cheese is bubbly and golden-brown.",
                chefTips = "Do not rush onions by raising the heat; the slow caramelization of their natural sugars is the sole flavor foundation of this soup.",
                upcyclingBenefit = "A Parisian bistro masterpiece that showcases how simple onions and hard stale bread can be transformed into culinary royalty."
            )
        ),
        "VELLUTATA_CAVOLO_NERO" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Vellutata di Coste e Foglie di Cavolo Nero",
                ingredientsMetric = "• 300g Foglie esterne e coste legnose di cavolo nero (scarti)\n• 1 Patata grande sbucciata e cubettata\n• 1 Cipolla dorata\n• 20ml Olio extravergine d'oliva\n• 700ml Brodo vegetale o acqua\n• Peperoncino a piacere",
                ingredientsImperial = "• 10.5 oz Tough outer leaves and ribs of Tuscan kale (cavolo nero)\n• 1 Large potato, peeled and diced\n• 1 Yellow onion\n• 4 tsp Extra virgin olive oil\n• 3 cups Vegetable broth or water\n• Chili flakes to taste",
                instructions = "1. Lavare bene il cavolo nero e separare le foglie dalle coste più dure. Tagliare le coste a pezzetti piccoli.\n2. In una pentola, stufare la cipolla affettata con l'olio d'oliva e il peperoncino per 3 minuti.\n3. Aggiungere le coste di cavolo nero e la patata, cuocendo per 5 minuti.\n4. Unire le foglie, coprire con il brodo bollente e cuocere per 25 minuti finché le coste non saranno tenere.\n5. Frullare alla massima velocità fino a ottenere una crema liscia e verde brillante.\n6. Servire con un filo d'olio d'oliva a crudo e crostini di pane.",
                chefTips = "Le coste del cavolo nero contengono molte fibre. La cottura prolungata e un potente frullatore le sminuzzano perfettamente, sprigionando un sapore minerale e terroso eccezionale.",
                upcyclingBenefit = "Valorizza le parti fibrose e le foglie esterne coriacee del cavolo nero, solitamente scartate a favore delle foglie più tenere, azzerando gli sprechi di questo superfood."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Tuscan Kale Rib and Stem Soup",
                ingredientsMetric = "• 300g Tough outer leaves and fibrous ribs of Tuscan kale\n• 1 Large potato, peeled and diced\n• 1 Yellow onion\n• 20ml Extra virgin olive oil\n• 700ml Vegetable broth or water\n• Chili flakes to taste",
                ingredientsImperial = "• 10.5 oz Tough outer leaves and fibrous ribs of Tuscan kale\n• 1 Large potato, peeled and diced\n• 1 Yellow onion\n• 4 tsp Extra virgin olive oil\n• 3 cups Vegetable broth or water\n• Chili flakes to taste",
                instructions = "1. Wash kale well. Strip leaves and chop the tough fibrous white-green ribs into small bits.\n2. In a saucepan, sweat sliced onion in olive oil with chili flakes for 3 minutes.\n3. Add chopped kale ribs and potato cubes, sautéing for 5 minutes.\n4. Toss in the green leaves and cover with hot broth. Simmer for 25 minutes until ribs are completely soft.\n5. Purée in a high-speed blender until silky-smooth and vibrant green.\n6. Serve with raw olive oil and toasted rustic bread.",
                chefTips = "Kale ribs have a high concentration of mineral salts and fiber. Thorough blending pulverizes the cellular walls, unlocking a deep earthy creaminess without adding cream.",
                upcyclingBenefit = "Rescues the woody kale stalks and tough outer foliage, converting highly nutritious agricultural scraps into an emerald gourmet soup."
            )
        ),
        "LEMON_CURD_SCARTE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Lemon Curd Cremoso con Scorze Spremute",
                ingredientsMetric = "• 100ml Succo di limone fresco\n• Scorza di 2 limoni spremuti (da spremuta, ben lavati)\n• 100g Zucchero semolato\n• 2 Uova intere medie\n• 60g Burro morbido a pezzetti",
                ingredientsImperial = "• 3.4 fl oz Fresh lemon juice\n• Grated zest of 2 spent lemon halves (washed)\n• 0.5 cup Granulated sugar\n• 2 Medium eggs\n• 4 tbsp Unsalted butter, softened",
                instructions = "1. Grattugiare finemente la scorza dei limoni spremuti prima di usarle per caramellare o infondere (assicurandosi che siano limoni biologici non trattati).\n2. In un pentolino a bagnomaria, sbattere le uova con lo zucchero.\n3. Unire il succo di limone e le scorze grattugiate finemente.\n4. Cuocere mescolando continuamente con una frusta per 10 minuti finché la crema non si addensa velando il cucchiaio (non bollire per non cuocere l'uovo).\n5. Togliere dal fuoco e incorporare il burro a pezzetti mescolando energicamente finché non si scioglie.\n6. Filtrare per rimuovere eventuali grumi ed ottenere una crema liscia. Conservare in frigo.",
                chefTips = "Il bagnomaria è fondamentale per mantenere la temperatura sotto gli 85°C. Se la temperatura sale troppo, l'uovo coagula creando grumi dal sapore spiacevole di frittata.",
                upcyclingBenefit = "Recupera la scorza esterna aromatica dei limoni spremuti a colazione o usati per insalate, catturando i preziosi oli essenziali agrumati prima di gettarli."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Zero-Waste Creamy Lemon Curd",
                ingredientsMetric = "• 100ml Fresh lemon juice\n• Grated zest of 2 squeezed lemons (spent halves, organic)\n• 100g Granulated sugar\n• 2 Medium eggs\n• 60g Softened unsalted butter",
                ingredientsImperial = "• 3.4 fl oz Fresh lemon juice\n• Grated zest of 2 squeezed lemons (spent halves, organic)\n• 0.5 cup Granulated sugar\n• 2 Medium eggs\n• 4 tbsp Softened unsalted butter",
                instructions = "1. Finely grate the zest from spent lemon halves (ensure they are organic and scrubbed well before juicing).\n2. In a heatproof bowl set over a pot of simmering water (double boiler), whisk eggs and sugar.\n3. Stir in lemon juice and the finely grated zest.\n4. Whisk constantly for 10 minutes until the mixture thickens and coats the back of a spoon (keep below boil to avoid cooking eggs).\n5. Remove from heat and beat in butter piece by piece until fully melted and glossy.\n6. Pass through a strainer to remove zest if desired, then pour into a jar and chill.",
                chefTips = "Using a double boiler ensures the egg stays below 185°F (85°C). Too much direct heat yields sulfurous scrambled egg notes instead of a sweet, rich glaze.",
                upcyclingBenefit = "Harvests the citrus zest of squeezed lemons before discarding them, saving the highly fragrant essential oils."
            )
        ),
        "INFUSO_CACAO_ARANCIA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Infuso caldo di Scorze di Cacao e Arancia",
                ingredientsMetric = "• 20g Bucce di fave di cacao o cacao in polvere\n• 10g Scorze d'arancia fresche (senza parte bianca)\n• 1 Stecca di cannella\n• 500ml Acqua bollente\n• Miele per dolcificare",
                ingredientsImperial = "• 0.7 oz Cocoa husks or cocoa powder\n• 0.35 oz Fresh orange peels (orange part only)\n• 1 Cinnamon stick\n• 2 cups Boiling water\n• Honey to sweeten",
                instructions = "1. In un tegame, unire le bucce di fave di cacao (o il cacao), la scorza d'arancia e la stecca di cannella.\n2. Versare l'acqua bollente e cuocere a fuoco lento coperto per 10 minuti.\n3. Spegnere il fuoco e lasciare in infusione per altri 5 minuti.\n4. Filtrare con un colino a maglie fitte.\n5. Servire caldissimo dolcificato con un cucchiaio di miele d'api.",
                chefTips = "Le bucce di cacao rilasciano un aroma avvolgente di cioccolato fondente senza calorie o zuccheri. Ottimo sostituto serale senza caffeina per rilassarsi.",
                upcyclingBenefit = "Recupera le scorze esterne degli agrumi ed eventuali bucce di cacao (solitamente scarto industriale della cioccolateria) valorizzando al massimo le risorse naturali."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Cocoa Husk and Orange Peel Hot Tea",
                ingredientsMetric = "• 20g Cocoa husks or cacao nibs\n• 10g Clean fresh orange peels (no bitter white pith)\n• 1 Cinnamon stick\n• 500ml Boiling water\n• Honey or maple syrup to sweeten",
                ingredientsImperial = "• 0.7 oz Cocoa husks or cacao nibs\n• 0.35 oz Clean fresh orange peels (no bitter white pith)\n• 1 Cinnamon stick\n• 2 cups Boiling water\n• Honey or maple syrup to sweeten",
                instructions = "1. In a small pot, combine cocoa husks, orange peel strips, and the cinnamon stick.\n2. Pour boiling water over the ingredients, cover, and simmer on low for 10 minutes.\n3. Turn off heat and let steep covered for 5 minutes.\n4. Pour through a fine mesh strainer into mugs.\n5. Sweeten with a touch of honey or maple syrup and serve hot.",
                chefTips = "Cocoa husks yield a deeply satisfying chocolate fragrance without calories, fats, or heavy caffeine, making for an exquisite evening digestif.",
                upcyclingBenefit = "Upcycles citrus peel waste and cacao husks—an industrial byproduct of bean-to-bar chocolate making—to create an aromatic infusion."
            )
        ),
        "CHIPS_ZUCCA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Chips Croccanti di Buccia di Zucca al Rosmarino",
                ingredientsMetric = "• 200g Bucce di zucca (Delica o Hokkaido, ben lavate)\n• 15ml Olio extravergine d'oliva\n• 1 Rametto di rosmarino tritato fine\n• Sale marino e paprika affumicata",
                ingredientsImperial = "• 7 oz Pumpkin or butternut squash skins (Delica/Hokkaido, scrubbed)\n• 1 tbsp Extra virgin olive oil\n• 1 Fresh rosemary sprig, minced\n• Sea salt and smoked paprika",
                instructions = "1. Lavare accuratamente la buccia della zucca sfregandola bene. Tagliarla a striscioline o pezzi grandi come chips.\n2. Sbollentare le bucce in acqua bollente salata per 3 minuti per ammorbidirle leggermente, poi scolarle e asciugarle benissimo.\n3. In una ciotola, condire le bucce con l'olio d'oliva, sale, rosmarino e paprika affumicata.\n4. Disporre su una teglia coperta di carta forno senza sovrapporle.\n5. Cuocere in forno statico a 200°C per 15-18 minuti finché non diventano arricciate e croccanti.\n6. Servire tiepide.",
                chefTips = "Le bucce di zucca Delica e Hokkaido diventano deliziosamente friabili e dolci in cottura. Sbollentare prima della cottura garantisce che la polpa residua attaccata alla buccia diventi tenera prima che la buccia si tosti.",
                upcyclingBenefit = "Evita di buttare la buccia coriacea della zucca (che rappresenta fino al 15% del suo peso), creando uno snack sano ricco di fibre e betacarotene."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Crispy Rosemary Pumpkin Peel Chips",
                ingredientsMetric = "• 200g Pumpkin skins (Delica, Kabocha, or Hokkaido, scrubbed)\n• 15ml Extra virgin olive oil\n• 1 Rosemary sprig, finely chopped\n• Sea salt and smoked paprika",
                ingredientsImperial = "• 7 oz Pumpkin skins (Delica, Kabocha, or Hokkaido, scrubbed)\n• 1 tbsp Extra virgin olive oil\n• 1 Rosemary sprig, finely chopped\n• Sea salt and smoked paprika",
                instructions = "1. Thoroughly scrub pumpkin skin, then slice into thin chip-like strips.\n2. Blanch rinds in boiling salted water for 3 minutes to soften, then drain and dry completely.\n3. In a bowl, toss the dry skins with olive oil, salt, chopped rosemary, and paprika.\n4. Spread on a baking sheet lined with parchment paper, ensuring no overlaps.\n5. Roast at 390°F (200°C) for 15-18 minutes until curly, dry, and crispy.\n6. Serve warm.",
                chefTips = "Delica and Hokkaido skins possess thin cellular skins that roast into an incredibly crispy texture. Blanching cooks any remaining flesh, preventing tough chewiness.",
                upcyclingBenefit = "Saves tough squash peels—often representing 15% of the vegetable's total weight—turning them into highly nutritious fiber-rich snack crisps."
            )
        ),
        "CARCIOFI_ROMANA" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Carciofi alla Romana con Gambi Dorati Saporiti",
                ingredientsMetric = "• 4 Carciofi romaneschi grandi\n• Gambi dei carciofi pelati a fondo\n• 1 Spicchio d'aglio tritato fine\n• Foglie di mentuccia fresca e prezzemolo\n• 50ml Olio extravergine d'oliva\n• 1 Limone per l'acqua acidulata",
                ingredientsImperial = "• 4 Large Romanesco artichokes\n• Artichoke stems, deeply peeled\n• 1 Garlic clove, minced\n• Fresh wild mint (mentuccia) and parsley\n• 3.5 tbsp Extra virgin olive oil\n• 1 Lemon for acidulated water",
                instructions = "1. Pulire i carciofi togliendo le foglie esterne dure. Tagliare i gambi alla base, sbucciare la scorza legnosa esterna fino a rivelare il cuore bianco e succulento.\n2. Immergere carciofi e gambi in acqua fredda acidulata col limone.\n3. Tritare aglio, mentuccia, prezzemolo, sale e pepe.\n4. Allargare i carciofi al centro e riempirli col trito aromatico. Strofinare anche i gambi col trito.\n5. Disporre i carciofi a testa in giù in un pentolino dai bordi alti, stretti l'uno all'altro. Infilare i gambi negli spazi vuoti.\n6. Versare l'olio e mezzo bicchiere d'acqua, coprire e cuocere a fuoco medio per 30 minuti finché i carciofi non sono teneri.",
                chefTips = "Il gambo del carciofo è squisito, ha lo stesso identico sapore del cuore ma spesso viene scartato per pigrizia. Basta pelarlo bene per rivelare una polpa tenerissima e priva di filamenti.",
                upcyclingBenefit = "Valorizza i gambi del carciofo riducendo lo spreco d'acquisto di quasi un terzo, esaltando una delle parti più nobili ma meno conosciute del vegetale."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Roman-Style Artichokes with Steamed Stems",
                ingredientsMetric = "• 4 Large Romanesco artichokes\n• Artichoke stems, deeply peeled\n• 1 Garlic clove, minced\n• Fresh wild mint (mentuccia) and parsley\n• 50ml Extra virgin olive oil\n• 1 Lemon for acidulated water",
                ingredientsImperial = "• 4 Large Romanesco artichokes\n• Artichoke stems, deeply peeled\n• 1 Garlic clove, minced\n• Fresh wild mint (mentuccia) and parsley\n• 3.5 tbsp Extra virgin olive oil\n• 1 Lemon for acidulated water",
                instructions = "1. Prep artichokes by plucking tough outer petals. Cut off stems, peel their fibrous green skin deeply until you reach the translucent, succulent inner white stalk.\n2. Submerge prepared hearts and stems in cold lemon water.\n3. Mince together garlic, mint, parsley, salt, and pepper.\n4. Pry open artichoke leaves and stuff with the herb mixture; rub stems with remaining herbs.\n5. Place artichokes upside down in a narrow deep pan, packing them tightly. Wedge the stems into any gaps.\n6. Drizzle olive oil and add a half-glass of water. Cover tightly and simmer over medium heat for 30 minutes until tender.",
                chefTips = "Artichoke stems taste exactly like the hearts but are often discarded. Deep peeling strips away the stringy outer layer to reveal a sweet, buttery marrow.",
                upcyclingBenefit = "Upcycles long artichoke stalks, recovering roughly 30% of the artichoke weight that typically lands in compost piles."
            )
        ),
        "TORTA_PANE_AMARETTI" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Torta di Pane Raffermo, Cacao e Amaretti",
                ingredientsMetric = "• 300g Pane raffermo sminuzzato\n• 600ml Latte intero caldo\n• 2 Uova medie biologiche\n• 50g Cacao amaro in polvere\n• 80g Zucchero di canna\n• 80g Amaretti sbriciolati\n• 50g Pinoli o uvetta",
                ingredientsImperial = "• 10.5 oz Stale bread, broken into pieces\n• 2.5 cups Warm whole milk\n• 2 Medium organic eggs\n• 1.8 oz Unsweetened cocoa powder\n• 0.4 cup Brown sugar\n• 2.8 oz Crushed amaretti cookies\n• 1.7 oz Pine nuts or raisins",
                instructions = "1. In una ciotola capiente, bagnare il pane raffermo con il latte caldo e lasciarlo riposare per 30 minuti, schiacciandolo bene con una forchetta per disfarlo completamente.\n2. Aggiungere le uova, lo zucchero, il cacao setacciato, gli amaretti sbriciolati finemente e metà dei pinoli.\n3. Mescolare energicamente fino a ottenere un composto denso e cioccolatoso.\n4. Versare in una tortiera da 22cm imburrata e infarinata.\n5. Cospargere la superficie con i pinoli rimasti e qualche briciola di amaretto.\n6. Cuocere in forno caldo a 180°C per 45-50 minuti, finché la torta non sarà soda e si sarà formata una crosticina in superficie.",
                chefTips = "Questa torta (conosciuta in Lombardia come 'Torta Paesana') è ancora più buona il giorno dopo. Il riposo permette ai profumi di amaretto e cacao di penetrare uniformemente nel pane bagnato.",
                upcyclingBenefit = "Consente il recupero totale di grandi quantità di pane secco, regalandogli una nuova identità ricca, profumata e amatissima da grandi e piccini."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Chocolate and Amaretti Stale Bread Cake",
                ingredientsMetric = "• 300g Stale bread, chopped\n• 600ml Warm whole milk\n• 2 Medium organic eggs\n• 50g Unsweetened cocoa powder\n• 80g Brown sugar\n• 80g Crushed amaretti cookies\n• 50g Pine nuts or raisins",
                ingredientsImperial = "• 10.5 oz Stale bread, chopped\n• 2.5 cups Warm whole milk\n• 2 Medium organic eggs\n• 1.8 oz Unsweetened cocoa powder\n• 0.4 cup Brown sugar\n• 2.8 oz Crushed amaretti cookies\n• 1.7 oz Pine nuts or raisins",
                instructions = "1. In a large bowl, soak stale bread pieces in hot milk for 30 minutes, mashing thoroughly with a fork until mushy.\n2. Whisk in eggs, brown sugar, sifted cocoa powder, crushed amaretti crumbs, and half of the pine nuts.\n3. Mix vigorously until you form a thick, uniform chocolate batter.\n4. Pour into a greased and floured 9-inch cake pan.\n5. Sprinkle remaining pine nuts and some cookie crumbs on top.\n6. Bake at 350°F (180°C) for 45-50 minutes until set and a rustic crinkle crust forms on top.",
                chefTips = "Widely celebrated in Northern Italy as 'Torta Paesana', this dessert tastes twice as good the next day. A night of rest matures the almond-chocolate flavors.",
                upcyclingBenefit = "Turns bulk amounts of stale bread into a luxurious, fudgy chocolate treat, demonstrating the heights of rustic peasant baking."
            )
        ),
        "DASHI_SOSTENIBILE" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Brodo Dashi Sostenibile con Gambi di Shiitake e Kombu",
                ingredientsMetric = "• 10g Alga Kombu essiccata\n• 15g Katsuobushi (fiocchi di tonnetto)\n• 10 Gambi di funghi Shiitake secchi (scarti)\n• 1L Acqua fredda",
                ingredientsImperial = "• 0.35 oz Dried Kombu kelp\n• 0.5 oz Bonito flakes (katsuobushi)\n• 10 Dried Shiitake mushroom stems (scraps)\n• 4 cups Cold water",
                instructions = "1. In una pentola, unire l'alga Kombu, i gambi di Shiitake e l'acqua fredda. Lasciare reidratare per 30 minuti.\n2. Scaldare lentamente sul fuoco fino a sfiorare l'ebollizione (non bollire forte per non estrarre sostanze amare).\n3. Togliere la Kombu subito prima del bollore, lasciando sobbollire i gambi di Shiitake per altri 10 minuti.\n4. Spegnere il fuoco, aggiungere il katsuobushi e attendere 3 minuti finché i fiocchi non si depositano sul fondo.\n5. Filtrare il brodo limpido dorato strizzando leggermente i funghi.",
                chefTips = "Questo dashi di recupero ha un'incredibile spinta di umami data dalla combinazione tra acido glutammico (Kombu) e acido guanilico (gambi di Shiitake), che si potenziano a vicenda.",
                upcyclingBenefit = "Usa i gambi duri dei funghi Shiitake (solitamente gettati perché gommosi) che contengono in realtà la maggior concentrazione di aromi e profumi boscati."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Sustainable Umami Dashi Broth",
                ingredientsMetric = "• 10g Dried Kombu kelp\n• 15g Bonito flakes (katsuobushi)\n• 10 Dried Shiitake mushroom stems (scraps)\n• 1L Cold water",
                ingredientsImperial = "• 0.35 oz Dried Kombu kelp\n• 0.5 oz Bonito flakes (katsuobushi)\n• 10 Dried Shiitake mushroom stems (scraps)\n• 4 cups Cold water",
                instructions = "1. In a pot, combine Kombu kelp, dry Shiitake mushroom stems, and cold water. Let sit for 30 minutes to rehydrate.\n2. Bring slowly to a bare simmer over medium-low heat (never rapid boil to prevent bitter extractions).\n3. Discard Kombu just before the boil, letting the Shiitake stems simmer gently for another 10 minutes.\n4. Turn off heat, sprinkle in bonito flakes, and let steep for 3 minutes until they sink.\n5. Strain the clear, deeply golden broth through a fine-mesh sieve.",
                chefTips = "Synergistic umami is at play here: combining the glutamic acid of seaweed with the guanylic acid of Shiitake stems multiplies the savory intensity tenfold.",
                upcyclingBenefit = "Makes brilliant use of woody Shiitake mushroom stalks, capturing their dense aromatic concentration which is typically wasted."
            )
        ),
        "HUMMUS_BUCCE_CECI" to mapOf(
            "IT" to LocalizedRecipeDetail(
                title = "Hummus Vellutato con Bucce di Ceci Upcycled",
                ingredientsMetric = "• 250g Ceci cotti biologici\n• 30g Bucce di ceci cotte extra (scarto di sbucciatura)\n• 50g Tahina (pasta di sesamo)\n• Succo di mezzo limone\n• 1 Spicchio d'aglio privato dell'anima\n• Olio extravergine, sale e cumino",
                ingredientsImperial = "• 8.8 oz Cooked organic chickpeas\n• 1 oz Cooked chickpea skins (spent peels from skinning)\n• 3 tbsp Tahini paste\n• Juice of half lemon\n• 1 Garlic clove, germ removed\n• Olive oil, salt, and ground cumin",
                instructions = "1. Per un hummus liscissimo stile mediorientale, sbucciare i ceci cotti sfrigolandoli delicatamente tra le dita in acqua. Raccogliere le bucce galleggianti.\n2. Invece di buttarle, frullare le bucce con un goccio d'acqua bollente di cottura dei ceci (aquafaba) alla massima velocità finché non sono polverizzate in crema.\n3. Aggiungere i ceci sbucciati, la tahina, il succo di limone, il sale, l'aglio e il cumino.\n4. Frullare unendo olio a filo e cubetti di ghiaccio fino a ottenere una crema soffice, liscia come seta e vellutata.\n5. Servire decorando con olio d'oliva e cumino.",
                chefTips = "L'aggiunta di un cubetto di ghiaccio durante la frullatura provoca uno shock termico che sbianca l'hummus e lo rende incredibilmente soffice e spumoso, come una mousse vegetale.",
                upcyclingBenefit = "Recupera le bucce dei ceci ricchissime di fibre digeribili, reinserendole nel piatto sotto forma di emulsione liscia senza compromettere la texture setosa del piatto finale."
            ),
            "EN" to LocalizedRecipeDetail(
                title = "Ultra-Silky Hummus with Upcycled Chickpea Skins",
                ingredientsMetric = "• 250g Cooked chickpeas\n• 30g Extra cooked chickpea skins (usually peeled and binned)\n• 50g Tahini paste\n• Juice of half lemon\n• 1 Garlic clove, germ removed\n• Extra virgin olive oil, salt, cumin, and ice cubes",
                ingredientsImperial = "• 8.8 oz Cooked chickpeas\n• 1 oz Extra cooked chickpea skins (usually peeled and binned)\n• 3 tbsp Tahini paste\n• Juice of half lemon\n• 1 Garlic clove, germ removed\n• Extra virgin olive oil, salt, cumin, and ice cubes",
                instructions = "1. To make restaurant-grade smooth hummus, slip the skins off cooked chickpeas in a bowl of cold water. Skim the floating skins.\n2. Instead of throwing them out, blend these fibrous skins on high speed with a splash of hot chickpea cooking water until fully puréed.\n3. Add the peeled chickpeas, tahini, garlic, lemon juice, salt, and cumin to the blender.\n4. Run the food processor on high, tossing in 2 ice cubes to create a silky, ultra-light whipped emulsion.\n5. Plate with a well in the center, filled with olive oil and spiced with cumin.",
                chefTips = "The ice cubes chill the blades and create a cold whipped emulsion, yielding a snow-white, airy whipped texture similar to gourmet mousse.",
                upcyclingBenefit = "Captures chickpea outer skins—often discarded to make hummus smooth—by micro-pureeing them so they contribute valuable fiber without any graininess."
            )
        )
    )

    fun getTranslation(recipeId: String, language: String): LocalizedRecipeDetail? {
        return translations[recipeId]?.get(language)
    }
}
