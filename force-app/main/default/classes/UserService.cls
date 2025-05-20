public with sharing class UserService {

    @AuraEnabled
    public static List<UserDTO> getUsers() {
        try {
            HttpResponse response = HttpClient.makeRequest('/api/users', '', 'GET');

            if (response.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> dataList = (List<Object>) responseMap.get('data');
                List<UserDTO> users = new List<UserDTO>();
                
                if (dataList == null || dataList.isEmpty()) {
                    return users;
                }

                for (Object obj : dataList) {
                    Map<String, Object> userMap = (Map<String, Object>) obj;
                    UserDTO user = new UserDTO();
                    user.id = (String) String.valueOf(userMap.get('id'));
                    user.name = (String) userMap.get('first_name') + ' ' + (String) userMap.get('last_name');
                    user.email = (String) userMap.get('email');
                    users.add(user);
                }

                return users;

            } else {
                throw new AuraHandledException('Erro ao buscar usuários: ' + response.getStatus() + ' - ' + response.getBody());
            }

        } catch (Exception e) {
            throw new AuraHandledException('Erro ao buscar usuários: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static UserDTO createUser(String name, String email) {
        try {
            if (String.isBlank(name) || String.isBlank(email)) {
                throw new AuraHandledException('Nome e profissão são obrigatórios.');
            }

            UserDTO user = new UserDTO();
            user.name = name;
            user.email = email;
            String body = JSON.serialize(user);
            HttpResponse response = HttpClient.makeRequest('/api/users', body, 'POST');

            if (response.getStatusCode() == 201) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                UserDTO createdUser = new UserDTO();
                createdUser.id = (String) responseMap.get('id');
                createdUser.name = (String) responseMap.get('name');
                createdUser.email = (String) responseMap.get('email');
                return createdUser;

            } else {
                throw new AuraHandledException('Erro ao criar usuário: ' + response.getStatus() + ' - ' + response.getBody());
            }

        } catch (Exception e) {
            throw new AuraHandledException('Erro: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static UserDTO updateUser(String userId, String name, String email) {
        try {
            if (String.isBlank(name) || String.isBlank(email)) {
                throw new AuraHandledException('Nome e profissão são obrigatórios.');
            }

            UserDTO user = new UserDTO();
            user.id = userId;
            user.name = name;
            user.email = email;
            String body = JSON.serialize(user);
            HttpResponse response = HttpClient.makeRequest('/api/users/' + userId, body, 'PUT');

            if (response.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                UserDTO updatedUser = new UserDTO();
                updatedUser.id = userId;
                updatedUser.name = (String) responseMap.get('name');
                updatedUser.email = (String) responseMap.get('email');
                return updatedUser;

            } else {
                throw new AuraHandledException('Erro ao atualizar usuário: ' + response.getStatus() + ' - ' + response.getBody());
            }

        } catch (Exception e) {
            throw new AuraHandledException('Erro: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteUser(Integer userId) {
        try {
            HttpResponse response = HttpClient.makeRequest('/api/users/' + userId, '', 'DELETE');

            if (response.getStatusCode() == 204) {
                return;

            } else {
                throw new AuraHandledException('Erro ao excluir usuário: ' + response.getStatus() + ' - ' + response.getBody());
            }

        } catch (Exception e) {
            throw new AuraHandledException('Erro: ' + e.getMessage());
        }
    }
}