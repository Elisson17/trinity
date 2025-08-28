# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

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

puts "🎉 Seeds executados com sucesso! #{Product.count} produtos no banco."
