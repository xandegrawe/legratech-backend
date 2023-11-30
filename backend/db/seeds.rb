# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Criação de pessoas (persons)
person1 = Person.create(name: "João", phone: "123-456-7890", email: "joao@example.com")
person2 = Person.create(name: "Maria", phone: "987-654-3210", email: "maria@example.com")

# Criação de clientes (customers)
customer1 = Customer.create(cpf: "123.456.789-00", rg: "ABC12345", last_name: "Silva", person: person1)
customer2 = Customer.create(cpf: "987.654.321-00", rg: "XYZ98765", last_name: "Pereira", person: person2)

# Criação de fornecedores (suppliers)
supplier1 = Provider.create(cnpj: "12.345.678/0001-00", person: person1)
supplier2 = Provider.create(cnpj: "98.765.432/0001-00", person: person2)

# Criação de endereços (addresses)
address1 = Address.create(street: "Rua A", number: "123", cep: "12345-678", observation: "Perto do parque", address_type: "Residencial", person: person1)
address2 = Address.create(street: "Avenida B", number: "456", cep: "98765-432", observation: "Edifício Comercial", address_type: "Comercial", person: person2)


puts "Foram criadas 10 pessoas, cada uma com um cliente, um fornecedor e um endereço."
