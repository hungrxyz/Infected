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

    let infectedAPI: InfectedAPI
    let widgetCenter: WidgetCenter

    init(infectedAPI: InfectedAPI = InfectedAPI(),
         widgetCenter: WidgetCenter = .shared) {
        self.infectedAPI = infectedAPI
        self.widgetCenter = widgetCenter
    }

    func reloadAllRegions() {
        reloadNational()
        reloadProvincial()
        reloadSecurityRegions()
        reloadMunicipal()
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

}
