//
//  NumbersProvider.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Foundation
import Combine
import WidgetKit

final class NumbersProvider: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    @Published var nationalSummary: Summary?
    @Published var provincialSummaries: GroupedSummaries?
    @Published var securityRegionsSummaries: GroupedSummaries?
    @Published var municipalSummaries: GroupedSummaries?
    @Published var watchlistSummaries: GroupedSummaries?
    @Published var watchedSummaries: [Summary] = []

    let infectedAPI: InfectedAPI
    let widgetCenter: WidgetCenter
    let watchlistKeeper: WatchlistKeeper

    init(infectedAPI: InfectedAPI = InfectedAPI(),
         widgetCenter: WidgetCenter = .shared,
         watchlistKeeper: WatchlistKeeper = WatchlistKeeper()) {
        self.infectedAPI = infectedAPI
        self.widgetCenter = widgetCenter
        self.watchlistKeeper = watchlistKeeper
    }

    func reloadAllRegions() {
        reloadNational()
        reloadProvincial()
        reloadSecurityRegions()
        reloadMunicipal()
        reloadWatchlistRegions()
    }

    func reloadNational() {
        infectedAPI.national()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] summary in
                self?.nationalSummary = summary
            })
            .store(in: &cancellables)
    }

    func reloadProvincial() {
        infectedAPI.provincialGroupedSummaries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] groupedSummaries in
                self?.provincialSummaries = groupedSummaries
            })
            .store(in: &cancellables)
    }

    func reloadSecurityRegions() {
        infectedAPI.securityRegionsGroupedSummaries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] groupedSummaries in
                self?.securityRegionsSummaries = groupedSummaries
            })
            .store(in: &cancellables)
    }

    func reloadMunicipal() {
        infectedAPI.municipalGroupedSummaries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] groupedSummaries in
                self?.municipalSummaries = groupedSummaries
            })
            .store(in: &cancellables)
    }

    func reloadWatchlistRegions() {
        let regionCodes = watchlistKeeper.list()

        let publishers = regionCodes.map {
            infectedAPI.region(regionCode: $0)
        }
        let basePublisher = publishers[0].map { [$0] }.eraseToAnyPublisher()

        let zipped = publishers.dropFirst().reduce(into: basePublisher) { (result, publisher) in
            result = result.zip(publisher, { $0 + [$1] }).eraseToAnyPublisher()
        }
        zipped
            .map { GroupedSummaries(updatedAt: $0[0].updatedAt!, numbersDate: $0[0].numbersDate!, regions: $0) }
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] summaries in
                self?.watchlistSummaries = summaries
                self?.watchedSummaries = summaries.regions
        }
        .store(in: &cancellables)

    }

}
