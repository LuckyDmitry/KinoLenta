//
//  MovieDetailViewModel.swift
//  KinoLenta
//
//  Created by Alexander Denisov on 29.12.2021.
//

import Foundation

struct MovieDetailViewModel {
    struct ButtonAction {
        let option: SavedMovieOption
        var item: QuickItem
    }

    let movieId: Int
    let title: String
    let imageURL: URL?
    let overview: String?
    let director: String?
    let starring: String?
    let reviews: [(nickname: String, text: String)]
    var buttonActions: [ButtonAction] = [
        ButtonAction(
            option: .wishToWatch,
            item: QuickItem(title: NSLocalizedString(
                "add_to_wishlist_action",
                comment: "Action title for adding to wishlist"
            ))
        ),
        ButtonAction(
            option: .watched,
            item: QuickItem(title: NSLocalizedString(
                "add_to_watched_list_action",
                comment: "Action title adding to already watched list"
            ))
        ),
    ]
}

extension MovieDetailViewModel {
    init(model: MovieDomainModel) {
        self.init(
            movieId: model.id,
            title: model.title,
            imageURL: model.backdropURL ?? model.posterURL,
            overview: model.overview,
            director: fakeDirector,
            starring: fakeStarring,
            reviews: fakeReviews
        )
    }

    init(model: SearchedMovieViewItem) {
        self.init(
            movieId: model.id,
            title: model.title,
            imageURL: model.imageURL,
            overview: model.overview,
            director: fakeDirector,
            starring: fakeStarring,
            reviews: fakeReviews
        )
    }

    init(model: QueryMovieModel) {
        self.init(
            movieId: model.id,
            title: model.title,
            imageURL: model.backdropURL ?? model.posterURL,
            overview: model.overview,
            director: fakeDirector,
            starring: fakeStarring,
            reviews: fakeReviews
        )
    }
}

let fakeDirector = "Дэмьен Шазелл"
let fakeStarring = "Райан Гослинг, Эмма Стоун, Джон Ледженд, Дж.К. Симмонс, Розмари ДеУитт, Финн Уиттрок, Калли Эрнандес, Соноя Мидзуно, Джессика Рот, Том Эверетт Скотт"
let fakeReviews = [
    (
        nickname: "Волк",
        text: "Сотворив из рядовой подготовки к джазовому концерту неподдельный триллер с зашкаливающим эмоциональным бурлеском, режиссер и сценарист Дэмьен Шазелл сам того не подозревая превратился в одного из наиболее уважаемых и востребованных творцов современности. Проросшая из скромной короткометражки идея была замечена продюсерами и перевоплотилась в полный метр, известный под названием 'Одержимость'. Заставив Дж. К. Симмонса и Майлза Тернера играть в действительности на грани, пройти огонь, воду, медные трубы и в довершении ко всему едва не поубивать друг друга на съемочной площадке, Дэмьен Шазелл собрал внушительный букет положительных откликов от широчайшей аудитории, обеспечивший его детищу блестящие как для малобюджетного кино кассовые сборы, а также стойкие позиции на церемонии награждения премией 'Оскар'. Открыв двери в заветный мир сверкающих софитов Голливуда, Дэмьен Шазелл был вправе выбирать любой приглянувшийся проект, однако вместо переноса чужой идеи на экран он вновь засел за написание сценария, известного нынче как 'Ла-Ла Ленд'. Питая теплые чувство к музыке"
    ),
    (
        nickname: "Волк",
        text: "Сотворив из рядовой подготовки к джазовому концерту неподдельный триллер с зашкаливающим эмоциональным бурлеском, режиссер и сценарист Дэмьен Шазелл сам того не подозревая превратился в одного из наиболее уважаемых и востребованных творцов современности. Проросшая из скромной короткометражки идея была замечена продюсерами и перевоплотилась в полный метр, известный под названием 'Одержимость'. Заставив Дж. К. Симмонса и Майлза Тернера играть в действительности на грани, пройти огонь, воду, медные трубы и в довершении ко всему едва не поубивать друг друга на съемочной площадке, Дэмьен Шазелл собрал внушительный букет положительных откликов от широчайшей аудитории, обеспечивший его детищу блестящие как для малобюджетного кино кассовые сборы, а также стойкие позиции на церемонии награждения премией 'Оскар'. Открыв двери в заветный мир сверкающих софитов Голливуда, Дэмьен Шазелл был вправе выбирать любой приглянувшийся проект, однако вместо переноса чужой идеи на экран он вновь засел за написание сценария, известного нынче как 'Ла-Ла Ленд'. Питая теплые чувство к музыке"
    ),
    (
        nickname: "Волк",
        text: "Сотворив из рядовой подготовки к джазовому концерту неподдельный триллер с зашкаливающим эмоциональным бурлеском, режиссер и сценарист Дэмьен Шазелл сам того не подозревая превратился в одного из наиболее уважаемых и востребованных творцов современности. Проросшая из скромной короткометражки идея была замечена продюсерами и перевоплотилась в полный метр, известный под названием 'Одержимость'. Заставив Дж. К. Симмонса и Майлза Тернера играть в действительности на грани, пройти огонь, воду, медные трубы и в довершении ко всему едва не поубивать друг друга на съемочной площадке, Дэмьен Шазелл собрал внушительный букет положительных откликов от широчайшей аудитории, обеспечивший его детищу блестящие как для малобюджетного кино кассовые сборы, а также стойкие позиции на церемонии награждения премией 'Оскар'. Открыв двери в заветный мир сверкающих софитов Голливуда, Дэмьен Шазелл был вправе выбирать любой приглянувшийся проект, однако вместо переноса чужой идеи на экран он вновь засел за написание сценария, известного нынче как 'Ла-Ла Ленд'. Питая теплые чувство к музыке"
    ),
]