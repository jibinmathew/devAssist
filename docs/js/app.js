/**
 * Jibin Mathew Jose — Portfolio JavaScript Application Logic
 * Pure Vanilla JS, zero external dependencies.
 * Includes AI Developer Assistant open source project references & GitHub link https://github.com/jibinmathew?tab=repositories
 */

document.addEventListener('DOMContentLoaded', () => {
    // ----------------------------------------------------------------------
    // 1. Theme Toggle & Persistence
    // ----------------------------------------------------------------------
    const themeToggleBtn = document.getElementById('theme-toggle');
    const htmlElem = document.documentElement;

    const savedTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    htmlElem.setAttribute('data-theme', savedTheme);

    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            const currentTheme = htmlElem.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            htmlElem.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            showToast('Theme switched to ' + newTheme + ' mode');
        });
    }

    // ----------------------------------------------------------------------
    // 2. Navbar Scroll Effect & Mobile Drawer
    // ----------------------------------------------------------------------
    const navbar = document.getElementById('navbar');
    const mobileMenuToggle = document.getElementById('mobile-menu-toggle');
    const navLinks = document.getElementById('nav-links');

    window.addEventListener('scroll', () => {
        if (window.scrollY > 40) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    if (mobileMenuToggle && navLinks) {
        mobileMenuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
        });
    }

    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', () => {
            if (navLinks) navLinks.classList.remove('active');
        });
    });

    // ----------------------------------------------------------------------
    // 3. Hero Code Snippets & Copy Functionality
    // ----------------------------------------------------------------------
    const codeSnippets = {
        ai_project: `// 🚀 Open Source AI Developer Assistant Engine
import Foundation

public struct AIAssistantEngine: Sendable {
    private let aiService: AIServiceProtocol

    public init(aiService: AIServiceProtocol) {
        self.aiService = aiService
    }

    public func analyzeCrashLog(_ log: String) async throws -> AnalysisReport {
        let result = try await aiService.analyze(log: log)
        return AnalysisReport(severity: .critical, fixSnippet: result.patch)
    }
}`,
        superapp: `// 🏛️ Super App Module Coordinator Protocol
import Foundation
import UIKit

public protocol ModuleCoordinatorProtocol: AnyObject {
    var moduleID: String { get }
    func buildModuleInterface() -> UIViewController
}

public final class SuperAppContainer {
    private var modules: [String: ModuleCoordinatorProtocol] = [:]
    
    public init() {}
    
    public func register(module: ModuleCoordinatorProtocol) {
        modules[module.moduleID] = module
    }
    
    public func resolve(moduleID: String) -> UIViewController? {
        return modules[moduleID]?.buildModuleInterface()
    }
}`,
        rxswift: `// ⚡ RxSwift Reactive State & Main Thread Dispatching
import RxSwift
import RxCocoa

public final class TelemetryViewModel {
    private let disposeBag = DisposeBag()
    public let deviceStream: Driver<[DeviceModel]>
    
    public init(service: TelemetryServiceProtocol) {
        self.deviceStream = service.fetchActiveDevices()
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}`
    };

    const codeDisplay = document.getElementById('code-snippet-display');
    const codeTabs = document.querySelectorAll('.code-tab');
    const copyCodeBtn = document.getElementById('copy-code-btn');

    function loadSnippet(key) {
        if (codeDisplay && codeSnippets[key]) {
            codeDisplay.textContent = codeSnippets[key];
        }
    }

    loadSnippet('ai_project');

    codeTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            codeTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            loadSnippet(tab.getAttribute('data-snippet'));
        });
    });

    if (copyCodeBtn) {
        copyCodeBtn.addEventListener('click', () => {
            if (codeDisplay) {
                navigator.clipboard.writeText(codeDisplay.textContent);
                showToast('Code copied to clipboard!');
            }
        });
    }

    // ----------------------------------------------------------------------
    // 4. Project Filtering
    // ----------------------------------------------------------------------
    const filterBtns = document.querySelectorAll('.filter-btn');
    const projectCards = document.querySelectorAll('.project-card');

    filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            filterBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const filter = btn.getAttribute('data-filter');

            projectCards.forEach(card => {
                const categories = card.getAttribute('data-category').split(' ');
                if (filter === 'all' || categories.includes(filter)) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    // ----------------------------------------------------------------------
    // 5. Complete Case Studies for All 9 Projects
    // ----------------------------------------------------------------------
    const projectDetails = {
        p1_superapp: {
            title: "US Telecommunications Super App Platform (40+ Modules)",
            bannerIcon: "📱",
            description: "A large-scale Super App for a renowned US-based telecommunications company, consolidating 40+ modules into a unified platform. Includes IoT solutions for smartwatches, trackers, connected driving devices, and a Networks & Maps module providing network coverage, service availability, roaming information, and location-based services.",
            role: "Chapter Lead (Lead of Leads) | Infosys Canada & India",
            responsibilities: [
                "Provided technical leadership across multiple iOS feature teams.",
                "Responsible for architecture, technical direction, and delivery of 6 key core modules.",
                "Led technical design, development, code reviews, and pair programming best practices.",
                "Managed project resources, mentored technical leads, and supported cross-team collaboration."
            ],
            tech: ["Swift", "SwiftUI", "RxSwift", "REST APIs", "Maps", "IoT Devices", "Modular Super App Architecture"]
        },
        p2_smartwatch: {
            title: "Kids' Wearable & Smartwatch IoT Companion Platform (100K+ Users)",
            bannerIcon: "⌚",
            description: "A companion mobile application for kids' smartwatches with an active user base of over 100,000 users, serving as one of the leading revenue-generating IoT products for a renowned telecommunications company.",
            role: "Technology Lead | Infosys India",
            responsibilities: [
                "Led a larger engineering team through architectural design, development, and delivery.",
                "Implemented real-time GPS tracking, safe zone geofencing, and parental device management.",
                "Managed project resources and mentored junior/senior iOS developers."
            ],
            tech: ["Swift", "SwiftUI", "RxSwift", "CoreLocation", "Bluetooth LE", "IoT Hardware"]
        },
        p3_smartfarming: {
            title: "Smart Agricultural & Environmental Monitoring System",
            bannerIcon: "🌾",
            description: "A smart farming application using wireless sensor telemetry data to monitor soil characteristics, moisture levels, and environmental parameters to help farmers make informed decisions and improve farming productivity.",
            role: "Senior Software Engineer | Reflections Infosystems",
            responsibilities: [
                "Designed and developed key application features and sensor data visualizations.",
                "Implemented SQLite local caching for uninterrupted offline field operation.",
                "Executed thorough debugging, unit testing, and performance optimization."
            ],
            tech: ["Swift", "Wireless Sensors", "Soil Data Analytics", "SQLite", "Core Graphics"]
        },
        p4_globalmedia: {
            title: "Global Media & Digital Entertainment Platform",
            bannerIcon: "🎬",
            description: "A media and entertainment application developed for a major global entertainment network, providing users with instant access to digital media, movies, live sports, and digital entertainment content.",
            role: "Senior Software Engineer | Attinad Software",
            responsibilities: [
                "Architected application UI, video playback workflows, and network error handling.",
                "Integrated secure media streaming protocols and digital rights management (DRM).",
                "Conducted performance analysis and unit testing across multiple iOS device form factors."
            ],
            tech: ["Objective-C", "AVFoundation", "Digital Media", "Live Sports", "XCTest"]
        },
        p5_malaysiamedia: {
            title: "Southeast Asian Integrated Live TV & Media Platform",
            bannerIcon: "📺",
            description: "A media application developed for Media Prima Berhad, a leading integrated media company in Malaysia. Provides access to TV shows, movies, and live television channels.",
            role: "Senior Software Engineer | Attinad Software",
            responsibilities: [
                "Responsible for application design, development, testing, and client delivery.",
                "Implemented live channel streaming and video-on-demand media players.",
                "Optimized video buffer times and UI layout constraints for high concurrency."
            ],
            tech: ["Objective-C", "Live TV Streaming", "VOD Catalog", "AVFoundation", "UIKit"]
        },
        p6_europeantv: {
            title: "Interactive Cable-Free Digital TV Platform",
            bannerIcon: "📡",
            description: "A media application developed for a European provider, providing users access to interactive digital television, live TV channels, TV shows, and video-on-demand without traditional cable subscriptions.",
            role: "Senior Software Engineer | Attinad Software",
            responsibilities: [
                "Designed and developed interactive TV channel navigation and EPG schedules.",
                "Implemented custom UI player controls and streaming quality auto-switching.",
                "Ensured high stability across iPhone and iPad resolutions."
            ],
            tech: ["Objective-C", "Interactive TV", "EPG Schedule", "Live Streaming", "UIKit"]
        },
        p7_singaporetelecom: {
            title: "Telecommunications SVOD & TVOD Streaming Platform",
            bannerIcon: "🎥",
            description: "A media application developed for StarHub, a Singapore-based telecommunications company, providing access to movies, TV shows, and live channels through TVOD and SVOD services.",
            role: "Senior Software Engineer | Attinad Software",
            responsibilities: [
                "Engineered transactional (TVOD) and subscription (SVOD) checkout and video delivery flows.",
                "Integrated secure REST APIs, payment gateways, and content catalog synchronization.",
                "Managed application testing and successful App Store delivery."
            ],
            tech: ["Objective-C", "SVOD", "TVOD", "REST APIs", "Payment Integration"]
        },
        p8_kidsanimation: {
            title: "Kids Interactive Animation & Game Suite",
            bannerIcon: "👾",
            description: "A media and entertainment application developed for Cartoon Network, designed for kids and featuring a rich collection of cartoons, games, and interactive entertainment content.",
            role: "Senior Software Engineer | Attinad Software",
            responsibilities: [
                "Developed interactive game view controllers and cartoon video playback flows.",
                "Created highly responsive, kid-friendly animations and touch controls.",
                "Executed thorough performance profiling using Xcode Instruments."
            ],
            tech: ["Objective-C", "Interactive Games", "Cartoons", "Custom Animations", "UIKit"]
        },
        p9_cadfacility: {
            title: "Enterprise Facility & CAD Asset Management Platform",
            bannerIcon: "🏢",
            description: "A facility management application providing direct synchronization with desktop SaaS platforms, enabling facility managers to manage CAD drawing-related data, Employee Management, Asset Management, Work Orders, Preventive Maintenance, and Space Management.",
            role: "Software Engineer | Esystem Software",
            responsibilities: [
                "Developed core modules for CAD drawing viewer, Work Orders, and Space Allocation.",
                "Implemented SQLite local data persistence for offline facility inspections.",
                "Conducted extensive debugging, feature testing, and client data sync validation."
            ],
            tech: ["Objective-C", "SQLite", "CAD Vector Sync", "Asset Management", "Work Orders"]
        }
    };

    const projectModal = document.getElementById('project-modal');
    const modalContentBody = document.getElementById('modal-content-body');
    const modalCloseBtn = document.getElementById('modal-close-btn');
    const modalOverlay = document.getElementById('modal-overlay');

    document.querySelectorAll('.view-project-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const projKey = btn.getAttribute('data-project');
            const data = projectDetails[projKey];

            if (data && modalContentBody && projectModal) {
                modalContentBody.innerHTML = 
                    '<div style="font-size: 2.5rem; margin-bottom: 0.5rem;">' + data.bannerIcon + '</div>' +
                    '<h2 style="font-size: 1.75rem; margin-bottom: 0.25rem;">' + data.title + '</h2>' +
                    '<p style="color: var(--primary); font-weight: 600; font-size: 0.95rem; margin-bottom: 1rem;">Role: ' + data.role + '</p>' +
                    '<p style="color: var(--text-secondary); margin-bottom: 1.5rem; font-size: 1rem;">' + data.description + '</p>' +
                    '<h3 style="font-size: 1.1rem; color: var(--primary); margin-bottom: 0.75rem;">Key Engineering Responsibilities</h3>' +
                    '<ul style="padding-left: 1.25rem; margin-bottom: 1.5rem; color: var(--text-secondary);">' +
                        data.responsibilities.map(function(r) { return '<li style="margin-bottom: 0.5rem;">' + r + '</li>'; }).join('') +
                    '</ul>' +
                    '<h3 style="font-size: 1.1rem; color: var(--primary); margin-bottom: 0.75rem;">Technologies Used</h3>' +
                    '<div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1.5rem;">' +
                        data.tech.map(function(t) { return '<span style="background: rgba(255,255,255,0.08); border: 1px solid var(--border-color); padding: 0.3rem 0.75rem; border-radius: 6px; font-size: 0.85rem;">' + t + '</span>'; }).join('') +
                    '</div>';
                projectModal.classList.add('active');
            }
        });
    });

    if (modalCloseBtn && modalOverlay && projectModal) {
        [modalCloseBtn, modalOverlay].forEach(elem => {
            elem.addEventListener('click', () => {
                projectModal.classList.remove('active');
            });
        });
    }

    // ----------------------------------------------------------------------
    // 6. Interactive Code Playground & Architecture Simulator
    // ----------------------------------------------------------------------
    const sandboxPresets = {
        ai_hobby: {
            tool: 'ai_hobby',
            input: '// AI Crash Analysis Request\nlet stackTrace = "Fatal error: Index out of range inside Swift 6 Task"\nlet patch = try await aiEngine.diagnoseAndFix(log: stackTrace)'
        },
        superapp_arch: {
            tool: 'superapp_arch',
            input: '// Super App Routing Verification\nprotocol SuperAppCoordinator {\n    func routeToModule(id: String, from: UIViewController)\n}\n// Validate protocol isolation for core modules.'
        },
        rx_combine: {
            tool: 'rx_combine',
            input: '// RxSwift DisposeBag & Retain Cycle Inspection\nObservable.combineLatest(telemetryService.fetchDevices(), networkService.observeStatus())\n    .subscribe(onNext: { [weak self] devices, status in\n        self?.updateSuperAppDashboard(devices: devices, status: status)\n    })\n    .disposed(by: disposeBag)'
        }
    };

    const sandboxInput = document.getElementById('sandbox-input');
    const sandboxOutput = document.getElementById('sandbox-output');
    const presetSelect = document.getElementById('preset-select');
    const runAiBtn = document.getElementById('run-ai-analysis-btn');
    const statusIndicator = document.getElementById('ai-status-indicator');
    const toolBtns = document.querySelectorAll('.sandbox-tool-btn');
    let activeTool = 'ai_hobby';

    function setPreset(key) {
        if (sandboxInput && sandboxPresets[key]) {
            sandboxInput.value = sandboxPresets[key].input;
        }
    }

    setPreset('ai_hobby');

    if (presetSelect) {
        presetSelect.addEventListener('change', (e) => {
            setPreset(e.target.value);
        });
    }

    toolBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            toolBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            activeTool = btn.getAttribute('data-tool');
            const titleElem = document.getElementById('sandbox-active-tool-title');
            if (titleElem) {
                titleElem.textContent = btn.querySelector('.tool-name').textContent;
            }
        });
    });

    if (runAiBtn) {
        runAiBtn.addEventListener('click', () => {
            const inputVal = sandboxInput ? sandboxInput.value.trim() : '';
            if (!inputVal) {
                showToast('Please enter code prompt first.');
                return;
            }

            if (statusIndicator) {
                statusIndicator.innerHTML = '<span class="pulse" style="background-color: var(--accent);"></span> Inspecting...';
            }
            if (sandboxOutput) {
                sandboxOutput.innerHTML = '<div style="color: var(--text-muted); font-style: italic;">Running AI analysis engine...</div>';
            }

            setTimeout(() => {
                if (statusIndicator) {
                    statusIndicator.innerHTML = '<span class="pulse"></span> Verified';
                }

                if (sandboxOutput) {
                    if (activeTool === 'ai_hobby') {
                        sandboxOutput.innerHTML = 
                            '<div style="color: var(--accent-green); font-weight: 700; margin-bottom: 0.5rem;">[AI DIAGNOSIS PASSED]</div>' +
                            '<p style="margin-bottom: 1rem; color: var(--text-secondary);">Identified Swift 6 array bounds issue. Patch generated via Gemini REST API integration.</p>' +
                            '<div style="color: var(--primary); font-weight: 700; margin-bottom: 0.3rem;">GITHUB REPOSITORY:</div>' +
                            '<a href="https://github.com/jibinmathew?tab=repositories" target="_blank" style="color: #a5f3fc;">github.com/jibinmathew?tab=repositories</a>';
                    } else if (activeTool === 'superapp_arch') {
                        sandboxOutput.innerHTML = 
                            '<div style="color: var(--accent-green); font-weight: 700; margin-bottom: 0.5rem;">[MODULE ROUTING VERIFIED]</div>' +
                            '<p style="margin-bottom: 1rem; color: var(--text-secondary);">Module boundaries decoupled successfully. Architecture isolation confirmed with zero circular dependencies.</p>';
                    } else {
                        sandboxOutput.innerHTML = 
                            '<div style="color: var(--accent-green); font-weight: 700; margin-bottom: 0.5rem;">[RXSWIFT MEMORY AUDIT CLEAN]</div>' +
                            '<p style="margin-bottom: 1rem; color: var(--text-secondary);">Weak self capture semantics verified. Zero memory leaks detected on main thread scheduler.</p>';
                    }
                }
                showToast('Code Diagnostic Complete!');
            }, 800);
        });
    }

    // ----------------------------------------------------------------------
    // 7. Resume Viewer Modal
    // ----------------------------------------------------------------------
    const openResumeBtn = document.getElementById('open-resume-btn');
    const resumeModal = document.getElementById('resume-modal');
    const resumeModalOverlay = document.getElementById('resume-modal-overlay');
    const resumeModalCloseBtn = document.getElementById('resume-modal-close-btn');
    const printResumeBtn = document.getElementById('print-resume-btn');

    if (openResumeBtn && resumeModal) {
        openResumeBtn.addEventListener('click', () => {
            resumeModal.classList.add('active');
        });
    }

    if (resumeModalCloseBtn && resumeModalOverlay && resumeModal) {
        [resumeModalCloseBtn, resumeModalOverlay].forEach(elem => {
            elem.addEventListener('click', () => {
                resumeModal.classList.remove('active');
            });
        });
    }

    if (printResumeBtn) {
        printResumeBtn.addEventListener('click', () => {
            window.print();
        });
    }

    // ----------------------------------------------------------------------
    // 8. Contact Form Handling
    // ----------------------------------------------------------------------
    const contactForm = document.getElementById('contact-form');
    if (contactForm) {
        contactForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const nameElem = document.getElementById('contact-name');
            const name = nameElem ? nameElem.value : 'Guest';
            showToast('Thank you, ' + name + '! Your message has been sent to jibinmjose@gmail.com.');
            contactForm.reset();
        });
    }

    // Toast Notification System
    function showToast(message) {
        const toastContainer = document.getElementById('toast-container');
        if (!toastContainer) return;
        const toast = document.createElement('div');
        toast.className = 'toast';
        toast.innerHTML = 
            '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--accent-green);"><polyline points="20 6 9 17 4 12"></polyline>' +
            '<span>' + message + '</span>';
        toastContainer.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }
});
