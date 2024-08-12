let commands = [];
let currentCategory = 'all';
let favorites = [];
let isDarkMode = true;

window.addEventListener("message", async (event) => {
    const data = event.data;
    if (data.action === "openMenu") {
        commands = data.commands;
        favorites = Array.isArray(data.favorites) ? data.favorites : [];
        renderMenu();
        document.getElementById('menu').style.display = 'block';
        if (!$("#menu").data("draggable")) {
            initializeDraggable();
        }
    } else if (data.action === "closeMenu") {
        closeMenu();
    }
});

function renderMenu(filteredCommands = commands) {
    const menu = document.getElementById('menu');
    menu.classList.toggle('light-mode', !isDarkMode);
    const commandList = document.getElementById('commandList');
    commandList.innerHTML = '';

    filteredCommands.sort((a, b) => a.title.localeCompare(b.title)).forEach(cmd => {
        const cmdElement = document.createElement('div');
        cmdElement.className = 'command';
        cmdElement.innerHTML = `
            <h3>
                <i class="${cmd.icon}"></i> ${cmd.title}
                <span class="favorite-button ${favorites.includes(cmd.name) ? 'active' : ''}" onclick="toggleFavorite('${cmd.name}')">
                    <i class="fas fa-star"></i>
                </span>
            </h3>
            <p>${cmd.description}</p>
            <p><strong>Command:</strong> ${cmd.usage}</p>
            ${cmd.parameters.length > 0 ? 
                cmd.parameters.map(param => renderParameter(cmd.name, param)).join('') + 
                `<button onclick="executeCommand('${cmd.name}')">Confirm</button>`
                : renderNonParameterControl(cmd)
            }
        `;
        commandList.appendChild(cmdElement);
    });
    initParameterFocus();
}

function renderNonParameterControl(cmd) {
    switch(cmd.mode) {
        case "toggle":
            return `<button onclick="executeCommand('${cmd.name}')" class="execute-btn">Execute</button>`;
        case "slider1":
        case "slider2":
            return `<label class="switch">
                <input type="checkbox" id="toggle-${cmd.name}" onchange="toggleCommand('${cmd.name}', this.checked, '${cmd.mode}')">
                <span class="slider"></span>
            </label>`;
        default:
            return '';
    }
}

function renderParameter(cmdName, param) {
    switch (param.type) {
        case 'text':
            return `<input type="text" id="params-${cmdName}-${param.name}" placeholder="${param.help}">`;
        default:
            return `<input type="text" id="params-${cmdName}-${param.name}" placeholder="${param.help}">`;
    }
}

function initParameterFocus() {
    document.querySelectorAll('input[type="text"], select').forEach(element => {
        element.addEventListener('focus', function() {
            fetch(`https://${GetParentResourceName()}/focusOn`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            });
        });
        element.addEventListener('blur', function() {
            fetch(`https://${GetParentResourceName()}/focusOff`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            });
        });
    });
}

function filterCategory(category) {
    currentCategory = category;
    const filteredCommands = category === 'all' ? commands :
        category === 'favorites' ? commands.filter(cmd => favorites.includes(cmd.name)) :
        commands.filter(cmd => cmd.category === category);
    renderMenu(filteredCommands);
    document.querySelectorAll('.category-icon').forEach(icon => {
        icon.classList.toggle('active', icon.dataset.category === category);
    });
}

function toggleFavorite(cmdName) {
    const index = favorites.indexOf(cmdName);
    if (index > -1) {
        favorites.splice(index, 1);
    } else {
        favorites.push(cmdName);
    }
    saveFavorites();
    renderMenu(currentCategory === 'all' ? commands : commands.filter(cmd => cmd.category === currentCategory));
}

function saveFavorites() {
    fetch(`https://${GetParentResourceName()}/saveFavorites`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ favorites: favorites })
    });
}

function executeCommand(name) {
    const command = commands.find(cmd => cmd.name === name);
    const params = command.parameters ? command.parameters.map(param => {
        const element = document.getElementById(`params-${name}-${param.name}`);
        return element ? element.value : '';
    }) : [];
    fetch(`https://${GetParentResourceName()}/executeCommand`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            name: name,
            params: params
        })
    });
}

function toggleCommand(name, isEnabled, mode) {
    const command = commands.find(cmd => cmd.name === name);
    if (command) {
        command.enabled = isEnabled;
        if (mode === 'slider1' || (mode === 'slider2' && isEnabled)) {
            executeCommand(name);
        }
    }
}

function closeMenu() {
    document.getElementById('menu').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

function toggleTheme() {
    isDarkMode = !isDarkMode;
    document.getElementById('menu').classList.toggle('light-mode', !isDarkMode);
    document.querySelector('.theme-toggle i').classList.toggle('fa-sun', isDarkMode);
    document.querySelector('.theme-toggle i').classList.toggle('fa-moon', !isDarkMode);
}

document.getElementById('searchBar').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filteredCommands = commands.filter(cmd => 
        (currentCategory === 'all' || cmd.category === currentCategory || (currentCategory === 'favorites' && favorites.includes(cmd.name))) &&
        (cmd.name.toLowerCase().includes(searchTerm) || 
        cmd.title.toLowerCase().includes(searchTerm) ||
        cmd.description.toLowerCase().includes(searchTerm) ||
        cmd.usage.toLowerCase().includes(searchTerm) ||
        cmd.parameters.some(param => param.name.toLowerCase().includes(searchTerm) || param.help.toLowerCase().includes(searchTerm)))
    );
    renderMenu(filteredCommands);
});

function initializeDraggable() {
    $(".menu").draggable({
        handle: ".menu-drag-handle",
        containment: "window",
        scroll: false,
        start: function(event, ui) {
            $(this).css('left', 'auto');
            $(this).css('right', 'auto');
        },
        drag: function(event, ui) {
            if (ui.position.top < 0) {
                ui.position.top = 0;
            }
        }
    });
}

$(document).ready(function() {
    renderMenu();
    initializeDraggable();
});

document.querySelector('.menu-close').addEventListener('click', closeMenu);

document.addEventListener('click', function(event) {
    const menu = document.getElementById('menu');
    if (menu && !menu.contains(event.target)) {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === "Escape" && document.getElementById('menu').style.display !== 'none') {
        closeMenu();
    }
});
