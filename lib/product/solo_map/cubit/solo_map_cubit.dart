import 'package:tabumium/core/utility/logger_service.dart';

import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/cache_manager.dart';
import '../../../features/utility/enum/enum_general_state.dart';
import '../model/solo_game_model.dart';

part 'solo_map_state.dart';

class SoloMapCubit extends BaseCubit<SoloMapState> {
  SoloMapCubit() : super(SoloMapState());

  Future<void> fetchSoloMapData() async {
    final level = CacheManager.db.getSoloLevel();

    Map<String, dynamic> params = {
      "data": [
        {
          "id": 10,
          "words": [
            {
              "word": "Paleontoloji",
              "clues": ["Fosiller", "Hayvan", "Bitki", "Eski", "Kazı"],
              "jokerClue": "Nesli Tükenmiş"
            },
            {
              "word": "Voltaire",
              "clues": ["Aydınlanma", "Fransa", "Yazar", "Felsefe", "Eleştiri"],
              "jokerClue": "Candide"
            },
            {
              "word": "Konstantinopolis",
              "clues": [
                "Bizans",
                "Doğu Roma",
                "İstanbul",
                "Başkent",
                "Hristiyanlık"
              ],
              "jokerClue": "Yeni Roma"
            },
            {
              "word": "Parodi",
              "clues": [
                "Taklit",
                "Dalga Geçmek",
                "Komik",
                "Orijinal",
                "Benzer"
              ],
              "jokerClue": "Gülünçleştirme"
            },
            {
              "word": "Dubstep",
              "clues": ["Elektronik", "Bas", "Ritim", "İngiliz", "Dans"],
              "jokerClue": "Skrillex"
            },
            {
              "word": "Diyapazon",
              "clues": ["Ses", "Ayar", "Frekans", "Çatal", "Metal"],
              "jokerClue": "Akort"
            },
            {
              "word": "Kaşmir",
              "clues": ["Keçi", "Yün", "Pahalı", "Yumuşak", "Sıcak"],
              "jokerClue": "Paşmina"
            },
            {
              "word": "Barfiks",
              "clues": ["Çubuk", "Paralel", "Jimnastik", "Çekmek", "Asılmak"],
              "jokerClue": "Üst Direk"
            },
            {
              "word": "İnziva",
              "clues": ["Çekilmek", "Huzur", "Mağara", "Dünyevi", "Zevk"],
              "jokerClue": "El Etetek Çekmek"
            },
            {
              "word": "Avangart",
              "clues": ["Öncü", "Yenilikçi", "Sanat", "Modern", "Deney"],
              "jokerClue": "Deneyselcilik"
            }
          ]
        },
        {
          "id": 9,
          "words": [
            {
              "word": "Barcelona",
              "clues": ["Messi", "Cruyff", "Tiki-Taka", "Kulüp", "Katalan"],
              "jokerClue": "Camp Nou"
            },
            {
              "word": "Rezonans",
              "clues": ["Titreşim", "Ses", "Yankı", "Frekans", "Tınlamak"],
              "jokerClue": "Eşlenim"
            },
            {
              "word": "Alegori",
              "clues": ["Mecaz", "Sembolik", "Gizli Anlam", "Hikaye", "Mesaj"],
              "jokerClue": "Temsili Sanat"
            },
            {
              "word": "Parka",
              "clues": [
                "Kapüşonlu",
                "Kışlık",
                "Su Geçirmez",
                "Sıcak",
                "Askeri"
              ],
              "jokerClue": "Anorak"
            },
            {
              "word": "Mütemadiyen",
              "clues": ["Her Zaman", "Hep", "Ara Vermek", "Sürmek", "Sık Sık"],
              "jokerClue": "Kesintisiz"
            },
            {
              "word": "Feodalite",
              "clues": ["Orta Çağ", "Toprak", "Lord", "Vassal", "Kral"],
              "jokerClue": "Derebeylik"
            },
            {
              "word": "Senkronizasyon",
              "clues": ["Görsel", "Eş Zamanlı", "Film", "Video", "Müzik"],
              "jokerClue": "Uyumlanma"
            },
            {
              "word": "Antartika",
              "clues": ["Kutup", "Penguen", "Buzul", "Soğuk", "Kıta"],
              "jokerClue": "Güney Kutbu"
            },
            {
              "word": "Jonglör",
              "clues": ["Top", "Atmak", "Yakalamak", "Sirk", "El"],
              "jokerClue": "Lobut"
            },
            {
              "word": "Postmodernizm",
              "clues": [
                "Büyük Anlatılar",
                "Gerçeklik",
                "Yorum",
                "Çeşitlilik",
                "Kimlik"
              ],
              "jokerClue": "Modernlik Sonrası"
            }
          ]
        },
        {
          "id": 8,
          "words": [
            {
              "word": "Senarist",
              "clues": ["Hikaye", "Film", "Metin", "Diyalog", "Kalem"],
              "jokerClue": "Tretman"
            },
            {
              "word": "Framing",
              "clues": [
                "Çerçeveleme",
                "Görüntü",
                "Kompozisyon",
                "Kamera",
                "Sanat"
              ],
              "jokerClue": "Kadraj"
            },
            {
              "word": "Talkie",
              "clues": ["Sesli Film", "Konuşma", "İlk", "Hollywood", "Devrim"],
              "jokerClue": "Caz Şarkıcısı"
            },
            {
              "word": "Memlükler",
              "clues": ["Mısır", "Köle", "Türk", "Suriye", "Moğol"],
              "jokerClue": "Kölemenler"
            },
            {
              "word": "Akkoyunlular",
              "clues": [
                "Türkmen",
                "Doğu Anadolu",
                "Uzun Hasan",
                "Devlet",
                "Otlukbeli"
              ],
              "jokerClue": "Bayındır Boyu"
            },
            {
              "word": "Filoloji",
              "clues": ["Dil", "Yazı", "Eski", "Metin", "Dil Bilim"],
              "jokerClue": "Linguistik Tarih"
            },
            {
              "word": "Destan",
              "clues": [
                "Kahramanlık",
                "Uzun Hikaye",
                "Millet",
                "Savaş",
                "Efsane"
              ],
              "jokerClue": "Epope"
            },
            {
              "word": "Soyağacı",
              "clues": ["Aile", "Geçmiş", "Soy", "Bağlantı", "Kök"],
              "jokerClue": "Genealoji"
            },
            {
              "word": "Şövalyelik",
              "clues": ["Orta Çağ", "At", "Savaşçı", "Onur", "Kral"],
              "jokerClue": "Zırhlı Süvari"
            },
            {
              "word": "Lisanslama",
              "clues": ["İzin", "Kullanım", "Telif", "Şarkı", "Yasal"],
              "jokerClue": "Fikri Mülkiyet"
            }
          ]
        },
        {
          "id": 7,
          "words": [
            {
              "word": "Kaftan",
              "clues": ["Uzun", "Gevşek", "Doğu", "Geleneksel", "Elbise"],
              "jokerClue": "Saray Giyisisi"
            },
            {
              "word": "Kimono",
              "clues": ["Japon", "Geleneksel", "Geniş Kol", "İpek", "Kuşak"],
              "jokerClue": "Yukata"
            },
            {
              "word": "Babet",
              "clues": ["Düz", "Ayakkabı", "Kadın", "Rahat", "Parmak"],
              "jokerClue": "Topuksuz"
            },
            {
              "word": "Kanun",
              "clues": ["Telli", "Türk", "Vurmalı", "Çalmak", "Düğün"],
              "jokerClue": "Mızrap"
            },
            {
              "word": "Amfi",
              "clues": ["Ses", "Yükseltmek", "Gitar", "Elektrik", "Kutu"],
              "jokerClue": "Amplifikatör"
            },
            {
              "word": "Vokalist",
              "clues": ["Şarkıcı", "Ses", "Söylemek", "Grup", "Müzik"],
              "jokerClue": "Geri Vokal"
            },
            {
              "word": "Besteci",
              "clues": ["Müzik", "Yazmak", "Senfoni", "Orkestra", "Ünlü"],
              "jokerClue": "Kompozitör"
            },
            {
              "word": "Mizansen",
              "clues": [
                "Sahneleme",
                "Görsel",
                "Tasarım",
                "Yönetmen",
                "Yerleşim"
              ],
              "jokerClue": "Set Düzeni"
            },
            {
              "word": "Koreograf",
              "clues": ["Dans", "Savaş", "Hareket", "Planlama", "Sahne"],
              "jokerClue": "Figür Tasarımı"
            },
            {
              "word": "Gaffer",
              "clues": ["Işık Şefi", "Ekip", "Elektrik", "Aydınlatma", "Film"],
              "jokerClue": "Set Işıkçısı"
            }
          ]
        },
        {
          "id": 6,
          "words": [
            {
              "word": "Pankart",
              "clues": ["Taraftar", "Yazı", "Mesaj", "Tribün", "Açmak"],
              "jokerClue": "Döviz"
            },
            {
              "word": "Altyapı",
              "clues": ["Genç", "Eğitim", "Kulüp", "Gelecek", "Oyuncu"],
              "jokerClue": "Akademi"
            },
            {
              "word": "Transfer",
              "clues": ["Kulüp", "Oyuncu", "Para", "Değişim", "Sözleşme"],
              "jokerClue": "Bonservis"
            },
            {
              "word": "İdman",
              "clues": ["Antrenman", "Çalışma", "Koşmak", "Top", "Hazırlık"],
              "jokerClue": "Kondisyon"
            },
            {
              "word": "Atik",
              "clues": ["Hızlı", "Çabuk", "Çevik", "Birden", "Davranmak"],
              "jokerClue": "Seri"
            },
            {
              "word": "Kargaşa",
              "clues": ["Kavga", "Itişme", "Kalabalık", "Karışık", "Düzensiz"],
              "jokerClue": "Kaos"
            },
            {
              "word": "Dibek",
              "clues": ["Türk", "Fincan", "Çeşit", "İçmek", "Ezmek"],
              "jokerClue": "Havanda Kahve"
            },
            {
              "word": "Karıncayiyen",
              "clues": ["Hayvan", "Hortum", "Burun", "Yer", "Yuva"],
              "jokerClue": "Tamandua"
            },
            {
              "word": "Abiye",
              "clues": ["Gece", "Özel Gün", "Uzun", "Davet", "Kadın"],
              "jokerClue": "Tuvalet Elbise"
            },
            {
              "word": "Showroom",
              "clues": [
                "Tasarımcı",
                "Koleksiyon",
                "Tanıtım",
                "Müşteri",
                "Sergileme"
              ],
              "jokerClue": "Teşhir Salonu"
            }
          ]
        },
        {
          "id": 5,
          "words": [
            {
              "word": "Termodinamik",
              "clues": ["Isı", "Enerji", "Sistem", "Kanunlar", "Fizik"],
              "jokerClue": "Entropi"
            },
            {
              "word": "Hormon",
              "clues": ["Vücut", "Salgı", "Kimyasal", "Mesajcı", "Büyüme"],
              "jokerClue": "Endokrin"
            },
            {
              "word": "Android",
              "clues": ["Robot", "İnsan", "Benzemek", "Yapay Zeka", "Makine"],
              "jokerClue": "İnsansı"
            },
            {
              "word": "Paintball",
              "clues": ["Boyalı Top", "Takım", "Savaş", "Maske", "Strateji"],
              "jokerClue": "İşaretleyici"
            },
            {
              "word": "Motocross",
              "clues": ["Motor", "Toprak", "Yarış", "Zıplamak", "Kask"],
              "jokerClue": "Arazi Sürüşü"
            },
            {
              "word": "Libero",
              "clues": ["Savunma", "Geriden", "Oyuncu", "Süpürücü", "Serbest"],
              "jokerClue": "Farklı Renk Forma"
            },
            {
              "word": "Meşale",
              "clues": ["Ateş", "Taraftar", "Tribün", "Yakmak", "Yasaktır"],
              "jokerClue": "Menzale"
            },
            {
              "word": "Cosplay",
              "clues": ["Karakter", "Kostüm", "Anime", "Oyun", "Canlandırma"],
              "jokerClue": "Kostümlü Oyun"
            },
            {
              "word": "Gayda",
              "clues": ["İskoç", "Tulum", "Nefesli", "Üflemek", "Tören"],
              "jokerClue": "Duduk"
            },
            {
              "word": "Arşivcilik",
              "clues": ["Belge", "Saklama", "Tarih", "Koleksiyon", "Düzenleme"],
              "jokerClue": "Dokümantasyon"
            }
          ]
        },
        {
          "id": 4,
          "words": [
            {
              "word": "Begonvil",
              "clues": ["Pembe", "Bodrum", "Sarmaşık", "Çiçek", "Renk"],
              "jokerClue": "Gelin Duvağı"
            },
            {
              "word": "Algoritma",
              "clues": ["Bilgisayar", "Adım", "Problem", "Çözüm", "Yazılım"],
              "jokerClue": "Akış Diyagramı"
            },
            {
              "word": "Berlin",
              "clues": [
                "Almanya",
                "Başkent",
                "Duvar",
                "Festival",
                "İkinci Dünya Savaşı"
              ],
              "jokerClue": "Brandenburg Kapısı"
            },
            {
              "word": "Kronoloji",
              "clues": ["Zaman", "Sıra", "Olaylar", "Tarih", "Yıl"],
              "jokerClue": "Zaman Dizini"
            },
            {
              "word": "Blockchain",
              "clues": ["Kripto", "Veri", "Dağıtılmış", "Güvenli", "Defter"],
              "jokerClue": "Blok Zinciri"
            },
            {
              "word": "Langırt",
              "clues": ["Masa", "Futbolcu", "Top", "El Hareketi", "Arkadaş"],
              "jokerClue": "Masa Futbolu"
            },
            {
              "word": "Konservatuvar",
              "clues": [
                "Müzik Okulu",
                "Eğitim",
                "Klasik",
                "Enstrüman",
                "Öğrenci"
              ],
              "jokerClue": "Güzel Sanatlar Akademisi"
            },
            {
              "word": "Arkeoloji",
              "clues": ["Kazı", "Eski", "Eşya", "Toprak", "Uygarlık"],
              "jokerClue": "Eser Bilimi"
            },
            {
              "word": "Snowboard",
              "clues": ["Kar", "Dağ", "Kaymak", "Kış Sporu", "Denge"],
              "jokerClue": "Kar Tahtası"
            },
            {
              "word": "Hologram",
              "clues": ["3D", "Görüntü", "Lazer", "Sanal", "Yansıma"],
              "jokerClue": "Üç Boyutlu Fotoğraf"
            }
          ]
        },
        {
          "id": 3,
          "words": [
            {
              "word": "Zaman",
              "clues": ["Saat", "Dakika", "Saniye", "Geçmek", "Ölçmek"],
              "jokerClue": "Vakit"
            },
            {
              "word": "Saha",
              "clues": ["Yeşil", "Çim", "Top", "Maç", "Oynamak"],
              "jokerClue": "Oyun Alanı"
            },
            {
              "word": "Damızlık",
              "clues": ["Çiftleştirmek", "At", "Boğa", "Hayvan", "Yetiştirmek"],
              "jokerClue": "Üretimlik"
            },
            {
              "word": "Boşboğaz",
              "clues": ["Konuşmak", "Geveze", "Sır", "Söylemek", "Anlatmak"],
              "jokerClue": "Laf Ebesi"
            },
            {
              "word": "Duvak",
              "clues": ["Gelin", "Beyaz", "Baş", "Örtü", "Düğün"],
              "jokerClue": "Yüz Örtüsü"
            },
            {
              "word": "Yaka",
              "clues": ["Gömlek", "Boyun", "Kravat", "Kıvırmak", "Üst"],
              "jokerClue": "Yaka Paça"
            },
            {
              "word": "Senfoni",
              "clues": ["Orkestra", "Müzik", "Büyük", "Dört Bölüm", "Klasik"],
              "jokerClue": "Dokuzuncu"
            },
            {
              "word": "Saksafon",
              "clues": ["Üflemeli", "Caz", "Bakır", "Ağızlık", "Çalmak"],
              "jokerClue": "Adolphe Sax"
            },
            {
              "word": "Dublaj",
              "clues": ["Seslendirme", "Yabancı", "Dil", "Film", "Konuşmak"],
              "jokerClue": "Senkronize Ses"
            },
            {
              "word": "Mezopotamya",
              "clues": [
                "Dicle Fırat",
                "Bereketli Hilal",
                "Sümerler",
                "Asurlular",
                "Babil"
              ],
              "jokerClue": "Medeniyetlerin Beşiği"
            }
          ]
        },
        {
          "id": 2,
          "words": [
            {
              "word": "Gezegenler",
              "clues": ["Mars", "Venüs", "Jüpiter", "Güneş", "Uydular"],
              "jokerClue": "Yörünge"
            },
            {
              "word": "Fotosentez",
              "clues": [
                "Bitki",
                "Güneş Işığı",
                "Su",
                "Karbondioksit",
                "Oksijen"
              ],
              "jokerClue": "Klorofil"
            },
            {
              "word": "Düğün",
              "clues": ["Gelin", "Damat", "Halay", "Takı", "Eğlence"],
              "jokerClue": "Gerdek"
            },
            {
              "word": "Bilardo",
              "clues": ["Masa", "Top", "Istaka", "Delik", "Oynamak"],
              "jokerClue": "Karambol"
            },
            {
              "word": "Uzatmalar",
              "clues": ["Maç", "Ekstra", "Süre", "Beraberlik", "Gol"],
              "jokerClue": "Altın Gol"
            },
            {
              "word": "Santra",
              "clues": ["Maç", "Başlangıç", "Ortada", "Top", "Vuruş"],
              "jokerClue": "Orta Yuvarlak"
            },
            {
              "word": "Isınma",
              "clues": ["Antrenman", "Maç Öncesi", "Koşmak", "Kas", "Hazırlık"],
              "jokerClue": "Kültür Fizik"
            },
            {
              "word": "Zulalamak",
              "clues": ["Saklamak", "Gizli", "Koymak", "Kaçak", "Yasak"],
              "jokerClue": "İstiflemek"
            },
            {
              "word": "Samba",
              "clues": ["Dans", "Brezilya", "Karnaval", "Ritüel", "Müzik"],
              "jokerClue": "Rio"
            },
            {
              "word": "Ampul",
              "clues": [
                "Thomas Edison",
                "Işık",
                "Elektrik",
                "Karanlık",
                "Bulmak"
              ],
              "jokerClue": "Filaman"
            }
          ]
        },
        {
          "id": 1,
          "words": [
            {
              "word": "Kurgucu",
              "clues": ["Film", "Kesmek", "Birleştirmek", "Sıralamak", "Sahne"],
              "jokerClue": "Editör"
            },
            {
              "word": "Pijama",
              "clues": ["Uyku", "Yatak", "Gece", "Giymek", "Rahat"],
              "jokerClue": "Gece Giysisi"
            },
            {
              "word": "Harita",
              "clues": ["Yol", "Ülke", "Coğrafya", "Gezmek", "Çizim"],
              "jokerClue": "Kartografya"
            },
            {
              "word": "Ademelması",
              "clues": ["Boğaz", "Gırtlak", "Çıkıntı", "Erkek", "Ergen"],
              "jokerClue": "Gırtlak Çıkıntısı"
            },
            {
              "word": "Binicilik",
              "clues": ["At", "Sürmek", "Spor", "Eyer", "Koşmak"],
              "jokerClue": "Manej"
            },
            {
              "word": "Enstrümantal",
              "clues": ["Sözsüz", "Şarkı", "Müzik", "Çalmak", "Vokal"],
              "jokerClue": "Saz Eseri"
            },
            {
              "word": "Fuar",
              "clues": ["Gösteri", "Stant", "Ürün", "Kalabalık", "Tanıtım"],
              "jokerClue": "Panayır"
            },
            {
              "word": "Reform",
              "clues": [
                "Kilise",
                "Martin Luther",
                "Protestanlık",
                "Din",
                "Avrupa"
              ],
              "jokerClue": "Yenilikçi Akım"
            },
            {
              "word": "Çevre",
              "clues": ["Doğa", "Koruma", "Yaşam", "İnsan", "Kirlilik"],
              "jokerClue": "Ekoloji"
            },
            {
              "word": "Parfüm",
              "clues": ["Koku", "Şişe", "Sıkmak", "Güzel", "Boyun"],
              "jokerClue": "Esans"
            }
          ]
        }
      ]
    };
    SoloGameModel soloGameModel = SoloGameModel.fromJson(params);
    SoloGame soloGame = (soloGameModel.data ?? []).firstWhere((element) {
      // _log.d("element.id: ${element.id} *** level-1: $level");
      return element.id == level;
    });
    MyLog("SoloMapCubit").d(
        "Fetched solo game data for level $level \n ${(soloGame.words ?? []).map((e) => e.toJson()).toList()}");
    await Future.delayed(Duration(seconds: 2));
    safeEmit(state.copyWith(
        status: EnumGeneralStateStatus.completed,
        soloGameList: soloGameModel.data ?? [],
        soloGame: soloGame));
  }

  levelUp() {
    final currentLevel = (state.soloGame ?? SoloGame(id: 1)).id ?? 1;
    CacheManager.db.setSoloLevel(currentLevel + 1);
    state.soloGameList?.forEach((element) {
      if (element.id == currentLevel + 1) {
        safeEmit(state.copyWith(soloGame: element));
        return;
      }
    });
  }
}
