require 'telegram/bot'
require_relative 'eurorobota_scrapper'
require 'json'

TOKEN = '737113657:AAHZBsquPCFNYM6CPjlnC_ZwivznNSPCE3o'

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text.downcase

    when '/start'
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Доброго дня #{message.from.first_name}!\nВас вітає онлайн 24/7 служба підтримки VisaStart.\nЯкі у вас виникли запитання? ")
    
    when '/stop'
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Дякуємо що звернулися до нас, #{message.from.first_name}. Бажаємо вам гарного дня!", reply_markup: kb)

    when '/contact'
    	bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380932575078", first_name: "Служба підтримки", last_name: "VisaStart", vcard: "Viber, Telegram")

    when '/vacancy'
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, щоб побачити вакансії, перейдіть за посиланням знизу або напишіть одну з перелічених вакансій\n Арматура, Опалубка, Електромонтер, Муляр, Нові вакансії")
    	bot.api.sendMessage(chat_id: message.chat.id, text: "https://visastart.com/vacancy/")

    when '/help'
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, напишіть питання яке вас цікавить\nЧат бот реагує на такі слова:\nАрматура, опалубка, контакти, страховка, віза, привітання всіх видів,\nменежер, зелена карта, вакансії, нові вакансії,\nзарплата, житло, страхівка.")

    when '/resume'
        scrapResumes = WebScrapper.new
        resumes = scrapResumes.getDitailsFromAllResumes
        resumes = JSON.pretty_generate(resumes)

        File.open("vacancy.json","w") do |f|
            f.write(resumes.to_json)
        end

        bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, на данний момент є такі резюме")
        bot.api.sendDocument(chat_id: message.chat.id,document: Faraday::UploadIO.new('vacancy.json', 'file'))

        File.delete('vacancy.json') if File.exist?('vacancy.json')

    when /city/
        cities = Hash['а', ['Авдіївка', 'Алмазна', 'Алупкa', 'Алушта', 'Алчевськ', 'Амвросіївка', 
            'Ананьїв', 'Андрушівка', 'Антрацит', 'Апостолове', 'Армянськ', 'Арциз'], 
            'б', ['Балаклія','Балта','Бар','Баранівка','Барвінкове','Батурин','Бахмач','Бахмут',
                'Бахчисарай','Баштанка','Белз','Бердичів','Бердянськ','Берегове','Бережани','Березань',
                'Березівка','Березнe','Берестечко','Берислав ','Бершадь','Бібрка','Біла Церква',
                'Білгород-Дністровський', 'Білицьке','Білогірськ','Білозерське', 'Білопілля','Біляївка',
                'Благовіщенське', 'Бобринець', 'Бобровиця', 'Богодухів', 'Богуслав', 'Боково-Хрустальне',
                'Болград', 'Болехів', 'Борзна', 'Борислав', 'Бориспіль', 'Борщів', 'Боярка', 'Бровари',
                'Броди', 'Брянка', 'Бунге', 'Буринь', 'Бурштин', 'Буськ', 'Буча','Бучач']]
        city = message.text.downcase.split(' ').last
        variant = cities[city[-1,1]]
        bot.api.sendMessage(chat_id: message.chat.id, text: "Ви ввели таке місто #{city.capitalize},\n#{variant.sample}")

    when /.*як справи.*/,/.*як ся маєш.*/,/.*як ваші справи.*/,/.*як твої справи.*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, все чудово, а у вас як справи?")

    when /.*привіт.*/, /.*вітаю.*/, /.*доброго дня.*/, /.*доброго вечора.*/, /.*доброго ранку.*/, /.*lj,hjuj lyz.*/, /.*lj,hjuj hfyre.*/, /.*ghbdsn.*/, /.*dsnf..*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Доброго дня #{message.from.first_name}\nВас вітає чат-бот компанії VisaStart\nУ вас є запитання до нас?")

    when /.*привет.*/, /.*добрый день.*/, /.*доброе утро.*/, /.*добрый вечер.*/, /.*ghbdtn.*/, /.*lj,hsq dtxth.*/, /.*lj,hjt enhj.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Здравствуйте #{message.from.first_name}\nВас приветствует чат-бот компании VisaStart\nУ вас есть вопросы к нам?")

    when /.*hi.*/, /.*hello.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Hello #{message.from.first_name}\nWelcome to the VisaStart chat bot\nDo you have questions for us?")

    when /.*зарплата.*/,/.*зарплатня.*/,/.*гроші.*/,/.*зп.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name} зарплатня видається в такі дні:\n - на заводах 1 - 10 число наступного місяця;\n - на будові зарплата видається 10 - 15 число наступного місяця;\n - на будові залічка видається з 1 - 10 число наступного місяця.\nЩоб дізнатися вашу ставку та коли точно видають зарплату, зверніться до вашого кординатора.")
   
    when /.*віза.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name} бажаєте оформити візу?\nПерейдіть по посиланню знизу\nhttps://visastart.com/polska-robocha-visa/")
    
    when /.*страхівка.*/,/.*страхування.*/,/.*страховка.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name} бажаєте оформити страховку?\nЗверніться до нас за номером телефону")
    	bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")
    
    when /.*арматурник.*/,/.*арматура.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/HAijoUqUw2pJZyH3A')
    	bot.api.sendMessage(chat_id: message.chat.id, text: "АРМАТУРНИК\n Зарплата 17 - 20 зл/год\n Місто Варшава, Польща\n Житло Безкоштовне\nhttps://visastart.com/vacancy/armaturnyk/")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")
    
    when /.*опалубка.*/, /.*опалубник.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/dngwVMQSBEPCGHKZ8')
    	bot.api.sendMessage(chat_id: message.chat.id, text: "ОПАЛУБНИК\n Зарплата 18 - 22 зл/год\n Місто Варшава, Польща\n Житло Безкоштовне\nhttps://visastart.com/vacancy/opalubshhyk/")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")
    
    when /.*де ви знаходитесь.*/, /.*контакти.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Наш офіс знаходиться в місті Івано-Франківськ")
    	bot.api.sendLocation(chat_id: message.chat.id, latitude: "48.9202", longitude: "24.70772")
    	bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Перелік всіх офісів\nhttps://visastart.com/kontakty/")

    when /.*менеджер.*/,/.*менеджера.*/,/.*менеджером.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Зв'язатися з менеджером кол центру можна по телефону")
    	bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Зв'язатися з менеджером служби підтримки можна по телефону")
    	bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380932575078", first_name: "Служба підтримки", last_name: "VisaStart", vcard: "Viber, Telegram")

    when /.*зелена карта.*/,/.*грін карта.*/,/.*green card.*/,/.*грін карту.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/CRJqBH5X8oLEYsES8')
    	bot.api.sendMessage(chat_id: message.chat.id, text: "Бажаєте заповнити анкету на розіграш Зеленої Карти 2021?\nЗалишіть ваш номер телефону, або подайте заявку в нас на сайті. І ми зв'яжемось з вами.\nhttps://visastart.com/greencard/\nМожете подавати ваші данні в чат боті: Залиште ваше ім'я та прізвище латинськими літерами, електронну пошту та фото в електронному вигляді як на паспорт")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*їду додому.*/,/.*планую їхати додому.*/,/.*хочу додому.*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, якщо ви плануєте їхати на Україну. Попередьте координатора за 2 тижні до поїздки додому.")

    when /.*мала зарплата.*/,/.*мало платять.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, на якій вакансії ви зараз працюєте?")

    when /.*погане житло.*/,/.*умови проживання.*/
    	bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, на якій вакансії ви зараз працюєте?")

    when /.*що вмієш.*/,/.*шо вмієш.*/, /.*що ти вмієш.*/,/.*шо ти вмієш.*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{message.from.first_name}, я вмію надсилати повідовлення з адресою офісу, номера телефону, та надсилати вакансії. Якщо вас цікавлять вакансії, напишіть вакансії і я надішлю вам нові вакансії.")

    when /.*вакансії.*/,/.*вакансія.*/,/.*робота.*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "В нас є такі вакансії\nАрматурник, Опалубник, Електромонтер, Муляр, Електрик, Нові вакансії")

    when /.*польща.*/,/.*польша.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/69ujKpwMbQv8xiU56')
        bot.api.sendMessage(chat_id: message.chat.id, text: "В нас є такі вакансії у Польщі\nАрматурник, Опалубник, Електромонтер, Муляр, Електрик")

    when /.*німеччина.*/,/.*германия.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/kVyd55d4mR8M8BTD9')
        bot.api.sendMessage(chat_id: message.chat.id, text: "В нас є такі вакансії у Німеччині\nОфіціант, Покоївка, Плиточник")

    when /.*будівельники.*/,/.*строители.*/,/.*будова.*/,/.*стройка.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/BMVdLV1myasaT8z46')
        bot.api.sendMessage(chat_id: message.chat.id, text: "В нас є такі вакансії по Будові\nАрматурник\nОпалубник\nЕлектромонтер\nМуляр\nЕлектрик")

    when /.*сфера обслуговування.*/,/.*сфера обслуживания.*/,/.*обслуживание.*/,/.*персонал.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/rDmVSj1dXoLuSqYt8')
        bot.api.sendMessage(chat_id: message.chat.id, text: "В нас є такі вакансії у Сфері обслуговування\n Офіціант, Покоївка")

    when /.*муляр.*/,/.*муровка.*/,/.*муровщик.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/XRSLr3FtNMiZGddD8')
        bot.api.sendMessage(chat_id: message.chat.id, text: "МУЛЯР\n Зарплата 15 - 17 зл/год\n Місто Варшава, Польща\n Житло Безкоштовне\nhttps://visastart.com/vacancy/mulyar-riznorobochi/")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*електромонтер.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://www.google.com/imgres?imgurl=http%3A%2F%2Fxn--c1adfgnledbxn1b3hya.xn--p1ai%2Fwp-content%2Fuploads%2F2018%2F01%2F47.jpg&imgrefurl=http%3A%2F%2Fxn--c1adfgnledbxn1b3hya.xn--p1ai%2F%25D1%258D%25D0%25BB%25D0%25B5%25D0%25BA%25D1%2582%25D1%2580%25D0%25BE%25D0%25BC%25D0%25BE%25D0%25BD%25D1%2582%25D0%25B5%25D1%2580-%25D1%2580%25D0%25B5%25D0%25BC%25D0%25BE%25D0%25BD%25D1%2582%25D1%2583-%25D0%25BE%25D0%25B1%25D1%2581%25D0%25BB%25D1%2583%25D0%25B6%25D0%25B8%25D0%25B2%25D0%25B0.html&docid=48XgTeR7QbmnSM&tbnid=qkSbpIoydGXOtM%3A&vet=1&w=640&h=480&source=sh%2Fx%2Fim')
        bot.api.sendMessage(chat_id: message.chat.id, text: "ЕЛЕКТРОМОНТЕР\n Зарплата 15 - 17 зл/год\n Місто Хелм, Польща\n Житло Безкоштовне")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*нові вакансії.*/,/.*нові ваканції.*/,/.*ваканції нові.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/Fwna2eimwhAQj3bi9')
        bot.api.sendMessage(chat_id: message.chat.id, text: "Сортувальник електро відходів\nДорожній робітник\nОператор електричної рохли\nШоколадна фабрика")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*сортувальник електро відходів.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/qsDTe9SPt1crzQjTA')
        bot.api.sendMessage(chat_id: message.chat.id, text: "!!! НОВА ВАКАНСІЯ !!! NEW !!!\nСортувальник електро відходів\n Зарплата 13 зл/год\n Місто околиця Варшави\n Житло Безкоштовне (250 зл/міс за комунальні послуги)\n Телефонуйте!!!!")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

     when /.*дорожній робітник.*/
     	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/KixVHDseNZJGujSL8')
        bot.api.sendMessage(chat_id: message.chat.id, text: "!!! НОВА ВАКАНСІЯ !!! NEW !!!\n Дорожній робітник\n Зарплата 12 зл/год\n Місто Седльце\n Житло Безкоштовне\n Телефонуйте!!!!")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*оператор електричної рохли.*/,/.*оператор електреской рохли.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/g6jzzUdHjg9XePgq5')
        bot.api.sendMessage(chat_id: message.chat.id, text: "Оператор електричної рохли\n Зарплата 14 зл/год\n Місто Коєтани\n Житло Безкоштовне (250 зл/міс за комунальні послуги)\n Телефонуйте!!!!")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*шоколадна фабрика.*/,/.*шоколадная фабрика.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/5Q4qiJ7UK96pjr2C7')
        bot.api.sendMessage(chat_id: message.chat.id, text: "Шоколадна фабрика\n Зарплата 11 зл/год\n Місто Камєна Гура\n Житло 11 зл/доба\n Телефонуйте!!!!")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*офіціантка.*/,/.*офіціант.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/DyjrSMvgiiK8WKWK6')
        bot.api.sendMessage(chat_id: message.chat.id, text: "!!! НОВА ВАКАНСІЯ !!! NEW !!!\nОфіціантка\n Зарплата 7 євро/год\n Місто Берлін, Німеччина\n Житло Безкоштовне\n Телефонуйте!!!!")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*покоївка.*/
    	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'https://images.app.goo.gl/ccoodqphXGoyCMxG9')
        bot.api.sendMessage(chat_id: message.chat.id, text: "!!! НОВА ВАКАНСІЯ !!! NEW !!!\nПокоївка\n Зарплата 6 євро/год\n Місто Берлін, Німеччина\n Житло Безкоштовне\n Телефонуйте!!!!")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*\d{9,12}.*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "Дякуємо вам за звернення. Ми з вами скоро зв'яжемось з вами.")

    when /.*[а-я].*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "Нажаль я вас не розумію\nЯкщо бажаєте продовжити взаємодію напишіть /help \nЗателефонуйте до нас, менеджери вам допоможуть")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "Працевлаштування за кордоном", vcard: "Viber, Telegram")

    when /.*[a-z].*/
        bot.api.sendMessage(chat_id: message.chat.id, text: "I do not understand you. Call us via viber or telegram.")
        bot.api.sendContact(chat_id: message.chat.id, phone_number: "+380987649888", first_name: "VisaStart", last_name: "European Employment Center", vcard: "Viber, Telegram")

    end
  end
end
