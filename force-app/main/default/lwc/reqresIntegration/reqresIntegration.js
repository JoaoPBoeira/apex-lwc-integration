import { LightningElement, track } from 'lwc';
import getUsers from '@salesforce/apex/UserService.getUsers';
import createUser from '@salesforce/apex/UserService.createUser';
import updateUser from '@salesforce/apex/UserService.updateUser';
import deleteUser from '@salesforce/apex/UserService.deleteUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ReqresIntegration extends LightningElement {
    @track users = [];
    @track filteredUsers = [];
    @track searchTerm = '';
    @track errorMessage = '';
    @track debugMessage = 'Carregando usuários...';
    @track newUserName = '';
    @track newUserEmail = '';
    @track isEditing = false;
    @track editingUserId = null;
    @track showCreateForm = false;

    get hasFilteredUsers() {
        return this.filteredUsers && Array.isArray(this.filteredUsers) && this.filteredUsers.length > 0;
    }

    get hasUsers() {
        return this.users && Array.isArray(this.users) && this.users.length > 0;
    }

    connectedCallback() {
        this.fetchUsers();
    }

    async fetchUsers() {
        try {
            const result = await getUsers();
            this.users = Array.isArray(result) ? result : [];
            this.filteredUsers = [...this.users];
            this.errorMessage = '';
        } catch (error) {
            console.error('Erro ao buscar usuários:', error);
            this.errorMessage = error.body ? error.body.message : 'Erro ao carregar usuários.';
            this.users = [];
            this.filteredUsers = [];
            this.showToast('Erro', this.errorMessage, 'error');
        }
    }

    handleSearch(event) {
        this.searchTerm = event.target.value.toLowerCase();
        this.filterUsers();
    }

    filterUsers() {
        if (this.searchTerm) {
            this.filteredUsers = this.users.filter(user =>
                (user.name && user.name.toLowerCase().includes(this.searchTerm)) ||
                (user.email && user.email.toLowerCase().includes(this.searchTerm))
            );
        } else {
            this.filteredUsers = [...this.users];
        }
    }

    async handleCreate() {
        if (!this.newUserName || !this.newUserEmail) {
            this.showToast('Erro', 'Nome e email são obrigatórios.', 'error');
            return;
        }
        try {
            const newUser = await createUser({ name: this.newUserName, email: this.newUserEmail });
            this.users = [...this.users, newUser];
            this.resetForm();
            this.showCreateForm = false;
            this.showToast('Sucesso', 'Usuário criado com sucesso!', 'success');
            await this.fetchUsers();
        } catch (error) {
            this.showToast('Erro', error.body.message, 'error');
        }
    }

    async handleUpdate() {
        if (!this.newUserName || !this.newUserEmail) {
            this.showToast('Erro', 'Nome e email são obrigatórios.', 'error');
            return;
        }
        try {
            const updatedUser = await updateUser({
                userId: this.editingUserId,
                name: this.newUserName,
                email: this.newUserEmail
            });
            this.users = this.users.map(user =>
                user.id === this.editingUserId ? updatedUser : user
            );
            this.resetForm();
            this.isEditing = false;
            this.showToast('Sucesso', 'Usuário atualizado com sucesso!', 'success');
            await this.fetchUsers();
        } catch (error) {
            this.showToast('Erro', error.body.message, 'error');
        }
    }

    async handleDelete(event) {
        const userId = event.target.dataset.id;
        try {
            await deleteUser({ userId: userId });
            this.users = this.users.filter(user => user.id != userId);
            this.showToast('Sucesso', 'Usuário excluído com sucesso!', 'success');
            await this.fetchUsers();
        } catch (error) {
            this.showToast('Erro', error.body.message, 'error');
        }
    }

    handleEdit(event) {
        const userId = event.target.dataset.id;
        const user = this.users.find(user => user.id == userId);
        if (user) {
            this.newUserName = user.name;
            this.newUserEmail = user.email;
            this.isEditing = true;
            this.editingUserId = userId;
            this.showCreateForm = false;
        } else {
            this.showToast('Erro', 'Usuário não encontrado para edição.', 'error');
        }
    }

    cancelEdit() {
        this.resetForm();
        this.isEditing = false;
    }

    handleNameChange(event) {
        this.newUserName = event.target.value;
    }

    handleEmailChange(event) {
        this.newUserEmail = event.target.value;
    }

    resetForm() {
        this.newUserName = '';
        this.newUserEmail = '';
        this.isEditing = false;
        this.editingUserId = null;
    }

    toggleCreateForm() {
        this.showCreateForm = !this.showCreateForm;
        if (this.showCreateForm) {
            this.isEditing = false;
            this.resetForm();
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}