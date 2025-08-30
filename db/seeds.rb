# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Criando usuário admin
puts "👤 Criando usuário admin..."

admin_user = User.find_or_create_by(email: "admin@admin.com") do |user|
  user.name = "Administrador"
  user.password = "12345678"
  user.password_confirmation = "12345678"
  user.role = "admin"
  user.confirmed_at = Time.current # Confirma o usuário automaticamente
end

puts "✅ Usuário admin criado: #{admin_user.email}"

# Criando produtos de exemplo para o e-commerce de roupas femininas
puts "🌱 Criando produtos de exemplo..."

products_data = [
  {
    name: "Vestido Floral Verão",
    description: "Vestido leve e feminino com estampa floral delicada. Perfeito para dias quentes e ocasiões especiais. Tecido fluido que valoriza o corpo.",
    price: 89.90,
    material: "Viscose",
    care_instructions: "Lavar à mão com água fria. Não usar alvejante. Secar à sombra.",
    featured: true
  },
  {
    name: "Blusa Básica Branca",
    description: "Blusa básica essencial para qualquer guarda-roupa. Corte clássico e tecido de alta qualidade. Combina com tudo.",
    price: 39.90,
    material: "Algodão 100%",
    care_instructions: "Lavar na máquina até 30°C. Pode ser passada a ferro.",
    featured: false
  },
  {
    name: "Calça Jeans Skinny",
    description: "Calça jeans com modelagem skinny que valoriza as curvas. Jeans de alta qualidade com elastano para maior conforto.",
    price: 119.90,
    material: "Algodão 98%, Elastano 2%",
    care_instructions: "Lavar na máquina com água fria. Não usar amaciante.",
    featured: true
  },
  {
    name: "Cardigan Tricot Rosa",
    description: "Cardigan em tricot macio e quentinho. Ideal para criar looks elegantes e confortáveis nos dias mais frescos.",
    price: 69.90,
    material: "Acrílico",
    care_instructions: "Lavar à mão com água morna. Secar na horizontal.",
    featured: false
  },
  {
    name: "Saia Midi Plissada",
    description: "Saia midi com pregas que criam movimento e elegância. Versátil para looks do dia a dia ou mais arrumados.",
    price: 79.90,
    material: "Poliéster",
    care_instructions: "Lavar na máquina até 30°C. Pendurar para secar.",
    featured: true
  },
  {
    name: "Blazer Alfaiataria",
    description: "Blazer estruturado de alfaiataria que confere elegância e sofisticação a qualquer look. Ideal para ocasiões formais.",
    price: 159.90,
    material: "Poliéster 95%, Elastano 5%",
    care_instructions: "Lavar a seco ou à mão com água fria.",
    featured: true
  },
  {
    name: "Camisa Social Feminina",
    description: "Camisa social clássica com corte feminino. Essencial para compor looks profissionais e elegantes.",
    price: 79.90,
    material: "Algodão 100%",
    care_instructions: "Lavar na máquina até 40°C. Passar a ferro.",
    featured: false
  },
  {
    name: "Vestido Midi Listrado",
    description: "Vestido midi com listras clássicas. Versátil e atemporal, combina com diversas ocasiões.",
    price: 99.90,
    material: "Viscose 100%",
    care_instructions: "Lavar à mão ou na máquina ciclo delicado.",
    featured: true
  },
  {
    name: "Short Jeans Destroyed",
    description: "Short jeans com detalhes destroyed que seguem as tendências atuais. Confortável e estiloso.",
    price: 59.90,
    material: "Algodão 98%, Elastano 2%",
    care_instructions: "Lavar na máquina com água fria.",
    featured: false
  },
  {
    name: "Regata Básica Preta",
    description: "Regata básica preta que não pode faltar no guarda-roupa. Corte moderno e tecido de qualidade.",
    price: 29.90,
    material: "Algodão 95%, Elastano 5%",
    care_instructions: "Lavar na máquina até 30°C.",
    featured: false
  },
  {
    name: "Calça Pantalona Camel",
    description: "Calça pantalona em tom camel que alonga a silhueta. Elegante e confortável para o dia a dia.",
    price: 109.90,
    material: "Viscose 100%",
    care_instructions: "Lavar à mão com água fria. Secar à sombra.",
    featured: true
  },
  {
    name: "Blusa Manga Longa Gola Alta",
    description: "Blusa básica de manga longa com gola alta. Ideal para compor looks em camadas ou usar sozinha.",
    price: 49.90,
    material: "Algodão 100%",
    care_instructions: "Lavar na máquina até 30°C.",
    featured: false
  },
  {
    name: "Vestido Envelope Vermelho",
    description: "Vestido envelope em tom vermelho vibrante. Corte que valoriza todas as silhuetas e destaca a feminilidade.",
    price: 129.90,
    material: "Poliéster 100%",
    care_instructions: "Lavar à mão com água fria.",
    featured: true
  },
  {
    name: "Jaqueta Jeans Clássica",
    description: "Jaqueta jeans clássica que nunca sai de moda. Versátil para criar diversos looks casuais.",
    price: 89.90,
    material: "Algodão 100%",
    care_instructions: "Lavar na máquina com água fria.",
    featured: false
  },
  {
    name: "Saia Lápis Preta",
    description: "Saia lápis preta de cintura alta. Peça clássica e elegante para looks executivos.",
    price: 69.90,
    material: "Poliéster 95%, Elastano 5%",
    care_instructions: "Lavar a seco ou à mão.",
    featured: true
  },
  {
    name: "Blusa Estampada Tropical",
    description: "Blusa com estampa tropical vibrante. Perfeita para trazer alegria e cor aos looks de verão.",
    price: 59.90,
    material: "Viscose 100%",
    care_instructions: "Lavar à mão com água fria.",
    featured: false
  },
  {
    name: "Calça Legging Fitness",
    description: "Legging de alta performance para atividades físicas. Tecido que proporciona conforto e liberdade de movimento.",
    price: 79.90,
    material: "Poliamida 80%, Elastano 20%",
    care_instructions: "Lavar na máquina até 30°C. Não usar amaciante.",
    featured: true
  },
  {
    name: "Vestido Longo Boho",
    description: "Vestido longo estilo boho com detalhes em renda. Romântico e feminino para ocasiões especiais.",
    price: 149.90,
    material: "Algodão 70%, Renda 30%",
    care_instructions: "Lavar à mão com cuidado especial.",
    featured: true
  },
  {
    name: "Top Cropped Ribana",
    description: "Top cropped em ribana que acompanha as tendências. Ideal para looks jovens e despojados.",
    price: 34.90,
    material: "Algodão 95%, Elastano 5%",
    care_instructions: "Lavar na máquina até 30°C.",
    featured: false
  },
  {
    name: "Casaco Tricot Cinza",
    description: "Casaco em tricot cinza mescla. Quentinho e estiloso para os dias mais frios.",
    price: 99.90,
    material: "Acrílico 100%",
    care_instructions: "Lavar à mão com água morna.",
    featured: false
  },
  {
    name: "Shorts Alfaiataria",
    description: "Shorts de alfaiataria com pregas frontais. Elegante para looks mais arrumados no verão.",
    price: 69.90,
    material: "Poliéster 100%",
    care_instructions: "Lavar a seco ou máquina ciclo delicado.",
    featured: true
  },
  {
    name: "Blusa Ombro a Ombro",
    description: "Blusa ciganinha ombro a ombro com elástico. Feminina e romântica para looks casuais.",
    price: 54.90,
    material: "Viscose 100%",
    care_instructions: "Lavar à mão com água fria.",
    featured: false
  },
  {
    name: "Vestido Tubinho Azul",
    description: "Vestido tubinho azul marinho clássico. Elegante e versátil para diversas ocasiões.",
    price: 119.90,
    material: "Poliéster 95%, Elastano 5%",
    care_instructions: "Lavar a seco preferencialmente.",
    featured: true
  },
  {
    name: "Macaquinho Jeans",
    description: "Macaquinho jeans com amarração na cintura. Prático e estiloso para looks casuais.",
    price: 109.90,
    material: "Algodão 98%, Elastano 2%",
    care_instructions: "Lavar na máquina com água fria.",
    featured: false
  },
  {
    name: "Kimono Floral",
    description: "Kimono com estampa floral delicada. Ideal para sobreposições e criar looks boho chic.",
    price: 89.90,
    material: "Chiffon 100%",
    care_instructions: "Lavar à mão com muito cuidado.",
    featured: true
  },
  {
    name: "Calça Jogger Feminina",
    description: "Calça jogger confortável com elástico no punho. Moderna e prática para o dia a dia.",
    price: 79.90,
    material: "Algodão 80%, Poliéster 20%",
    care_instructions: "Lavar na máquina até 40°C.",
    featured: false
  },
  {
    name: "Blusa Gola V Nude",
    description: "Blusa básica gola V em tom nude. Corte moderno que alonga o pescoço e valoriza o colo.",
    price: 44.90,
    material: "Viscose 95%, Elastano 5%",
    care_instructions: "Lavar na máquina até 30°C.",
    featured: false
  },
  {
    name: "Saia Plissada Metalizada",
    description: "Saia midi plissada com efeito metalizado. Perfeita para ocasiões especiais e festas.",
    price: 129.90,
    material: "Poliéster 100%",
    care_instructions: "Lavar a seco apenas.",
    featured: true
  },
  {
    name: "Vestido Camiseta Listrado",
    description: "Vestido estilo camiseta com listras navy. Confortável e prático para o dia a dia.",
    price: 69.90,
    material: "Algodão 100%",
    care_instructions: "Lavar na máquina até 40°C.",
    featured: false
  },
  {
    name: "Conjunto Cropped e Short",
    description: "Conjunto coordenado com cropped e short de cintura alta. Moderno e jovem para o verão.",
    price: 89.90,
    material: "Linho 100%",
    care_instructions: "Lavar à mão ou ciclo delicado.",
    featured: true
  },
  {
    name: "Blazer Oversized Xadrez",
    description: "Blazer oversized com estampa xadrez clássica. Tendência atual que combina conforto e estilo.",
    price: 179.90,
    material: "Lã 50%, Poliéster 50%",
    care_instructions: "Lavar a seco obrigatoriamente.",
    featured: true
  },
  {
    name: "Body Manga Longa Preto",
    description: "Body básico de manga longa em preto. Peça versátil que serve como base para diversos looks.",
    price: 54.90,
    material: "Algodão 95%, Elastano 5%",
    care_instructions: "Lavar na máquina até 30°C.",
    featured: false
  }
]

products_data.each do |product_attrs|
  product = Product.find_or_create_by(name: product_attrs[:name]) do |p|
    p.description = product_attrs[:description]
    p.price = product_attrs[:price]
    p.material = product_attrs[:material]
    p.care_instructions = product_attrs[:care_instructions]
    p.featured = product_attrs[:featured]
    p.active = true
  end

  puts "✅ Produto criado: #{product.name} - #{product.formatted_price}"
end

puts "🎉 Seeds executados com sucesso!"
puts "👤 #{User.count} usuário(s) no banco"
puts "👗 #{Product.count} produtos no banco"
