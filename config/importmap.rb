# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
# NOTE: pin jquery to jsdelivr instead of jspm
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.0/dist/jquery.js"
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js", preload: true
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.2/dist/esm/index.js", preload: true
