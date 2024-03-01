package com.cupidconnect.cupidconnect.services;

import com.cupidconnect.cupidconnect.models.Role;

import java.util.List;

public interface IRoleService {
     Role createRole(Role role);
     Role getRoleById(long id);

     List<Role> getAllRoles();

     Role updateRole(long id,Role newRole);

     void deleteRole(long id);
}
