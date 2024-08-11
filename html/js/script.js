let commands = [];
let currentCategory = 'all';
let favorites = [];
let isDarkMode = true;

window.addEventListener("message", (event) => {
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
        document.getElementById('menu').style.display = 'none';
    } else if (data.action === "copy") {
        const el = document.createElement("textarea");
        el.value = data.text;
        document.body.appendChild(el);
        el.select();
        document.execCommand("copy");
        document.body.removeChild(el);
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
                cmd.parameters.map(param => `
                    <input type="text" id="params-${cmd.name}-${param.name}" placeholder="${param.help}">
                `).join('') + `<button onclick="executeCommand('${cmd.name}')">Confirm</button>`
                : 
                `<label class="switch">
                    <input type="checkbox" id="toggle-${cmd.name}" ${cmd.enabled ? 'checked' : ''} onchange="toggleCommand('${cmd.name}', this.checked)">
                    <span class="slider"></span>
                </label>`
            }
        `;
        commandList.appendChild(cmdElement);
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
    const params = command.parameters.map(param => 
        document.getElementById(`params-${name}-${param.name}`).value
    );
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

function toggleCommand(name, isEnabled) {
    fetch(`https://${GetParentResourceName()}/toggleCommand`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            name: name,
            enabled: isEnabled
        })
    });
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

document.addEventListener('keydown', function(event) {
    if (event.key === "Escape" && document.getElementById('menu').style.display !== 'none') {
        closeMenu();
    }
});
